//
//  FacebookContactListManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import FBSDKCoreKit

struct ExpandableSection {

    var isExpanded : Bool
    var contacts : [User]
    
}

class FacebookContactListManager {
    
    public static let shared = FacebookContactListManager()
    
    var twoDimensionalList : [ExpandableSection]?
    var facebookFriendArray : [User]?
    
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
    
    func getFaceBookFriendList() {
        
        // ulrich userid : O7u29FKbqtRzREARgmZSA1GOZa72
        // richard userid : wPeXxNwNM4bOuDgTY51IAF9apbk2
        // sharon userid : semlX3xtOBfynq4rkWNcMpMKkT42
        
        let parameterKey = FirebaseManager.FacebookPermissions.parameter_key
        let parameterValue = FirebaseManager.FacebookPermissions.parameterValueForFriends
        let method = FirebaseManager.FacebookPermissions.method
        let path = FirebaseManager.FacebookPermissions.pathMe_Friends
        
        print("FBSDKAccessToken.current()?.tokenString : \(FBSDKAccessToken.current()?.tokenString)")
        
        let graphRequest = FBSDKGraphRequest(graphPath: path, parameters: [parameterKey : parameterValue], tokenString: FBSDKAccessToken.current()?.tokenString, version: nil, httpMethod: method)
        
        graphRequest?.start(completionHandler: { (connection, data, error) in
            if error != nil {
                if let error = error as NSError? {
                    print("error info : \(error.localizedDescription)")
                }
            } else {
                if let data = data as? NSDictionary {
                    self.parseGraphRequestData(data: data)
                    
                }
            }
        })
        
    }
    
    func parseGraphRequestData(data : NSDictionary) {
        print("parseGraphRequestData starts")
        print("data : \(data)")
        
        if facebookFriendArray == nil {
            facebookFriendArray = [User]()
        }
        
        if let data = data["data"] as? NSArray {
            for item in data {
                if let friendData = item as? NSDictionary {
                    print("friend_id : \(friendData["id"])")
                    
                    let user = User()
                    user.provider = "facebook"
                    
                    if let id = friendData["id"] { user.providerID = String(describing: id) }
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
                    
                    facebookFriendArray!.append(user)
                }
            }
        }
        
        converFacebookContactListToProvider()
        
        print("facebookFriends array count : \(facebookFriendArray!.count)")
    }
    
    func converFacebookContactListToProvider() {
        
        let providerList = REProviderList()
        
        if providerList?.items == nil {
            providerList?.items = [REProvider]()
        }
        
        if let userArray = FacebookContactListManager.shared.facebookFriendArray {
            for item in userArray {
                providerList?.items?.append(User.shared.convertUserToProvider(inputUser: item))
            }
        }
        
        if let userid = User.shared.userid {
            APIGatewayManager.shared.initiateFacebookContactExploreProcess(userid: User.shared.userid!, providerList: providerList!) { (finish) in
                
                if finish {
                    print("Bitti")
                }
                
            }
        }
        
    }
    
}
