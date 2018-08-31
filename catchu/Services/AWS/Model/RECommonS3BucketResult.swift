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
public class RECommonS3BucketResult : AWSModel {
    
    var error: REError?
    var signedUrl: String?
    var downloadUrl: String?
    var fileExtention: String?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["error"] = "error"
		params["signedUrl"] = "signedUrl"
		params["downloadUrl"] = "downloadUrl"
		params["fileExtention"] = "fileExtention"
		
        return params
	}
	class func errorJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REError.self);
	}
}
