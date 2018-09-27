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
public class REPost : AWSModel {
    
    var groupid: String?
    var postid: String?
    var message: String?
    var attachments: [REMedia]?
    var location: RELocation?
    var distance: NSNumber?
    var isLiked: NSNumber?
    var likeCount: NSNumber?
    var commentCount: NSNumber?
    var createAt: String?
    var user: REUser?
    var privacyType: String?
    var allowList: [REUser]?
    var comments: [REComment]?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["groupid"] = "groupid"
		params["postid"] = "postid"
		params["message"] = "message"
		params["attachments"] = "attachments"
		params["location"] = "location"
		params["distance"] = "distance"
		params["isLiked"] = "isLiked"
		params["likeCount"] = "likeCount"
		params["commentCount"] = "commentCount"
		params["createAt"] = "createAt"
		params["user"] = "user"
		params["privacyType"] = "privacyType"
		params["allowList"] = "allowList"
		params["comments"] = "comments"
		
        return params
	}
	class func attachmentsJSONTransformer() -> ValueTransformer{
		return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REMedia.self);
	}
	class func locationJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: RELocation.self);
	}
	class func userJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REUser.self);
	}
	class func allowListJSONTransformer() -> ValueTransformer{
		return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REUser.self);
	}
	class func commentsJSONTransformer() -> ValueTransformer{
		return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REComment.self);
	}
}
