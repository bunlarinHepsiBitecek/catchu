//
//  FacebookContactListManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct ExpandableSection {

    var isExpanded : Bool
    var contacts : [User]
    
}

enum ReturnResult<T> {
    case success(T)
    case failure(User)
}

class FacebookContactListManager {
    
    public static let shared = FacebookContactListManager()
    
    var twoDimensionalList : [ExpandableSection]?
    var facebookFriendArray : [User]?
    var facebookFriendsViewModelArray : [ViewModelUser]?
    
    func appendViewModeItem(viewModelUser : ViewModelUser) {
        
        if FacebookContactListManager.shared.facebookFriendsViewModelArray == nil {
           FacebookContactListManager.shared.facebookFriendsViewModelArray = [ViewModelUser]()
        }
        
        FacebookContactListManager.shared.facebookFriendsViewModelArray?.append(viewModelUser)
        
    }
    
    func emptyViewModelUserArray() {
        if FacebookContactListManager.shared.facebookFriendsViewModelArray != nil {
            FacebookContactListManager.shared.facebookFriendsViewModelArray?.removeAll()
        }
        
    }
    
    func emptyFacebookFriendArray() {
        if FacebookContactListManager.shared.facebookFriendArray != nil {
            FacebookContactListManager.shared.facebookFriendArray?.removeAll()
        }
        
    }
    
    func appendNewUserToFacebookFriendArray(user : User) {
        if FacebookContactListManager.shared.facebookFriendArray == nil {
            FacebookContactListManager.shared.facebookFriendArray = [User]()
        }
        
        FacebookContactListManager.shared.facebookFriendArray?.append(user)
    }
    
    func returnFacebookFriendArrayExist() -> Bool {
        if let array = FacebookContactListManager.shared.facebookFriendArray {
            if array.count > Constants.NumericConstants.INTEGER_ZERO {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func returnViewModelUser(index : Int) -> ReturnResult<ViewModelUser> {
        
        if let viewModelUserArray = FacebookContactListManager.shared.facebookFriendsViewModelArray {
            return .success(viewModelUserArray[index])
        }
        
        return .failure(User())
    }
    
    func returnUser(index : Int) -> User {
        if let array = FacebookContactListManager.shared.facebookFriendArray {
            return array[index]
        }
        
        return User()
    }
    
    func returnFacebookViewModelUserArray() -> Int {
        if let array = FacebookContactListManager.shared.facebookFriendsViewModelArray {
            return array.count
        } else {
            return Constants.NumericConstants.INTEGER_ZERO
        }
    }
    
    func returnFacebookArrayCount() -> Int {
        if let array = FacebookContactListManager.shared.facebookFriendArray {
            return array.count
        } else {
            return Constants.NumericConstants.INTEGER_ZERO
        }
    }
    
    func returnTwoDimensionalListCount() -> Int {
        if let list = FacebookContactListManager.shared.twoDimensionalList {
            return list.count
        } else {
            return Constants.NumericConstants.INTEGER_ZERO
        }
    }
    
    func returnExpandableSectionContactListItemCount(index : Int) -> Int {
        if let list = FacebookContactListManager.shared.twoDimensionalList {
            
            return list[index].contacts.count
            
        } else {
            return Constants.NumericConstants.INTEGER_ZERO
        }
    }
    
    func initiateGetFacebookFriendListByLoggedIn(completion : @escaping (_ finish : Bool) -> Void) {
        
        guard let currentViewController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        
        let facebook = FBSDKLoginManager()
        let permissinList = [FirebaseManager.FacebookPermissions.email, FirebaseManager.FacebookPermissions.public_profile, FirebaseManager.FacebookPermissions.user_friends]
        
        facebook.logIn(withReadPermissions: permissinList, from: currentViewController) { (loginResult, error) in
            
            if error != nil {
                if let error = error as NSError? {
                    print("error : \(error.localizedDescription)")
                }
            } else {
                if let result = loginResult {
                    if result.isCancelled {
                        return
                    } else {
                        if let accessToken = result.token {
                            print("accessToken from result          : \(accessToken.tokenString)")
                            
                            self.startGraphRequestForFacebookFriends(token: accessToken.tokenString, completion: completion)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func startGraphRequestForFacebookFriends(token : String, completion : @escaping (_ finish : Bool) -> Void) {
        
        print("startGraphRequestForFacebookFriends starts")
        
        let request = FBSDKGraphRequest(graphPath: FirebaseManager.FacebookPermissions.path_Me_Friends, parameters: [FirebaseManager.FacebookPermissions.parameter_key : FirebaseManager.FacebookPermissions.parameter_value], tokenString: token, version: nil, httpMethod: FirebaseManager.FacebookPermissions.method_GET)
        
        // try catch bloguna sokmak gerekiyor
        
        if let graphRequestForFriends = request {
            graphRequestForFriends.start(completionHandler: { (connection, data, error) in
                if error != nil {
                    if let error = error as NSError? {
                        print("error : \(error.localizedDescription)")
                    }
                } else {
                    if let data = data as? NSDictionary {
//                        self.parseGraphRequestData(data: data, completion: { (finish) in
//                            completion(finish)
//                        })
                        
                        self.parseGraphRequestData(data: data, completion: completion)
                    }
                }
            })
        } else {
            print("Facebook Graph Request can not be created")
        }
        
    }
    
    func parseGraphRequestData(data : NSDictionary, completion : @escaping (_ finish : Bool) -> Void) {
        print("parseGraphRequestData starts")
        print("data : \(data)")
        
        if FacebookContactListManager.shared.facebookFriendArray == nil {
            FacebookContactListManager.shared.facebookFriendArray = [User]()
        } else {
            emptyFacebookFriendArray()
        }
        
        if let data = data["data"] as? NSArray {
            for item in data {
                if let friendData = item as? NSDictionary {
                    print("friend_id : \(friendData["id"])")
                    
                    let user = User()
                    
                    if let id = friendData["id"] as? String {
                        user.provider = Provider(id: id, type: ProviderType.facebook)
//                        user.provider = ProviderType.facebook.rawValue
//                        user.providerID = String(describing: id)
                    }
                    if let name = friendData["name"] { user.name = String(describing: name) }
                    if let userName = friendData["short_name"] { user.username = String(describing: userName) }
                    
                    if let picture = friendData["picture"] as? NSDictionary {
                        if let pictureData = picture["data"] as? NSDictionary {
                            print("pictureData : \(pictureData)")
                            if let url = pictureData["url"] {
                                user.profilePictureUrl = String(describing: url)
                            }
                        }
                    }
                    
                    appendNewUserToFacebookFriendArray(user: user)
                }
            }
            
            completion(true)
            
        }
        
        //converFacebookContactListToProvider()
        
        print("facebookFriends array count : \(facebookFriendArray!.count)")
    }
    
    func getFacebookFriendsExistedInCatchU(completion : @escaping(_ finish : Bool) -> Void) {
        
        let providerList = REProviderList()
        
        if providerList?.items == nil {
            providerList?.items = [REProvider]()
        }
        
        if let userArray = FacebookContactListManager.shared.facebookFriendArray {
            for item in userArray {
//                providerList?.items?.append(User.shared.convertUserToProvider(inputUser: item))
                if let provider = item.provider {
                    providerList?.items?.append(provider.getProvider())
                }
            }
        }
        
        if let userid = User.shared.userid {
            
            APIGatewayManager.shared.initiateFacebookContactExploreProcess(userid: userid, providerList: providerList!) { (result) in
                
                switch result {
                case .success(let data):
                    self.updateFacebookFriendArray(userListResponse: data)
                    completion(true)
                case .failure(let error):
                    //print("error : \(error.message)")
                    return
                }
                
            }
            
        }
        
    }
    
    func updateFacebookFriendArray(userListResponse : REUserListResponse) {
        print("updateFacebookFriendArray starts")
        
        emptyFacebookFriendArray()
        
        if let array = userListResponse.items {
            for item in array {
                let user = User(user: item)
                appendNewUserToFacebookFriendArray(user: user)
                
                let viewModelUser = ViewModelUser(user: user)
                appendViewModeItem(viewModelUser: viewModelUser)
                
            }
        }
        
    }
    
    func initiateFacebookContactListProcess(completion : @escaping (_ finish : Bool) -> Void) {
        
        print("initiateFacebookContactListProcess starts")
        
        if let token = FBSDKAccessToken.current() {
            print("token.tokenString : \(token.tokenString)")
            print("token.isExpired : \(token.isExpired)")
            print("token expire date : \(token.expirationDate)")
            
            if token.isExpired {
                initiateGetFacebookFriendListByLoggedIn(completion: completion)
            } else {
                startGraphRequestForFacebookFriends(token: token.tokenString, completion: completion)
            }
        }
        
        /*else {
            initiateGetFacebookFriendListByLoggedIn(completion: completion)
        }*/
        
    }
    
    func initiateFacebookContactListProcessByConnectionRequest(completion : @escaping (_ finish : Bool) -> Void) {
        
        print("initiateFacebookContactListProcess starts")
        
        initiateGetFacebookFriendListByLoggedIn(completion: completion)
        
    }
    
    
    /// Ask facebook access token expire or not
    ///
    /// - Returns: if FBSDKAccessToken is expired, returns true. Otherwise returns false. Also, if user can have no access to facebook, access token would be nil. Therefore function returns true to make client trigger a direct request to facebook servers to start a login process.
    func askAccessTokenExpire() -> Bool {
        
        if let token = FBSDKAccessToken.current() {
            if token.isExpired {
                return true
            } else {
                return false
            }
        }
        
        return true
        
    }
    
}
