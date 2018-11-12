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
    
    private var shadowLayer: CAShapeLayer!
    private let padding: CGFloat = 10.0
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        view.layer.shadowColor = UIColor.lightGray.cgColor
//        view.layer.shadowOpacity = 0.8
//        view.layer.shadowOffset = CGSize(width: 0, height: 5) // for CGSize.zero
//        view.layer.shadowRadius = 7
//        view.layer.cornerRadius = 15
        
        return view
    }()
    
    lazy var mediaView: MediaView = {
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
        super.setupViews()
        
        self.containerView.addSubview(profileImageView)
        self.containerView.addSubview(name)
        self.containerView.addSubview(username)
        self.containerView.addSubview(likeButton)
        self.containerView.addSubview(statusTextView)
        self.containerView.addSubview(mediaView)
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
        
        NSLayoutConstraint.activate([
            
            // pin containerView to content
            containerView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: padding),
            containerView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor, constant: -padding),
            containerView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: padding),
            containerView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -padding),
            
            //pin profileImage
            profileImageView.safeTopAnchor.constraint(equalTo: containerView.safeTopAnchor, constant: padding),
            profileImageView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor, constant: padding),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            //pin name
            name.safeTopAnchor.constraint(equalTo: profileImageView.safeTopAnchor),
            name.safeLeadingAnchor.constraint(equalTo: profileImageView.safeTrailingAnchor, constant: padding),
            name.safeTrailingAnchor.constraint(equalTo: likeButton.safeLeadingAnchor, constant: -padding),
            
            //pin username
            username.safeTopAnchor.constraint(equalTo: name.safeBottomAnchor),
            username.safeLeadingAnchor.constraint(equalTo: name.safeLeadingAnchor),
            username.safeTrailingAnchor.constraint(equalTo: name.safeTrailingAnchor),
            
            //layout addButton
            likeButton.safeTopAnchor.constraint(equalTo: containerView.safeTopAnchor, constant: padding),
            likeButton.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor, constant: -padding),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            
            // pin statustext
            statusTextView.safeTopAnchor.constraint(equalTo: username.safeBottomAnchor),
            statusTextView.safeLeadingAnchor.constraint(equalTo: username.safeLeadingAnchor),
            statusTextView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor),
            
            mediaView.safeTopAnchor.constraint(equalTo: statusTextView.safeBottomAnchor),
            mediaView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor),
            mediaView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: mediaView.frame.height),
            
            footerView.safeTopAnchor.constraint(equalTo: mediaView.safeBottomAnchor, constant: padding),
            footerView.safeBottomAnchor.constraint(equalTo: containerView.safeBottomAnchor, constant: -padding),
            footerView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor, constant: padding),
            footerView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor, constant: -padding),
            
            timeAgoLabel.safeTopAnchor.constraint(equalTo: footerView.safeTopAnchor),
            timeAgoLabel.safeLeadingAnchor.constraint(equalTo: footerView.safeLeadingAnchor),
            
            distanceLabel.safeTopAnchor.constraint(equalTo: footerView.safeTopAnchor),
            distanceLabel.safeTrailingAnchor.constraint(equalTo: footerView.safeTrailingAnchor),
            
            likeCountLabel.safeTopAnchor.constraint(equalTo: timeAgoLabel.safeBottomAnchor, constant: padding),
            likeCountLabel.safeBottomAnchor.constraint(equalTo: footerView.safeBottomAnchor),
            likeCountLabel.safeLeadingAnchor.constraint(equalTo: footerView.safeLeadingAnchor),
            likeIcon.safeBottomAnchor.constraint(equalTo: likeCountLabel.safeBottomAnchor),
            likeIcon.safeLeadingAnchor.constraint(equalTo: likeCountLabel.safeTrailingAnchor, constant: 5),
            likeIcon.widthAnchor.constraint(equalToConstant: 17),
            likeIcon.heightAnchor.constraint(equalToConstant: 17),
            
            commentCountLabel.safeBottomAnchor.constraint(equalTo: likeCountLabel.safeBottomAnchor),
            commentCountLabel.safeLeadingAnchor.constraint(equalTo: likeIcon.safeTrailingAnchor, constant: 20),
            commentIcon.safeBottomAnchor.constraint(equalTo: commentCountLabel.safeBottomAnchor),
            commentIcon.safeLeadingAnchor.constraint(equalTo: commentCountLabel.safeTrailingAnchor, constant: 5),
            commentIcon.widthAnchor.constraint(equalToConstant: 17),
            commentIcon.heightAnchor.constraint(equalToConstant: 17),
            
            moreButton.safeBottomAnchor.constraint(equalTo: footerView.safeBottomAnchor),
            moreButton.safeTrailingAnchor.constraint(equalTo: footerView.safeTrailingAnchor),
            ])
        

    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
         /// Custom cell subview actual size zero in layoutSubviews(), so override layoutIfNeeded
        if shadowLayer == nil {
            let cornerRadius: CGFloat = 15.0
            
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 7
            
            containerView.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func configure(item: FeedViewModelItem, indexPath: IndexPath) {
        guard let item = item as? FeedViewModelPostItem else { return }
        self.item = item
        self.indexPath = indexPath
        
        // MARK: Post value converter
        if let post = item.post {
            self.mediaView.post = post
            
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
            self.distanceLabel.text = post.distanceFormatter()
            
            if let user = post.user {
                if let name = user.name {
                    self.name.text = name
                    self.profileImageView.setImageInitialPlaceholder(name, circular: true)
                }
                if let username = user.username {
                    self.username.text = username
                }
                if let profilePictureUrl = user.profilePictureUrl {
                    self.profileImageView.loadAndCacheImage(url: profilePictureUrl)
                }
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

