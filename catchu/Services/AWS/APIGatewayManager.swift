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
        
        let clientInput = REFriendRequest()
        
        clientInput?.requestType = inputRequestType.rawValue
        clientInput?.requesterUserid = reqester
        clientInput?.requestedUserid = requested
        
        client.followRequestPost(authorization: "", body: clientInput!).continueWith { (task) -> Any? in
            
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
    
    
    /// To get user profile information from neo4j USER node properties
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - completion: REUserProfile
    func getUserProfileInfo(userid : String, completion :  @escaping (_ httpResult : REUserProfile, _ response : Bool) -> Void) {
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
    
            self.client.usersGet(userid: userid, requestedUserid: userid, authorization: tokenResult.token).continueWith { (task) -> Any? in
                
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
    
    
    /// To update user profile information on neo4j USER node properties
    ///
    /// - Parameters:
    ///   - userObject: USER singleton Shared object
    ///   - completion: REError
    func updateUserProfileInformation(requestType : RequestType, userObject : User, completion :  @escaping (_ httpResult : REBaseResponse, _ response : Bool) -> Void) {
        
        print("updateUserProfileInformation starts")
        print("userObject : \(userObject)")
        
        let inputREUserProfile = REUserProfile()
        let inputUserInfo = REUserProfileProperties()
        
//        inputUserInfo?.setUserProfileInformation(user: userObject)
        
        inputREUserProfile?.userInfo = inputUserInfo
        inputREUserProfile?.requestType = requestType.rawValue
        
//        inputREUserProfile?.userInfo?.displayProperties()
        
        client.usersPost(authorization: "", body: inputREUserProfile!).continueWith { (task) -> Any? in
            
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
        
        let inputBody = REGroupRequest()
        
        inputBody?.requestType = requestType.rawValue
        inputBody?.groupid = groupId
        
        //        client.groupsPost(body: inputBody!).continueWith { (task) -> Any? in
        //
        //            if task.error != nil {
        //
        //                print("error : \(String(describing: task.error?.localizedDescription))")
        //
        //                AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        //
        //                LoaderController.shared.removeLoader()
        //
        //            } else {
        //
        //                print("task result : \(task.result?.resultArrayParticipantList?.count)")
        //
        //                if let result = task.result {
        //
        //                    completion(result, true)
        //
        //                }
        //
        //            }
        //
        //            return nil
        //
        //        }
        
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
        
        //        client.groupsPost(body: groupBody).continueWith { (task) -> Any? in
        //
        //            if task.error != nil {
        //
        //                print("task.error : \(task.error)")
        //
        //                AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        //
        //                LoaderController.shared.removeLoader()
        //
        //            } else {
        //
        //                if let result = task.result {
        //
        //                    if let error = result.error {
        //
        //                        if error.code != 1 {
        //
        //                            AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: error.message!, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        //
        //                        }
        //
        //                    }
        //
        //                    LoaderController.shared.removeLoader()
        //
        //                    completion(result, true)
        //
        //                }
        //
        //            }
        //
        //            return nil
        //
        //        }
        
    }
    
    
    /// To add one or more new participants into the existing group
    ///
    /// - Parameters:
    ///   - groupBody: group object
    ///   - completion: result and completion parameter
    func addNewParticipantsToExistingGroup(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        print("addNewParticipantsToExistingGroup starts")
        
        groupBody.displayGroupAttributes()
        
        //        client.groupsPost(body: groupBody).continueWith { (task) -> Any? in
        //
        //            if task.error != nil {
        //
        //                print("task.error : \(task.error)")
        //
        //                AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: LocalizedConstants.DefaultError, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        //
        //                LoaderController.shared.removeLoader()
        //
        //            } else {
        //
        //                if let result = task.result {
        //
        //                    if let error = result.error {
        //
        //                        if error.code != 1 {
        //
        //                            AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Warning, message: error.message!, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        //
        //                        }
        //
        //                    }
        //
        //                    LoaderController.shared.removeLoader()
        //
        //                    completion(result, true)
        //
        //                }
        //
        //            }
        //
        //            return nil
        //
        //        }
        
    }
    
    
    /// To remove a participant from group or remove yourself
    ///
    /// - Parameters:
    ///   - groupBody: group object of REGroupRequest
    ///   - completion: completion object
    func removeParticipantFromGroup(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        //        client.groupsPost(body: groupBody).continueWith { (task) -> Any? in
        //
        //            if task.error != nil {
        //
        //                print("Remove from group failed")
        //
        //            } else {
        //
        //                if let result = task.result {
        //
        //                    if let error = result.error {
        //
        //                        if error.code != 1 {
        //
        //                            print("Error code : \(error.code)")
        //                            print("Error message : \(error.message)")
        //
        //                        } else {
        //
        //                            print("Remove from group is ok!")
        //                            completion(result, true)
        //
        //                        }
        //
        //                    }
        //
        //                }
        //
        //            }
        //
        //            return nil
        //
        //        }
        
        
    }
    
    func createNewGroup(groupBody : REGroupRequest, completion :  @escaping (_ httpResult : REGroupRequestResult, _ response : Bool) -> Void) {
        
        //        client.groupsPost(body: groupBody).continueWith { (task) -> Any? in
        //
        //            if task.error != nil {
        //
        //                print("Remove from group failed")
        //
        //            } else {
        //
        //                if let result = task.result {
        //
        //                    if let error = result.error {
        //
        //                        if error.code != 1 {
        //
        //                            print("Error code : \(error.code)")
        //                            print("Error message : \(error.message)")
        //
        //                        } else {
        //
        //                            print("Remove from group is ok!")
        //                            completion(result, true)
        //
        //                        }
        //
        //                    }
        //
        //                }
        //
        //            }
        //
        //            return nil
        //
        //        }
        
    }
    
    
    /// Function Below triggers a group of events in a row. Firstly get download and upload urls from server. Then update group image url in neo4j.
    ///
    /// - Parameter inputImage: images selected from gallery or taken already
//    func startImageUploadProcess(inputImage : UIImage, inputGroup: Group, completion : @escaping (_ response : Bool, _ s3result : RECommonS3BucketResult, _ updatedGroupObject : Group) -> Void) {
//
//        REAWSManager.shared.getSignedUpload { (s3BucketResult) in
//
//            // check getting upload and download url request from lambda is ok or not
//            if let error = s3BucketResult.error {
//                if let errorCode = error.code {
//                    if errorCode.boolValue {
//
//                        // if everyting is all right, let's update group photo url with new one retrieved from s3 lambda service
//                        print("s3BucketResult : \(String(describing: s3BucketResult.downloadUrl))")
//                        print("s3BucketResult : \(String(describing: s3BucketResult.signedUrl))")
//
//                        // call upload image directly s3 from client
//                        REAWSManager.shared.uploadFileToS3WithImageInput(inputImage: inputImage, commonS3BucketResult: s3BucketResult, completion: { (response) in
//
//                            // upload process is ok, call apigateway to update group information
//                            if response {
//
//                                // update photoUrl of inputGroup
//                                inputGroup.groupPictureUrl = s3BucketResult.downloadUrl
//
//                                APIGatewayManager.shared.updateGroupInformation(groupBody: Group.shared.returnGroupRequestForUpdateProcess(inputGroup: inputGroup), completion: { (groupRequestResult, groupProcessResponse) in
//
//                                    // group information update process in neo4j is ok
//                                    if groupProcessResponse {
//
//                                        completion(true, s3BucketResult, inputGroup)
//
//                                    }
//                                })
//                            }
//                        })
//                    }
//                }
//            }
//        }
//
//    }
    
    
    /// To get friendList fron neo4j
    ///
    /// - Parameters:
    ///   - userid: Authenticated userid
    ///   - completion: comletion REFriendList, result
    func getUserFriendList(userid : String, completion :  @escaping (_ httpResult : REFriendList, _ response : Bool) -> Void) {
        
        let client = RECatchUMobileAPIClient.default()
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                
                guard let userid = User.shared.userid else { return }
                
                client.friendsGet(userid: userid, authorization: tokenResult.token).continueWith { (taskFriendList) -> Any? in
                    
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
    
    func initiatePostOperations() {
        
        Share.shared.convertPostItemsToShare()
        
//        afterPostOperations(granted: false)
        
        REAWSManager.shared.createPost(share: Share.shared) { (result) in

            switch (result) {
            case .success(let response):

                if let error = response.error {
                    if error.code != 1 {
                        print("post operation is failed")
                        self.afterPostOperations(granted: false)
                    }
                }
                
                // if everything is ok, let get user informed
                self.afterPostOperations(granted: true)

            default:
                self.afterPostOperations(granted: false)
                break;
            }

        }
        
    }
    
    func afterPostOperations(granted : Bool) {
        
        print("afterPostOperations starts")
        print("LoaderController.currentViewController() : \(LoaderController.currentViewController())")
        
        var imageAttachmentArray = [UIImage]()
        
        if !granted {
            if let imageArray = PostItems.shared.selectedImageDictionary {
                if let image = imageArray.first {
                    
                    imageAttachmentArray.append(image)
                    
                }
            }
            
            if let videoScreenShot = PostItems.shared.selectedVideoScreenShootWithPlayButton {
                if let imageObject = videoScreenShot.first {
                    
                    imageAttachmentArray.append(imageObject.value)
                    
                }
            }
            
            if let noteSnapShot = PostItems.shared.messageScreenShot {
                imageAttachmentArray.append(noteSnapShot)
            }
            
            CustomNotificationManager.shared.sendNotification(inputTitle: LocalizedConstants.Notification.postTitle , inputSubTitle: Constants.CharacterConstants.EMPTY, inputMessage: LocalizedConstants.Notification.postFailedMessage, inputIdentifier: "postIdentifier", operationResult: granted, image: imageAttachmentArray) { (finish) in
                
                if finish {
                    print("GOGOGOGOGOGOGOGOOG")
                }
            }
            
        } else {
            
            // if post operation is succesfull
            CustomNotificationManager.shared.sendNotification(inputTitle: LocalizedConstants.Notification.postTitle , inputSubTitle: Constants.CharacterConstants.EMPTY, inputMessage: LocalizedConstants.Notification.postSuccessMessage, inputIdentifier: "postIdentifier", operationResult: granted, image: []) { (finish) in

                if finish {
                    print("GOGOGOGOGOGOGOGOOG 2")
                }
            }
            
        }
        
        
    }
    
}
