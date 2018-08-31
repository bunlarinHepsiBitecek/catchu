//
//  Group.swift
//  catchu
//
//  Created by Erkut Baş on 8/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Group {
    
    public static var shared = Group()
    
    private var _groupID : String
    private var _adminUserID : String
    private var _groupName : String
    private var _groupPictureUrl : String
    private var _groupCreateDate : String
    private var _groupMembers : [User] = []
    
    // var _groupDictionary : Dictionary<String, String> = [:]
    private var _groupDictionary : Dictionary<String, Group> = [:]
    private var _groupList : Array<Group> = []
    private var _groupSortedList : Array<Group> = []
    
    init() {
        self._groupID = Constants.CharacterConstants.SPACE
        self._adminUserID = Constants.CharacterConstants.SPACE
        self._groupName = Constants.CharacterConstants.SPACE
        self._groupPictureUrl = Constants.CharacterConstants.SPACE
        self._groupCreateDate = Constants.CharacterConstants.SPACE
        self._groupMembers = []
    }
    
    var groupID : String {
        get {
            return self._groupID
        }
        set(inputValue) {
            self._groupID = inputValue
        }
    }
    
    var adminUserID : String {
        get {
            return self._adminUserID
        }
        set(inputValue) {
            self._adminUserID = inputValue
        }
    }
    
    var groupName : String {
        get {
            return self._groupName
        }
        set {
            self._groupName = newValue
        }
    }
    
    var groupPictureUrl : String {
        get {
            return self._groupPictureUrl
        }
        set(inputValue) {
            self._groupPictureUrl = inputValue
        }
    }
    
    var groupMembers : [User] {
        get {
            return self._groupMembers
        }
        set(inputValue) {
            self._groupMembers = inputValue
        }
    }
    
    var groupDictionary: Dictionary<String, Group> {
        get {
            return _groupDictionary
        }
        set {
            _groupDictionary = newValue
        }
    }
    
    var groupCreateDate: String {
        get {
            return _groupCreateDate
        }
        set {
            _groupCreateDate = newValue
        }
    }
    
    var groupList: Array<Group> {
        get {
            return _groupList
        }
        set {
            _groupList = newValue
        }
    }
    
    var groupSortedList: Array<Group> {
        get {
            return _groupSortedList
        }
        set {
            _groupSortedList = newValue
        }
    }
    
    func createSortedGroupList() {
        
        self._groupSortedList = _groupList.sorted(by: { $0.groupName < $1.groupName })
        
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
        
        for item in httpRequest.resultArray! {
            
            let tempGroupObject = Group()
            
            tempGroupObject.groupID = item.groupid!
            tempGroupObject.groupName = item.name!
            tempGroupObject.groupCreateDate = item.createAt!
            tempGroupObject.groupPictureUrl = item.groupPhotoUrl!
            tempGroupObject.adminUserID = item.groupAdmin!
            
            self._groupList.append(tempGroupObject)
            
        }
        
        for item in _groupList {
            print("Group item :\(item._groupName)")
        }
        
        //SectionBasedGroup.shared.createInitialLetterBasedGroupDictionary()
        
    }
    
    
    func returnREGroupRequestFromGroup(inputGroup : Group) -> REGroupRequest {
        
        let returnREGroup = REGroupRequest()
        
        returnREGroup?.userid = inputGroup.adminUserID
        returnREGroup?.groupid = inputGroup.groupID
        returnREGroup?.groupName = inputGroup.groupName
        returnREGroup?.groupPhotoUrl = inputGroup.groupPictureUrl
        
        return returnREGroup!
        
    }
    
    func displayGroupProperties() {
        
        print("displayGroupProperties starts")
        
        print("")
        
    }
    
    func updateGroupInfoInGroupList(inputGroupID : String, inputGroupName : String) {
        
        print("updateGroupInfoInGroupList starts")
        
        var i = 0
        
        for item in _groupList {
            
            if item._groupID == inputGroupID {
                
                _groupList[i]._groupName = inputGroupName
                break
                
            }
            
            i += 1
        }
        
    }
    
//    var groupDictionary: Dictionary<String, String> {
//        get {
//            return _groupDictionary
//        }
//        set {
//            _groupDictionary = newValue
//        }
//    }
//
//    func appendAttributeToDictionary(inputKey : String, inputValue : String) {
//
//        self._groupDictionary[inputKey] = inputValue
//
//    }

    
    
}
