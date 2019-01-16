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
public class REReport : AWSModel {
    
    var reportid: String?
    var type: String?
    var platform: String?
    var message: String?
    var isFixed: NSNumber?
    var createAt: String?
    var attachments: [REMedia]?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["reportid"] = "reportid"
		params["type"] = "type"
        params["platform"] = "platform"
		params["message"] = "message"
		params["isFixed"] = "isFixed"
        params["createAt"] = "createAt"
		params["attachments"] = "attachments"
		
        return params
	}
	class func attachmentsJSONTransformer() -> ValueTransformer{
		return  ValueTransformer.awsmtl_JSONArrayTransformer(withModelClass: REMedia.self);
	}
}
