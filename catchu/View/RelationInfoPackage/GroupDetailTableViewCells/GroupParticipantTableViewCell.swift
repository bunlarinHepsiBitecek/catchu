//
//  GroupParticipantTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupParticipantTableViewCell: CommonTableCell, CommonDesignableCell {
    
    var groupParticipantViewModel: GroupParticipantViewModel?
    
    lazy var participantImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Width.width_50))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackViewForParticipantInfo: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [name, username])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var adminSticker: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.lightGray
        label.text = Constants.CharacterConstants.EMPTY
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    override func initializeCellSettings() {
        
        self.accessoryType = .detailButton
        self.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_85, bottom: 0, right: 0)
        
        addViews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellSettings()
    }
    
}

// MARK: - major functions
extension GroupParticipantTableViewCell {
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        print("\(#function)")
        
        if let model = item as? GroupParticipantViewModel {
            self.groupParticipantViewModel = model
            
            guard let groupParticipantViewModel = self.groupParticipantViewModel else { return }
            
            if let user = groupParticipantViewModel.user {
                
                if let name = user.name {
                    self.name.text = name
                    self.participantImageView.setImageInitialPlaceholder(name, circular: true)
                }
                
                if let userName = user.username {
                    self.username.text = userName
                }
                
                if let url = user.profilePictureUrl {
                    self.participantImageView.setImagesFromCacheOrFirebaseForFriend(url)
                }
                
                if let group = groupParticipantViewModel.group {
                    if group.adminUserID == user.userid {
                        adminSticker.text = LocalizedConstants.TitleValues.LabelTitle.admin
                    }
                }

            }

        }
        
    }
    
    private func resetCellSettings() {
        participantImageView.image = nil
        name.text = ""
        username.text = ""
        adminSticker.text = ""
    }
    
    private func addViews() {
        
        self.contentView.addSubview(participantImageView)
        self.contentView.addSubview(stackViewForParticipantInfo)
        self.contentView.addSubview(adminSticker)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeParticipantImage = self.participantImageView.safeAreaLayoutGuide
        let safeStackViewForParticipantInfo = self.stackViewForParticipantInfo.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            participantImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            participantImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            participantImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            participantImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            participantImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            stackViewForParticipantInfo.leadingAnchor.constraint(equalTo: safeParticipantImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewForParticipantInfo.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            adminSticker.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            adminSticker.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            
            ])
        
    }
    
}
