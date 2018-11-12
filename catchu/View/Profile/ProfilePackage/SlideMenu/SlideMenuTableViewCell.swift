//
//  SlideMenuTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 11/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SlideMenuTableViewCell: BaseTableCell {

    var slideMenuType : SlideMenuViewTags?
    
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
    
    override func setupViews() {
        
        self.addSubview(slideMenuImageView)
        self.addSubview(slideMenuLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeImage = self.slideMenuImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            slideMenuImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            slideMenuImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            slideMenuImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            slideMenuImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            slideMenuLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            slideMenuLabel.leadingAnchor.constraint(equalTo: safeImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            slideMenuLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            slideMenuImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            ])
        
    }
    
    func setProperties(image : UIImage, slideMenuType: SlideMenuViewTags, cellMenuString : String) {
        
        self.slideMenuLabel.text = cellMenuString
        self.slideMenuImageView.image = image
        self.slideMenuType = slideMenuType
        
    }
    
}
