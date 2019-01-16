//
//  UserProfileEditViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileEditViewModel: BaseViewModel, ViewModel {
    var user: User!
    var items: [[ViewModelItem]] = []
    
    init(user: User) {
        super.init()
        
        self.user = user
        self.fillItems()
    }
    
    private func fillItems() {
        let nameItem = UserProfileEditViewModelItemName(user: user)
        let usernameItem = UserProfileEditViewModelItemUsername(user: user)
        let websiteItem = UserProfileEditViewModelItemWebsite(user: user)
        let bioItem = UserProfileEditViewModelItemBio(user: user)
        let emailItem = UserProfileEditViewModelItemEmail(user: user)
        let phoneItem = UserProfileEditViewModelItemPhone(user: user)
        let genderItem = UserProfileEditViewModelItemGender(user: user)
        let birthday = UserProfileEditViewModelItemBirthday(user: user)
        
        items.append([nameItem, usernameItem, websiteItem, bioItem, emailItem, phoneItem, genderItem, birthday])
    }
    
}

enum UserProfileEditViewModelItemType {
    case name
    case username
    case website
    case bio
    case email
    case phone
    case gender
    case birthday
}

protocol UserProfileEditViewModelItem: ViewModelItem {
    var type: UserProfileEditViewModelItemType { get }
    var isSelectable: Bool { get }
    var title: String { get }
    var placeHolder: String { get }
    var user: User { get }
    var text: String { set get }
}

extension UserProfileEditViewModelItem {
    var isSelectable: Bool {
        return true
    }
}

class UserProfileEditViewModelItemName: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .name
    }
    
    var title: String {
        return LocalizedConstants.Profile.Name
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Name
    }
    
    var user: User
    
    var text: String {
        get {
            return user.name ?? ""
        }
        set {
            self.user.name = newValue
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
}

class UserProfileEditViewModelItemUsername: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .username
    }
    
    var title: String {
        return LocalizedConstants.Profile.Username
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Username
    }
    
    var user: User
    
    var text: String {
        get {
            return user.username ?? ""
        }
        set {
            self.user.username = newValue
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemWebsite: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .website
    }
    
    var title: String {
        return LocalizedConstants.Profile.Website
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Website
    }
    
    var user: User
    
    var text: String {
        get {
            return user.website ?? ""
        }
        set {
            user.website = newValue
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemBio: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .bio
    }
    
    var title: String {
        return LocalizedConstants.Profile.Bio
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Bio
    }
    
    var user: User
    
    var text: String {
        get {
            return user.bio ?? ""
        }
        set {
            user.bio = newValue
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemEmail: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .email
    }
    
    var isSelectable: Bool {
        return false
    }
    var title: String {
        return LocalizedConstants.Profile.Email
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Email
    }
    
    var user: User
    var text: String {
        get {
            return user.email ?? ""
        }
        set {
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemPhone: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .phone
    }
    
    var isSelectable: Bool {
        return false
    }
    var title: String {
        return LocalizedConstants.Profile.Phone
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Phone
    }
    
    var user: User
    var text: String {
        get {
            if let phone = user.phone {
                return phone.getPhoneNumber()
            }
            return ""
        }
        set {
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemGender: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .gender
    }
    
    var isSelectable: Bool {
        return false
    }
    
    var title: String {
        return LocalizedConstants.Profile.Gender
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Gender
    }
    
    var user: User
    var text: String {
        get {
            return user.gender?.rawValue ?? GenderType.unspecified.rawValue
        }
        set {
            user.gender = GenderType.init(rawValue: newValue) ?? GenderType.unspecified
        }
    }
    
    init(user: User) {
        self.user = user
    }
}

class UserProfileEditViewModelItemBirthday: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .birthday
    }
    
    var isSelectable: Bool {
        return false
    }
    
    var title: String {
        return LocalizedConstants.Profile.Birthday
    }
    
    var placeHolder: String {
        return LocalizedConstants.Profile.Birthday
    }
    
    var user: User
    
    var text: String {
        get {
            return user.birthday ?? ""
        }
        set {
            user.birthday = newValue
        }
    }
    
    init(user: User) {
        self.user = user
    }
}
