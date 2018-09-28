//
//  FeedViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

protocol FeedViewCellDelegate: class {
    func updateTableView(indexPath: IndexPath?)
}

class BaseTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class FeedViewCell: BaseTableCell {
    
    var item: FeedViewModelItem?
    var indexPath: IndexPath?
    
    weak var delegate: FeedViewCellDelegate!
    
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
    
    lazy var swipingView: MediaView = {
        let view = MediaView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 250))
        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 120))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    //we use lazy properties for each view
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "catchuname"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = UIColor.lightGray
        label.text = "catchuuser"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-more"), for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.textContainer.lineFragmentPadding = 0 // textContainer always 5.0 left pedding

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        return textView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-like"), for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-like")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var commentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-comment")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewComments(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        
        return imageView
    }()
    
    let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "120 m"
        return label
    }()
    
    
    override func setupViews() {
        
        self.containerView.addSubview(profileImageView)
        self.containerView.addSubview(name)
        self.containerView.addSubview(username)
        self.containerView.addSubview(likeButton)
        self.containerView.addSubview(statusTextView)
        self.containerView.addSubview(swipingView)
        self.containerView.addSubview(footerView)
        
        footerView.addSubview(timeAgoLabel)
        footerView.addSubview(distanceLabel)
        footerView.addSubview(likeCountLabel)
        footerView.addSubview(commentCountLabel)
        footerView.addSubview(likeIcon)
        footerView.addSubview(commentIcon)
        footerView.addSubview(moreButton)
        
        
        // now add container view to content view for UITableViewAutomaticDimension
        self.contentView.addSubview(self.containerView)
        let contentLayout   = self.contentView.safeAreaLayoutGuide
        let containerLayout = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            // pin containerView to content
            containerView.topAnchor.constraint(equalTo: contentLayout.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentLayout.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentLayout.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentLayout.trailingAnchor, constant: -10),
            
            //pin profileImage
            profileImageView.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            //pin name
            name.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            name.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10),
            
            //pin username
            username.topAnchor.constraint(equalTo: name.bottomAnchor),
            username.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            username.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            //layout addButton
            likeButton.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -10),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            
            // pin statustext
            statusTextView.topAnchor.constraint(equalTo: username.bottomAnchor),
            statusTextView.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            statusTextView.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor),
            ])
        
        NSLayoutConstraint.activate([
            swipingView.topAnchor.constraint(equalTo: statusTextView.bottomAnchor),
            swipingView.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor),
            swipingView.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor),
            swipingView.heightAnchor.constraint(equalToConstant: self.swipingView.frame.height)
            ])

        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: swipingView.bottomAnchor, constant: 10),
            footerView.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor, constant: -10),
            footerView.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 10),
            footerView.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -10),
            ])

        let footerLayout = self.footerView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            timeAgoLabel.topAnchor.constraint(equalTo: footerLayout.topAnchor),
            timeAgoLabel.leadingAnchor.constraint(equalTo: footerLayout.leadingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: footerLayout.topAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: footerLayout.trailingAnchor),
            
            likeCountLabel.topAnchor.constraint(equalTo: timeAgoLabel.bottomAnchor, constant: 10),
            likeCountLabel.bottomAnchor.constraint(equalTo: footerLayout.bottomAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: footerLayout.leadingAnchor),
            likeIcon.bottomAnchor.constraint(equalTo: likeCountLabel.bottomAnchor),
            likeIcon.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 5),
            likeIcon.widthAnchor.constraint(equalToConstant: 17),
            likeIcon.heightAnchor.constraint(equalToConstant: 17),
            
            commentCountLabel.bottomAnchor.constraint(equalTo: likeCountLabel.bottomAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: 20),
            commentIcon.bottomAnchor.constraint(equalTo: commentCountLabel.bottomAnchor),
            commentIcon.leadingAnchor.constraint(equalTo: commentCountLabel.trailingAnchor, constant: 5),
            commentIcon.widthAnchor.constraint(equalToConstant: 17),
            commentIcon.heightAnchor.constraint(equalToConstant: 17),
            
            moreButton.bottomAnchor.constraint(equalTo: footerLayout.bottomAnchor),
            moreButton.trailingAnchor.constraint(equalTo: footerLayout.trailingAnchor),
            
            ])
    }
    
    func configure(item: FeedViewModelItem, indexPath: IndexPath) {
        guard let item = item as? FeedViewModelPostItem else { return }
        self.item = item
        self.indexPath = indexPath
        
        // MARK: Post value converter
        if let post = item.post {
            
            if let message = post.message {
                statusTextViewReadMore(expanded: item.expanded, text: message)
            }
            if let isLiked = post.isLiked {
                let buttonImage = isLiked ? UIImage(named: "icon-like-filled") : UIImage(named: "icon-like")
                self.likeButton.setImage(buttonImage, for: .normal)
            }
            if let likeCount = post.likeCount {
                self.likeCountLabel.text = "\(likeCount)"
            }
            if let commentCount = post.commentCount {
                self.commentCountLabel.text = "\(commentCount)"
            }
            if let createAt = post.createAt {
                self.timeAgoLabel.text = createAt.timeAgoSinceDate()
            }
            if let distance = post.distance {
                self.distanceLabel.text = "\(Int(distance)) m"
            }
            if let user = post.user {
                self.name.text = user.name
                self.username.text = user.userName
                self.profileImageView.loadImageUsingUrlString(urlString: user.profilePictureUrl)
            }
        }
    }
    
    func statusTextViewReadMore(expanded: Bool, text: String) {
        self.statusTextView.attributedText = nil
        self.statusTextView.text = text
        
        if expanded {
            self.statusTextView.resolveHashTags()
        } else {
            self.statusTextView.readMoreCheck()
        }
    }
    
    @objc func likeButtonClick() {
        
        guard let item = item as? FeedViewModelPostItem else {
            return
        }
        
        guard let post = item.post else { return }
        
        guard let isLiked = post.isLiked else { return }
        guard var likeCount = post.likeCount else { return }
        
        let comment = Comment(comment: REComment()) // empty, no need
        
        if isLiked {
            post.isLiked = !isLiked
            likeCount -= 1
            post.likeCount = likeCount
            self.likeButton.setImage(UIImage(named: "icon-like"), for: .normal)
            REAWSManager.shared.unlike(post: post, comment: comment) { (result) in
                // result true
            }
        } else {
            post.isLiked = !isLiked
            likeCount += 1
            post.likeCount = likeCount
            self.likeButton.setImage(UIImage(named: "icon-like-filled"), for: .normal)
            
            REAWSManager.shared.like(post: post, comment: comment) { (result) in
                // result true
            }
        }
        
        self.likeCountLabel.text = "\(likeCount)"
        
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
    
    @objc func viewComments(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let item = self.item as? FeedViewModelPostItem else { return }
        guard let post = item.post else { return }
        
        let commentViewController = CommentViewController()
        commentViewController.commentView.dataSource.post = post
        LoaderController.pushViewController(controller: commentViewController)
    }
    
}

//extension UITableViewCell {
//
//    /** Gets the owner tableView of the cell */
//    var tableView: UITableView? {
//        var view = self.superview
//        while (view != nil && view!.isKind(of: UITableView.self) == false) {
//            view = view!.superview
//        }
//        return view as? UITableView
//    }
//}

extension FeedViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("shouldInteractWith")
        // check for our fake URL scheme hash:helloWorld
        switch URL.scheme {
        case SchemeType.hash.rawValue :
            print("Hash basildi")
        case SchemeType.mention.rawValue :
            print("mention basildi")
        case LocalizedConstants.Feed.More :
            print("more basildi")
            delegate.updateTableView(indexPath: self.indexPath)
        default:
            print("just a regular url click")
        }

        return true
    }
}
