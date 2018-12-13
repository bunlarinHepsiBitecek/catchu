//
//  FriendRelationSelectionCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationSelectionCollectionViewCell: BaseCollectionCell {
    
    var userViewModel: CommonUserViewModel?
    
    lazy var profilePictureView: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_60, height: Constants.StaticViewSize.ViewSize.Width.width_60))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
        //temp.layer.borderWidth = 1
        //temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.clipsToBounds = true
        return temp
    }()
    
    lazy var iconContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
        
    }()
    
    lazy var iconImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cancel_gray.png")
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        
        return temp
    }()
    
    lazy var friendName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.contentMode = .center
        label.text = "catchuname"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func setupViews() {
        
        self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        addSubviews()
    }
    
}

// MARK: - major functions
extension FriendRelationSelectionCollectionViewCell: CommonDesignableCell {
    
    func addSubviews() {
        
        self.contentView.addSubview(profilePictureView)
        self.contentView.addSubview(iconContainer)
        self.iconContainer.addSubview(iconImageView)
        self.contentView.addSubview(friendName)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeIconContainer = self.iconContainer.safeAreaLayoutGuide
        let safeProfileImage = self.profilePictureView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            profilePictureView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            //profilePictureView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            profilePictureView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            profilePictureView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            profilePictureView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            
            iconContainer.trailingAnchor.constraint(equalTo: safeProfileImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            iconContainer.topAnchor.constraint(equalTo: safeProfileImage.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            iconContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            iconContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            iconImageView.centerXAnchor.constraint(equalTo: safeIconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: safeIconContainer.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            friendName.topAnchor.constraint(equalTo: safeProfileImage.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            friendName.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendName.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendName.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_15),
            
            ])
        
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        
        guard let userViewModel = item as? CommonUserViewModel else { return }
        
        self.userViewModel = userViewModel
        
        guard let user = userViewModel.user else { return }
        
        if let userName = user.username {
            self.friendName.text = userName
        }
        
        if let name = user.name {
            self.profilePictureView.setImageInitialPlaceholder(name, circular: true)
        } else {
            self.profilePictureView.image = UIImage(named: "user.png")
        }
        
        if let url = user.profilePictureUrl {
            self.profilePictureView.setImagesFromCacheOrFirebaseForFriend(url)
        }
        
    }
    
}
