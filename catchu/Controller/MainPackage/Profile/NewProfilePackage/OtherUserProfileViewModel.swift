//
//  OtherUserProfileViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class OtherUserProfileViewModel: BaseViewModel, ViewModel {
    var page: Int = 1
    let perPage: Int = 21
    var privacyType = PrivacyType.everyone
    var radius: Double = 0.10
    var isMorePageExists = true
    var items = [FeedViewModelItem]()
    let changes = Dynamic(CellChanges())
    let state = Dynamic(TableViewState.loading)
    let headerState = Dynamic(TableViewState.loading)
    
    var user: User!
    var headerItem: OtherUserProfileViewModelItemHeader!
    
    var postRowHeight: CGFloat {
        let targetWidthHeight = Constants.ScreenBounds.width / Constants.Profile.CollectionItemPerLine
        let rowCount = CGFloat(items.count) / Constants.Profile.CollectionItemPerLine
        let roundedUpRowCount = CGFloat(ceil(rowCount))
        
        return roundedUpRowCount * targetWidthHeight
    }
    
    init(user: User) {
        super.init()
        self.user = user
        self.headerItem = OtherUserProfileViewModelItemHeader(user)
    }
    
    
    func getUserInfo() {
        guard let userid = User.shared.userid else { return }
        guard let requestedUserid = user.userid else { return }

        headerState.value = .loading
        REAWSManager.shared.getUserProfileInfo(userid: userid, requestedUserid: requestedUserid, isShortInfo: false) { (result) in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    
    private func handleResult(_ result: NetworkResult<REUserProfile>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                headerState.value = .error
                return
            }
            
            user.setUserProfile(response)
            headerState.value = .populate
            getUserPosts()
        case .failure(let apiError):
            headerState.value = .error
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
    
    /// When user info is readed than get post
    func getUserPosts() {
        guard let userid = user.userid else { return }
        
        print("getUserPosts started")
        
        // TODO: for test delete sil
        if Constants.LOCALTEST {
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            let posts = dummyPosts(start: 0, stop: 20)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.populate(posts: posts)
            })
            return
        }
        
        state.value = .loading
        REAWSManager.shared.getUserProfilePosts(targetUserid: userid, privacyType: privacyType, page: page, perPage: perPage, radius: radius) { [unowned self] result in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    func getUserPostsMore() {
        guard let userid = user.userid else { return }
        
        // TODO: for test delete sil
        if Constants.LOCALTEST, isMorePageExists, state.value != .loading {
            
            print("getUserPostsMore started")
            
            guard Reachability.networkConnectionCheck() else { return }
            state.value = .loading
            let posts = dummyPosts(start: 21, stop: 29)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.populate(posts: posts)
            })
            return
        }
        
        page += 1
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
            
            if !newItems.isEmpty {
                self.populate(posts: newItems)
            } else {
                isMorePageExists = false
                state.value = .empty
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


class OtherUserProfileViewModelItemHeader: ViewModelItem {
    var user: User

    init(_ user: User) {
        self.user = user
    }
}

