//
//  SectionBasedFriend.swift
//  catchu
//
//  Created by Erkut Baş on 6/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SectionBasedFriend {
    
//    public static let shared = SectionBasedFriend()
    public static var shared = SectionBasedFriend()
    
    private var _friendUsernameInitialBasedDictionary : Dictionary<String, [User]>!
    private var _friendSectionKeyData : Array<String>!
    private var _selectedUserArray : Array<User>!
    private var _searchResult : Array<User>!
    private var _ifUserSelectedDictionary : Dictionary<String, Bool>!
    private var _isSearchModeActivated : Bool!
    
    private var _cachedFriendProfileImages : NSCache<NSString, UIImage>!
    
    init() {
        
        _friendUsernameInitialBasedDictionary = Dictionary<String, [User]>()
        _friendSectionKeyData = Array<String>()
        _cachedFriendProfileImages = NSCache<NSString, UIImage>()
        _selectedUserArray = Array<User>()
        _ifUserSelectedDictionary = Dictionary<String, Bool>()
        _searchResult = Array<User>()
        _isSearchModeActivated = false
        
    }
    
    var friendUsernameInitialBasedDictionary: Dictionary<String, [User]> {
        get {
            return _friendUsernameInitialBasedDictionary
        }
        set {
            _friendUsernameInitialBasedDictionary = newValue
        }
    }
    
    var friendSectionKeyData: Array<String> {
        get {
            return _friendSectionKeyData
        }
        set {
            _friendSectionKeyData = newValue
        }
    }
    
    var cachedFriendProfileImages: NSCache<NSString, UIImage> {
        get {
            return _cachedFriendProfileImages
        }
        set {
            _cachedFriendProfileImages = newValue
        }
    }
    
    var selectedUserArray: Array<User> {
        get {
            return _selectedUserArray
        }
        set {
            _selectedUserArray = newValue
        }
    }
    
    var ifUserSelectedDictionary: Dictionary<String, Bool> {
        get {
            return _ifUserSelectedDictionary
        }
        set {
            _ifUserSelectedDictionary = newValue
        }
    }
    
    var searchResult : Array<User> {
        get {
            sortSearchResult()
            return _searchResult
        }
        set {
            _searchResult = newValue
        }
    }
    
    var isSearchModeActivated: Bool{
        get {
            return _isSearchModeActivated
        }
        set {
            _isSearchModeActivated = newValue
        }
    }
    
    func emptySectionBasedDictioanry() {
        
//        SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.removeAll()
        self.friendUsernameInitialBasedDictionary.removeAll()

        
    }
    
    func addElementIntoSelectedUsers(user : User) {
        
        _selectedUserArray.append(user)
        
    }
    
    func addElementIntoSearchResultOfFriends(user : User) {
    
        _searchResult.append(user)
        
    }
    
    func emptyIfUserSelectedDictionary() {
        
        print("_friendUsernameInitialBasedDictionary : \(_friendUsernameInitialBasedDictionary.count)")
        
        for item in User.shared.userFriendList {
            
            _ifUserSelectedDictionary[item.value.userID] = false
            
        }
        
    }
    
    func emptySelectedUserArray() {
        
        _selectedUserArray.removeAll()
        
    }
    
    func emptySearchResult() {
        
        _searchResult.removeAll()
        
    }
    
    func sortSearchResult() {
        
        _searchResult.sort(by: {$0.name < $1.name})
        
    }
    
    func createInitialLetterBasedFriendDictionary() {
        
        User.shared.createSortedUserArray()
        
        for item in User.shared.sortedFriendArray {
            
            if item.name.uppercased().hasPrefix(Constants.LetterConstants.A) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.A] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.A] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.A]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.A]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.B){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.B] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.B] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.B]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.B]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.C) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.C] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.C] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.C]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.C]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.D){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.D] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.D] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.D]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.D]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.E) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.E] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.E] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.E]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.E]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.F){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.F] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.F] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.F]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.F]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.G) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.G] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.G] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.G]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.G]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.H){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.H] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.H] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.H]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.H]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.I) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.I] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.I] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.I]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.I]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.J){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.J] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.J] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.J]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.J]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.K) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.K] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.K] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.K]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.K]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.L){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.L] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.L] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.L]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.L]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.M) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.M] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.M] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.M]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.M]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.N){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.N] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.N] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.N]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.N]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.O) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.O] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.O] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.O]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.O]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.P){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.P] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.P] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.P]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.P]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.Q) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Q] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Q] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Q]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Q]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.R) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.R] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.R] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.R]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.R]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.S){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.S] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.S] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.S]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.S]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.T) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.T] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.T] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.T]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.T]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.U){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.U] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.U] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.U]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.U]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.V) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.V] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.V] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.V]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.V]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.W){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.W] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.W] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.W]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.W]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.X) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.X] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.X] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.X]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.X]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.Y){
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Y] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Y] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Y]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Y]?.append(item)
                }
                
            } else if item.name.uppercased().hasPrefix(Constants.LetterConstants.Z) {
                
                if self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Z] == nil {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Z] = [User]()
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Z]?.append(item)
                } else {
                    self._friendUsernameInitialBasedDictionary[Constants.LetterConstants.Z]?.append(item)
                }
            }
            
        }
        
        print("SectionBasedFriend.shared.friendUsernameInitialBasedDictionary : \(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
        _friendSectionKeyData = Array(friendUsernameInitialBasedDictionary.keys).sorted()
        
    }

    func returnSectionNumber(index : Int) -> Int {
        
        if friendSectionKeyData[index] == Constants.LetterConstants.A {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.A]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.B {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.B]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.C {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.C]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.D {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.D]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.E {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.E]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.F {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.F]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.G {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.G]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.H {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.H]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.I {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.I]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.J {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.J]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.K {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.K]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.L {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.L]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.M {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.M]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.N {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.N]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.O {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.O]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.P {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.P]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.Q {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.Q]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.R {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.R]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.S {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.S]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.T {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.T]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.U {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.U]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.V {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.V]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.W {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.W]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.X {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.X]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.Y {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.Y]?.count)!
            
        } else if friendSectionKeyData[index] == Constants.LetterConstants.Z {
            
            return (friendUsernameInitialBasedDictionary[Constants.LetterConstants.Z]?.count)!
            
        } else {
            
            return 0
            
        }

    }
    
    func returnUserFromSectionBasedDictionary(indexPath : IndexPath) -> User {
        
        if indexPath.section == Constants.NumberOrSections.section0 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section1 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section2 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section3 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section4 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section5 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section6 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section7 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section8 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section9 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section10 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section11 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section12 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section13 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section14 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section15 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section16 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section17 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section18 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section19 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section20 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section21 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section22 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section23 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section24 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section25 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section26 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section27 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section28 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section29 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else if indexPath.section == Constants.NumberOrSections.section30 {
            
            if let userArray : [User] = friendUsernameInitialBasedDictionary[friendSectionKeyData[indexPath.section]] {
                return userArray[indexPath.row]
            } else {
                return User()
            }
            
        } else {
            
            return User()
        }
        
    }

    
}
