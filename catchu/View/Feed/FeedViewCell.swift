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

class FeedViewCell: BaseTableCell {
    
    var item: FeedViewModelItem?
    var indexPath: IndexPath?
    
    weak var delegate: FeedViewCellDelegate!
    
//    private var shadowLayer: CAShapeLayer!
    private let padding = Constants.Feed.Padding
    private let dimension = Constants.Feed.ImageWidthHeight
    
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
    
    lazy var mediaView: MediaView = {
        let view = MediaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //we use lazy properties for each view
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
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
        button.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewLikeUsers(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
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
        return label
    }()
    
    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-location"), for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showLocation(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        // MARK : It use in stack for lean view to right
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // MARK : horizontal right
        likeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let customLayoutMargin = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let nameStackView = UIStackView(arrangedSubviews: [name, username])
        nameStackView.axis = .vertical
        
        let headerStackView = UIStackView(arrangedSubviews: [profileImageView, nameStackView, likeButton])
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        headerStackView.spacing = padding
        
        let mediaStackView = UIStackView(arrangedSubviews: [mediaView])
        mediaStackView.layoutMargins = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        mediaStackView.isLayoutMarginsRelativeArrangement = true
        
        let locationStackView = UIStackView(arrangedSubviews: [distanceLabel, locationButton])
        locationStackView.alignment = .fill
        locationStackView.distribution = .equalSpacing
        locationStackView.spacing = padding
        
//        let timeDistanceStackView = UIStackView(arrangedSubviews: [timeAgoLabel, distanceLabel])
        let timeDistanceStackView = UIStackView(arrangedSubviews: [timeAgoLabel, locationStackView])
        timeDistanceStackView.alignment = .fill
        timeDistanceStackView.distribution = .equalCentering
        
        let likeCommentStackView = UIStackView(arrangedSubviews: [likeIcon, likeCountLabel, commentIcon, commentCountLabel, spacer, moreButton])
        likeCommentStackView.alignment = .fill
        likeCommentStackView.distribution = .fill
        likeCommentStackView.spacing = padding/2
        likeCommentStackView.setCustomSpacing(padding, after: likeCountLabel)
        
        let containerStackView = UIStackView(arrangedSubviews: [headerStackView, statusTextView, mediaStackView, timeDistanceStackView, likeCommentStackView,])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.layoutMargins = customLayoutMargin
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.setCustomSpacing(padding, after: mediaStackView)
        containerStackView.setCustomSpacing(padding, after: timeDistanceStackView)
        
        self.containerView.addSubview(containerStackView)
        // now add container view to content view for UITableViewAutomaticDimension
        self.contentView.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            
            // pin containerView to content
            containerView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: padding),
            containerView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor, constant: -padding),
            containerView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: padding),
            containerView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -padding),
            
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            containerStackView.safeTopAnchor.constraint(equalTo: containerView.safeTopAnchor),
            containerStackView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor),
            containerStackView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor),
            containerStackView.safeBottomAnchor.constraint(equalTo: containerView.safeBottomAnchor),
            ])
        

    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        /// Custom cell subview actual size zero in layoutSubviews(), so override layoutIfNeeded
//        if shadowLayer == nil {
//            let cornerRadius: CGFloat = 15.0
//
//            shadowLayer = CAShapeLayer()
//
//            shadowLayer.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
//            shadowLayer.fillColor = UIColor.white.cgColor
//
//            shadowLayer.shadowColor = UIColor.lightGray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//            shadowLayer.shadowOpacity = 0.8
//            shadowLayer.shadowRadius = 7
//
//            containerView.layer.insertSublayer(shadowLayer, at: 0)
//        }
    }
    
    func configure(item: FeedViewModelItem, indexPath: IndexPath) {
        guard let item = item as? FeedViewModelPostItem else { return }
        self.item = item
        self.indexPath = indexPath
        
        // MARK: Post value converter
        if let post = item.post {
//            self.mediaView.post = post
            self.mediaView.item = item
            if let attachments = post.attachments {
                self.mediaView.isHidden = attachments.count > 0 ? false : true
            } else {
                self.mediaView.isHidden = true
            }
            
            print("\(indexPath) MediaView hide: \(self.mediaView.isHidden)")
            
            if let message = post.message {
                statusTextView.isHidden = message.isEmpty
                statusTextViewReadMore(expanded: item.expanded, text: message)
            } else {
                statusTextView.isHidden = true
            }
            print("statusTextView.isHidden: \(statusTextView.isHidden)")
            
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
                    self.username.text = "@\(username)"
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
    
    @objc func likePost() {
        
        guard let item = item as? FeedViewModelPostItem else {
            return
        }
        
        guard let post = item.post else { return }
        
        guard let isLiked = post.isLiked else { return }
        guard var likeCount = post.likeCount else { return }
        
        if isLiked {
            post.isLiked = !isLiked
            likeCount -= 1
            post.likeCount = likeCount
            self.likeButton.setImage(UIImage(named: "icon-like"), for: .normal)
            REAWSManager.shared.unlike(post: post, commentid: nil) { (result) in
                // result true
            }
        } else {
            post.isLiked = !isLiked
            likeCount += 1
            post.likeCount = likeCount
            self.likeButton.setImage(UIImage(named: "icon-like-filled"), for: .normal)
            
            REAWSManager.shared.like(post: post, commentid: nil) { (result) in
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
        commentViewController.dataSource.post = post
        LoaderController.pushViewController(controller: commentViewController)
    }
    
    @objc func viewLikeUsers(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let item = self.item as? FeedViewModelPostItem else { return }
        guard let post = item.post else { return }
        guard let likeCount = post.likeCount else { return }
        
        if likeCount == 0 {
            return
        }
        
        let likeViewController = LikeViewController()
        likeViewController.configure(post: post)
        LoaderController.pushViewController(controller: likeViewController)
    }
    
    @objc func showLocation(_ sender: UIButton) {
        guard let item = self.item as? FeedViewModelPostItem else { return }
        guard let post = item.post else { return }
        guard let location = post.location else { return }
        
        
        let feedMapView = FeedMapView()
        feedMapView.location = location.convertToCLLocation()
        feedMapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(feedMapView)
        
        NSLayoutConstraint.activate([
            feedMapView.safeCenterXAnchor.constraint(equalTo: safeCenterXAnchor),
            feedMapView.safeCenterYAnchor.constraint(equalTo: safeCenterYAnchor),
            feedMapView.widthAnchor.constraint(equalToConstant: 300),
            feedMapView.heightAnchor.constraint(equalToConstant: 400),
            ])
        
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

