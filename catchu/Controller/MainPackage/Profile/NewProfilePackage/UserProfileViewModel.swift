//
//  UserProfileViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewModel: BaseViewModel, ViewModel {
    var page: Int = 1
    let perPage: Int = 21
    var user: User!
    
    let followRow = UserProfileViewModelItemFollow()
    let postRow = UserProfileViewModelItemPost()
    let caughtRow = UserProfileViewModelItemCaught()
    let groupsRow = UserProfileViewModelItemGroups()
    
    var items: [UserProfileViewModelSection] {
        var items: [UserProfileViewModelSection] = []
        items.append(UserProfileViewModelSection(headerTitle: nil, [followRow, postRow, caughtRow]))
        items.append(UserProfileViewModelSection(headerTitle: LocalizedConstants.Profile.Groups.uppercased(), [groupsRow]))
        return items
    }
    let state = Dynamic(TableViewState.suggest)
    
    func getUserInfo() {
//        guard let userid = User.shared.userid else { return }
//        guard let requestedUserid = user.userid else { return }
//
//        state.value = .loading
//        REAWSManager.shared.getUserProfileInfo(userid: userid, requestedUserid: requestedUserid) { (result) in
//            print("\(#function) working and get data")
//            self.handleResult(result)
//        }
        
        self.dummyUserData()
        state.value = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.dummyGroups()
            self.populate()
        })
    }
    
    
    func dummyUserData() {
        let dummyUser = User()
        dummyUser.profilePictureUrl = "https://picsum.photos/100/100/?random"
        dummyUser.userid = "userid"
        dummyUser.name = "Dummy Remzi Yildirim"
        dummyUser.username = "remziyildirim"
        dummyUser.followStatus = .own
        dummyUser.userFollowerCount = "123400000"
        dummyUser.userFollowingCount = "456700"
        dummyUser.userPostCount = 23
        dummyUser.userCaughtCount = 12
        dummyUser.birthday = "04/03/1989"
        dummyUser.bio = "Bio benim profil benim kan benim damar benim"
        dummyUser.gender = GenderType.male
        self.user = dummyUser
    }
    
    func dummyGroups() {
        let group1 = Group()
        group1.groupName = "Ilk grup"
        group1.groupID = "groupid1"
        group1.groupPictureUrl = "https://picsum.photos/100/100/?random"
        group1.adminUserID = User.shared.userid
        
        let group2 = Group()
        group2.groupName = "Ikinci grup"
        group2.groupID = "groupid2"
        group2.groupPictureUrl = "https://picsum.photos/110/110/?random"
        group2.adminUserID = User.shared.userid
        
        let group3 = Group()
        group3.groupName = "Ucuncu grup"
        group3.groupID = "groupid3"
        group3.groupPictureUrl = "https://picsum.photos/120/120/?random"
        group3.adminUserID = User.shared.userid
        
        let group4 = Group()
        group4.groupName = "Dorduncu grup"
        group4.groupID = "groupid4"
        group4.groupPictureUrl = "https://picsum.photos/130/130/?random"
        group4.adminUserID = User.shared.userid
        
        let group5 = Group()
        group5.groupName = "Besinci grup"
        group5.groupID = "groupid5"
        group5.groupPictureUrl = "https://picsum.photos/140/140/?random"
        group5.adminUserID = User.shared.userid
        
        
        groupsRow.items.append(group1)
        groupsRow.items.append(group2)
        groupsRow.items.append(group3)
        groupsRow.items.append(group4)
        groupsRow.items.append(group5)
    }
    
    func populate() {
        guard let followerCount = user.userFollowerCount,
            let followingCount = user.userFollowingCount,
            let postCount = user.userPostCount,
            let caughtCount = user.userCaughtCount else { return }
        
        followRow.followerCount.value = Int(followerCount) ?? 0
        followRow.followingCount.value = Int(followingCount) ?? 0
        postRow.postCount.value = postCount
        caughtRow.caughtCount.value = caughtCount
        
        state.value = .populate
    }
    
    func handleResult(_ result: NetworkResult<REUserProfile>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                state.value = .error
                return
            }
            
            state.value = .populate
            user.setUserProfile(response)
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
    
    func getUserGroups() {
        
        REAWSManager.shared.getUserGroups(requestType: .userGroups) { [unowned self] (result) in
            print("\(#function) working and get data")
            self.handleResultGroups(result)
        }
    }
    
    func handleResultGroups(_ result: NetworkResult<REGroupRequestResult>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                state.value = .error
                return
            }
            
            state.value = .populate
            
            guard let items = response.resultArray, items.count > 0 else { return }
            
            groupsRow.items.removeAll()
            for item in items {
                groupsRow.items.append(Group(group: item))
            }
            
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
}


class UserProfileViewModelSection: SectionViewModel {
    var headerTitle: String?
    var rowViewModels: [ViewModelItem] = []
    
    init(headerTitle: String?, _ rowViewModels: [UserProfileViewModelItem]) {
        self.headerTitle = headerTitle
        self.rowViewModels = rowViewModels
    }
}


enum UserProfileViewModelItemType {
    case follow
    case post
    case caught
    case groups
    
    func tableViewIndexPath() -> IndexPath {
        switch self {
        case .follow:
            return IndexPath(row: 0, section: 0)
        case .post:
            return IndexPath(row: 1, section: 0)
        case .caught:
            return IndexPath(row: 2, section: 0)
        case .groups:
            return IndexPath(row: 0, section: 1)
        }
    }
}

protocol UserProfileViewModelItem: ViewModelItem {
    var type: UserProfileViewModelItemType { get }
}

class UserProfileViewModelItemFollow: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .follow
    }
    var followerCount: Dynamic<Int> = Dynamic(0)
    var followingCount: Dynamic<Int> = Dynamic(0)
    
    func formattFollowersCount() -> String {
        return roundedWithAbbreviations(followerCount.value)
    }
    
    func formattFollowingCount() -> String {
        return roundedWithAbbreviations(followingCount.value)
    }
    
    func roundedWithAbbreviations(_ count: Int) -> String {
        let number = Double(count)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(Int(number))"
        }
    }
}

class UserProfileViewModelItemPost: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .post
    }
    
    var title = LocalizedConstants.Profile.Posts
    var postCount: Dynamic<Int> = Dynamic(0)
}

class UserProfileViewModelItemCaught: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .caught
    }
    
    var title = LocalizedConstants.Profile.CaughtPosts
    var caughtCount: Dynamic<Int> = Dynamic(0)
}

class UserProfileViewModelItemGroups: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .groups
    }
    
    var items = [Group]()
}
