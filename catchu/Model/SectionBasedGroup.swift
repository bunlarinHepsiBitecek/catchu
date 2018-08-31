//
//  SectionBasedGroup.swift
//  catchu
//
//  Created by Erkut Baş on 8/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SectionBasedGroup {
    
    public static var shared = SectionBasedGroup()
    
    private var _user : User
    private var _userGroupList : [Group] = []
    private var _userGroupSortedList : [Group] = []
    private var _userGroupSortedDictionary : [String : Group] = [:]
    private var _keyData : Array<String>
    
    private var _groupNameInitialBasedDictionary : Dictionary<String, [Group]>!
    private var _groupSectionKeyData : Array<String>!
    
    
    var user : User {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }
    
    var userGroupList : [Group] {
        get {
            return _userGroupList
        }
        set {
            _userGroupList = newValue
        }
    }
    
    var userGroupSortedList : [Group] {
        get {
            return _userGroupSortedList
        }
        set {
            _userGroupSortedList = newValue
        }
    }
    
    var userGroupSortedDictionary : [String : Group] {
        get {
            return _userGroupSortedDictionary
        }
        set {
            _userGroupSortedDictionary = newValue
        }
    }
    
    var keyData : Array<String> {
        get {
            return _keyData
        }
        set {
            _keyData = newValue
        }
    }
    
    var groupNameInitialBasedDictionary : Dictionary<String, [Group]> {
        get {
            return _groupNameInitialBasedDictionary
        }
        set {
            _groupNameInitialBasedDictionary = newValue
        }
    }
    
    var groupSectionKeyData: Array<String> {
        get {
            return _groupSectionKeyData
        }
        set {
            _groupSectionKeyData = newValue
        }
    }
    
    init() {
        
        _user = User()
        _keyData = []
        
        _groupNameInitialBasedDictionary = Dictionary<String, [Group]>()
        _groupSectionKeyData = Array<String>()
        
    }
    
    
    func sortUserGroupList() {
        
        _userGroupSortedList = _userGroupList.sorted(by: { $0.groupName < $1.groupName })
        
    }
    
    func loadSortedDictionary() {
        
        for item in _userGroupSortedList {
            
            _userGroupSortedDictionary[item.groupID] = item
            
        }
        
    }
    
    func emptySectionBasedGroupData() {
        _groupNameInitialBasedDictionary.removeAll()
    }
    
    func createInitialLetterBasedGroupDictionary() {
        
        print("createInitialLetterBasedGroupDictionary starts")
        print("count : \(Group.shared.groupList.count)")
        print("count : \(Group.shared.groupSortedList.count)")
        
        Group.shared.createSortedGroupList()
        
        print("count : \(Group.shared.groupSortedList.count)")
        
        for item in Group.shared.groupSortedList {
            
            print("group : \(item.groupName)")
            
            if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.A) {
                print("A var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.A] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.A] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.A]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.A]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.B){
                print("B var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.B] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.B] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.B]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.B]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.C) {
                print("B var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.C] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.C] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.C]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.C]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.D){
                print("D var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.D] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.D] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.D]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.D]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.E) {
                print("E var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.E] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.E] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.E]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.E]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.F){
                print("F var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.F] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.F] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.F]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.F]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.G) {
                print("G var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.G] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.G] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.G]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.G]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.H){
                print("H var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.H] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.H] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.H]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.H]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.I) {
                print("I var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.I] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.I] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.I]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.I]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.J){
                print("J var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.J] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.J] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.J]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.J]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.K) {
                print("K var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.K] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.K] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.K]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.K]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.L){
                print("L var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.L] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.L] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.L]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.L]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.M) {
                print("M var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.M] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.M] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.M]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.M]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.N){
                print("N var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.N] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.N] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.N]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.N]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.O) {
                print("O var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.O] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.O] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.O]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.O]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.P){
                print("P var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.P] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.P] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.P]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.P]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.Q) {
                print("Q var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Q] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Q] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Q]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Q]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.R) {
                print("R var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.R] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.R] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.R]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.R]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.S){
                print("S var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.S] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.S] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.S]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.S]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.T) {
                print("T var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.T] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.T] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.T]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.T]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.U){
                print("U var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.U] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.U] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.U]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.U]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.V) {
                print("V var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.V] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.V] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.V]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.V]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.W){
                print("W var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.W] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.W] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.W]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.W]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.X) {
                print("X var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.X] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.X] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.X]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.X]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.Y){
                print("Y var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Y] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Y] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Y]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Y]?.append(item)
                }
                
            } else if item.groupName.uppercased().hasPrefix(Constants.LetterConstants.Z) {
                print("Z var")
                if SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Z] == nil {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Z] = [Group]()
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Z]?.append(item)
                } else {
                    SectionBasedGroup.shared._groupNameInitialBasedDictionary[Constants.LetterConstants.Z]?.append(item)
                }
            }
            
        }
        
        print("SectionBasedGroup.shared._groupNameInitialBasedDictionary : \(SectionBasedGroup.shared._groupNameInitialBasedDictionary.count)")
        
        _groupSectionKeyData = Array(groupNameInitialBasedDictionary.keys).sorted()
        
    }

    func returnSectionNumber(index : Int) -> Int {
        
        if groupSectionKeyData[index] == Constants.LetterConstants.A {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.A]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.B {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.B]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.C {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.C]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.D {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.D]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.E {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.E]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.F {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.F]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.G {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.G]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.H {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.H]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.I {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.I]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.J {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.J]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.K {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.K]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.L {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.L]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.M {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.M]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.N {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.N]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.O {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.O]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.P {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.P]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.Q {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.Q]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.R {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.R]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.S {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.S]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.T {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.T]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.U {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.U]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.V {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.V]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.W {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.W]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.X {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.X]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.Y {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.Y]?.count)!
            
        } else if groupSectionKeyData[index] == Constants.LetterConstants.Z {
            
            return (groupNameInitialBasedDictionary[Constants.LetterConstants.Z]?.count)!
            
        } else {
            
            return 0
            
        }
        
    }
    
    func returnGroupFromSectionBasedDictionary(indexPath : IndexPath) -> Group {
        
        if indexPath.section == Constants.NumberOrSections.section0 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section1 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section2 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section3 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section4 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section5 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section6 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section7 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section8 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section9 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section10 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section11 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section12 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section13 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section14 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section15 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section16 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section17 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section18 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section19 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section20 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section21 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section22 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section23 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section24 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section25 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section26 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section27 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section28 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section29 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section30 {
            
            if let groupArray : [Group] = groupNameInitialBasedDictionary[groupSectionKeyData[indexPath.section]] {
                return groupArray[indexPath.row]
            } else {
                return Group()
            }
            
        } else {
            
            return Group()
        }
    }
    
    
    
}
