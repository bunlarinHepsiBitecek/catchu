//
//  SyncedContactTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SyncedContactTableViewCell: CommonFollowTableViewCell {

    private var syncedContactTableCellViewModel : SyncedContactTableCellViewModel!
    
    override func initializeCellSettings() {
        addViews()
        configureCellSettings()
        configureStackView()
    }
    
    override func confirmButtonTapped(_ sender: UIButton) {
        print("\(#function)")
        syncedContactTableCellViewModel.followButtonProcess()
        followButtonStatusUpdate()
    }
    
    override func configureCellSettings() {
        self.selectionStyle = .none
    }
    
    override func followButtonStatusUpdate() {
        print("\(#function)")
        guard let user = syncedContactTableCellViewModel.returnUser() else { return }
        if let followStatus = user.followStatus {
            print("user followStatus : \(followStatus)")
            Formatter.configure(followStatus, followButton)
        }
    }
}

// MARK: - major functions
extension SyncedContactTableViewCell {
    
    private func addViews() {
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(mainStackView)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeUserImageView = self.userImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            userImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            userImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            userImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1),
            
            mainStackView.leadingAnchor.constraint(equalTo: safeUserImageView.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            mainStackView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10)
            
            ])
        
    }
    
    private func configureStackView() {
        stackViewForProcessButtons.arrangedSubviews[1].isHidden = true
        stackViewForProcessButtons.arrangedSubviews[1].alpha = 0
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        
        guard let userViewModel = item as? CommonUserViewModel else { return }
        
        syncedContactTableCellViewModel = SyncedContactTableCellViewModel(commonUserViewModel: userViewModel)
        
        guard let commonUserViewModel = syncedContactTableCellViewModel.commonUserViewModel else { return }
        guard let user = commonUserViewModel.user else { return }
        
        if let userName = user.username {
            self.username.text = userName
        }
        
        if let name = user.name {
            self.name.text = name
            self.userImageView.setImageInitialPlaceholder(name, circular: true)
        } else {
            self.userImageView.image = UIImage(named: "user.png")
        }
        
        if let url = user.profilePictureUrl {
            self.userImageView.setImagesFromCacheOrFirebaseForFriend(url)
        }
        
        self.followButtonStatusUpdate()
            
    }
    
}
