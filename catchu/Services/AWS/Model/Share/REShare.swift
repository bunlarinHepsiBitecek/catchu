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
public class REShare : AWSModel {
    
    var userid: String?
    var shareid: String?
    var imageUrl: String?
    var videoUrl: String?
    var text: String?
    var location: RELocation?
    var distance: NSNumber?
    var createAt: NSNumber?
    var user: REUserProfileProperties?
    var privacyType: String?
    var allowList: [REUserProfileProperties]?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["userid"] = "userid"
		params["shareid"] = "shareid"
		params["imageUrl"] = "imageUrl"
        params["videoUrl"] = "videoUrl"
		params["text"] = "text"
		params["location"] = "location"
		params["distance"] = "distance"
		params["createAt"] = "createAt"
		params["user"] = "user"
		params["privacyType"] = "privacyType"
		params["allowList"] = "allowList"
		
        return params
	}
	class func locationJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: RELocation.self);
	}
	class func userJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REUserProfileProperties.self);
	}
	class func allowListJSONTransformer() -> ValueTransformer{
		return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REUserProfileProperties.self);
	}
}
