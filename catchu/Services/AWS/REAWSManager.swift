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
    func getFeeds(postid: String, catchType: CatchType, page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void )
    func updatePost(post: Post, completion: @escaping (NetworkResult<REBaseResponse>) -> Void )
    func deletePost(postid: String, completion: @escaping (NetworkResult<REBaseResponse>) -> Void )
    func reportPost(postid: String, reportType: ReportType, completion: @escaping (NetworkResult<REBaseResponse>) -> Void)
    func getUploadUrl(imageCount: Int, imageExtension: String, videoCount: Int, videoExtension: String, completion : @escaping (NetworkResult<REBucketUploadResponse>) -> Void )
    func like(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void)
    func unlike(post: Post, commentid: String?, completion: @escaping (NetworkResult<REBaseResponse>) -> Void)
    func getLikeUsers(page: Int, perPage: Int, post: Post, commentid: String?, completion: @escaping (NetworkResult<REUserListResponse>) -> Void)
    func requestRelationProcess(requestType : RequestType, userid : String, targetUserid : String, completion: @escaping (NetworkResult<REFriendRequestList>) -> Void)
    func getCountries(userid: String, completion: @escaping (NetworkResult<RECountryListResponse>)-> Void)
    func deleteUploadUrl(userid: String, delete: REBucketUploadResponse, completion: @escaping (NetworkResult<REBaseResponse>)-> Void)
    func searchUsersGet(searchText: String, page: Int, perPage: Int, completion: @escaping (NetworkResult<REUserListResponse>)-> Void)
    func getUserProfilePosts(targetUserid: String, privacyType: PrivacyType, page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void)
    func getUserProfileCaught(privacyType: String?, page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void)
    func getUserProfileInfo(userid: String, requestedUserid: String, isShortInfo: Bool?, completion: @escaping (NetworkResult<REUserProfile>) -> Void)
    func getUserGroups(requestType: RequestType, completion: @escaping (NetworkResult<REGroupRequestResult>) -> Void)
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
        guard let provider = REProvider() else { return }
        provider.providerType = user.provider
        provider.providerid = user.providerID
        userReq.provider = provider
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = userReq
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.loginPost(userid: ownerUserid, authorization: tokenResult.token, body: baseRequest).continueWith { (task) -> Any? in
                self.processExpectingData(task: task, completion: completion)
                return nil
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
                        
                        print("images index : \(index), uploadUrl : \(uploadUrl)")
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
                        
                        print("videos index : \(index), uploadUrl : \(uploadUrl)")
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
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.commonSignedurlGet(authorization: tokenResult.token, imagecount: imageCountStr, videocount: videoCountStr, videoextension: videoExtension, imageextension: imageExtension).continueWith { (task) -> Any? in
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    
    /// Get shared items to nearby current location within specified range
    /// - Parameters:
    ///   - postid:
    ///   - catchType: It a CatchType. Now public or catch
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - radius: Radius value for searching location
    ///   - completion: A NetworkResult<REPostListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getFeeds(postid: String, catchType: CatchType ,page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard LocationManager.shared.currentLocation != nil else {
            print("\(#function) Lokasyon verisi bos")
            return
        }
        
        guard let userid = User.shared.userid else { return }
        
        let latitude = String(LocationManager.shared.currentLocation.coordinate.latitude)
        let longitude = String(LocationManager.shared.currentLocation.coordinate.longitude)
        let radius = String(radius)
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            
            // TODO: Open
            self.apiClient.postsPostidGet(userid: userid, authorization: tokenResult.token, postid: postid, catchType: catchType.rawValue, longitude: longitude, perPage: perPageStr, latitude: latitude, radius: radius, page: pageStr).continueWith { (task) -> Any? in

                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
        
    }
    
    
    /// Update own post, when comment is allowed change
    /// - Parameters:
    ///   - post: Updated login user's post
    ///   - completion: A NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func updatePost(post: Post, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let userid = User.shared.userid else { return }

        guard let postid = post.postid else { return }
        guard let isCommentAllowed = post.isCommentAllowed else { return }
        
        guard let postRequest = REPostRequest() else { return }
        guard let updatedPost = REPost() else { return }
        updatedPost.isCommentAllowed = NSNumber(value: isCommentAllowed)
        
        postRequest.post = updatedPost
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.postsPostidPatch(userid: userid, postid: postid, authorization: tokenResult.token, body: postRequest).continueWith { (task) -> Any? in
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    /// Delete own post
    /// - Parameters:
    ///   - postid: Deleted postid
    ///   - completion: A NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func deletePost(postid: String, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let userid = User.shared.userid else { return }
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.postsPostidDelete(userid: userid, postid: postid, authorization: tokenResult.token).continueWith { (task) -> Any? in
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    
    /// Report related post
    /// - Parameters:
    ///   - postid: Postid which is reported
    ///   - reportType: A ReportType
    ///   - completion: A NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func reportPost(postid: String, reportType: ReportType, completion: @escaping (NetworkResult<REBaseResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let userid = User.shared.userid else { return }
        
        guard let report = REReport() else { return }
        report.type = reportType.rawValue
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.commonReportPost(userid: userid, authorization: tokenResult.token, body: report, relatedid: postid).continueWith { (task) -> Any? in
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, finished) in
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
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
    func getLikeUsers(page: Int, perPage: Int, post: Post, commentid: String?, completion: @escaping (NetworkResult<REUserListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else { return }
        
        guard let ownerUserid = User.shared.userid else { return }
        guard let postid = post.postid else { return } // postid is mandatory
        
        let commentid = commentid ?? Constants.AWS_PATH_EMPTY
        
        guard let baseRequest = REBaseRequest() else { return }
        baseRequest.user = User.shared.getUser()
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.postsPostidCommentsCommentidLikeGet(userid: ownerUserid, postid: postid, perPage: perPageStr, page: pageStr, authorization: tokenResult.token, commentid: commentid).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            
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
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            
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
    
    
    /// Search name and username withing giving searchText
    ///
    /// - Parameters:
    ///   - searchText: searched Text
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - completion: NetworkResult<REBaseResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func searchUsersGet(searchText: String, page: Int, perPage: Int, completion: @escaping (NetworkResult<REUserListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else {return}

        guard let userid = User.shared.userid else { return }
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.searchUsersGet(userid: userid, searchText: searchText, authorization: tokenResult.token, perPage: perPageStr, page: pageStr).continueWith(block: { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            })
            
        }
    }
    
    
    
    
    /// Gets the target users profile posts
    ///
    /// - Parameters:
    ///   - targetUserid: User which is viewed profile
    ///   - privacyType: A PrivacyType.
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - radius: Radius value for searching location
    ///   - completion: A NetworkResult<REPostListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getUserProfilePosts(targetUserid: String, privacyType: PrivacyType, page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else {return}
        
        guard let userid = User.shared.userid else { return }
        
        let latitude = String(LocationManager.shared.currentLocation.coordinate.latitude)
        let longitude = String(LocationManager.shared.currentLocation.coordinate.longitude)
        let radius = String(radius)
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            self.apiClient.usersUidPostsGet(userid: userid, uid: targetUserid, authorization: tokenResult.token, longitude: longitude, perPage: perPageStr, latitude: latitude, radius: radius, page: pageStr, privacyType: privacyType.stringValue).continueWith(block: { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            })
        }
    }
    
    /// Gets the target users profile posts
    ///
    /// - Parameters:
    ///   - privacyType: A PrivacyType.
    ///   - page: Pagination purposel initial must be 1
    ///   - perPage: Result list item count per page
    ///   - radius: Radius value for searching location
    ///   - completion: A NetworkResult<REPostListResponse>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getUserProfileCaught(privacyType: String?, page: Int, perPage: Int, radius: Double, completion: @escaping (NetworkResult<REPostListResponse>) -> Void) {
        guard Reachability.networkConnectionCheck() else {return}
        
        guard let userid = User.shared.userid else { return }
        
        let latitude = String(LocationManager.shared.currentLocation.coordinate.latitude)
        let longitude = String(LocationManager.shared.currentLocation.coordinate.longitude)
        let radius = String(radius)
        
        let pageStr = "\(page)"
        let perPageStr = "\(perPage)"
        
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, _) in
            
            self.apiClient.usersUidCaughtGet(userid: userid, uid: userid, authorization: tokenResult.token, longitude: longitude, perPage: perPageStr, latitude: latitude, radius: radius, page: pageStr, privacyType: privacyType).continueWith(block: { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            })
        }
    }
    
    
    /// Get Requested User Profile
    ///
    /// - Parameters:
    ///   - userid: Login user's userid
    ///   - requestedUserid: Requested user's userid
    ///   - isShortInfo: When set true return only user info
    ///   - completion: A NetworkResult<REUserProfile>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getUserProfileInfo(userid : String, requestedUserid: String, isShortInfo: Bool?, completion: @escaping (NetworkResult<REUserProfile>) -> Void) {
        let readShortInfo = isShortInfo?.description ?? ""
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, _) in
            self.apiClient.usersGet(userid: userid, requestedUserid: requestedUserid, authorization: tokenResult.token, shortInfo: readShortInfo).continueWith { (task) -> Any? in
                
                print("\(#function) Result: \(task)")
                self.processExpectingData(task: task, completion: completion)
                return nil
            }
        }
    }
    
    
    /// Get Users Groups
    ///
    /// - Parameters:
    ///   - requestType: Group operation request type
    ///   - completion: A NetworkResult<REGroupRequestResult>
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getUserGroups(requestType: RequestType, completion: @escaping (NetworkResult<REGroupRequestResult>) -> Void) {
        
        guard let userid = User.shared.userid else { return }
        guard let groupRequest = REGroupRequest() else { return }
        
        groupRequest.requestType = requestType.rawValue
        groupRequest.userid = userid
        
        FirebaseManager.shared.getIdToken { [unowned self](tokenResult, _) in
            self.apiClient.groupsPost(authorization: tokenResult.token, body: groupRequest).continueWith(block: { (task) -> Any? in
                
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
        if let allowList = share.allowList {
            post.allowList = User.shared.getREUSerList(inputUserList: allowList)
        }
        if let isCommentAllowed = share.isCommentAllowed {
            post.isCommentAllowed = NSNumber(booleanLiteral: isCommentAllowed)
        }
        if let isShowOnMap = share.isShowOnMap {
            post.isShowOnMap = NSNumber(booleanLiteral: isShowOnMap)
        }
        
        if let isCommentAllowed = share.isCommentAllowed {
            post.isCommentAllowed = NSNumber(booleanLiteral: isCommentAllowed)
        }
        if let isShowOnMap = share.isShowOnMap {
            post.isShowOnMap = NSNumber(booleanLiteral: isShowOnMap)
        }
        
        guard let postRequest = REPostRequest() else { return }
        postRequest.post = post
        
        let postid = Constants.AWS_PATH_EMPTY
        FirebaseManager.shared.getIdToken { [unowned self] (tokenResult, finished) in
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

