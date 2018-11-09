/*
 Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at
 
 http://aws.amazon.com/apache2.0
 
 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */


import AWSCore
import AWSAPIGateway

public class RECatchUMobileAPIClient: AWSAPIGatewayClient {
    
    static let AWSInfoClientKey = "RECatchUMobileAPIClient"
    
    private static let _serviceClients = AWSSynchronizedMutableDictionary()
    private static let _defaultClient:RECatchUMobileAPIClient = {
        var serviceConfiguration: AWSServiceConfiguration? = nil
        let serviceInfo = AWSInfo.default().defaultServiceInfo(AWSInfoClientKey)
        if let serviceInfo = serviceInfo {
            serviceConfiguration = AWSServiceConfiguration(region: serviceInfo.region, credentialsProvider: serviceInfo.cognitoCredentialsProvider)
        } else if (AWSServiceManager.default().defaultServiceConfiguration != nil) {
            serviceConfiguration = AWSServiceManager.default().defaultServiceConfiguration
        } else {
            serviceConfiguration = AWSServiceConfiguration(region: .Unknown, credentialsProvider: nil)
        }
        
        return RECatchUMobileAPIClient(configuration: serviceConfiguration!)
    }()
    
    /**
     Returns the singleton service client. If the singleton object does not exist, the SDK instantiates the default service client with `defaultServiceConfiguration` from `AWSServiceManager.defaultServiceManager()`. The reference to this object is maintained by the SDK, and you do not need to retain it manually.
     
     If you want to enable AWS Signature, set the default service configuration in `func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)`
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
     let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
     AWSServiceManager.default().defaultServiceConfiguration = configuration
     
     return true
     }
     
     Then call the following to get the default service client:
     
     let serviceClient = RECatchUMobileAPIClient.default()
     
     Alternatively, this configuration could also be set in the `info.plist` file of your app under `AWS` dictionary with a configuration dictionary by name `RECatchUMobileAPIClient`.
     
     @return The default service client.
     */
    
    public class func `default`() -> RECatchUMobileAPIClient{
        return _defaultClient
    }
    
    /**
     Creates a service client with the given service configuration and registers it for the key.
     
     If you want to enable AWS Signature, set the default service configuration in `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)`
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
     let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
     RECatchUMobileAPIClient.registerClient(withConfiguration: configuration, forKey: "USWest2RECatchUMobileAPIClient")
     
     return true
     }
     
     Then call the following to get the service client:
     
     
     let serviceClient = RECatchUMobileAPIClient.client(forKey: "USWest2RECatchUMobileAPIClient")
     
     @warning After calling this method, do not modify the configuration object. It may cause unspecified behaviors.
     
     @param configuration A service configuration object.
     @param key           A string to identify the service client.
     */
    
    public class func registerClient(withConfiguration configuration: AWSServiceConfiguration, forKey key: String){
        _serviceClients.setObject(RECatchUMobileAPIClient(configuration: configuration), forKey: key  as NSString);
    }
    
    /**
     Retrieves the service client associated with the key. You need to call `registerClient(withConfiguration:configuration, forKey:)` before invoking this method or alternatively, set the configuration in your application's `info.plist` file. If `registerClientWithConfiguration(configuration, forKey:)` has not been called in advance or if a configuration is not present in the `info.plist` file of the app, this method returns `nil`.
     
     For example, set the default service configuration in `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) `
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "YourIdentityPoolId")
     let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
     RECatchUMobileAPIClient.registerClient(withConfiguration: configuration, forKey: "USWest2RECatchUMobileAPIClient")
     
     return true
     }
     
     Then call the following to get the service client:
     
     let serviceClient = RECatchUMobileAPIClient.client(forKey: "USWest2RECatchUMobileAPIClient")
     
     @param key A string to identify the service client.
     @return An instance of the service client.
     */
    public class func client(forKey key: String) -> RECatchUMobileAPIClient {
        objc_sync_enter(self)
        if let client: RECatchUMobileAPIClient = _serviceClients.object(forKey: key) as? RECatchUMobileAPIClient {
            objc_sync_exit(self)
            return client
        }
        
        let serviceInfo = AWSInfo.default().defaultServiceInfo(AWSInfoClientKey)
        if let serviceInfo = serviceInfo {
            let serviceConfiguration = AWSServiceConfiguration(region: serviceInfo.region, credentialsProvider: serviceInfo.cognitoCredentialsProvider)
            RECatchUMobileAPIClient.registerClient(withConfiguration: serviceConfiguration!, forKey: key)
        }
        objc_sync_exit(self)
        return _serviceClients.object(forKey: key) as! RECatchUMobileAPIClient;
    }
    
    /**
     Removes the service client associated with the key and release it.
     
     @warning Before calling this method, make sure no method is running on this client.
     
     @param key A string to identify the service client.
     */
    public class func removeClient(forKey key: String) -> Void{
        _serviceClients.remove(key)
    }
    
    init(configuration: AWSServiceConfiguration) {
        super.init()
        
        self.configuration = configuration.copy() as! AWSServiceConfiguration
        var URLString: String = "https://gg83crxb25.execute-api.us-east-1.amazonaws.com/prod"
        if URLString.hasSuffix("/") {
            URLString = URLString.substring(to: URLString.index(before: URLString.endIndex))
        }
        self.configuration.endpoint = AWSEndpoint(region: configuration.regionType, service: .APIGateway, url: URL(string: URLString))
        let signer: AWSSignatureV4Signer = AWSSignatureV4Signer(credentialsProvider: configuration.credentialsProvider, endpoint: self.configuration.endpoint)
        if let endpoint = self.configuration.endpoint {
            self.configuration.baseURL = endpoint.url
        }
        self.configuration.requestInterceptors = [AWSNetworkingRequestInterceptor(), signer]
    }
    
    
    /*
     
     
     @param authorization
     @param imagecount
     @param videocount
     @param videoextension
     @param imageextension
     
     return type: REBucketUploadResponse
     */
    public func commonSignedurlGet(authorization: String, imagecount: String?, videocount: String?, videoextension: String?, imageextension: String?) -> AWSTask<REBucketUploadResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["imagecount"] = imagecount
        queryParameters["videocount"] = videocount
        queryParameters["videoextension"] = videoextension
        queryParameters["imageextension"] = imageextension
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/common/signedurl", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REBucketUploadResponse.self) as! AWSTask<REBucketUploadResponse>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     
     return type: REFriendRequestList
     */
    public func followRequestPost(authorization: String, body: REFriendRequest) -> AWSTask<REFriendRequestList> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/follow-request", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REFriendRequestList.self) as! AWSTask<REFriendRequestList>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     
     return type: REFriendList
     */
//    public func friendsGet(userid: String) -> AWSTask<REFriendList> {
//        let headerParameters = [
//            "Content-Type": "application/json",
//            "Accept": "application/json",
//
//            ]
//
//        var queryParameters:[String:Any] = [:]
//        queryParameters["userid"] = userid
//
//        let pathParameters:[String:Any] = [:]
//
//        return self.invokeHTTPRequest("GET", urlString: "/friends", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REFriendList.self) as! AWSTask<REFriendList>
//    }
    
    public func friendsGet(userid: String, authorization: String) -> AWSTask<REFriendList> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization
        ]
        
        print("authorization : \(authorization)")
        
        var queryParameters:[String:Any] = [:]
        queryParameters["userid"] = userid
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/friends", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REFriendList.self) as! AWSTask<REFriendList>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     
     return type: REGroupRequestResult
     */
    public func groupsPost(authorization: String, body: REGroupRequest) -> AWSTask<REGroupRequestResult> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/groups", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REGroupRequestResult.self) as! AWSTask<REGroupRequestResult>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     
     return type: REBaseResponse
     */
    public func loginPost(authorization: String, body: REBaseRequest) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/login", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     @param longitude
     @param perPage
     @param latitude
     @param radius
     @param page
     
     return type: REPostListResponse
     */
    public func postsGeolocationPost(authorization: String, body: REBaseRequest, longitude: String?, perPage: String?, latitude: String?, radius: String?, page: String?) -> AWSTask<REPostListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["longitude"] = longitude
        queryParameters["perPage"] = perPage
        queryParameters["latitude"] = latitude
        queryParameters["radius"] = radius
        queryParameters["page"] = page
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/geolocation", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REPostListResponse.self) as! AWSTask<REPostListResponse>
    }
    
    
    /*
     
     
     @param postid
     @param authorization
     @param body
     
     return type: REPostResponse
     */
    public func postsPostidPost(postid: String, authorization: String, body: REPostRequest) -> AWSTask<REPostResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REPostResponse.self) as! AWSTask<REPostResponse>
    }
    
    
    /*
     
     
     @param postid
     @param authorization
     @param commentid
     @param body
     
     return type: RECommentResponse
     */
    public func postsPostidCommentsCommentidAddPost(postid: String, authorization: String, commentid: String, body: RECommentRequest) -> AWSTask<RECommentResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}/add", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: RECommentResponse.self) as! AWSTask<RECommentResponse>
    }
    
    
    /*
     
     
     @param postid
     @param commentid
     @param body
     @param authorization
     
     return type: RECommentListResponse
     */
    public func postsPostidCommentsCommentidGetPost(postid: String, commentid: String, body: REBaseRequest, authorization: String?) -> AWSTask<RECommentListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization!
        ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}/get", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: RECommentListResponse.self) as! AWSTask<RECommentListResponse>
    }
    
    
    /*
     
     
     @param postid
     @param authorization
     @param commentid
     @param body
     
     return type: REBaseResponse
     */
    public func postsPostidCommentsCommentidLikePost(postid: String, authorization: String, commentid: String, body: REBaseRequest) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}/like", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param postid
     @param commentid
     @param body
     @param authorization
     
     return type: REBaseResponse
     */
    public func postsPostidCommentsCommentidUnlikePost(postid: String, commentid: String, body: REBaseRequest, authorization: String?) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization!
        ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}/unlike", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     @param searchValue
     
     return type: RESearchResult
     */
    public func searchGet(userid: String, authorization: String, searchValue: String) -> AWSTask<RESearchResult> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["userid"] = userid
        queryParameters["searchValue"] = searchValue
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/search", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: RESearchResult.self) as! AWSTask<RESearchResult>
    }
    
    
    /*
     
     
     @param userid
     @param requestedUserid
     @param authorization
     
     return type: REUserProfile
     */
    public func usersGet(userid: String, requestedUserid: String, authorization: String) -> AWSTask<REUserProfile> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization
        ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["requestedUserid"] = requestedUserid
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/users", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REUserProfile.self) as! AWSTask<REUserProfile>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     
     return type: REBaseResponse
     */
    public func usersPost(authorization: String, body: REUserProfile) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/users", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param authorization
     @param body
     
     return type: REFollowInfo
     */
    public func usersFollowPost(authorization: String, body: REFollowInfo) -> AWSTask<REFollowInfo> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/users/follow", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REFollowInfo.self) as! AWSTask<REFollowInfo>
    }
    
    
    
    
}
