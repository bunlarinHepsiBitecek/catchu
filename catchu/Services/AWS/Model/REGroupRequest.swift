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
 

import Foundation
import AWSCore

@objcMembers
public class REGroupRequest : AWSModel {
    
    var error: REError?
    var requestType: String?
    var userid: String?
    var groupid: String?
    var groupName: String?
    var groupPhotoUrl: String?
    var groupParticipantArray: [REGroupRequest_groupParticipantArray_item]?
    
    public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
        var params:[AnyHashable : Any] = [:]
        params["error"] = "error"
        params["requestType"] = "requestType"
        params["userid"] = "userid"
        params["groupid"] = "groupid"
        params["groupName"] = "groupName"
        params["groupPhotoUrl"] = "groupPhotoUrl"
        params["groupParticipantArray"] = "groupParticipantArray"
        
        return params
    }
    class func errorJSONTransformer() -> ValueTransformer{
        return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REError.self);
    }
    class func groupParticipantArrayJSONTransformer() -> ValueTransformer{
        return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REGroupRequest_groupParticipantArray_item.self);
    }
    
    func displayGroupAttributes() {
        print("requestType:\( requestType)")
        print("userid:\( userid)")
        print("groupid:\( groupid)")
        print("groupName:\( groupName)")
        print("groupPhotoUrl:\( groupPhotoUrl)")
        
//        for item in groupParticipantArray! {
//
//            item.displayItemProperties()
//
//        }
    }
    
}
