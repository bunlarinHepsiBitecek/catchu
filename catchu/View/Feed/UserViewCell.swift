//
//  UserViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserViewCell: BaseTableCell, ConfigurableCell {
    
    var viewModelItem: ViewModelUser!
    
    private let padding = Constants.Feed.Padding
    private let dimension = Constants.Feed.ImageWidthHeight
    
    lazy var profileImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true

        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "catchuname"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.lightGray
        label.text = "catchuuser"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedConstants.Like.Loading, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(followProcess(_:)), for: .touchUpInside)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let layoutMargin = UIEdgeInsets(top: padding/2, left: padding, bottom: padding/2, right: padding)
        
        let nameStackView = UIStackView(arrangedSubviews: [name, username])
        nameStackView.axis = .vertical
        
        let contentStackView = UIStackView(arrangedSubviews: [nameStackView, followButton])
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = padding
        
        contentStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let cellStackView = UIStackView(arrangedSubviews: [profileImageView, contentStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .center
        cellStackView.distribution = .fillProportionally
        cellStackView.spacing = padding
        cellStackView.layoutMargins = layoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        self.contentView.addSubview(cellStackView)
        
        // MARK: height and width constraint in stackview must be priority less then stack view zero height and width priority. Defauly priority equal 1000. Set to 999 cause of default priority cann't set .hight, .medium or .low
        // second solution to set height and width constraint to lessThanOrEqualToConstant which stackview can handle to view height set to zero when hide it.
        let imageHeightConstraint = profileImageView.safeHeightAnchor.constraint(equalToConstant: 50)
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        let imageWidthConstraint = profileImageView.safeWidthAnchor.constraint(equalToConstant: 50)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            profileImageView.safeHeightAnchor.constraint(equalTo: profileImageView.safeWidthAnchor, multiplier: 1), // aspect ratio
            imageHeightConstraint,
            imageWidthConstraint,
            
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        name.text = nil
        username.text = nil
        followButton.setTitle(LocalizedConstants.Like.Loading, for: .normal)
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? ViewModelUser else { return }
        guard let user = viewModelItem.user else { return }
        
        self.viewModelItem = viewModelItem

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
    
    @objc func followProcess(_ sender: UIButton) {
        guard let user = viewModelItem.user else { return }
        let requestType = viewModelItem.findRequestType()
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
        self.viewModelItem.sendRequestProcess()
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
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                
                stackView.safeTopAnchor.constraint(equalTo: actionSheetController.view.safeTopAnchor, constant: padding),
                stackView.safeCenterXAnchor.constraint(equalTo: actionSheetController.view.safeCenterXAnchor),
                stackView.safeLeadingAnchor.constraint(equalTo: actionSheetController.view.safeLeadingAnchor),
                stackView.safeTrailingAnchor.constraint(equalTo: actionSheetController.view.safeTrailingAnchor)
                ])
        }
        
        let unfollowAction = UIAlertAction(title: LocalizedConstants.Like.Unfollow, style: .destructive) { (action) in
            self.viewModelItem.sendRequestProcess()
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
