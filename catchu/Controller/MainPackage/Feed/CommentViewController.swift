//
//  CommentViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CommentViewController: BaseTableViewController {
    
    let dataSource = CommentViewModel()
    
    var repliedCommentid: String?
    
    lazy var commentAccessoryView: CommentAccessoryView = {
        let view = CommentAccessoryView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = LocalizedConstants.Feed.Comments
        
        // MARK: for inputAccessoryView and canBecomeFirstResponder with becomeFirstResponder
        self.tableView.keyboardDismissMode = .interactive
        
        self.becomeFirstResponder() // for inputAccessoryView
        
        setupTableView()
        
        dataSource.delegate = self
        // load comment data
        self.dataSource.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func viewDidLayoutSubviews() {
        // MARK: for iphone X return 83, the other return 49
        if let accessoryViewHeight = inputAccessoryView?.frame.height {
            tableView.contentInset.bottom =  accessoryViewHeight
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCell.identifier)
        
        tableView.separatorStyle = .none
    }
    
}


extension CommentViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentAccessoryView.messageTextView.resignFirstResponder()
    }
}

extension CommentViewController: CommentAccessoryViewDelegate {
    
    func replyComment(comment: Comment) {
        guard let user = comment.user else { return }
        // TODO: user objesi duzeltilecek
        guard let usernameOrg = user.username else { return }
        let username = "@\(usernameOrg)"
        self.commentAccessoryView.messageTextView.text = username
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
        
        REAWSManager.shared.comment(post: post, repliedCommentid: repliedCommentid, comment: commentInfo) { (result) in
            self.handleResult(result)
        }
        repliedCommentid = nil
    }
    
    private func handleResult(_ result: NetworkResult<RECommentResponse>) {
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

extension CommentViewController: CommentViewModelDelegate {
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
