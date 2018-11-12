//
//  CommentViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

enum CommentViewModelItemType {
    case comment
}

protocol CommentViewModelItem {
    var type: CommentViewModelItemType { get }
    var id: String { get }
    var cellItems: [CellItem] { get }
}

class CommentViewModelCommentItem: CommentViewModelItem {
    var type: CommentViewModelItemType {
        return .comment
    }
    var id: String {
        return comment?.commentid ?? ""
    }
    
    var cellItems: [CellItem] {
        return getCellItems()
    }
    
    var comment: Comment?
    var post: Post?
    
    init(comment: Comment, post: Post) {
        self.comment = comment
        self.post = post
    }
    
    private func getCellItems() -> [CellItem] {
        
        var cellItems = [CellItem]()
        guard let comment = self.comment else { return cellItems }
        guard let commentid = comment.commentid else { return cellItems }
        
        if let message = comment.message {
            let id = "message:\(commentid)"
            cellItems.append(CellItem(value: message, id: id))
        }
        if let likeCount = comment.likeCount {
            let id = "likeCount:\(commentid)"
            cellItems.append(CellItem(value: likeCount, id: id))
        }
        if let isLiked = comment.isLiked {
            let id = "isLiked:\(commentid)"
            cellItems.append(CellItem(value: isLiked, id: id))
        }
        if let replies = comment.replies {
            let id = "replies:\(commentid)"
            cellItems.append(CellItem(value: replies.count, id: id))
        }
        if let user = comment.user {
            let id = "user:\(commentid)"
            cellItems.append(CellItem(value: user, id: id))
        }
        
        return cellItems
    }
    
}

protocol CommentViewModelDelegate: class {
    func apply(changes: CellChanges)
}

class CommentViewModel: BaseViewModel {
    let sectionCount = 1
    var items = [CommentViewModelItem]()
    var post: Post?
    
    weak var delegate: CommentViewModelDelegate!
    
    // MARK: call after push controller
    func loadData() {
        guard let post = self.post else {
            print("Post data nil, check it couldn't be nil")
            return
        }
        
        LoaderController.shared.showLoader(style: .gray)
        // MARK: when set it get comment of comments
        let commentid = Constants.AWS_PATH_EMPTY
        REAWSManager.shared.getPostComments(post: post, commentid: commentid) { [weak self] result  in
            LoaderController.shared.removeLoader()
            self?.handleResult(result)
        }
    }
    
    private func handleResult(_ result: NetworkResult<RECommentListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
            
            guard let comments = response.items else { return }
            guard let post = self.post else { return }
            
            var newItems = [Comment]()
            for comment in comments {
                newItems.append(Comment(comment: comment))
            }
            
            if !newItems.isEmpty {
                self.populate(comments: newItems, post: post)
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
    
    public func populateWithNewComment(comments: [Comment], post:Post) {
        var newItems = [CommentViewModelItem]()
        newItems += self.items  // adding old data
        
        for comment in comments {
            newItems.append(CommentViewModelCommentItem(comment: comment, post: post))
        }
        setup(newItems: newItems)
    }
    
    func populate(comments: [Comment], post:Post) {
        var newItems = [CommentViewModelItem]()
        for comment in comments {
            newItems.append(CommentViewModelCommentItem(comment: comment, post: post))
        }
        setup(newItems: newItems)
    }
    
    private func setup(newItems: [CommentViewModelItem]) {
        // MARK: difference calculator
        let oldData = flatten(items: items)
        let newData = flatten(items: newItems)
        let cellChanges = DifferenceCalculator.calculate(oldItems: oldData, newItems: newData)
        
        self.items = newItems
        delegate.apply(changes: cellChanges)
        LoaderController.shared.removeLoader()
    }
    
    private func flatten(items: [CommentViewModelItem]) -> [ReloadableCell<CellItem>] {
        let reloadableItems = items
            .enumerated()
            .map { ReloadableCell(key: $0.element.id, value: $0.element.cellItems, index: $0.offset) }
        
        return reloadableItems
    }
}

extension CommentViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        switch item.type {
        case .comment:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewCell.identifier, for: indexPath) as? CommentViewCell {
                cell.selectionStyle = .none
                
                cell.configure(item: item)
                
                return cell
            }
            return UITableViewCell()
        }
    }
}
