//
//  CommentViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let replyComment = #selector(CommentViewCell.replyComment(_:))
    static let like = #selector(CommentViewCell.like(_:))
}

class CommentViewCell: BaseTableCell {
    
    var item: CommentViewModelItem?
    
    private let padding: CGFloat = 10.0
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "catchuusername"
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineFragmentPadding = 0 // textContainer always 5.0 left pedding
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-like"), for: .normal)
        button.tintColor = UIColor.red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: .like, for: .touchUpInside)
        return button
    }()
    
    let likeCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var reply: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.lightGray
        label.text = LocalizedConstants.Feed.Reply
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: .replyComment)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 5) // for CGSize.zero
        view.layer.shadowRadius = 7
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    
    override func setupViews() {
        
        let customLayoutMargin = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let bottomStackView = UIStackView(arrangedSubviews: [likeButton, likeCount, timeAgoLabel, reply])
        bottomStackView.alignment = .fill
        bottomStackView.distribution = .fillProportionally
        bottomStackView.spacing = padding
        
        let contentStackView = UIStackView(arrangedSubviews: [username, messageTextView, bottomStackView])
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        
        let cellStackView = UIStackView(arrangedSubviews: [profileImageView, contentStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .top
        cellStackView.distribution = .fill
        cellStackView.spacing = padding
        cellStackView.layoutMargins = customLayoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        
        self.containerView.addSubview(cellStackView)
        
        self.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor, constant: -padding),
            containerView.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -padding),
            
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            cellStackView.safeTopAnchor.constraint(equalTo: containerView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: containerView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor),
            ])
        
    }
    
    @objc func replyComment(_ sender: Any) {
        guard let item = item as? CommentViewModelCommentItem else { return }
        guard let comment = item.comment else { return }
        
        // TODO: duzelt
//        guard let commentView = self.commentView else { return }
//        commentView.replyComment(comment: comment)
    }
    
    // MARK: trigger from ViewModel DataSource
    func configure(item: CommentViewModelItem) {
        guard let item = item as? CommentViewModelCommentItem else { return }
        self.item = item
        
        guard let comment = item.comment else { return }
        guard let user = comment.user else { return }
        
        if let profileImageUrl = user.profilePictureUrl {
            self.profileImageView.loadAndCacheImage(url: profileImageUrl)
        }
        if let username = user.username {
            self.username.text = username
        }
        
        if let message = comment.message {
            self.messageTextView.text = message
        }
        if let createAt = comment.createAt {
            self.timeAgoLabel.text = createAt.timeAgoSinceDate()
        }
        
        if let likeCount = comment.likeCount {
            self.likeCount.text = "\(likeCount) Likes"
            self.likeCount.isHidden = likeCount > 0 ? false : true
        } else {
            self.likeCount.isHidden = true
        }
        
        if let isLiked = comment.isLiked {
            let buttonImage = isLiked ? UIImage(named: "icon-like-filled") : UIImage(named: "icon-like")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
    }
    
    @objc func like(_ sender: Any) {
        guard let item = item as? CommentViewModelCommentItem else {
            return
        }
        
        guard let relatedPost = item.post else { return }
        guard let comment = item.comment else { return }
        
        guard let isLiked = comment.isLiked else { return }
        guard var likeCount = comment.likeCount else { return }
        
        if isLiked {
            comment.isLiked = !isLiked
            likeCount -= 1
            self.likeButton.setImage(UIImage(named: "icon-like"), for: .normal)
            
            REAWSManager.shared.unlike(post: relatedPost, commentid: comment.commentid) { [weak self] result in
                self?.handleResult(result)
            }
        } else {
            comment.isLiked = !isLiked
            likeCount += 1
            self.likeButton.setImage(UIImage(named: "icon-like-filled"), for: .normal)
            
            REAWSManager.shared.like(post: relatedPost, commentid: comment.commentid) { [weak self] result in
                self?.handleResult(result)
            }
        }
        
        likeCount = likeCount < 0 ? 0 : likeCount
        self.likeCount.text = likeCount > 0 ? "\(likeCount) Likes" : "No Likes"
        self.likeCount.isHidden = likeCount > 0 ? false : true
        
        self.likeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.likeButton.transform = CGAffineTransform.identity
        },
            completion: { Void in()  }
        )
        
    }
    
    private func handleResult(_ result: NetworkResult<REBaseResponse>) {
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

extension CommentViewCell {
    
    /** Gets the owner CommentView of the cell */
//    var commentView: CommentView? {
//        var view = self.superview
//        while (view != nil && view!.isKind(of: CommentView.self) == false) {
//            view = view!.superview
//        }
//        return view as? CommentView
//    }
}

