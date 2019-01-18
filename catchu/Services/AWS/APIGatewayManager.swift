//
//  APIGatewayManager.swift
//  catchu
//
//  Created by Erkut Baş on 8/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

enum ConnectionResult<T> {
    case success(T)
    case failure(ApiConnectionError)
}

enum ApiConnectionError: Error {
    case missingData
    case connectionError(error : Error)
    case serverError(error : Error)
}

protocol ApiGatewayInterface {
    func prepareRetrievedDataFromApigateway<CommonModel>(task: AWSTask<CommonModel>, completion: (ConnectionResult<CommonModel>) -> Void)
}

enum ApiLambdaError: NSNumber {
    case success = 1
}

class APIGatewayManager: ApiGatewayInterface {
    
    /// Description : The function process task object retrived from server. Fragment data such as errors, failures, success etc. And complete function with api response data
    ///
    /// - Parameters:
    ///   - task: AWSTask model
    ///   - completion: completion method holding failures or success
    func prepareRetrievedDataFromApigateway<CommonModel>(task: AWSTask<CommonModel>, completion: (ConnectionResult<CommonModel>) -> Void) {
        
        if let error = task.error {
            completion(.failure(.serverError(error: error)))
        } else if let resultData = task.result {
            completion(.success(resultData))
        } else {
            completion(.failure(.missingData))
        }
        
    }
    
    
    /// Description: REAWSManager api gateway handler
    ///
    /// - Parameters:
    ///   - task: AWSTask model
    ///   - completion: completion method holding failures or success
    private func processExpectingData<Model>(task: AWSTask<Model>, completion: ((NetworkResult<Model>) -> Void)) {
        
        if let error = task.error {
            completion(.failure(.serverError(error: error)))
        } else if let result = task.result {
            completion(.success(result))
        } else {
            completion(.failure(.missingDataError))
        }
    }
    
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
    func getUserProfileInfo(userid : String, requestedUserid: String, completion :  @escaping (_ httpResult : REUserProfile, _ response : Bool) -> Void) {
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            self.client.usersGet(userid: userid, requestedUserid: requestedUserid, authorization: tokenResult.token, shortInfo: "").continueWith { (task) -> Any? in
                
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
        
        guard let userProfileRequest = REUserProfile() else { return }
        
        userProfileRequest.userInfo = userObject.getUserProfile()
        userProfileRequest.requestType = requestType.rawValue
        
        client.usersPost(authorization: "", body: userProfileRequest).continueWith { (task) -> Any? in
            
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
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                self.client.groupsPost(authorization: tokenResult.token, body: inputBody!).continueWith(block: { (task) -> Any? in
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
                })
            }
        }
        
    }
    
    /// Description : get user followers from server.
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - page: page number for pagination logic
    ///   - perPage: number of items in one page
    ///   - completion: task result
    /// - Throws: if userid does not exist, throw client error
    /// - Author: Erkut Bas
    func getUserFriendList(userid: String, page: Int, perPage: Int, completion: @escaping (ConnectionResult<REFriendList>) -> Void) throws {
        
        if userid.isEmpty {
            throw ApiGatewayClientErrors.missingUserId
        }
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, finished) in
            
            if finished {
                
                self.client.friendsGet(userid: userid, perPage: String(perPage), page: String(page), authorization: tokenResult.token).continueWith(block: { (awsTask) -> Any? in
                    
                    self.prepareRetrievedDataFromApigateway(task: awsTask, completion: completion)
                    
                    return nil
                })
            }
            
        }
        
    }
    
    /// Description : get user groups from server
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - page: page number for pagination logic
    ///   - perPage: number of items in one page
    ///   - completion: task result
    /// - Throws: if userid does not exist, throw client error
    /// - Author: Erkut Bas
    func getUserGroupList(userid: String, page: Int?, perPage: Int?, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) throws {
        
        if userid.isEmpty {
            throw ApiGatewayClientErrors.missingUserId
        }
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, finished) in
            
            if finished {
                
                // create group request object
                guard let groupRequest = REGroupRequest() else { return }
                groupRequest.requestType = RequestType.userGroups.rawValue
                groupRequest.userid = userid
                
                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (awsTask) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: awsTask, completion: completion)
                    return nil
                    
                })
                
            }
            
        }
        
    }
    
    /// Description : get participant list of a specific group
    ///
    /// - Parameters:
    ///   - groupid: groupid
    ///   - completion: participant list
    /// - Throws: missing group id
    /// - Author: Erkut Bas
    func getGroupParticipantList(groupid: String, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) throws {
        
        if groupid.isEmpty {
            throw ApiGatewayClientErrors.missingGroupId
        }
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, finished) in
            
            if finished {
                
                // create group request object
                guard let groupRequest = REGroupRequest() else { return }
                groupRequest.requestType = RequestType.get_group_participant_list.rawValue
                groupRequest.groupid = groupid
                
                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (awsTask) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: awsTask, completion: completion)
                    return nil
                    
                })
                
            }
            
        }
        
    }
    
    /// Description : update group information
    ///
    /// - Parameters:
    ///   - group: group object
    ///   - completion: updated group information
    /// - Author: Erkut Bas
    func updateGroupInformation(group: Group, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) {
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, finished) in
            
            if finished {
                
                // create group request object
                guard let groupRequest = group.returnREGroupRequestFromGroup() else { return }
                groupRequest.requestType = RequestType.update_group_info.rawValue

                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (awsTask) -> Any? in
                    
                    self.prepareRetrievedDataFromApigateway(task: awsTask, completion: completion)
                    return nil
                    
                })
                
            }
            
        }
        
    }
    
    /// Description: it's used to upload an image to S3 Bucket and then get a download url for neo4j update process
    ///
    /// - Parameters:
    ///   - data: image converted to data
    ///   - mediaType: media type - image or video
    ///   - imageExtension: image extension
    ///   - completion: download url
    func uploadImageToBucket(data: Data, mediaType: MediaType, imageExtension: String, completion : @escaping (String) -> Void ) {
        
        REAWSManager.shared.getUploadUrl(imageCount: 1, imageExtension: imageExtension, videoCount: 0, videoExtension: Constants.CharacterConstants.EMPTY) { (result) in
        
            switch result {
            case .success(let response):
                
                if let dataImageArray = response.images {
                    if let dataImageSingleObject = dataImageArray.first {
                        guard let uploadString = dataImageSingleObject.uploadUrl else { return }
                        guard let uploadUrl = URL(string: uploadString) else { return }
                        guard let downloadUrl = dataImageSingleObject.downloadUrl else { return }
                        
                        UploadManager.shared.uploadFile(uploadUrl: uploadUrl, data: data, type: mediaType, ext: imageExtension, completion: { (success) in
                            if success {
                                completion(downloadUrl)
                                
                            }
                        })
    
                    }
                }
                
            case .failure(let apiError):
                switch apiError {
                case .serverError(let error):
                    print("Server error: \(error)")
                case .connectionError(let error) :
                    print("Connection error: \(error)")
                case .missingDataError:
                    print("Missing Data Error")
                }
            }
        
        }
        
    }
    
    /// Description : used to remove given participant from group
    ///
    /// - Parameters:
    ///   - group: related group
    ///   - userid: given username who wants to remove from group
    ///   - completion: operation result information
    /// - Author: Erkut Bas
    func removeParticipantFromGroup(group: Group, userid: String, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) {
        
        if (group.groupID?.isEmpty)! || userid.isEmpty {
            print("\(Constants.ALERT)\tUserid or groupid is empty.")
            return
        }

        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                guard let groupRequest = group.returnREGroupRequestFromGroup() else { return }
                groupRequest.userid = userid
                groupRequest.requestType = RequestType.exit_group.rawValue
                
                self.client.groupsPost(authorization: tokenResult.token, body:   groupRequest).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
            }
        }
    }
    
    /// Description: adding new participants to group
    ///
    /// - Parameters:
    ///   - participantArray: user array
    ///   - completion: function completion result
    /// - Author: Erkut Bas
    func addNewParticipantsToGroup(group: Group, participantArray: Array<User>, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) throws {
        
        if participantArray.isEmpty {
            throw ApiGatewayClientErrors.participantArrayCanNotBeEmpty
        }
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                guard let groupRequest = group.returnREGroupRequestFromGroup() else { return }
                groupRequest.requestType = RequestType.add_participant_into_group.rawValue
                groupRequest.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
                
                for item in participantArray {
                    let participantArrayItem = REGroupRequest_groupParticipantArray_item()
                    participantArrayItem?.participantUserid = item.userid
                    groupRequest.groupParticipantArray?.append(participantArrayItem!)
                }
                
                self.client.groupsPost(authorization: tokenResult.token, body:   groupRequest).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
            }
        }
        
    }
    
    /// Description : changes group admin
    ///
    /// - Parameters:
    ///   - group: selected group
    ///   - adminUserid: admin
    ///   - newAdminUserid: new admin
    ///   - completion: result
    /// - Throws: api gateway client errors
    /// - Author: Erkut Bas
    func changeGroupAdmin(group: Group, adminUserid: String, newAdminUserid: String, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) throws {
        
        if adminUserid.isEmpty || newAdminUserid.isEmpty {
            throw ApiGatewayClientErrors.missingUserId
        }
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                guard let groupRequest = group.returnREGroupRequestFromGroup() else { return }
                groupRequest.userid = adminUserid
                groupRequest.requestType = RequestType.changeGroupAdmin.rawValue
                
                groupRequest.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
                let participantArrayItem = REGroupRequest_groupParticipantArray_item()
                participantArrayItem?.participantUserid = newAdminUserid
                groupRequest.groupParticipantArray?.append(participantArrayItem!)
                
                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
                
            }
        }
        
    }
    
    /// Description: Create new group
    ///
    /// - Parameters:
    ///   - group: created group object
    ///   - adminUserid: creator user
    ///   - participantList: group participants
    ///   - completion: network result
    func createNewGroup(groupName: String, groupPhotoUrl: String?, adminUserid: String, participantList: Array<User>, completion: @escaping (ConnectionResult<REGroupRequestResult>) -> Void) {
        
        if adminUserid.isEmpty {
            return
        }
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                guard let groupRequest = REGroupRequest() else { return }
                // minimum properties to create a group
                groupRequest.groupName = groupName
                if let url = groupPhotoUrl {
                    groupRequest.groupPhotoUrl = url
                }
                groupRequest.userid = adminUserid
                
                groupRequest.requestType = RequestType.create_group.rawValue
                
                groupRequest.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
                
                for item in participantList {
                    let participantArrayItem = REGroupRequest_groupParticipantArray_item()
                    participantArrayItem?.participantUserid = item.userid
                    groupRequest.groupParticipantArray?.append(participantArrayItem!)
                }
                
                self.client.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
                
            }
        }
        
    }
    
    /// Description: retrives follow request list for authenticated user
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - completion: follower request list
    /// - Author: Erkut Bas
    func getUserFollowerRequests(userid: String, completion: @escaping (ConnectionResult<REFriendRequestList>) -> Void)
    {
        if userid.isEmpty {
            return
        }
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                let friendRequestBody = REFriendRequest()
                friendRequestBody?.requesterUserid = userid
                friendRequestBody?.requestType = RequestType.getRequestingFollowList.rawValue
                
                guard let body = friendRequestBody else { return }
                
                self.client.followRequestPost(authorization: tokenResult.token, body: body).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
                
            }
        }
    }
    
    /// Description: accepts or rejects follow requests
    ///
    /// - Parameters:
    ///   - requestedUserid: follow requested userid
    ///   - requesterUserid: follow requester userid
    ///   - requestType: reject or confirm follow request
    ///   - completion: network result
    /// - Author: Erkut Bas
    func followRequestOperations(requestedUserid: String, requesterUserid: String, requestType: RequestType, completion: @escaping (ConnectionResult<REFriendRequestList>) -> Void) {
    
        if requestedUserid.isEmpty || requesterUserid.isEmpty {
            return
        }
        
        FirebaseManager.shared.getIdToken { (tokenResult, finish) in
            if finish {
                
                let friendRequestBody = REFriendRequest()
                friendRequestBody?.requestedUserid = requestedUserid
                friendRequestBody?.requesterUserid = requesterUserid
                friendRequestBody?.requestType = requestType.rawValue
                
                guard let body = friendRequestBody else { return }
                
                self.client.followRequestPost(authorization: tokenResult.token, body: body).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
                
            }
        }
        
    }
    
    
    /// Description : post operation
    ///
    /// - Parameters:
    ///   - share: share data
    ///   - completion: network result
    func initiatePostProcess(share: Share, completion: @escaping (NetworkResult<REPostResponse>) -> Void) {
        REAWSManager.shared.createPost(share: Share.shared, completion: completion)
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
            if let imageArray = PostItems.shared.selectedImageArray {
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

    
    /// used for syns facebook friends and catchU followers
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - providerList: facebook friends list
    ///   - completion: user list retrieved from api gateway stored in neo4j
    /// - Author: Erkut Bas
    func initiateFacebookContactExploreProcess(userid : String, providerList : REProviderList, completion : @escaping (ConnectionResult<REUserListResponse>) -> ()) {
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
        
            if finished {
                
                guard let userid = User.shared.userid else { return }
                
                self.client.usersProvidersPost(userid: userid, authorization: tokenResult.token, body: providerList).continueWith(block: { (userListResponse) -> Any? in
                    
                    if userListResponse.error != nil {
                        print("userListResponse.error : \(userListResponse.error)")
                    } else {
                        if let result = userListResponse.result {
                            
                            if let error = result.error {
                                if error.code != 1 {
                                    //completion(.failure(error))
                                }
                            }
                            
                            completion(.success(result))
                            
                        }
                        
                    }
                 
                    return nil
                    
                })
                
            }
            
        }
        
    }
    
    
    /// used for syns device contact list - friends and catchU followers
    ///
    /// - Parameters:
    ///   - userid: authenticated userid
    ///   - providerList: device contact list
    ///   - completion: user list retrieved from api gateway stored in neo4j
    /// - Author: Erkut Bas
    func initiateDeviceContactListExploreOnCatchU(userid : String, providerList : REProviderList, completion : @escaping (ConnectionResult<REUserListResponse>) -> ()) {
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                
                guard let userid = User.shared.userid else { return }
                
                self.client.usersProvidersPost(userid: userid, authorization: tokenResult.token, body: providerList).continueWith(block: { (userListResponse) -> Any? in
                    
                    if userListResponse.error != nil {
                        print("userListResponse.error : \(userListResponse.error)")
                    } else {
                        if let result = userListResponse.result {
                            if let error = result.error {
                                if error.code != 1 {
                                    //completion(.failure(error))
                                }
                            }
                            completion(.success(result))
                        }
                    }
                    return nil
                })
            }
        }
    }

    /// Description: getting user followers or followings list according to request type
    ///
    /// - Parameters:
    ///   - userid: logged in userid
    ///   - requesterUserid: other profile userid
    ///   - page: page number
    ///   - perPage: count for per page
    ///   - requestType: request type - followers or followings
    ///   - completion: follow info list
    /// - Throws: throws apigateway requeired parameters error
    /// - Author: Erkut Bas
    func getUserFollowInfo(userid: String, requesterUserid: String, page: Int, perPage: Int, requestType: RequestType, completion: @escaping (ConnectionResult<REFollowInfoListResponse>) -> Void) throws {
        
        if userid.isEmpty || requesterUserid.isEmpty {
            throw ApiGatewayClientErrors.missingUserId
        }
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, finished) in
            if finished {
                self.client.usersUidFollowGet(userid: userid, uid: requesterUserid, authorization: tokenResult.token, perPage: String(perPage), requestType: requestType.rawValue, page: String(page)).continueWith(block: { (task) -> Any? in
                    self.prepareRetrievedDataFromApigateway(task: task, completion: completion)
                    return nil
                })
            }
            
        }
        
    }
    
}
