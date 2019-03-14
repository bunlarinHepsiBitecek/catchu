//
//  LikeViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class LikeViewModel: BaseViewModel, ViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 20
    var items = [ViewModelItem]()
    
    var post: Post?
    var comment: Comment?
    
    var reloadTableView = Dynamic(true)
    
    func loadData() {
//        guard let post = self.post else { return }
//        let comment = self.comment ?? Comment()
//        LoaderController.shared.showLoader(style: .gray)
//        REAWSManager.shared.getlikeUsers(page: page, perPage: perPage, post: post, comment: comment) { [weak self] result in
//            print("\(#function) working and get data")
//            LoaderController.shared.removeLoader()
//            self?.handleResult(result)
//        }
        dummyData()
    }
    
    func refreshData() {
        
    }
    
    private func handleResult(_ result: NetworkResult<REUserListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
            
            guard let users = response.items else { return }
            
            var newItems = [User]()
            for user in users {
                newItems.append(User(user: user))
            }
            if !newItems.isEmpty {
                self.populate(users: newItems)
            }
            
        case .failure(let apiError):
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
    
    private func populate(users: [User]) {
        for user in users {
            let likeItem = ViewModelUser(user: user)
            items.append(likeItem)
        }
        reloadTableView.value = true
    }
    
    func dummyData() {
        guard let user1 = REUser() else { return}
        user1.userid = UUID.init().uuidString
        user1.name = "user Aname"
        user1.username = "user1 username"
        user1.followStatus = "FOLLOWING"
        
        guard let user2 = REUser() else { return}
        user2.userid = UUID.init().uuidString
        user2.name = "user2 Bname"
        user2.username = "user2 username x"
        user2.followStatus = "NONE"
        user2.isPrivateAccount = NSNumber(value: true)
        
        guard let user3 = REUser() else { return}
        user3.userid = UUID.init().uuidString
        user3.name = "user3 Cname"
        user3.username = "user3 username xx"
        user3.followStatus = "NONE"
        user3.isPrivateAccount = NSNumber(value: false)
        
        guard let user4 = REUser() else { return}
        user4.userid = UUID.init().uuidString
        user4.name = "user4 Dname"
        user4.username = "user4 username xxx"
        user4.followStatus = "OWN"
        
        guard let user5 = REUser() else { return}
        user5.userid = UUID.init().uuidString
        user5.name = "user5 Ename"
        user5.username = "user5 username xxxx"
        user5.followStatus = "FOLLOWING"
        user5.isPrivateAccount = NSNumber(value: true)
        
        guard let user6 = REUser() else { return}
        user6.userid = UUID.init().uuidString
        user6.name = "user6 Fname"
        user6.username = "user6 username xxxx"
        user6.followStatus = "PENDING"
        user6.isPrivateAccount = NSNumber(value: true)

        var users = [REUser]()
        users.append(user1)
        users.append(user2)
        users.append(user3)
        users.append(user4)
        users.append(user5)
        users.append(user6)
        
        var newItems = [User]()
        for user in users {
            newItems.append(User(user: user))
        }
        if !newItems.isEmpty {
            self.populate(users: newItems)
        }
        
    }
}

class ViewModelUser: ViewModelItem {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func sendRequestProcess() {
//        guard let user = self.user else { return }
        guard let targetUserid = user.userid else { return }
        let requestType = findRequestType()
        if requestType == .defaultRequest {
            return
        }
        guard let userid = User.shared.userid else { return }
        
        updateFollowStatus(requestType)
        REAWSManager.shared.requestRelationProcess(requestType: requestType, userid: userid, targetUserid: targetUserid) { [weak self] resut in
            self?.handleResult(resut)
        }
    }
    
    func findRequestType() -> RequestType {
//        guard let user = self.user else { return .defaultRequest }
        guard let followStatus = user.followStatus else { return .defaultRequest }
        let isPrivateAccount = user.isUserHasAPrivateAccount ?? false
        
        switch followStatus {
        case .none:
            return isPrivateAccount ? .followRequest : .createFollowDirectly
        case .following:
            return .deleteFollow
        case .pending:
            return .deletePendingFollowRequest
        default:
            return .defaultRequest
        }
    }
    
    private func updateFollowStatus(_ requestType: RequestType) {
        switch requestType {
        case .createFollowDirectly:
            user.followStatus = User.FollowStatus.following
        case .followRequest:
            user.followStatus = User.FollowStatus.pending
        case .deleteFollow, .deletePendingFollowRequest:
            user.followStatus = User.FollowStatus.none
        default:
            return
        }
    }
    
    private func handleResult(_ result: NetworkResult<REFriendRequestList>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
        case .failure(let apiError):
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
