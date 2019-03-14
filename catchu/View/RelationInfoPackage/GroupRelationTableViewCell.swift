//
//  GroupRelationTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupRelationTableViewCell: CommonTableCell, CommonDesignableCell {
    
    var groupViewModel: CommonGroupViewModel?
    private var cellAnimation : Bool = false
    private var friendRelationPurpose : FriendRelationViewPurpose?
    
    lazy var groupProfileImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Width.width_50))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
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
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var moreIcon: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_30, height: Constants.StaticViewSize.ViewSize.Width.width_30))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon-more-vertical")
        return imageView
    }()
    
    lazy var stackViewForGroupInfo: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [groupName])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let groupName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "catchuname"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func initializeCellSettings() {
        print("\(#function) starts")
        
        self.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_80, bottom: 0, right: 0)
        
        addViews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetCellSettings()
        
    }
    
    deinit {
        groupViewModel?.groupNameChanged.unbind()
        groupViewModel?.groupImageChanged.unbind()
        groupViewModel?.groupSelected.unbind()
    }
}

// MARK: - major functions
extension GroupRelationTableViewCell {
    
    private func addViews() {
        
        self.contentView.addSubview(groupProfileImageView)
        self.contentView.addSubview(stackViewForGroupInfo)
        self.contentView.addSubview(selectIcon)
        //self.contentView.addSubview(moreIcon)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeProfileImage = self.groupProfileImageView.safeAreaLayoutGuide
        let safeSelectedIcon = self.selectIcon.safeAreaLayoutGuide
        //let safeMoreIcon = self.moreIcon.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupProfileImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            groupProfileImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            groupProfileImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupProfileImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            groupProfileImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            stackViewForGroupInfo.leadingAnchor.constraint(equalTo: safeProfileImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewForGroupInfo.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            stackViewForGroupInfo.trailingAnchor.constraint(equalTo: safeSelectedIcon.leadingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            selectIcon.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            selectIcon.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            selectIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            selectIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            ])
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
        case .alreadyGroupParticipant:
            return
        }
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {

        guard let model = item as? CommonGroupViewModel else { return }
        
        self.groupViewModel = model
        
        guard let group = self.groupViewModel?.group else { return }
        
        if let name = group.groupName {
            self.groupName.text = name
            self.groupProfileImageView.setImageInitialPlaceholder(name, circular: true)
        }
        
        if let url = group.groupPictureUrl {
            if let urlToBeCheckedValid = URL(string: url) {
                if UIApplication.shared.canOpenURL(urlToBeCheckedValid) {
                    self.groupProfileImageView.setImagesFromCacheOrDownloadWithTypes(url, type: ImageSizeTypes.thumbnails)
                }
            }
        }
        
        if let friendRelationPurpose = friendRelationPurpose {
            switch friendRelationPurpose {
            case .groupManagement:
                self.selectIcon.isHidden = true
                self.accessoryType = .detailButton
            default:
                break
            }
        }
        
        self.groupViewModel?.groupSelected.bindAndFire({ [unowned self] (selectedInfo) in
            self.cellSelectionAnimation(state: selectedInfo, animated: self.cellAnimation)
        })
        
        self.groupViewModel?.groupNameChanged.bind({ (newString) in
            print("sikibok")
            DispatchQueue.main.async {
                self.groupName.text = newString
            }
        })
        
        self.groupViewModel?.groupImageChanged.bind({ (newImage) in
            print("mokomoko")
            DispatchQueue.main.async {
                self.groupProfileImageView.image = newImage
            }
        })
        
        groupViewModel?.displayProperties()
        
    }
    
    func setGroupSelectionState(state: TableViewRowSelected) {
        self.cellAnimation = true
        
        print("gropViewModel : \(String(describing: groupViewModel))")
        groupViewModel?.displayProperties()
        
        if groupViewModel?.groupSelected.value == .selected {
            groupViewModel?.groupSelected.value = .deSelected
        } else {
            groupViewModel?.groupSelected.value = state
        }
        
        groupViewModel?.displayProperties()
        
    }
    
    func resetCellSettings() {
        groupViewModel?.groupSelected.unbind()
        groupProfileImageView.image = nil
        groupName.text = ""
        selectIcon.image = nil
        cellAnimation = false

    }
    
    func returnCellRelatedGroup() -> Group? {
        if let group = self.groupViewModel?.group {
            return group
        }
        
        return nil
    }
    
    func returnCellGroupViewModel() -> CommonGroupViewModel {
        return self.groupViewModel!
    }
    
    func setFriendRelationPurpose(friendRelationPurpose: FriendRelationViewPurpose) {
        self.friendRelationPurpose = friendRelationPurpose
    }
    
}
