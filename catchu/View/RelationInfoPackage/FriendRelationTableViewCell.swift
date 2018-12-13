//
//  FriendRelationTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationTableViewCell: CommonTableCell, CommonDesignableCell {

    var userViewModel: CommonUserViewModel?
    var cellAnimation : Bool = false
    
    lazy var profileImageView: UIImageView = {
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
    
    lazy var selectIcon: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_20, height: Constants.StaticViewSize.ViewSize.Width.width_20))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackViewForUserInfo: UIStackView = {
        
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
    
    override func initializeCellSettings() {
        print("\(#function) starts")
        
        self.addViews()
        
    }
    
    override func prepareForReuse() {
        print("\(#function) starts")
        super.prepareForReuse()
        self.resetCellProperties()
    }
    
}

// MARK: - major functions
extension FriendRelationTableViewCell {
    
    private func addViews() {
        
        print("\(#function) starts")
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(stackViewForUserInfo)
        self.contentView.addSubview(selectIcon)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeProfileImage = self.profileImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            profileImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            profileImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            stackViewForUserInfo.leadingAnchor.constraint(equalTo: safeProfileImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewForUserInfo.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            selectIcon.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            selectIcon.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            selectIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            selectIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            ])
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        //print("\(#function) starts")
        
        if let userViewModel = item as? CommonUserViewModel {
            self.userViewModel = userViewModel
            
            guard let user = userViewModel.user else { return }
            
            //userViewModel.displayProperties()
            
            self.profileImageView.alpha = 1
            self.username.alpha = 1
            self.name.alpha = 1
            self.selectIcon.alpha = 1
            
            if let name = user.name {
                self.name.text = name
                self.profileImageView.setImageInitialPlaceholder(name, circular: true)
            }
            
            if let userName = user.username {
                self.username.text = userName
            }
            
            if let url = user.profilePictureUrl {
                self.profileImageView.setImagesFromCacheOrFirebaseForFriend(url)
            }
            
            userViewModel.userSelected.bindAndFire { [unowned self] in
                self.cellSelectionAnimation(state: $0, animated: self.cellAnimation)
            }
        
        } else {
          
            self.profileImageView.alpha = 0
            self.username.alpha = 0
            self.name.alpha = 0
            self.selectIcon.alpha = 0
            
        }
        //guard let userViewModel = item as? CommonUserViewModel else { return }

    }

    private func resetCellProperties() {
        userViewModel?.userSelected.unbind()
        //print("viewmodel user state :\(userViewModel!.userSelected.value.rawValue) ")
        profileImageView.image = nil
        selectIcon.image = nil
        cellAnimation = false
    }
    
    private func cellSelectionAnimation(state : TableViewRowSelected, animated: Bool) {
        if animated {
            UIView.transition(with: self.selectIcon, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.setIconImage(state: state)
            })
        } else {
            self.setIconImage(state: state)
        }
        
    }
    
    private func setIconImage(state: TableViewRowSelected) {
        switch state {
        case .selected:
            self.selectIcon.image = #imageLiteral(resourceName: "icon_checked_lightBlue")
            self.selectIcon.layer.borderWidth = 0
        case .deSelected:
            self.selectIcon.image = nil
            self.selectIcon.layer.borderWidth = 1
        }
    }
    
    func setUserSelectionState(state: TableViewRowSelected) {
        self.cellAnimation = true
        
        if userViewModel?.userSelected.value == .selected {
            userViewModel?.userSelected.value = .deSelected
        } else {
            userViewModel?.userSelected.value = state
        }
        
    }
    
}
