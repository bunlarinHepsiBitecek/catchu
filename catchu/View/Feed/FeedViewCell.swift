//
//  FeedViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let likePostAction = #selector(FeedViewCell.likePost)
    static let doubleClickLikePostAction = #selector(FeedViewCell.doubleClickLikePost)
    static let showLocationAction = #selector(FeedViewCell.showLocation(_:))
    static let viewCommentsAction = #selector(FeedViewCell.viewComments(_:))
    static let viewLikeUsersAction = #selector(FeedViewCell.viewLikeUsers(_:))
    static let showMoreAction = #selector(FeedViewCell.showMoreActionSheet)
}

class FeedViewCell: BaseTableCell {
    
    var viewModel: FeedViewModelItemPost!
    var indexPath: IndexPath!
    var readMore: Dynamic<IndexPath>?
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: .doubleClickLikePostAction)
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
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
    
    lazy var statusTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.textContainer.lineFragmentPadding = 0 // textContainer always 5.0 left pedding
        textView.delegate = self
        return textView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon-like"), for: UIControlState())
        button.addTarget(self, action: .likePostAction, for: .touchUpInside)
        
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.text = "0"
        return label
        
    }()
    
    lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon-like")
        imageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: .viewLikeUsersAction)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var commentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-comment")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: .viewCommentsAction)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon-more"), for: UIControlState())

        button.addTarget(self, action: .showMoreAction, for: .touchUpInside)
        return button
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
    
    lazy var showOnMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-location"), for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: .showLocationAction, for: .touchUpInside)
        
        return button
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        selectionStyle = .none
        
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
        
        let locationStackView = UIStackView(arrangedSubviews: [distanceLabel, showOnMapButton])
        locationStackView.alignment = .fill
        locationStackView.distribution = .equalSpacing
        locationStackView.spacing = padding
        
        let timeDistanceStackView = UIStackView(arrangedSubviews: [timeAgoLabel, locationStackView])
        timeDistanceStackView.alignment = .fill
        timeDistanceStackView.distribution = .equalCentering
        
        let likeCommentStackView = UIStackView(arrangedSubviews: [likeIcon, likeCountLabel, commentIcon, commentCountLabel, spacer, moreButton])
        likeCommentStackView.alignment = .fill
        likeCommentStackView.distribution = .fill
        likeCommentStackView.spacing = padding/2
        likeCommentStackView.setCustomSpacing(2*padding, after: likeCountLabel)
        
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
            containerView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: padding/2),
            containerView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor, constant: -padding/2),
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        name.text = nil
        username.text = nil
        
        mediaView.isHidden = true
        statusTextView.isHidden = true
        commentIcon.isHidden = false
        commentCountLabel.isHidden = false
        showOnMapButton.isHidden = false
        
        likeCountLabel.text = nil
        
        commentCountLabel.text = nil
        timeAgoLabel.text = nil
        distanceLabel.text = nil
        
        likeButton.setImage(UIImage(named: "icon-like"), for: .normal)
    }
    
    func configure(viewModel: FeedViewModelItem, indexPath: IndexPath) {
        guard let viewModel = viewModel as? FeedViewModelItemPost else { return }
        self.viewModel = viewModel
        self.indexPath = indexPath
        
        // MARK: Post value converter
        if let post = viewModel.post {
            self.mediaView.item = viewModel
            if let attachments = post.attachments {
                self.mediaView.isHidden = attachments.count > 0 ? false : true
            }
            
            if let message = post.message {
                statusTextView.isHidden = message.isEmpty
                statusTextViewReadMore(expanded: viewModel.expanded, text: message)
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
            if let isCommentAllowed = post.isCommentAllowed {
                commentIcon.isHidden = !isCommentAllowed
                commentCountLabel.isHidden = !isCommentAllowed
            }
            if let isShowOnMap = post.isShowOnMap {
                showOnMapButton.isHidden = !isShowOnMap
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
        
        bindViewModel()
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
    
    func bindViewModel() {
        viewModel.isPostLiked.bind { [unowned self] in
            // update like icon and like count
            if $0 {
                self.likeButton.setImage(UIImage(named: "icon-like-filled"), for: .normal)
                self.animateLikeButton()
            } else {
                self.likeButton.setImage(UIImage(named: "icon-like"), for: .normal)
            }
            
            guard let viewModel = self.viewModel, let post = viewModel.post, let likeCount = post.likeCount else { return }
            self.likeCountLabel.text = "\(likeCount)"
        }
    }
    
    private func animateLikeButton() {
        self.likeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: 6,    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.likeButton.transform = CGAffineTransform.identity
        },
            completion: { Void in()  }
        )
    }
    
    @objc func likePost() {
        guard let viewModel = viewModel else { return }
        viewModel.likeUnlikePost()
    }
    
    @objc func viewComments(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard let viewModel = self.viewModel else { return }
        guard let post = viewModel.post else { return }
        
        let commentViewController = CommentViewController()
        commentViewController.dataSource.post = post
        LoaderController.pushViewController(controller: commentViewController)
    }
    
    @objc func viewLikeUsers(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard let viewModel = self.viewModel else { return }
        guard let post = viewModel.post else { return }
        guard let likeCount = post.likeCount else { return }
        
        if likeCount == 0 {
            return
        }
        
        
        let likeViewModel = LikeViewModel()
        likeViewModel.post = post
        
        let likeViewController = LikeViewController()
        likeViewController.configure(viewModel: likeViewModel)
        LoaderController.pushViewController(controller: likeViewController)
    }
    
    @objc func showLocation(_ sender: UIButton) {
        guard let viewModel = self.viewModel else { return }
        guard let post = viewModel.post else { return }
        guard let location = post.location else { return }
        
        
        let feedMapView = FeedMapView()
        feedMapView.location = location.convertToCLLocation()
        feedMapView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let currentVC = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        currentVC.view.addSubview(feedMapView)
        
        NSLayoutConstraint.activate([
            feedMapView.safeCenterXAnchor.constraint(equalTo: currentVC.view.safeCenterXAnchor),
            feedMapView.safeCenterYAnchor.constraint(equalTo: currentVC.view.safeCenterYAnchor),
            feedMapView.widthAnchor.constraint(equalToConstant: 250),
            feedMapView.heightAnchor.constraint(equalToConstant: 300),
            ])
    }
    
    @objc func showMoreActionSheet() {
        guard let post = viewModel.post else { return }
        guard let isCommentAllowed = post.isCommentAllowed else { return }
        
        /// Find current view controller to present action sheet
        guard let currentController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if post.isOwnPost() {
            /// Turn Off Comment of own post
            let title = isCommentAllowed ? LocalizedConstants.Feed.TurnOffComments : LocalizedConstants.Feed.TurnOnComments
            actionSheetController.addAction(
                UIAlertAction(title: title, style: .default) { (_) in
                    print("Turn Off Comments selected")
//                    self.item.turnOffComments()
            })
            
            /// Delete own post
            actionSheetController.addAction(
                UIAlertAction(title: LocalizedConstants.Feed.Delete, style: .destructive) { (_) in
                    print("Delete selected")
//                    self.item.deletePost()
            })
        } else {
            /// Report the other post
            actionSheetController.addAction(
                UIAlertAction(title: LocalizedConstants.Feed.Report, style: .destructive) { (_) in
                    print("Report selected")
                    
                    let reportActionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                    reportActionSheetController.addAction(UIAlertAction(title: LocalizedConstants.Feed.ItSpam, style: .destructive) { (_) in
                        print("ItSpam selected")
//                        self.item.reportPost(.spam)
                    })
                    
                    reportActionSheetController.addAction(UIAlertAction(title: LocalizedConstants.Feed.ItInappropriate, style: .destructive) { (_) in
                        print("ItInappropriate selected")
//                        self.item.reportPost(.inappropiate)
                    })
                    
                    /// Report Cancel
                    reportActionSheetController.addAction(
                        UIAlertAction(title: LocalizedConstants.Cancel, style: .cancel) { (_) in
                    })
                    
                    currentController.present(reportActionSheetController, animated: true, completion: nil)
                    
            })
        }
        
        /// Cancel
        actionSheetController.addAction(
            UIAlertAction(title: LocalizedConstants.Cancel, style: .cancel) { (_) in
            print("Cancel selected")
        })
        
        currentController.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        print("handleTap double clicked")
    }
    
    @objc func doubleClickLikePost() {
        guard let viewModel = viewModel else { return }
        viewModel.like()
    }
    
}

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
            if readMore == nil {
                readMore = Dynamic(indexPath)
            } else {
                readMore?.value = indexPath
            }
        default:
            print("just a regular url click")
        }

        return true
    }
}

