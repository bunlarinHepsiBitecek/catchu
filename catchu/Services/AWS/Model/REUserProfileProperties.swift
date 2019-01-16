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
public class REUserProfileProperties : AWSModel {
    
    var name: String?
    var userid: String?
    var username: String?
    var profilePhotoUrl: String?
    var isPrivateAccount: NSNumber?
    var birthday: String?
    var gender: String?
    var email: String?
    var website: String?
    var bio: String?
    var phone: REPhone?
    var provider: REProvider?
    
    public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
        var params:[AnyHashable : Any] = [:]
        params["name"] = "name"
        params["userid"] = "userid"
        params["username"] = "username"
        params["profilePhotoUrl"] = "profilePhotoUrl"
        params["isPrivateAccount"] = "isPrivateAccount"
        params["birthday"] = "birthday"
        params["gender"] = "gender"
        params["email"] = "email"
        params["website"] = "website"
        params["bio"] = "bio"
        params["phone"] = "phone"
        params["provider"] = "provider"
        
        return params
    }
    class func phoneJSONTransformer() -> ValueTransformer{
        return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REPhone.self);
    }
    class func providerJSONTransformer() -> ValueTransformer{
        return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REProvider.self);
    }
}
