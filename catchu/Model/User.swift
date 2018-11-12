//
//  User.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class User {
    public static var shared = User()
    
    var userid: String?
    var username: String?
    var name: String?
    var email: String?
    var password: String?
    var provider: String?
    var providerID: String?
    var profilePictureUrl: String?
    var userBirthday: String?
    var userGender: String?
    var phone: Phone?
    var userWebsite: String?
    var followStatus: FollowStatus?
    
    var userFollowerCount: String?
    var userFollowingCount: String?
    
    // the attributes below is used for collectionView management
    var indexPathCollectionView: IndexPath!
    var indexPathTableView: IndexPath!
    var indexPathTableViewOfSearchMode: IndexPath!
    var isUserSelected: Bool?
    
    var userDataDictionary: Dictionary<String, String> = [:]
    
    var userFriendList : Dictionary<String, User> = [:]
    var sortedFriendArray : Array<User> = []
    // authenticated user's follow requests made by other users
    var requestingFriendList : Array<User> = []
    
    var isUserHasAFriendRelation : Bool?
    var isUserHasPendingFriendRequest: Bool?
    var isUserHasAPrivateAccount : Bool?
    
    init() {}
    
    init(userid: String? = nil, username: String?  = nil, name: String?  = nil, email: String?  = nil, password: String?  = nil, provider: String?  = nil, providerID: String?  = nil, followStatus: FollowStatus? = nil) {
        self.userid     = userid
        self.username   = username
        self.name       = name
        self.email      = email
        self.password   = password
        self.provider   = provider
        self.providerID = providerID
        self.followStatus = followStatus
    }
    
    init(user: REUser?) {
        guard let user = user else { return }
        
        if let userid = user.userid {
            self.userid = userid
        }
        if let name = user.name {
            self.name = name
        }
        if let username = user.username {
            self.username = username
        }
        if let profilePhotoUrl = user.profilePhotoUrl {
            self.profilePictureUrl = profilePhotoUrl
        }
        if let isPrivateAccount = user.isPrivateAccount {
            self.isUserHasAPrivateAccount = isPrivateAccount.boolValue
        }
        if let followStatus = user.followStatus {
            self.followStatus = FollowStatus.convert(followStatus)
        }
    }
    
    var nameCompare: String {
        get {
            return self.name ?? ""
        }
    }
    
    func appendElementIntoDictionary(key : String, value : String) {
        
        self.userDataDictionary[key] = value
        
    }
    
    func appendElementIntoFriendListAWS(httpResult : REFriendList) {
        
        for item in httpResult.resultArray! {
            
            let tempUser = User()

            if let userid = item.userid {
                tempUser.userid = userid
            }

            if let username = item.username {
                tempUser.username = username
            }
            
            if let profilePhotoUrl = item.profilePhotoUrl {
                tempUser.profilePictureUrl = profilePhotoUrl
            }
            
            if let name = item.name {
                tempUser.name = name
            }
            
            User.shared.userFriendList[item.userid!] = tempUser
            
        }
    }
        
    func createSortedUserArray() {
        
        var tempArray : Array<User> = []
        
        for item in User.shared.userFriendList {
            
            tempArray.append(item.value)
            
        }

        sortedFriendArray = tempArray.sorted(by: {$0.nameCompare < $1.nameCompare})
        
    }
    
    func addRequestingFollow(httpResult : REFriendRequestList) {
        
        for item in httpResult.resultArray! {
            
            let tempUser = User()
            
            tempUser.userid = item.userid!
            tempUser.username = item.username!
            tempUser.profilePictureUrl = item.profilePhotoUrl!
            tempUser.name = item.name!
            
            requestingFriendList.append(tempUser)
        }
        
    }
    
    // set user profile data into singleton object
    func convertReUserDataToUserObject(httpRequest : REUserProfile) {
        
        print("convertReUserDataToUserObject starts")
        
        print("httpRequest username : \(httpRequest.userInfo?.username)")
        print("httpRequest name : \(httpRequest.userInfo?.name)")
        
        if let data = httpRequest.userInfo {
            if let name = data.name {
                self.name = name
            }
            if let username = data.username {
                self.username = username
            }
            if let profilePhotoUrl = data.profilePhotoUrl {
                self.profilePictureUrl = profilePhotoUrl
            }
            if let birthday = data.birthday {
                self.userBirthday = birthday
            }
            if let gender = data.gender {
                self.userGender = gender
            }
            if let email = data.email {
                self.email = email
            }
            if let phone = data.phone {
                self.phone = Phone(phone: phone)
            }
            if let website = data.website {
                self.userWebsite = website
            }
            if let isPrivateAccount = data.isPrivateAccount {
                isUserHasAPrivateAccount = isPrivateAccount.boolValue
            }
        }
        
        if let dataRelation = httpRequest.relationInfo {
            if let followingCount = dataRelation.followingCount {
                self.userFollowingCount = followingCount
            }
            if let followerCount = dataRelation.followerCount {
                self.userFollowerCount = followerCount
            }
        }
    }
    
    func setUserProfileProperties(httpRequest : REUserProfileProperties) {
        
        self.userid = httpRequest.userid!
        self.name = httpRequest.name!
        self.username = httpRequest.username!
        self.profilePictureUrl = httpRequest.profilePhotoUrl!
        self.isUserHasAPrivateAccount = (httpRequest.isPrivateAccount?.boolValue)!
//        userBirthday = httpRequest.birthday
//        userGender = httpRequest.gender!
//        email = httpRequest.email!
//        userPhone = httpRequest.phone!
    }
    
    func getUserProfile() -> REUserProfileProperties? {
        guard let user = REUserProfileProperties() else { return nil }
        user.userid = self.userid
        user.name = self.name
        user.username = self.username
        user.birthday = self.userBirthday
        user.gender = self.userGender
        user.email = self.email
        user.phone = self.phone?.getPhone()
        user.website = self.userWebsite
        return user
    }
    
    func getUser() -> REUser? {
        guard let user = REUser() else { return nil }
        user.userid = self.userid
        user.name = self.name
        user.username = self.username
        user.profilePhotoUrl = self.profilePictureUrl
        if let isUserHasAPrivateAccount = self.isUserHasAPrivateAccount {
            user.isPrivateAccount = NSNumber(booleanLiteral: isUserHasAPrivateAccount)
        }
        return user
    }
    
    func getREUSerList(inputUserList : [User]) -> [REUser] {
        
        var returList = [REUser]()
        
        for item in inputUserList {
            returList.append(item.getUser()!)
        }
        
        return returList
        
    }
    
    func convertUserToProvider(inputUser : User) -> REProvider {
        
        let provider = REProvider()
        
        if let providerString = inputUser.provider {
            provider?.providerType = providerString
        }
        
        if let providerID = inputUser.providerID {
            provider?.providerid = providerID
        }
        
        return provider!
        
    }
    
}

extension User {
    
    public enum FollowStatus {
        case following
        case pending
        case own
        case none
        
        internal var toString: String {
            switch self {
            case .following:
                return LocalizedConstants.Like.Following
            case .pending:
                return LocalizedConstants.Like.Requested
            case .own:
                return ""
            case .none:
                return LocalizedConstants.Like.Follow
            }
        }
        
        static func convert(_ followStatus: String?) -> FollowStatus {
            guard let followStatus = followStatus else { return .none }
            
            switch followStatus {
            case Constants.Relation.Following:
                return .following
            case Constants.Relation.Pending:
                return .pending
            case Constants.Relation.Own:
                return .own
            default:
                return FollowStatus.none
            }
        }
        
        func configure(_ button: UIButton) {
            let title = self.toString
            let titleColor: UIColor = self == .none ? UIColor.white : UIColor.black
            let borderColor: UIColor = self == .none ? UIColor.blue : UIColor.lightGray
            let backgroundColor: UIColor = self == .none ? UIColor.blue : UIColor.white
            let alpha: CGFloat = self == .own ? 0 : 1
            
            button.setTitle(title, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
            button.backgroundColor = backgroundColor
            button.alpha = alpha
            
            button.layer.borderColor = borderColor.cgColor
        }
    }
}
