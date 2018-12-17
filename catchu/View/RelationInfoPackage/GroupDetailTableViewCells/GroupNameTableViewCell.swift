//
//  GroupNameTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupNameTableViewCell: CommonTableCell, CommonDesignableCellForGroupDetail {
    
    var groupNameViewModel: GroupNameViewModel?
    
    lazy var groupName: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1

        return temp
    }()
    
    override func initializeCellSettings() {
        
        self.accessoryType = .disclosureIndicator
        
        addViews()
        //addGroupNameUpdateListener()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetCellSettings()
    }

}

// MARK: - major functions
extension GroupNameTableViewCell {
    
    func initiateCellDesign(item: CommonGroupViewModelItem?) {
        print("\(#function)")
        
        if let model = item as? GroupNameViewModel {
            self.groupNameViewModel = model
            
            guard let groupNameViewModel = self.groupNameViewModel else { return }
            
            if let group = groupNameViewModel.group {
                self.groupName.text = group.groupName
            }
            
        }
        
    }
    
    private func resetCellSettings() {
        groupName.text = ""
    }
    
    private func addViews() {
        
        self.contentView.addSubview(groupName)
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupName.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupName.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupName.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            groupName.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            
            ])
        
    }

}
