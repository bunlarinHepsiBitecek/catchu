//
//  UserProfilePostsViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfilePostsViewModel: BaseViewModel, ViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 21
    var postid = Constants.AWS_PATH_EMPTY
    var privacyType = PrivacyType.everyone
    var radius: Double = 0.10
    
    var user: User!
    
    var items = [FeedViewModelItem]()
    
    let state = Dynamic(TableViewState.suggest)
    let changes = Dynamic(CellChanges())
    
    var isMorePostsExists = true
    
    /// call when pull to refresh
    func refreshData() {
        page = 1
        items.removeAll()
        
        getUserPosts()
    }
    
    private func getUserPosts() {
        guard let userid = user.userid else { return }
        
        // TODO: for test delete sil
        if Constants.LOCALTEST {
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.populate(posts: [Post]())
            })
            return
        }
        // TODO: for test delete sil
        
        state.value = .loading
        REAWSManager.shared.getUserProfilePosts(targetUserid: userid, privacyType: privacyType, page: page, perPage: perPage, radius: radius) { [unowned self] result in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    private func getUserMorePosts() {
        guard isMorePostsExists, let userid = user.userid else { return }

        page += 1
        // TODO: for test delete sil
        if Constants.LOCALTEST {
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.populate(posts: [Post]())
            })
            return
        }
        // TODO: for test delete sil
        
        state.value = .loading
        REAWSManager.shared.getUserProfilePosts(targetUserid: userid, privacyType: privacyType, page: page, perPage: perPage, radius: radius) { [unowned self] result in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    func handleResult(_ result: NetworkResult<REPostListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                state.value = .error
                return
            }
            
            guard let posts = response.items else { return }
            
            var newItems = [Post]()
            for post in posts {
                newItems.append(Post(post: post))
            }
            
            isMorePostsExists = newItems.count == perPage
            
            if !newItems.isEmpty {
                self.populate(posts: newItems)
            } else {
                state.value = items.count == 0 ? .empty : .populate
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
    
    private func populate(posts: [Post]) {
        var newItems = [FeedViewModelItem]()
        for post in posts {
            newItems.append(FeedViewModelItemPost(post: post))
        }
        setup(newItems: newItems)
    }
    
    private func setup(newItems: [FeedViewModelItem]) {
        // MARK: difference calculator
        let oldData = flatten(items: items)
        let newData = flatten(items: newItems)
        let cellChanges = DifferenceCalculator.calculate(oldItems: oldData, newItems: newData)
        
        self.items = newItems
        state.value = items.count == 0 ? .empty : .populate
        self.changes.value = cellChanges
    }
    
    private func flatten(items: [FeedViewModelItem]) -> [ReloadableCell<CellItem>] {
        let reloadableItems = items
            .enumerated()
            .map { ReloadableCell(key: $0.element.id, value: $0.element.cellItems, index: $0.offset) }
        
        return reloadableItems
    }
}
