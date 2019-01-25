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
    var user = User.shared
    
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
    let changes = Dynamic(CellChanges())
    
    func getUserInfo() {
        guard let userid = User.shared.userid else { return }
        
        state.value = .loading
        REAWSManager.shared.getUserProfileInfo(userid: userid, requestedUserid: userid, isShortInfo: nil) { (result) in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    
    func handleResult(_ result: NetworkResult<REUserProfile>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                state.value = .error
                return
            }
            
            user.setUserProfile(response)
            setupRowData()
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
    
    private func setupRowData() {
        
        followRow.user = self.user
        
        if let userFollower = user.userFollowerCount, let followerCount = Int(userFollower) {
            followRow.followerCount = followerCount
        }
        if let userFollowing = user.userFollowingCount, let followingCount = Int(userFollowing) {
            followRow.followingCount = followingCount
        }
        if let postCount = user.userPostCount {
            postRow.postCount = postCount
        }
        if let caughtCount = user.userCaughtCount {
            caughtRow.caughtCount = caughtCount
        }
    }
    
    func getUserGroups() {
        REAWSManager.shared.getUserGroups(requestType: .userGroups) { [unowned self] in
            print("\(#function) working and get data")
            self.handleResultGroups($0)
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
            
            groupsRow.items.removeAll()
            guard let items = response.resultArray else { return }
            
            for item in items {
                groupsRow.items.append(Group(reGroup: item))
            }
            changes.value = CellChanges(inserts: [], deletes: [], reloads: [groupsRow.type.indexPath()])
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
    
    func indexPath() -> IndexPath {
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
    var user: User!
    var followerCount: Int = 0
    var followingCount: Int = 0
}

class UserProfileViewModelItemPost: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .post
    }
    
    var title = LocalizedConstants.Profile.Posts
    var postCount: Int = 0
}

class UserProfileViewModelItemCaught: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .caught
    }
    
    var title = LocalizedConstants.Profile.CaughtPosts
    var caughtCount: Int = 0
}

class UserProfileViewModelItemGroups: UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {
        return .groups
    }
    
    var items = [Group]()
}
