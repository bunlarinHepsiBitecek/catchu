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
    var userPhone: String?
    var userWebsite: String?
    
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
    
    init(userid: String? = nil, username: String?  = nil, name: String?  = nil, email: String?  = nil, password: String?  = nil, provider: String?  = nil, providerID: String?  = nil) {
        self.userid     = userid
        self.username   = username
        self.name       = name
        self.email      = email
        self.password   = password
        self.provider   = provider
        self.providerID = providerID
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
        
        httpResult.displayProperties()
        
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
    func setUserProfileData(httpRequest : REUserProfile) {
        
        print("setUserProfileData starts")
        
        httpRequest.userInfo?.displayProperties()
        
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
                self.userPhone = phone
            }
            if let website = data.website {
                self.userWebsite = website
            }
            if let isPrivateAccount = data.isPrivateAccount {
                isUserHasAPrivateAccount = isPrivateAccount.boolValue
            }
        }
        if let dataRelation = httpRequest.relationCountInfo {
            self.userFollowingCount = dataRelation.followingCount
            self.userFollowerCount = dataRelation.followerCount
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
    
    func getUser() -> REUser {
        let user = REUser()
        user?.userid = self.userid
        user?.name = self.name
        user?.username = self.username
        user?.profilePhotoUrl = self.profilePictureUrl
        if let isUserHasAPrivateAccount = self.isUserHasAPrivateAccount {
            user?.isPrivateAccount = NSNumber(booleanLiteral: isUserHasAPrivateAccount)
        }
        return user!
    }
    
    func getREUSerList(inputUserList : [User]) -> [REUser] {
        
        var returList = [REUser]()
        
        for item in inputUserList {
            returList.append(item.getUser())
        }
        
        return returList
        
    }
    
}
