//
//  UserPostsViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

class UserPostsViewModel: BaseViewModel, ViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 21
    var isMorePageExists = true
    var radius: Double = 0.10
    
    var user: User! // targetUser
    
    var items = [FeedViewModelItem]()
    let state = Dynamic(TableViewState.suggest)
    let changes = Dynamic(CellChanges())
    
    func getUserPosts() {
        page = 1
        items.removeAll()
        // TODO: for test delete sil
        if Constants.LOCALTEST {
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                let posts = self.dummyPosts(start: 0, stop: 20)
                self.populate(posts: posts)
            })
            return
        }
        // TODO: for test delete sil
        
        guard let targetUserid = self.user.userid else { return }
        state.value = .loading
        REAWSManager.shared.getUserProfilePosts(targetUserid: targetUserid, privacyType: .everyone, page: page, perPage: perPage, radius: radius) { [unowned self] in
            print("\(#function) working and get data")
            self.handleResult($0)
        }
    }
    
    func getUserPostsMore() {
        // TODO: for test delete sil
        if Constants.LOCALTEST, state.value == .paging {
            
            page += 1
            print("getUserPostsMore started")
            
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            let posts = dummyPosts(start: 21, stop: 38)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.populate(posts: posts)
            })
            return
        }
        // TODO: for test delete sil
        
        
    }
    
    
    private func handleResult(_ result: NetworkResult<REPostListResponse>) {
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
            
            self.populate(posts: newItems)
            
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
        
        // MARK: bu satir kritik duzenleme sonrasi silinecek SIL
        newItems = items.compactMap {$0 as? FeedViewModelItemPost}
        
        isMorePageExists = posts.count == perPage
        
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
        
        if isMorePageExists {
            state.value = .paging
        } else {
            state.value = items.isEmpty ? .empty : .populate
        }
        
        self.changes.value = cellChanges
    }
    
    private func flatten(items: [FeedViewModelItem]) -> [ReloadableCell<CellItem>] {
        let reloadableItems = items
            .enumerated()
            .map { ReloadableCell(key: $0.element.id, value: $0.element.cellItems, index: $0.offset) }
        
        return reloadableItems
    }
}

extension UserPostsViewModel {
    
    func dummyPosts(start: Int, stop: Int) -> [Post] {
        var posts = [Post]()
        
        for index in start...stop {
            let post = Post()
            post.postid = "post\(index)"
            post.message = "post\(index) message"
            let media = Media()
            media.type = "image"
            media.url = "https://picsum.photos/\(index*10)/\(index*10)/?random"
            post.attachments = [media]
            post.location = Location()
            post.location?.latitude = 41.013303
            post.location?.longitude = 28.93119
            post.distance = 3000
            post.isLiked = true
            post.isCommentAllowed = true
            post.isShowOnMap = true
            post.commentCount = 79
            post.user = User()
            post.user?.userid = "userid\(index)"
            post.user?.name = "Fake User Name \(index)"
            post.user?.username = "username\(index)"
            post.user?.followStatus = .following
            post.privacyType = "Public"
            post.allowList = []
            post.comments = []
            posts.append(post)
        }
        
        return posts
    }
}
