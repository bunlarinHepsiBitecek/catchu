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


import Foundation
import AWSCore


@objcMembers
public class REUser : AWSModel {
    
    var userid: String?
    var name: String?
    var username: String?
    var email: String?
    var profilePhotoUrl: String?
    var isPrivateAccount: NSNumber?
    var followStatus: String?
    var bio: String?
    var provider: REProvider?
    
    public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
        var params:[AnyHashable : Any] = [:]
        params["userid"] = "userid"
        params["name"] = "name"
        params["username"] = "username"
        params["email"] = "email"
        params["profilePhotoUrl"] = "profilePhotoUrl"
        params["isPrivateAccount"] = "isPrivateAccount"
        params["followStatus"] = "followStatus"
        params["bio"] = "bio"
        params["provider"] = "provider"
        
        return params
    }
    class func providerJSONTransformer() -> ValueTransformer{
        return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REProvider.self);
    }
}
