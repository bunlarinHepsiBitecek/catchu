//
//  CommentView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class CommentView: BaseView {
    
    let dataSource = CommentViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var commentAccessoryView: CommentAccessoryView = {
        let view = CommentAccessoryView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.delegate = self
        return view
    }()
    
    var repliedCommentid = ""
    
    override func setupView() {
        
        // MARK: for inputAccessoryView and canBecomeFirstResponder with becomeFirstResponder
        self.tableView.keyboardDismissMode = .interactive
        self.becomeFirstResponder() // for inputAccessoryView
        
        dataSource.delegate = self
        
        self.addSubview(tableView)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            ])
    }
    
    // MARK: call every time when touch inputAccessoryView
    override var inputAccessoryView: UIView? {
        get {
            return commentAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func layoutSubviews() {
        // MARK: for iphone X return 83, the other return 49
        if let accessoryViewHeight = inputAccessoryView?.frame.height {
            self.tableView.contentInset.bottom =  accessoryViewHeight
        }
    }
    
}

extension CommentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentAccessoryView.messageTextView.resignFirstResponder()
    }
}

extension CommentView: CommentAccessoryViewDelegate {
    
    func replyComment(comment: Comment) {
        guard let user = comment.user else { return }
        // TODO: user objesi duzeltilecek
        //        guard let username = user.userName else { return }
        let username = user.username
        self.commentAccessoryView.messageTextView.text = "@\(username) "
        self.commentAccessoryView.messageTextView.becomeFirstResponder()
        if let commentid = comment.commentid {
            self.repliedCommentid = commentid
        }
    }
    
    func send(_ sender: UIButton) {
        
        guard let post = self.dataSource.post else { return }
        
        guard let message = self.commentAccessoryView.messageTextView.text, !message.isEmpty else {
            print("Message is empty")
            return
        }
        
        let commentInfo = Comment(message: message, user: User.shared)
        commentInfo.commentid = UUID().uuidString
        
        self.dataSource.populateWithNewComment(comments: [commentInfo], post: post)
        self.commentAccessoryView.messageTextView.text = ""
        // hide keyboard after send (just to show how accessory view behave when keyboard hides)
        self.commentAccessoryView.messageTextView.resignFirstResponder()
        
        //        REAWSManager.shared.comment(post: post, repliedCommentid: selectedCommentid, comment: commentInfo) { (result) in
        //            self.handleResult(result)
        //        }
    }
    
    private func handleResult(_ result: NetworkResult<RECommentResponse>) {
        self.repliedCommentid = ""
        
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
        //            guard let comment = response.comment else { return }
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

extension CommentView: CommentViewModelDelegate {
    func apply(changes: CellChanges) {
        print("apply for CommentView")
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: changes.reloads, with: .fade)
            self.tableView.insertRows(at: changes.inserts, with: .fade)
            self.tableView.deleteRows(at: changes.deletes, with: .fade)
            self.tableView.endUpdates()
            
            let section = 0
            let numberOfRows = self.tableView.numberOfRows(inSection: section)
            
            if numberOfRows > 0 {
                let lastRow = numberOfRows - 1
                let indexPath = IndexPath(row: lastRow, section: section)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
}
