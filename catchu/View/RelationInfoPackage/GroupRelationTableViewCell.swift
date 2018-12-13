//
//  GroupRelationTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupRelationTableViewCell: CommonTableCell, CommonDesignableCell {
    
    private var groupViewModel: CommonGroupViewModel?
    private var cellAnimation : Bool = false
    
    lazy var groupProfileImageView: UIImageView = {
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
    
    lazy var moreIcon: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_30, height: Constants.StaticViewSize.ViewSize.Width.width_30))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
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
    
    /*
     let username: UILabel = {
     let label = UILabel()
     label.font = UIFont.systemFont(ofSize: 14, weight: .light)
     label.textColor = UIColor.lightGray
     label.text = "catchuuser"
     label.numberOfLines = 1
     label.translatesAutoresizingMaskIntoConstraints = false
     
     return label
     }()*/
    
    override func initializeCellSettings() {
        print("\(#function) starts")
        
        addViews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetCellSettings()
        
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
            
            /*
            moreIcon.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            moreIcon.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            moreIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            moreIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            */
            
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
        }
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        print("initiateCellDesign")
        
        guard let model = item as? CommonGroupViewModel else { return }
        
        self.groupViewModel = model
        
        guard let group = self.groupViewModel?.group else { return }
        
        if let name = group.groupName {
            self.groupName.text = name
            self.groupProfileImageView.setImageInitialPlaceholder(name, circular: true)
        }
        
        if let url = group.groupPictureUrl {
            self.groupProfileImageView.setImagesFromCacheOrFirebaseForGroup(url)
        }
        
        self.groupViewModel?.groupSelected.bindAndFire({ [unowned self] (selectedInfo) in
            self.cellSelectionAnimation(state: selectedInfo, animated: self.cellAnimation)
        })
        
        groupViewModel?.displayProperties()
        
    }
    
    func setGroupSelectionState(state: TableViewRowSelected) {
        self.cellAnimation = true
        
        print("gropViewModel : \(groupViewModel)")
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
    
}
