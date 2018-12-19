//
//  Group.swift
//  catchu
//
//  Created by Erkut Baş on 8/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Group: NSCopying {
    
    public static var shared = Group()
    
    var groupID : String?
    var adminUserID : String?
    var groupName : String?
    var groupPictureUrl : String?
    var groupCreateDate : String?
    var groupMembers : [User] = []
    
    var indexPath : IndexPath?
    
    // var _groupDictionary : Dictionary<String, String> = [:]
    var groupDictionary : Dictionary<String, Group> = [:]
    var groupList : Array<Group> = []
    var groupSortedList : Array<Group> = []
    
    init() {
        self.groupMembers = []
    }
    
    init(groupID: String, adminUserID: String, groupName: String, groupPictureUrl: String, groupCreateDate: String) {
        self.groupID = groupID
        self.adminUserID = adminUserID
        self.groupName = groupName
        self.groupPictureUrl = groupPictureUrl
        self.groupCreateDate = groupCreateDate
        
    }
    
    init(reGroup : REGroupRequestResult_resultArray_item) {
        
        if let groupid = reGroup.groupid {
            self.groupID = groupid
        }
        
        if let adminUserid = reGroup.groupAdmin {
            self.adminUserID = adminUserid
        }
        
        if let name = reGroup.name {
            self.groupName = name
        }
        
        if let url = reGroup.groupPhotoUrl {
            self.groupPictureUrl = url
        }
        
        if let createData = reGroup.createAt {
            self.groupCreateDate = createData
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Group(groupID: groupID!, adminUserID: adminUserID!, groupName: groupName!, groupPictureUrl: groupPictureUrl!, groupCreateDate: groupCreateDate!)
    }
    
    func createSortedGroupList() {
        
        self.groupSortedList = groupList.sorted(by: {$0.groupName! < $1.groupName!})
//        self.groupSortedList = groupList.sorted(by: { $0.groupName < $1.groupName })
        
    }
    
    func createGroupDictionary(httpRequest : REGroupRequestResult) {
        
        for item in httpRequest.resultArray! {
            
            let tempGroupObject = Group()
            
            tempGroupObject.groupID = item.groupid!
            tempGroupObject.groupName = item.name!
            tempGroupObject.groupCreateDate = item.createAt!
            
            self.groupDictionary[item.groupid!] = tempGroupObject
            
        }
        
    }
    
    func createGroupList(httpRequest : REGroupRequestResult) {
        
        print("createGroupList starts")
        
        for item in httpRequest.resultArray! {
            
            let tempGroupObject = Group()
            
            if let groupid = item.groupid {
                tempGroupObject.groupID = groupid
            }
            
            if let name = item.name {
                tempGroupObject.groupName = name
            }
            
            if let createAt = item.createAt {
                tempGroupObject.groupCreateDate = createAt
            }
            
            if let groupPhotoUrl = item.groupPhotoUrl {
                tempGroupObject.groupPictureUrl = groupPhotoUrl
            }
            
            if let groupAdmin = item.groupAdmin {
                tempGroupObject.adminUserID = groupAdmin
            }
            
            self.groupList.append(tempGroupObject)
            
        }
        
    }
    
    func returnREGroupRequestFromGroup(inputGroup : Group) -> REGroupRequest? {
        
        let returnREGroup = REGroupRequest()
        
        returnREGroup?.userid = inputGroup.adminUserID
        returnREGroup?.groupid = inputGroup.groupID
        returnREGroup?.groupName = inputGroup.groupName
        returnREGroup?.groupPhotoUrl = inputGroup.groupPictureUrl
        
        return returnREGroup
        
    }
    
    func returnREGroupRequestFromGroup() -> REGroupRequest? {
        
        let returnREGroup = REGroupRequest()
        
        if let groupid = self.groupID {
            returnREGroup?.groupid = groupid
        }
        
        if let adminUserid = self.adminUserID {
            returnREGroup?.userid = adminUserid
        }
        
        if let groupName = self.groupName {
            returnREGroup?.groupName = groupName
        }
        
        if let groupPhotoUrl = self.groupPictureUrl {
            returnREGroup?.groupPhotoUrl = groupPhotoUrl
        }
        
        return returnREGroup
        
    }
    
    /// Converts group object to ReGroupRequest
    ///
    /// - Parameter inputGroup: Group object
    /// - Returns: returns REGroupRequest
    func returnGroupRequestForUpdateProcess(inputGroup : Group) -> REGroupRequest {
        
        let groupRequest = REGroupRequest()
        
        if let object = groupRequest {
            
            object.requestType = RequestType.update_group_info.rawValue
            object.groupid = inputGroup.groupID
            object.groupPhotoUrl = inputGroup.groupPictureUrl
            object.groupName = inputGroup.groupName
            
            return object
            
        }
        
        return REGroupRequest()

    }
    
    func displayGroupProperties() {
        
        print("displayGroupProperties starts")
        
        print("groupid : \(String(describing: groupID))")
        print("adminUserID : \(String(describing: adminUserID))")
        print("groupName : \(String(describing: groupName))")
        print("groupPictureUrl : \(String(describing: groupPictureUrl))")
        print("groupCreateDate : \(String(describing: groupCreateDate))")
        print("indexPath : \(String(describing: indexPath))")
        
    }
    
    func updateGroupInfoInGroupList(inputGroupID : String, inputGroupName : String) {
        
        print("updateGroupInfoInGroupList starts")
        
        var i = 0
        
        for item in groupList {
            
            if item.groupID == inputGroupID {
                
                groupList[i].groupName = inputGroupName
                break
                
            }
            
            i += 1
        }

    }
    
    func updateGroupInfoInGroupListWithGroupObject(updatedGroup : Group) {
        
        if let i = groupList.index(where: { $0.groupID == updatedGroup.groupID}) {
            
            groupList[i] = updatedGroup
            
        }
        
    }
    
}
