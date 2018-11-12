//
//  FeedViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

enum FeedViewModelItemType {
    case post
    //    case advert
}

protocol FeedViewModelItem: BaseViewModelItem {
    var type: FeedViewModelItemType { get }
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

protocol FeedViewModelDelegete: class {
    func apply(changes: CellChanges)
}

class FeedViewModelPostItem: FeedViewModelItem {
    var type: FeedViewModelItemType {
        return .post
    }
    var id: String {
        return post?.postid ?? ""
    }
    var cellItems: [CellItem] {
        return getCellItems()
    }
    var post: Post?
    var expanded = false
    var currentPage: Int = 0
    
    init(post: Post?) {
        self.post = post
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
}

class FeedViewModel: BaseViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 20
    var items = [FeedViewModelItem]()
    
    weak var delegate: FeedViewModelDelegete!
    
    override func setup() {
        LocationManager.shared.delegate = self
        LocationManager.shared.startUpdateLocation()
    }
    
    func refreshData() {
        LocationManager.shared.startUpdateLocation()
    }
    
    private func loadData() {
        
        // TODO: for test delete sil
        if Constants.LOCALTEST {
            LoaderController.shared.showLoader(style: .gray)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                LoaderController.shared.removeLoader()
                self.populate(posts: [Post]())
            })
            return
        }
        // TODO: for test delete sil
        
        LoaderController.shared.showLoader(style: .gray)
        REAWSManager.shared.getFeeds(page: page, perPage: perPage, radius: Constants.Map.Radius) { [weak self]
            result in
            print("\(#function) working and get data")
            LoaderController.shared.removeLoader()
            self?.handleResult(result)
        }
    }
    
    func handleResult(_ result: NetworkResult<REPostListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
            
            guard let posts = response.items else { return }
            
            var newItems = [Post]()
            for post in posts {
                newItems.append(Post(post: post))
            }
            if !newItems.isEmpty {
                self.populate(posts: newItems)
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
    
    private func populate(posts: [Post]) {
        var newItems = [FeedViewModelItem]()
        for post in posts {
            newItems.append(FeedViewModelPostItem(post: post))
        }
        setup(newItems: newItems)
    }
    
    private func setup(newItems: [FeedViewModelItem]) {
        // MARK: difference calculator
        let oldData = flatten(items: items)
        let newData = flatten(items: newItems)
        let cellChanges = DifferenceCalculator.calculate(oldItems: oldData, newItems: newData)
        
        self.items = newItems
        delegate?.apply(changes: cellChanges)
        LoaderController.shared.removeLoader()
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

extension FeedViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .post:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.identifier, for: indexPath) as? FeedViewCell {
                cell.selectionStyle = .none
                
                cell.configure(item: item, indexPath: indexPath)
                
                if let delegate = self.delegate as? FeedViewCellDelegate {
                    cell.delegate = delegate
                }
                
                return cell
            }
            return UITableViewCell()
        }
    }
    
    
}

