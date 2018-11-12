//
//  FacebookContactTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FacebookContactTableViewCell: BaseTableCell {

    lazy var contactName: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
        
    }()
    
    lazy var contactImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
        
    }()
    
    override func setupViews() {
        
        self.addSubview(contactImageView)
        self.addSubview(contactName)
        
        let safe = self.safeAreaLayoutGuide
        let safeImage = self.contactImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            contactImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            contactImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            contactImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            contactImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            contactName.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            contactName.leadingAnchor.constraint(equalTo: safeImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            contactName.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            contactName.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            ])
        
    }
    
    func setProperties(image : UIImage, slideMenuType: SlideMenuViewTags, cellMenuString : String) {
        
        self.contactName.text = cellMenuString
        self.contactImageView.image = image
        
    }

}
