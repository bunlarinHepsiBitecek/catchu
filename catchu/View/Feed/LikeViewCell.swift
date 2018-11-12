//
//  LikeViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LikeViewCell: BaseTableCell {
    
    var item: LikeViewModelItem?
    
    private let padding = Constants.Feed.Padding
    private let dimension = Constants.Feed.ImageWidthHeight
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
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
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
//        if let titleLabel = button.titleLabel {
//            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        }
        
        button.setTitle(LocalizedConstants.Like.Loading, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(followProcess(_:)), for: .touchUpInside)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let layoutMargin = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let nameStackView = UIStackView(arrangedSubviews: [name, username])
        nameStackView.axis = .vertical
        
        let contentStackView = UIStackView(arrangedSubviews: [nameStackView, followButton])
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = padding
        
        let cellStackView = UIStackView(arrangedSubviews: [profileImageView, contentStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .center
        cellStackView.distribution = .fillProportionally
        cellStackView.spacing = padding
        cellStackView.layoutMargins = layoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        self.containerView.addSubview(cellStackView)
        
        self.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            containerView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            containerView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            
            cellStackView.safeTopAnchor.constraint(equalTo: containerView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: containerView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: containerView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: containerView.safeTrailingAnchor),
            ])
    }
    
    func configure(item: LikeViewModelItem) {
        self.item = item
        guard let item = item as? LikeViewModelLikeItem else { return }
        guard let user = item.user else { return }
        
        if let name = user.name {
            self.name.text = name
            self.profileImageView.setImageInitialPlaceholder(name, circular: true)
        }
        if let username = user.username {
            self.username.text = username
        }
        if let followStatus = user.followStatus {
            followStatus.configure(followButton)
        }
        if let profilePictureUrl = user.profilePictureUrl {
            self.profileImageView.loadAndCacheImage(url: profilePictureUrl)
        }
    }

    
//    @objc func followProcess(_ sender: UIButton) {
//
//    }
    
    @objc func followProcess(_ sender: UIButton) {
        guard let item = item as? LikeViewModelLikeItem else { return }
        guard let user = item.user else { return }
        let requestType = findRequestType(targetUser: user)
        if requestType == .defaultRequest {
            return
        }

        // MARK: when user account is private and ask for unfollow request
        if let isPrivateAccount = user.isUserHasAPrivateAccount {
            if isPrivateAccount && requestType == .deleteFollow {
                unfollowAlertControll(image: profileImageView.image, message: username.text)
                return
            }
        }
        sendRequestProcess()
    }
    
    private func sendRequestProcess() {
        guard let item = item as? LikeViewModelLikeItem else { return }
        guard let user = item.user else { return }
        guard let targetUserid = user.userid else { return }
        let requestType = findRequestType(targetUser: user)
        if requestType == .defaultRequest {
            return
        }
        
        guard let userid = User.shared.userid else { return }
        
        REAWSManager.shared.requestRelationProcess(requestType: requestType, userid: userid, targetUserid: targetUserid) { [weak self] resut in
            self?.handleResult(resut)
        }
    }
    
    func unfollowAlertControll(image: UIImage? = nil, message: String? = nil) {
        
        let actionTitle = image == nil ? nil : "\n\n"
        
        let actionSheetController = UIAlertController(title: actionTitle, message: message, preferredStyle: .actionSheet)
        
        if image != nil {
            let padding: CGFloat = 10
            let imageView = UIImageView(image: image)
            
            let stackView = UIStackView(arrangedSubviews: [imageView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = padding / 2
            
            actionSheetController.view.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.safeTopAnchor.constraint(equalTo: actionSheetController.view.safeTopAnchor, constant: padding),
                stackView.safeCenterXAnchor.constraint(equalTo: actionSheetController.view.safeCenterXAnchor),
                stackView.safeLeadingAnchor.constraint(equalTo: actionSheetController.view.safeLeadingAnchor),
                stackView.safeTrailingAnchor.constraint(equalTo: actionSheetController.view.safeTrailingAnchor)
                ])
        }
        
        let unfollowAction = UIAlertAction(title: LocalizedConstants.Like.Unfollow, style: .destructive) { (action) in
            self.sendRequestProcess()
        }
        let cancelAction = UIAlertAction(title: LocalizedConstants.Cancel, style: .cancel, handler: nil)
        actionSheetController.addAction(unfollowAction)
        actionSheetController.addAction(cancelAction)
        
        guard let currentController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        currentController.present(actionSheetController, animated: true, completion: nil)
    }
}

extension LikeViewCell {
    
    private func findRequestType(targetUser: User) -> RequestType {
        guard let followStatus = targetUser.followStatus else { return .defaultRequest}
        let isPrivateAccount = targetUser.isUserHasAPrivateAccount ?? false
        
        switch followStatus {
        case .none:
            return isPrivateAccount ? .followRequest : .createFollowDirectly
        case .following:
            return .deleteFollow
        case .pending:
            return .deletePendingFollowRequest
        default:
            return .defaultRequest
        }
    }
    
    private func handleResult(_ result: NetworkResult<REFriendRequestList>) {
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
