//
//  GroupExitTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupExitTableViewCell: CommonTableCell, CommonDesignableCellForGroupDetail {
    
    var groupExitViewModel: GroupExitViewModel?
    
    lazy var cellLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        temp.textColor = UIColor.red
        temp.text = LocalizedConstants.TitleValues.LabelTitle.exitGroup
        temp.numberOfLines = 1
        
        return temp
    }()
    
    override func initializeCellSettings() {
        
        addViews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellSettings()
    }
    
}

// MARK: - major functions
extension GroupExitTableViewCell {
    
    func initiateCellDesign(item: CommonGroupViewModelItem?) {
        print("\(#function)")
        
        if let model = item as? GroupExitViewModel {
            self.groupExitViewModel = model
            
            guard let groupExitViewModel = self.groupExitViewModel else { return }
            
        }
        
    }
    
    private func resetCellSettings() {
    }
    
    private func addViews() {
        
        self.contentView.addSubview(cellLabel)
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            cellLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            cellLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            cellLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            cellLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            cellLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            
            ])
        
    }
    
}
