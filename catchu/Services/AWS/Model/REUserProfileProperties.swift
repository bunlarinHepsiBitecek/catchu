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
public class REUserProfileProperties : AWSModel {
    
    var name: String?
    var userid: String?
    var username: String?
    var profilePhotoUrl: String?
    var isPrivateAccount: NSNumber?
    var birthday: String?
    var gender: String?
    var email: String?
    var phone: String?
    var website: String?
    
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
        params["phone"] = "phone"
        params["website"] = "website"
        
        return params
    }
    
    func displayProperties() {
    
        print("displayProperties starts")
        
        print("name : \(self.name)")
        print("userid :\(self.userid)")
        print("username : \(self.username)")
        print("profilePhotoUrl :\(self.profilePhotoUrl)")
        print("isPrivateAccount :\(self.isPrivateAccount)")
        print("birthday :\(self.birthday)")
        print("gender :\(self.gender)")
        print("email :\(self.email)")
        print("phone :\(self.phone)")
        print("website :\(self.website)")
    }
    
    func setUserProfileInformation(user : User) {
        
        print("setUserProfileInformation starts")
        print("user : \(user.displayProperties())")
        
        name = user.name
        userid = user.userID
        username = user.userName
        birthday = user.userBirthday
        gender = user.userGender
        email = user.email
        phone = user.userPhone
        website = user.userWebsite
        
    }
    
}
