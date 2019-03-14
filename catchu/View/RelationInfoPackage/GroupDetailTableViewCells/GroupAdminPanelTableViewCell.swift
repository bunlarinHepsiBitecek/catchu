//
//  GroupAdminPanelTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupAdminPanelTableViewCell: CommonTableCell, CommonDesignableCellForGroupDetail {
    
    var groupAdminViewModel: GroupAddParticipantViewModel?
    
    lazy var addIconContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.75)
        return temp
    }()
    
    lazy var addIcon: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(named: "icon_add")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        imageView.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_8
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackViewForCellLabel: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [commandLabel])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let commandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = LocalizedConstants.TitleValues.LabelTitle.addParticipant
        label.textColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func initializeCellSettings() {
        
        self.accessoryType = .disclosureIndicator
        
        addViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetCellSettings()
    }
    
}

// MARK: - major functions
extension GroupAdminPanelTableViewCell {
    
    func initiateCellDesign(item: CommonGroupViewModelItem?) {
        print("\(#function)")
        
        if let model = item as? GroupAddParticipantViewModel {
            self.groupAdminViewModel = model
            
            guard let groupAdminViewModel = self.groupAdminViewModel else { return }
            
            
        }
        
    }
    
    private func resetCellSettings() {

    }
    
    private func addViews() {
        
        self.contentView.addSubview(addIconContainerView)
        self.addIconContainerView.addSubview(addIcon)
        self.contentView.addSubview(stackViewForCellLabel)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeIconContainerView = self.addIconContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            addIconContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            addIconContainerView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            addIconContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            addIconContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            addIconContainerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_40),
            
            addIcon.centerYAnchor.constraint(equalTo: safeIconContainerView.centerYAnchor),
            addIcon.centerXAnchor.constraint(equalTo: safeIconContainerView.centerXAnchor),
            addIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_16),
            addIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_16),
            
            stackViewForCellLabel.leadingAnchor.constraint(equalTo: safeIconContainerView.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            stackViewForCellLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
        
    }
    
}
