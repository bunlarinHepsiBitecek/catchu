/*
 Copyright 2010-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 
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
     
     
     @param userid
     @param authorization
     
     return type: RECountryListResponse
     */
    public func commonCountriesGet(userid: String, authorization: String) -> AWSTask<RECountryListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization
        ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/common/countries", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: RECountryListResponse.self) as! AWSTask<RECountryListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     @param body
     @param relatedid
     
     return type: REBaseResponse
     */
    public func commonReportPost(userid: String, authorization: String, body: REReport, relatedid: String?) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["relatedid"] = relatedid
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/common/report", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
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
     
     
     @param userid
     @param authorization
     @param body
     
     return type: REBaseResponse
     */
    public func commonSignedurlDelete(userid: String, authorization: String, body: REBucketUploadResponse) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("DELETE", urlString: "/common/signedurl", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
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
     @param perPage
     @param page
     @param authorization
     
     return type: REFriendList
     */
    public func friendsGet(userid: String, perPage: String?, page: String?, authorization: String?) -> AWSTask<REFriendList> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization!
        ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["perPage"] = perPage
        queryParameters["userid"] = userid
        queryParameters["page"] = page
        
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
     
     
     @param userid
     @param authorization
     @param groupid
     @param longitude
     @param perPage
     @param latitude
     @param radius
     @param page
     
     return type: REPostListResponse
     */
    public func groupsGroupidCaughtGet(userid: String, authorization: String, groupid: String, longitude: String?, perPage: String?, latitude: String?, radius: String?, page: String?) -> AWSTask<REPostListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["longitude"] = longitude
        queryParameters["perPage"] = perPage
        queryParameters["latitude"] = latitude
        queryParameters["radius"] = radius
        queryParameters["page"] = page
        
        var pathParameters:[String:Any] = [:]
        pathParameters["groupid"] = groupid
        
        return self.invokeHTTPRequest("GET", urlString: "/groups/{groupid}/caught", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REPostListResponse.self) as! AWSTask<REPostListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     @param body
     
     return type: REBaseResponse
     */
    public func loginPost(userid: String, authorization: String, body: REBaseRequest) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/login", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     @param postid
     @param catchType
     @param longitude
     @param perPage
     @param latitude
     @param radius
     @param page
     
     return type: REPostListResponse
     */
    public func postsPostidGet(userid: String, authorization: String, postid: String, catchType: String?, longitude: String?, perPage: String?, latitude: String?, radius: String?, page: String?) -> AWSTask<REPostListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["catchType"] = catchType
        queryParameters["longitude"] = longitude
        queryParameters["perPage"] = perPage
        queryParameters["latitude"] = latitude
        queryParameters["radius"] = radius
        queryParameters["page"] = page
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        
        return self.invokeHTTPRequest("GET", urlString: "/posts/{postid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REPostListResponse.self) as! AWSTask<REPostListResponse>
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
     
     
     @param userid
     @param postid
     @param authorization
     
     return type: REBaseResponse
     */
    public func postsPostidDelete(userid: String, postid: String, authorization: String) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization
        ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        
        return self.invokeHTTPRequest("DELETE", urlString: "/posts/{postid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param authorization
     @param body
     
     return type: REBaseResponse
     */
    public func postsPostidPatch(userid: String, postid: String, authorization: String, body: REPostRequest) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        
        return self.invokeHTTPRequest("PATCH", urlString: "/posts/{postid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param authorization
     @param commentid
     
     return type: RECommentListResponse
     */
    public func postsPostidCommentsCommentidGet(userid: String, postid: String, authorization: String, commentid: String) -> AWSTask<RECommentListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("GET", urlString: "/posts/{postid}/comments/{commentid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: RECommentListResponse.self) as! AWSTask<RECommentListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param authorization
     @param commentid
     @param body
     
     return type: RECommentResponse
     */
    public func postsPostidCommentsCommentidPost(userid: String, postid: String, authorization: String, commentid: String, body: RECommentRequest) -> AWSTask<RECommentResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: RECommentResponse.self) as! AWSTask<RECommentResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param perPage
     @param page
     @param authorization
     @param commentid
     
     return type: REUserListResponse
     */
    public func postsPostidCommentsCommentidLikeGet(userid: String, postid: String, perPage: String, page: String, authorization: String, commentid: String) -> AWSTask<REUserListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["perPage"] = perPage
        queryParameters["page"] = page
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("GET", urlString: "/posts/{postid}/comments/{commentid}/like", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REUserListResponse.self) as! AWSTask<REUserListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param authorization
     @param commentid
     
     return type: REBaseResponse
     */
    public func postsPostidCommentsCommentidLikePost(userid: String, postid: String, authorization: String, commentid: String) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("POST", urlString: "/posts/{postid}/comments/{commentid}/like", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param postid
     @param authorization
     @param commentid
     
     return type: REBaseResponse
     */
    public func postsPostidCommentsCommentidLikeDelete(userid: String, postid: String, authorization: String, commentid: String) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        var pathParameters:[String:Any] = [:]
        pathParameters["postid"] = postid
        pathParameters["commentid"] = commentid
        
        return self.invokeHTTPRequest("DELETE", urlString: "/posts/{postid}/comments/{commentid}/like", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    /*
     
     
     @param userid
     @param searchText
     @param authorization
     @param perPage
     @param page
     
     return type: REUserListResponse
     */
    public func searchUsersGet(userid: String, searchText: String, authorization: String, perPage: String?, page: String?) -> AWSTask<REUserListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["perPage"] = perPage
        queryParameters["page"] = page
        queryParameters["searchText"] = searchText
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/search/users", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REUserListResponse.self) as! AWSTask<REUserListResponse>
    }
    
    
    /*
     
     
     
     return type: Empty
     */
    public func testPost() -> AWSTask<Empty> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/test", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: Empty.self) as! AWSTask<Empty>
    }
    
    
    /*
     
     
     @param userid
     @param requestedUserid
     @param authorization
     @param shortInfo
     
     return type: REUserProfile
     */
    public func usersGet(userid: String, requestedUserid: String, authorization: String, shortInfo: String?) -> AWSTask<REUserProfile> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["shortInfo"] = shortInfo
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
     
     
     @param userid
     @param requestType
     @param authorization
     
     return type: REFollowInfoListResponse
     */
    public func usersFollowGet(userid: String, requestType: String, authorization: String) -> AWSTask<REFollowInfoListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization
        ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["requestType"] = requestType
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("GET", urlString: "/users/follow", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REFollowInfoListResponse.self) as! AWSTask<REFollowInfoListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param authorization
     @param body
     
     return type: REUserListResponse
     */
    public func usersProvidersPost(userid: String, authorization: String, body: REProviderList) -> AWSTask<REUserListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/users/providers", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REUserListResponse.self) as! AWSTask<REUserListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param uid
     @param authorization
     @param longitude
     @param perPage
     @param latitude
     @param radius
     @param page
     @param privacyType
     
     return type: REPostListResponse
     */
    public func usersUidCaughtGet(userid: String, uid: String, authorization: String, longitude: String?, perPage: String?, latitude: String?, radius: String?, page: String?, privacyType: String?) -> AWSTask<REPostListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["longitude"] = longitude
        queryParameters["perPage"] = perPage
        queryParameters["latitude"] = latitude
        queryParameters["radius"] = radius
        queryParameters["page"] = page
        queryParameters["privacyType"] = privacyType
        
        var pathParameters:[String:Any] = [:]
        pathParameters["uid"] = uid
        
        return self.invokeHTTPRequest("GET", urlString: "/users/{uid}/caught", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REPostListResponse.self) as! AWSTask<REPostListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param uid
     @param authorization
     @param perPage
     @param requestType
     @param page
     
     return type: REFollowInfoListResponse
     */
    public func usersUidFollowGet(userid: String, uid: String, authorization: String, perPage: String?, requestType: String?, page: String?) -> AWSTask<REFollowInfoListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["perPage"] = perPage
        queryParameters["requestType"] = requestType
        queryParameters["page"] = page
        
        var pathParameters:[String:Any] = [:]
        pathParameters["uid"] = uid
        
        return self.invokeHTTPRequest("GET", urlString: "/users/{uid}/follow", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REFollowInfoListResponse.self) as! AWSTask<REFollowInfoListResponse>
    }
    
    
    /*
     
     
     @param userid
     @param uid
     @param authorization
     @param longitude
     @param perPage
     @param latitude
     @param radius
     @param page
     @param privacyType
     
     return type: REPostListResponse
     */
    public func usersUidPostsGet(userid: String, uid: String, authorization: String, longitude: String?, perPage: String?, latitude: String?, radius: String?, page: String?, privacyType: String?) -> AWSTask<REPostListResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "userid": userid,
            "Authorization": authorization,
            
            ]
        
        var queryParameters:[String:Any] = [:]
        queryParameters["longitude"] = longitude
        queryParameters["perPage"] = perPage
        queryParameters["latitude"] = latitude
        queryParameters["radius"] = radius
        queryParameters["page"] = page
        queryParameters["privacyType"] = privacyType
        
        var pathParameters:[String:Any] = [:]
        pathParameters["uid"] = uid
        
        return self.invokeHTTPRequest("GET", urlString: "/users/{uid}/posts", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: nil, responseClass: REPostListResponse.self) as! AWSTask<REPostListResponse>
    }
    
    /*
     
     
     @param body
     
     return type: REBaseResponse
     */
    public func notifPost(authorization: String, body: RENotification) -> AWSTask<REBaseResponse> {
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": authorization,
            
            ]
        
        let queryParameters:[String:Any] = [:]
        
        let pathParameters:[String:Any] = [:]
        
        return self.invokeHTTPRequest("POST", urlString: "/notif", pathParameters: pathParameters, queryParameters: queryParameters, headerParameters: headerParameters, body: body, responseClass: REBaseResponse.self) as! AWSTask<REBaseResponse>
    }
    
    
    
}
