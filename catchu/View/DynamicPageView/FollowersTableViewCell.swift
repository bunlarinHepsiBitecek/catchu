//
//  FollowersTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowersTableViewCell: CommonFollowTableViewCell, CommonDesignableCell {
    
    private var followersTableCellViewModel : FollowersTableCellViewModel!

    override func initializeCellSettings() {
        addViews()
        configureCellSettings()
    }
    
    override func deleteButtonTapped(_ sender: UIButton) {
        print("\(#function)")
        if let user = followersTableCellViewModel.returnUser() {
            AlertControllerManager.shared.startActionSheetManager(type: .removeFollower, operationType: nil, delegate: self, title: "KOKO", user: user)
        }
    }
    
    override func confirmButtonTapped(_ sender: UIButton) {
        print("\(#function)")
        followersTableCellViewModel.followButtonProcess()
        followButtonStatusUpdate()
    }
    
    override func configureCellSettings() {
        self.selectionStyle = .none
    }
    
    override func followButtonStatusUpdate() {
        print("\(#function)")
        guard let user = followersTableCellViewModel.returnUser() else { return }
        if let followStatus = user.followStatus {
            print("username : \(user.username)")
            print("user followStatus : \(followStatus)")
            Formatter.configure(followStatus, followButton)
        }
    }

}

// MARK: - major functions
extension FollowersTableViewCell {
    
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
    
    private func removeFollower() {
        print("\(#function)")
        followersTableCellViewModel.removeFromFollowers()
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {

        if let userViewModel = item as? CommonUserViewModel {
            
            followersTableCellViewModel = FollowersTableCellViewModel(commonUserViewModel: userViewModel)
            
            self.userImageView.alpha = 1
            self.username.alpha = 1
            self.name.alpha = 1
            self.moreButton.alpha = 1
            self.followButton.alpha = 1
            
            guard let commonUserViewModel = followersTableCellViewModel.commonUserViewModel else { return }
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
            
        } else {
            self.userImageView.alpha = 0
            self.username.alpha = 0
            self.name.alpha = 0
            self.moreButton.alpha = 0
            self.followButton.alpha = 0
        }
        
//        followersTableCellViewModel.followOperation.bind { (operationData) in
//            self.triggerFollowRequestOperations(operationData: operationData)
//        }
        
    }
    
    func listenButtonOperations(completion: @escaping (_ buttonProcessData: FollowRequestOperationData) -> Void) {
        followersTableCellViewModel.buttonProcessData.bind { (buttonProcessData) in
            completion(buttonProcessData)
        }

    }
    
    func returnCellUserid() -> String {
        return followersTableCellViewModel.returnFollowersUserid()!
    }
    
}

// MARK: - ActionSheetProtocols
extension FollowersTableViewCell: ActionSheetProtocols {
    
    func returnOperations(selectedProcessType: ActionButtonOperation) {
        switch selectedProcessType {
        case .removeFollower:
            self.removeFollower()
        default:
            return
        }
    }
    
}
