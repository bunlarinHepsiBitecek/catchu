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
    
    let state = Dynamic(TableViewState.suggest)
    
    let valueChanged = Dynamic(false)
    
    init(user: User) {
        super.init()
        
        self.user = user
        self.fillItems()
    }
    
    private func fillItems() {
        let profileImage = UserProfileEditViewModelItemProfileImage(user: user)
        let nameItem = UserProfileEditViewModelItemName(user: user)
        let usernameItem = UserProfileEditViewModelItemUsername(user: user)
        let websiteItem = UserProfileEditViewModelItemWebsite(user: user)
        let bioItem = UserProfileEditViewModelItemBio(user: user)
        let emailItem = UserProfileEditViewModelItemEmail(user: user)
        let phoneItem = UserProfileEditViewModelItemPhone(user: user)
        let genderItem = UserProfileEditViewModelItemGender(user: user)
        let birthday = UserProfileEditViewModelItemBirthday(user: user)
        
        nameItem.valueChanged = valueChanged
        usernameItem.valueChanged = valueChanged
        websiteItem.valueChanged = valueChanged
        bioItem.valueChanged = valueChanged
        emailItem.valueChanged = valueChanged
        phoneItem.valueChanged = valueChanged
        genderItem.valueChanged = valueChanged
        birthday.valueChanged = valueChanged
        
        items.append([profileImage, nameItem, usernameItem, websiteItem, bioItem, emailItem, phoneItem, genderItem, birthday])
    }
    
    func updateUserInfo() {
//        state.value = .loading
//        REAWSManager.shared.updateUserProfile(user: user) { [unowned self] in
//            print("\(#function) working and get data")
//            self.handleResult($0)
//        }
        
        state.value = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state.value = .populate
        }
    }
    
    private func handleResult(_ result: NetworkResult<REBaseResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
            state.value = .populate
        case .failure(let apiError):
            state.value = .error
            switch apiError {
            case .serverError(let error):
                print("Server error: \(error)")
            case .connectionError(let error) :
                print("Connection error: \(error)")
            case .missingDataError:
                print("Missing Data Error")
            }
        }
    }
    
    func removeProfilePhoto() {
        user.profilePictureUrl = ""
    }
    
}

enum UserProfileEditViewModelItemType {
    case profileImage
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
    var valueChanged: Dynamic<Bool>? { get }
}

extension UserProfileEditViewModelItem {
    var isSelectable: Bool {
        return true
    }
}

class UserProfileEditViewModelItemProfileImage: UserProfileEditViewModelItem {
    var type: UserProfileEditViewModelItemType {
        return .profileImage
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
            return ""
        }
        set {
            self.user.profilePictureUrl = newValue
            valueChanged?.value = true
        }
    }
    var valueChanged: Dynamic<Bool>?
    
    init(user: User) {
        self.user = user
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
            valueChanged?.value = true
        }
    }
    var valueChanged: Dynamic<Bool>?
    
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
            valueChanged?.value = true
        }
    }
    
    var valueChanged: Dynamic<Bool>?
    
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
            valueChanged?.value = true
        }
    }
    
    var valueChanged: Dynamic<Bool>?
    
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
            valueChanged?.value = true
        }
    }
    
    var valueChanged: Dynamic<Bool>?
    
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
    
    var valueChanged: Dynamic<Bool>?
    
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
    
    var valueChanged: Dynamic<Bool>?
    
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
            valueChanged?.value = true
        }
    }
    var valueChanged: Dynamic<Bool>?
    
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
            valueChanged?.value = true
        }
    }
    var valueChanged: Dynamic<Bool>?
    
    init(user: User) {
        self.user = user
    }
}
