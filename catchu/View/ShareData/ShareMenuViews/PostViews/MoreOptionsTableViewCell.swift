//
//  AlloCommentsTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AlloCommentsTableViewCell: CommonTableCell, CommonDesignableCell {

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
    
    lazy var switchButton: UISwitch = {
        let temp = UISwitch()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    override func initializeCellSettings() {
        print("\(#function) of MoreOptionsTableViewCell")
    }

}

// MARK: - major functions
extension AlloCommentsTableViewCell {
    
    private func addViews() {
        
        self.contentView.addSubview(stackViewForUserInfo)
        self.contentView.addSubview(switchButton)
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewForUserInfo.leadingAnchor.constraint(equalTo: safe.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewForUserInfo.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            switchButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            switchButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
        
    }
    
}

// MARK: - outside functions
extension AlloCommentsTableViewCell {

    func initiateCellDesign(item: CommonViewModelItem?) {
        print("\(#function)")
    }
    
}

