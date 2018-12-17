//
//  GroupInfoEditTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoEditTableViewCell: CommonTableCell, CommonDesignableCell {
    
    var groupViewModel: CommonGroupViewModel?
    
    lazy var groupNameTextField: UITextField = {
        let temp = UITextField()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.textAlignment = .left
        temp.contentMode = .left
        temp.clearButtonMode = .whileEditing
        temp.keyboardType = .namePhonePad
        temp.keyboardAppearance = .dark
        temp.autocorrectionType = .no
        
        temp.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: UIControlEvents.editingChanged)
        
        return temp
    }()
    
    lazy var letterCountSticker: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.lightGray
        label.text = Constants.CharacterConstants.EMPTY
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    override func initializeCellSettings() {
        
        addViews()
        
    }
    
}

// MARK: - major functions
extension GroupInfoEditTableViewCell {
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        print("\(#function)")
        
        guard let groupViewModel = item as? CommonGroupViewModel else { return }
        
        self.groupViewModel = groupViewModel
        
        if let group = groupViewModel.group {
            if let groupName = group.groupName {
                self.groupNameTextField.text = groupName
            }
        }
        
    }
    
    private func addViews() {
        
        self.contentView.addSubview(groupNameTextField)
        self.contentView.addSubview(letterCountSticker)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeGroupNameTextField = self.groupNameTextField.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupNameTextField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            groupNameTextField.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            
            letterCountSticker.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            letterCountSticker.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            letterCountSticker.topAnchor.constraint(equalTo: safeGroupNameTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            letterCountSticker.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    @objc func textFieldChanged(_ sender : UITextField) {
        if let text = sender.text {
            groupViewModel?.groupNameChanged.value = text
        }
    }
    
}

