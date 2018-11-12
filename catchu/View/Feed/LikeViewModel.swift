//
//  LikeViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

protocol LikeViewModelDelegete: class {
    func updateTableView()
}

class LikeViewModel: BaseViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 20
    var items = [LikeViewModelItem]()
    
    var post: Post?
    var comment: Comment?
    
    weak var delegate: LikeViewModelDelegete!
    
    func loadData() {
        guard let post = self.post else { return }
        let comment = self.comment ?? Comment()
//        LoaderController.shared.showLoader(style: .gray)
//        REAWSManager.shared.getlikeUsers(page: page, perPage: perPage, post: post, comment: comment) { [weak self] result in
//            print("\(#function) working and get data")
//            LoaderController.shared.removeLoader()
//            self?.handleResult(result)
//        }
        dummyData()
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
            let likeItem = LikeViewModelLikeItem(user: user)
            items.append(likeItem)
        }
        
        if let delegate = self.delegate {
            delegate.updateTableView()
        }
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

enum LikeViewModelItemType {
    case like
}

protocol LikeViewModelItem {
    var type: LikeViewModelItemType { get }
}

class LikeViewModelLikeItem: LikeViewModelItem {
    var type: LikeViewModelItemType {
        return .like
    }
    
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
}


extension LikeViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .like:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LikeViewCell.identifier, for: indexPath) as? LikeViewCell {
                
                cell.configure(item: item)
                
                return cell
            }
            return UITableViewCell()
        }
    }
    
}
