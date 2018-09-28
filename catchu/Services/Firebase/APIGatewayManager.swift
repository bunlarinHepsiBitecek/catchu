//
//  APIGatewayManager.swift
//  catchu
//
//  Created by Erkut Baş on 8/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class APIGatewayManager {
    
    public static var shared = APIGatewayManager()
    
    let client = RECatchUMobileAPIClient.default()
    
    /// The function below manages realtionship between authenticated user and the users registerd in catchu
    ///
    /// - Parameters:
    ///   - inputRequestType:
    ///     makeFollowRequest : to request a follow from a user whose account is private
    ///     acceptFollowRequest : to accept a follow request
    ///     getRequestingFollowList : to get a list of request made by users
    ///     createFollowDirectly : to create a follow with a user whose account is not private
    ///     deleteFollow : to unfollow a user
    ///     deletePendingFollowRequest : to withdraw a follow request
    ///   - reqester: requester userid
    ///   - requested: requested userid
    /// - Author: Erkut
    func requstProces(inputRequestType : RequestType, reqester : String, requested : String, completion :  @escaping (_ httpResult : REFriendRequestList) -> Void) {
        
        guard let friendRequest = REFriendRequest() else { return }
        
        friendRequest.requestType = inputRequestType.rawValue
        friendRequest.requesterUserid = reqester
        friendRequest.requestedUserid = requested
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                self.client.followRequestPost(authorization: tokenResult.token, body: friendRequest).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("error : \(String(describing: task.error?.localizedDescription))")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                    } else {
                        
                        if (task.result?.error?.code?.boolValue)! {
                            
                            if let result = task.result {
                                
                                completion(result)
                            }
                            
                        }
                        
                    }
                    
                    return nil
                }
            }
        }
    }
    

    /// To get user profile information from neo4j USER node properties
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - completion: REUserProfile
    func getUserProfileInfo(userid : String, completion :  @escaping (_ httpResult : REUserProfile, _ response : Bool) -> Void) {
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.client.usersGet(authorization: tokenResult.token, userid: userid).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("error : \(String(describing: task.error?.localizedDescription))")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                        LoaderController.shared.removeLoader()
                        
                    } else {
                        
                        if (task.result?.error?.code?.boolValue)! {
                            
                            if let result = task.result {
                                
                                completion(result, true)
                            }
                            
                        }
                        
                    }
                    
                    return nil
                }
            }
        }
    }
    
    
    /// To update user profile information on neo4j USER node properties
    ///
    /// - Parameters:
    ///   - userObject: USER singleton Shared object
    ///   - completion: REError
    func updateUserProfileInformation(requestType : RequestType, userObject : User, completion :  @escaping (_ httpResult : REBaseResponse, _ response : Bool) -> Void) {
     
        print("updateUserProfileInformation starts")
        print("userObject : \(userObject)")
        
        guard let userProfile = REUserProfile() else { return }
        let inputUserInfo = REUserProfileProperties()
        
        inputUserInfo?.setUserProfileInformation(user: userObject)
        
        userProfile.userInfo = inputUserInfo
        userProfile.requestType = requestType.rawValue
        
        userProfile.userInfo?.displayProperties()
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.client.usersPost(authorization: tokenResult.token, body: userProfile).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("error : \(String(describing: task.error?.localizedDescription))")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                        LoaderController.shared.removeLoader()
                        
                    } else {
                        
                        print("error : \(String(describing: task.error?.localizedDescription))")
                        
                        print("task.result : \(task.result)")
                        print("task.result.code : \(task.result?.error?.code)")
                        print("task.result.message : \(task.result?.error?.message)")
                        
                        if (task.result?.error?.code?.boolValue)! {
                            
                            if let result = task.result {
                                
                                completion(result, true)
                            }
                        }
                        
                    }
                    
                    return nil
                    
                }
            }
        }
        
    }
    
    
    /// To get a list of participant of a specific group
    ///
    /// - Parameters:
    ///   - requestType: requestType for lambda function
    ///   - groupId: groupId information
    ///   - completion: groupRequest process result responseBody
    /// - Author: Erkut Bas
    func getGroupParticipantList(requestType : RequestType, groupId : String, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        print("getGroupParticipantList starts")
        print("groupId : \(groupId)")
    
        guard let groupRequest = REGroupRequest() else { return }
        
        groupRequest.requestType = requestType.rawValue
        groupRequest.groupid = groupId
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("error : \(String(describing: task.error?.localizedDescription))")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                        LoaderController.shared.removeLoader()
                        
                    } else {
                        
                        print("task result : \(task.result?.resultArrayParticipantList?.count)")
                        
                        if let result = task.result {
                            
                            completion(result, true)
                            
                        }
                        
                    }
                    
                    return nil
                    
                }
            }
        }
        
    }
    
    
    /// To update group information
    ///
    /// - Parameters:
    ///   - requestType: to decide which operations will be processed in lambda
    ///   - groupBody: group objects
    ///   - completion: result and boolean value for completion
    func updateGroupInformation(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
    
        print("updateGroupInformation starts")
        
//        groupBody.displayGroupAttributes()
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.client.groupsPost(authorization: tokenResult.token, body: groupBody).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("task.error : \(task.error)")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                        LoaderController.shared.removeLoader()
                        
                    } else {
                        
                        if let result = task.result {
                            
                            if let error = result.error {
                                
                                if error.code != 1 {
                                    
                                    AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: error.message!, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                                    
                                }
                                
                            }
                            
                            LoaderController.shared.removeLoader()
                            
                            completion(result, true)
                            
                        }
                        
                    }
                    
                    return nil
                    
                }
            }
        }
    
    }
    
    
    /// To add one or more new participants into the existing group
    ///
    /// - Parameters:
    ///   - groupBody: group object
    ///   - completion: result and completion parameter
    func addNewParticipantsToExistingGroup(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        print("addNewParticipantsToExistingGroup starts")
        
        groupBody.displayGroupAttributes()
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                
                self.client.groupsPost(authorization: tokenResult.token, body: groupBody).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("task.error : \(task.error)")
                        
                        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                        
                        LoaderController.shared.removeLoader()
                        
                    } else {
                        
                        if let result = task.result {
                            
                            if let error = result.error {
                                
                                if error.code != 1 {
                                    
                                    AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: error.message!, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
                                    
                                }
                                
                            }
                            
                            LoaderController.shared.removeLoader()
                            
                            completion(result, true)
                            
                        }
                        
                    }
                    
                    return nil
                    
                }
                
            }
        }
        
    }
    
    
    /// To remove a participant from group or remove yourself
    ///
    /// - Parameters:
    ///   - groupBody: group object of REGroupRequest
    ///   - completion: completion object
    func removeParticipantFromGroup(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.client.groupsPost(authorization: tokenResult.token, body: groupBody).continueWith { (task) -> Any? in
                    
                    if task.error != nil {
                        
                        print("Remove from group failed")
                        
                    } else {
                        
                        if let result = task.result {
                            
                            if let error = result.error {
                                
                                if error.code != 1 {
                                    
                                    print("Error code : \(error.code)")
                                    print("Error message : \(error.message)")
                                    
                                } else {
                                    
                                    print("Remove from group is ok!")
                                    completion(result, true)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    return nil
                    
                }
            }
        }
        
    }
    
    
    /// To get friendList fron neo4j
    ///
    /// - Parameters:
    ///   - userid: Authenticated userid
    ///   - completion: comletion REFriendList, result
    func getUserFriendList(userid : String, completion :  @escaping (_ httpResult : REFriendList, _ response : Bool) -> Void) {
        
        let client = RECatchUMobileAPIClient.default()
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                
                self.client.friendsGet(userid: User.shared.userID, authorization: tokenResult.token).continueWith { (taskFriendList) -> Any? in
                    
                    if taskFriendList.error != nil {
                        
                        print("getting friend list failed")
                        
                    } else {
                        
                        print("getting friend list ok")
                        
                        if let result = taskFriendList.result {
                            
                            completion(result, true)
                            
                        }
                        
                        //User.shared.appendElementIntoFriendListAWS(httpResult: taskFriendList.result!)
                        
                    }
                    
                    return nil
                    
                }
                
            }
            
        }
        
        
        
    }
    
}
