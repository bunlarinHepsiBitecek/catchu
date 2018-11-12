//
//  REAWSManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//
import UIKit
import AWSCore
import AWSS3

enum BackEndAPIErrorCode: NSNumber {
    case success = 1
}

enum BackEndAPIError: Error {
    // The Server returned no data
    case missingDataError
    // Can't connect to the server (maybe offline?)
    case connectionError(error: Error)
    // The server responded with a non 200 status code
    case serverError(error: Error)
}

enum NetworkResult<T> {
    case success(T)
    case failure(BackEndAPIError)
}

protocol BackEndAPIInterface {
    func createPost(share: Share, completion: @escaping (NetworkResult<REPostResponse>)-> Void)
    func getFeeds(page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void )
    func getUploadUrl(imageCount: Int, imageExtension: String, videoCount: Int, videoExtension: String, completion : @escaping (NetworkResult<REBucketUploadResponse>) -> Void )
    func like(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void)
    func unlike(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void)
    func getlikeUsers(page: Int, perPage: Int, post: Post, commentid: String?, completion: @escaping (NetworkResult<REUserListResponse>) -> Void)
    func requestRelationProcess(requestType : RequestType, userid : String, targetUserid : String, completion: @escaping (NetworkResult<REFriendRequestList>) -> Void)
    func getCountries(userid: String, completion: @escaping (NetworkResult<RECountryListResponse>)-> Void)
    func deleteUploadUrl(userid: String, delete: REBucketUploadResponse, completion: @escaping (NetworkResult<REBaseResponse>)-> Void)
}

class REAWSManager: BackEndAPIInterface {
    
    public static let shared = REAWSManager()
    let apiClient = RECatchUMobileAPIClient.default()
    
    /// Handle AWS API Gateway errors
    ///
    /// - Parameters:
    ///   - task: Return from API Method Call,  AWSTask<Model>
    ///   - completion: Client NetworkResult<Model>
    private func processExpectingData<Model>(task: AWSTask<Model>, completion: ((NetworkResult<Model>) -> Void)) {
        if let error = task.error {
            completion(.failure(.serverError(error: error)))
        } else if let result = task.result {
            completion(.success(result))
        } else {
            completion(.failure(.missingDataError))
        }
    }
    
    
    /// Call after Register user or signin via other provider Facebook, Twitter
    ///
    /// - Parameters:
    ///   - user: Contains login user info
    ///   - completion: A NetworkResult<REBaseResponse>
    func loginSync(user: User, completion : @escaping (NetworkResult<REBaseResponse>) -> Void ) {
        guard Reachability.networkConnectionCheck() else {return}
        
        guard let ownerUserid = user.userid else { return }
        
        guard let userReq = REUser() else { return }
        userReq.userid = user.userid
        userReq.name = user.name
        userReq.username = user.username
        userReq.email = user.email
        userReq.profilePhotoUrl = user.profilePictureUrl
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = userReq
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                
                self.apiClient.loginPost(userid: ownerUserid, authorization: tokenResult.token, body: baseRequest).continueWith { (task) -> Any? in
                    self.processExpectingData(task: task, completion: completion)
                    return nil
                }
                
            }
        }
        
        
    }
    
    /// Send text, image data to graph via AWS
    ///
    /// - Parameters:
    ///   - share: Share object contains message, images and videos
    ///   - completion: A NetworkResult<REPostResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func createPost(share: Share, completion: @escaping (NetworkResult<REPostResponse>)-> Void) {
        guard Reachability.networkConnectionCheck() else {return}
        
        var mediaCount = 0
        var completionCount = 0 {
            didSet {
                if completionCount == mediaCount {
                    self.sharePostRequest(share: share, completion: completion)
                }
            }
        }
        
        var imageExtension = Constants.Feed.DefaultImageExtension
        var videoExtension = Constants.Feed.DefaultVideoExtension
        var imageCount = 0
        var videoCount = 0
        if let images = share.images {
            imageCount = images.count
            if let ext = images[0].media._extension {
                imageExtension = ext
            }
        }
        if let videos = share.videos {
            videoCount = videos.count
            if let ext = videos[0].media._extension {
                videoExtension = ext
            }
        }
        
        mediaCount = imageCount + videoCount
        
        if mediaCount == 0 {
            self.sharePostRequest(share: share, completion: completion)
            return
        }
        
        
        self.getUploadUrl(imageCount: imageCount, imageExtension: imageExtension, videoCount: videoCount, videoExtension: videoExtension) { (result) in
            switch result {
            case .success(let bucket):
                if let items = share.images {
                    guard let bucketItems = bucket.images else { return }
                    
                    for (index, item) in items.enumerated() {
                        let bucketItem = bucketItems[index]
                        guard let urlStr = bucketItem.uploadUrl else { return }
                        guard let uploadUrl = URL(string: urlStr) else { return }
                        item.media.url = bucketItem.downloadUrl
                        item.media.thumbnail = bucketItem.thumbnailUrl
                        item.media._extension = bucketItem._extension
                        guard let data = item.toData() else { return }
                        guard let ext = item.media._extension else { return }
                        
                        UploadManager.shared.uploadFile(uploadUrl: uploadUrl, data: data, type: item.type, ext: ext) { (result) in
                            completionCount += 1
                        }
                    }
                }
                
                if let items = share.videos {
                    guard let bucketItems = bucket.videos else { return }
                    
                    for (index, item) in items.enumerated() {
                        let bucketItem = bucketItems[index]
                        guard let urlStr = bucketItem.uploadUrl else { return }
                        guard let uploadUrl = URL(string: urlStr) else { return }
                        item.media.url = bucketItem.downloadUrl
                        item.media.thumbnail = bucketItem.thumbnailUrl
                        item.media._extension = bucketItem._extension
                        guard let data = item.toData() else { return }
                        guard let ext = item.media._extension else { return }
                        
                        UploadManager.shared.uploadFile(uploadUrl: uploadUrl, data: data, type: item.type, ext: ext) { (result) in
                            completionCount += 1
                        }
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
    
    
    /// Return signed upload url for AWS S3
    ///
    /// - Parameters:
    ///   - imageCount: Image count
    ///   - imageExtension: Image extension
    ///   - videoCount: Video count
    ///   - videoExtension: Video extension
    ///   - completion: A NetworkResult<REBucketUploadResult>
    func getUploadUrl(imageCount: Int, imageExtension: String, videoCount: Int, videoExtension: String, completion : @escaping (NetworkResult<REBucketUploadResponse>) -> Void ) {
        
        if imageCount + videoCount == 0 {
            return
        }
        
        let imageCountStr = "\(imageCount)"
        let videoCountStr = "\(videoCount)"
        
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                self.apiClient.commonSignedurlGet(authorization: tokenResult.token, imagecount: imageCountStr, videocount: videoCountStr, videoextension: videoExtension, imageextension: imageExtension).continueWith { (task) -> Any? in
                    self.processExpectingData(task: task, completion: completion)
                    return nil
                }
            }
        }
    }
    
    
    /// Get shared items to nearby current location within specified range
    /// - Parameters:
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - radius: Radius value for searching location
    ///   - completion: A NetworkResult<REPostListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getFeeds(page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard LocationManager.shared.currentLocation != nil else {
            print("\(#function) Lokasyon verisi bos")
            return
        }
        
        let latitude = String(LocationManager.shared.currentLocation.coordinate.latitude)
        let longitude = String(LocationManager.shared.currentLocation.coordinate.longitude)
        let radius = String(radius)
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = REUser()
        baseRequest.user?.userid = User.shared.userid
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            self.apiClient.postsGeolocationPost(authorization: tokenResult.token, body: baseRequest, longitude: longitude, perPage: perPageStr, latitude: latitude, radius: radius, page: pageStr).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
        
    }
    
    
    
    /// Get posts comments with replies. This methot also use for get list of comment of comments
    ///
    /// - Parameters:
    ///   - post: mandatory post for getting comments
    ///   - commentid: when giving commentid if exists gets comment of comments
    ///   - completion: A [Comment]
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getPostComments(post: Post, commentid: String, completion: @escaping (NetworkResult<RECommentListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let postid = post.postid else { return }
        guard let userid = User.shared.userid else { return }
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = User.shared.getUser()
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            self.apiClient.postsPostidCommentsCommentidGet(userid: userid, postid: postid, authorization: tokenResult.token, commentid: commentid).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                
                self.processExpectingData(task: task, completion: completion)
                
                return nil
            }
        }
    }
    
    
    
    /// Create a comment to the post or the comment
    ///
    /// - Parameters:
    ///   - post: Post object
    ///   - repliedCommentid: When replied comment it contains replied comment's commentid
    ///   - comment: Contain message and user info
    ///   - completion: A Comment
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func comment(post: Post, repliedCommentid: String?, comment: Comment ,completion: @escaping (NetworkResult<RECommentResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let postid = post.postid else { return } // postid is mandatory
        guard let userid = User.shared.userid else { return } // userid is mandatory
        
        guard let message = comment.message, !message.isEmpty else { return } // message is mandatory
        
        let commentid = repliedCommentid ?? Constants.AWS_PATH_EMPTY // optional
        
        guard let commentRequest = RECommentRequest() else { return }
        commentRequest.comment = REComment()
        
        commentRequest.comment!.message = message
        commentRequest.comment!.user = User.shared.getUser()
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            print("Token: \(tokenResult.token)")
            print("Userid: \(userid)")
            
            self.apiClient.postsPostidCommentsCommentidPost(userid: userid, postid: postid, authorization: tokenResult.token, commentid: commentid, body: commentRequest).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
        
    }
    
    
    /// Like post or comment
    ///
    /// - Parameters:
    ///   - post: Post object
    ///   - commentid: When like a comment it filled with liked commentid
    ///   - completion: A NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func like(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let postid = post.postid else { return } // postid is mandatory
        guard let userid = User.shared.userid else { return }
        
        let commentid = commentid ?? Constants.AWS_PATH_EMPTY
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = User.shared.getUser()
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            self.apiClient.postsPostidCommentsCommentidLikePost(userid: userid, postid: postid, authorization: tokenResult.token, commentid: commentid).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
        
    }
    
    
    /// Unlike post or comment
    ///
    /// - Parameters:
    ///   - post: Post object
    ///   - commentid: When unlike a comment it filled with unliked commentid
    ///   - completion: A NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func unlike(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let postid = post.postid else { return } // postid is mandatory
        guard let userid = User.shared.userid else { return }
        
        let commentid = commentid ?? Constants.AWS_PATH_EMPTY // optional
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = User.shared.getUser()
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            self.apiClient.postsPostidCommentsCommentidLikeDelete(userid: userid, postid: postid, authorization: tokenResult.token, commentid: commentid).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    
    /// Get like user list a post or a comment
    /// - Parameters:
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - post: Post object
    ///   - commentid: When get comment likers then fill commentid
    ///   - completion: A NetworkResult<REUserListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getlikeUsers(page: Int, perPage: Int, post: Post, commentid: String?, completion: @escaping (NetworkResult<REUserListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let ownerUserid = User.shared.userid else { return }
        guard let postid = post.postid else { return } // postid is mandatory
        
        let commentid = commentid ?? Constants.AWS_PATH_EMPTY
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = User.shared.getUser()
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                
                self.apiClient.postsPostidCommentsCommentidLikeGet(userid: ownerUserid, postid: postid, perPage: perPageStr, page: pageStr, authorization: tokenResult.token, commentid: commentid).continueWith { (task) -> Any? in
                    
                    print("\(#function) Result: \(task)")
                    self.processExpectingData(task: task, completion: completion)
                    return nil
                }
            }
        }
    }
    
    /// The function below manages realtionship between authenticated user and the users registerd in catchu
    ///
    /// - Parameters:
    ///   - requestType:
    ///     makeFollowRequest : to request a follow from a user whose account is private
    ///     acceptFollowRequest : to accept a follow request
    ///     getRequestingFollowList : to get a list of request made by users
    ///     createFollowDirectly : to create a follow with a user whose account is not private
    ///     deleteFollow : to unfollow a user
    ///     deletePendingFollowRequest : to withdraw a follow request
    ///   - userid: requester userid
    ///   - requestedUserid: requested userid
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func requestRelationProcess(requestType : RequestType, userid : String, targetUserid : String, completion: @escaping (NetworkResult<REFriendRequestList>) -> Void) {
        
        guard let friendRequest = REFriendRequest() else { return }
        friendRequest.requestType = requestType.rawValue
        friendRequest.requesterUserid = userid
        friendRequest.requestedUserid = targetUserid
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            self.apiClient.followRequestPost(authorization: tokenResult.token, body: friendRequest).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    
    
    /// Return country code and phone dial code
    ///
    /// - Parameters:
    ///   - userid: Login userid
    ///   - completion: A NetworkResult<RECountryListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getCountries(userid: String, completion: @escaping (NetworkResult<RECountryListResponse>) -> Void) {
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            self.apiClient.commonCountriesGet(userid: userid, authorization: tokenResult.token).continueWith(block: { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            })
            
        }
    }
    
    
    /// Delete S3 files
    ///
    /// - Parameters:
    ///   - userid: Login user's userid
    ///   - delete: Delete images and url list object, it return getUploadUrl
    ///   - completion: NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func deleteUploadUrl(userid: String, delete: REBucketUploadResponse, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, finished) in
            
            self.apiClient.commonSignedurlDelete(userid: userid, authorization: tokenResult.token, body: delete).continueWith(block: { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            })
        }
    }
}


// private function
extension REAWSManager {
    
    private func sharePostRequest(share: Share, completion: @escaping (NetworkResult<REPostResponse>)-> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let shareLocation = Share.shared.location else { return }
        
        guard let user = REUser() else { return }
        user.userid = User.shared.userid
        
        guard let location = RELocation() else { return }
        location.latitude = NSNumber(value: shareLocation.coordinate.latitude)
        location.longitude = NSNumber(value: shareLocation.coordinate.longitude)
        
        var attachments = [REMedia]()
        
        // Images
        if let items = share.images {
            for item in items {
                if let media = REMedia() {
                    media.type = item.type.rawValue
                    media.url = item.media.url
                    media.thumbnail = item.media.thumbnail
                    media._extension = item.media._extension
                    if let width = item.media.width {
                        media.width = NSNumber(value: width)
                    }
                    if let height = item.media.height {
                        media.height = NSNumber(value: height)
                    }
                    attachments.append(media)
                }
            }
        }
        
        // Videos
        if let items = share.videos {
            for item in items {
                if let media = REMedia() {
                    media.type = item.type.rawValue
                    media.url = item.media.url
                    media.thumbnail = item.media.thumbnail
                    media._extension = item.media._extension
                    if let width = item.media.width {
                        media.width = NSNumber(value: width)
                    }
                    if let height = item.media.height {
                        media.height = NSNumber(value: height)
                    }
                    attachments.append(media)
                }
            }
        }
        
        guard let post = REPost() else { return }
        post.user = user
        post.location = location
        post.attachments = attachments
        post.message = Share.shared.message
        post.privacyType = share.privacyType?.stringValue
        post.groupid = share.groupid
        
//        post.privacyType = PrivacyType.allFollowers.stringValue
        // MARK: for custom person selected
        //        post.privacyType = PrivacyType.custom.stringValue
        //        post.allowList = []
        //        let user1 = REShare_allowList_item()
        //        let user2 = REShare_allowList_item()
        //        user1?.userid = "us-east-1:ea155b84-4f97-49f0-8559-5b20d507bdfa"
        //        user2?.userid = "us-east-1:8a22a451-af0d-48cb-8e6b-f0ed3316449b"
        //        share?.allowList?.append(user1!)
        //        share?.allowList?.append(user2!)
        
        guard let postRequest = REPostRequest() else { return }
        postRequest.post = post
        
        let postid = Constants.AWS_PATH_EMPTY
        
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                
                self.apiClient.postsPostidPost(postid: postid, authorization: tokenResult.token, body: postRequest).continueWith { (task) -> Any? in
                    print("\(#function) Result: \(task)")
                    
                    self.processExpectingData(task: task, completion: completion)
                    return nil
                }
            }
        }
    }
}

