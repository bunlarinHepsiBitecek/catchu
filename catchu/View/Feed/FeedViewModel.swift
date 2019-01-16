//
//  FeedViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class FeedViewModel: BaseViewModel, ViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 21
    var postid = Constants.AWS_PATH_EMPTY
    var catchType = CatchType.public
    var radius: Double = 0.10
    
    var items = [FeedViewModelItem]()
    
    let state = Dynamic(TableViewState.suggest)
    let changes = Dynamic(CellChanges())
    
    override func setup() {
        super.setup()
        LocationManager.shared.delegate = self
    }
    
    /// call when first time to get data
    func getData() {
        LocationManager.shared.startUpdateLocation()
    }
    
    /// call when pull to refresh
    func refreshData() {
        LocationManager.shared.startUpdateLocation()
    }
    
    private func loadData() {
        
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
        REAWSManager.shared.getFeeds(postid: postid, catchType: catchType, page: page, perPage: perPage, radius: radius) { [unowned self] result in
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

extension FeedViewModel: LocationManagerDelegate {
    func didUpdateLocation() {
        LocationManager.shared.stopUpdateLocation()
        self.loadData()
    }
}

protocol FeedViewModelItem: ViewModelItem {
    var id: String { get }
    var cellItems: [CellItem] { get }
}

struct CellItem: Equatable {
    var value: CustomStringConvertible
    var id: String
    
    static func ==(lhs: CellItem, rhs: CellItem) -> Bool {
        return lhs.id == rhs.id && lhs.value.description == rhs.value.description
    }
}

class FeedViewModelItemPost: FeedViewModelItem {
    var id: String {
        return post?.postid ?? ""
    }
    var cellItems: [CellItem] {
        return getCellItems()
    }
    var post: Post?
    var expanded = false
    var currentPage: Int = 0
    var isPostLiked = Dynamic(false)
    
    init(post: Post?) {
        self.post = post
        
        if let isLiked = post?.isLiked {
            self.isPostLiked.value = isLiked
        }
    }
    
    private func getCellItems() -> [CellItem] {
        
        var cellItems = [CellItem]()
        guard let post = self.post else { return cellItems }
        guard let postid = post.postid else { return cellItems }
        
        if let message = post.message {
            let id = "message:\(postid)"
            cellItems.append(CellItem(value: message, id: id))
        }
        if let attachments = post.attachments {
            let id = "attachements:\(postid)"
            cellItems.append(CellItem(value: attachments.count, id: id))
        }
        if let distance = post.distance {
            let id = "distance:\(postid)"
            cellItems.append(CellItem(value: distance, id: id))
        }
        if let isLiked = post.isLiked {
            let id = "isLiked:\(postid)"
            cellItems.append(CellItem(value: isLiked, id: id))
        }
        if let likeCount = post.likeCount {
            let id = "likeCount:\(postid)"
            cellItems.append(CellItem(value: likeCount, id: id))
        }
        if let commentCount = post.commentCount {
            let id = "commentCount:\(postid)"
            cellItems.append(CellItem(value: commentCount, id: id))
        }
        if let user = post.user {
            let id = "user:\(postid)"
            cellItems.append(CellItem(value: user, id: id))
        }
        if let comments = post.comments {
            let id = "comments:\(postid)"
            cellItems.append(CellItem(value: comments.count, id: id))
        }
        
        return cellItems
    }
    
    func likeUnlikePost() {
        guard let post = self.post, let isLiked = post.isLiked else { return }
        return isLiked ? unlike() : like()
    }
    
    private func like() {
        guard let post = self.post, let isLiked = post.isLiked, var likeCount = post.likeCount else { return
        }
        
        post.isLiked = !isLiked
        likeCount += 1
        post.likeCount = likeCount
        REAWSManager.shared.like(post: post, commentid: nil) { (result) in
            // result true
        }
        
        isPostLiked.value = post.isLiked ?? false
    }
    
    private func unlike() {
        guard let post = self.post, let isLiked = post.isLiked, var likeCount = post.likeCount else { return
        }
        
        post.isLiked = !isLiked
        likeCount -= 1
        post.likeCount = likeCount
        REAWSManager.shared.unlike(post: post, commentid: nil) { (result) in
            // result true
        }
        isPostLiked.value = post.isLiked ?? false
    }
    
    // Turn Off Comments
    func turnOffComments() {
        guard let post = self.post else { return }
        if !post.isOwnPost() {
            fatalError("The post is not own post")
        }
        guard let isCommentAllowed = post.isCommentAllowed else { return }
        post.isCommentAllowed = !isCommentAllowed
        
        REAWSManager.shared.updatePost(post: post) { [unowned self] in
            print("\(#function) working")
            switch $0 {
            case .success(let response):
                if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                    
                    post.isCommentAllowed = isCommentAllowed
                    
                    print("Lambda Error: \(error)")
                    return
                }
                
                
                
            case .failure(let apiError):
                post.isCommentAllowed = isCommentAllowed
                
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
    
    
    /// Report Post
    func reportPost(_ reportType: ReportType) {
        guard let post = self.post else { return }
        guard let postid = post.postid else { return }
        
        REAWSManager.shared.reportPost(postid: postid, reportType: reportType) { [unowned self] in
            print("\(#function) working")
            switch $0 {
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
    
    func deletePost() {
        guard let post = self.post else { return }
        guard let postid = post.postid else { return }
        
        if !post.isOwnPost() {
            debugPrint("Can not delete not owned post")
            return
        }
        
        REAWSManager.shared.deletePost(postid: postid) { [unowned self] in
            print("\(#function) working")
            switch $0 {
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
    
}
