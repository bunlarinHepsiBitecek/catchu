//
//  ManageGroupsSlideMenuTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ManageGroupsSlideMenuTableViewCell: CommonSlideMenuTableCell, CommonDesignableCellForSlideMenu {
    
    var manageGroupsSlideMenuTableCellViewModel: ManageGroupsSlideMenuTableCellViewModel?
    
    override func initializeCellSettings() {
        addViews()
        
        self.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_44, bottom: 0, right: 0)
    }
    
}

// MARK: - major functions
extension ManageGroupsSlideMenuTableViewCell {
    
    private func addViews() {
        self.contentView.addSubview(slideMenuImageView)
        self.contentView.addSubview(slideMenuLabel)
        self.contentView.addSubview(slideMenuBadgeContainer)
        self.slideMenuBadgeContainer.addSubview(badgeLabel)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeImage = self.slideMenuImageView.safeAreaLayoutGuide
        let safeSlideMenuBadgeContainer = self.slideMenuBadgeContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            slideMenuImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            slideMenuImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            slideMenuImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            slideMenuImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            slideMenuLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            slideMenuLabel.leadingAnchor.constraint(equalTo: safeImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            slideMenuLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            slideMenuLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            slideMenuBadgeContainer.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            slideMenuBadgeContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            slideMenuBadgeContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            slideMenuBadgeContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            badgeLabel.centerXAnchor.constraint(equalTo: safeSlideMenuBadgeContainer.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: safeSlideMenuBadgeContainer.centerYAnchor),
            badgeLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            badgeLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            ])
        
        self.badgeLabelAlphaManager(active: false)
    }
    
    private func badgeLabelAlphaManager(active : Bool) {
        if active {
            self.slideMenuBadgeContainer.alpha = 1
        } else {
            self.slideMenuBadgeContainer.alpha = 0
        }
    }
    
    func badgeActivationManager(active: Bool, animated: Bool) {
        if animated {
            UIView.transition(with: self.badgeLabel, duration: Constants.AnimationValues.aminationTime_03, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.badgeLabelAlphaManager(active: active)
            })
        } else {
            self.badgeLabelAlphaManager(active: active)
        }
    }
    
    func initiateCellDesign(item: CommonSlideMenuTableCellViewModelItem?) {
        
        guard let model = item as? ManageGroupsSlideMenuTableCellViewModel else { return }
        
        self.manageGroupsSlideMenuTableCellViewModel = model
        
        guard let manageGroupsSlideMenuTableCellViewModel = manageGroupsSlideMenuTableCellViewModel else { return }
        
        slideMenuImageView.image = manageGroupsSlideMenuTableCellViewModel.cellImage
        slideMenuLabel.text = manageGroupsSlideMenuTableCellViewModel.cellTitle
        
    }
    
}
