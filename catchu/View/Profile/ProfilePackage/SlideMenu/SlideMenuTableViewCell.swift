//
//  SlideMenuTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 11/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SlideMenuTableViewCell: BaseTableCell {
    
    lazy var slideMenuLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    lazy var slideMenuImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
//        temp.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return temp
    }()
    
    lazy var slideMenuBadgeContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
    }()
    
    lazy var badgeLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return temp
    }()
    
    override func setupViews() {
        
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
    
    func setProperties(image : UIImage, slideMenuType: SlideMenuViewTags, cellMenuString : String) {
        
        self.slideMenuLabel.text = cellMenuString
        self.slideMenuImageView.image = image
        
    }
    
}

// MARK: - major functions
extension SlideMenuTableViewCell {
    
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
    
}
