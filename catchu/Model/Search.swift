//
//  Search.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Search {
    
    public static var shared = Search()
    
    private var _isSearchProgressActive :Bool!
    private var _searchKey :String!
    private var _searchResultArray :Array<User>!
    
    init() {
        
        _isSearchProgressActive = false
        _searchKey = Constants.CharacterConstants.SPACE
        _searchResultArray = Array<User>()
        
    }
    
    var isSearchProgressActive: Bool {
        get {
            return _isSearchProgressActive
        }
        set {
            _isSearchProgressActive = newValue
        }
    }
    
    var searchKey: String {
        get {
            return _searchKey
        }
        set {
            _searchKey = newValue
        }
    }
    
    var searchResultArray: Array<User> {
        get {
            return _searchResultArray
        }
        set {
            _searchResultArray = newValue
        }
    }
    
    func appendElementIntoSearchArrayResult(httpResult : REUserListResponse) {
        
        for item in httpResult.items! {
            
            let tempUser = User()
            
            tempUser.userid = item.userid
            tempUser.username = item.username
            tempUser.name = item.name
            tempUser.profilePictureUrl = item.profilePhotoUrl
            tempUser.followStatus = User.FollowStatus.convert(item.followStatus)
            
            tempUser.isUserHasAFriendRelation = (tempUser.followStatus == User.FollowStatus.following)
            tempUser.isUserHasPendingFriendRequest = (tempUser.followStatus == User.FollowStatus.pending)
            
//            if let friendRelation = item.friendRelation {
//                tempUser.isUserHasAFriendRelation = friendRelation.boolValue
//            }
//            if let pendingFriendRequest = item.pendingFriendRequest {
//                tempUser.isUserHasPendingFriendRequest = pendingFriendRequest.boolValue
//            }
            
            if let isPrivateAccount = item.isPrivateAccount {
                tempUser.isUserHasAPrivateAccount = isPrivateAccount.boolValue
            }
            
            _searchResultArray.append(tempUser)
            
        }
        
    }
    
    
}
