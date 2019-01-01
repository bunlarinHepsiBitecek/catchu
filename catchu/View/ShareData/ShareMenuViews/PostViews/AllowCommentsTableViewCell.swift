//
//  AllowCommentsTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AllowCommentsTableViewCell: CommonMoreOptionsTableCell, CommonDesignableCellForAdvancedCettings {
    
    var allowCommentViewModel: AllowCommentViewModel?
    
    override func initializeCellSettings() {
        print("\(#function) of MoreOptionsTableViewCell")
        self.addViews()
        self.setupViewSettings()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetCellSettings()
    }
    
}

// MARK: - major functions
extension AllowCommentsTableViewCell {
    
    private func addViews() {
        print("TATATATATATATATAT")
        
        self.contentView.addSubview(stackViewAdvancedSettings)
        self.contentView.addSubview(switchButton)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeSwitch = self.switchButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewAdvancedSettings.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            stackViewAdvancedSettings.trailingAnchor.constraint(equalTo: safeSwitch.leadingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewAdvancedSettings.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            stackViewAdvancedSettings.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            
            switchButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            switchButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
        
    }
    
    private func setupViewSettings() {
        
        addSwitchButtonTarget()
        
    }
    
    private func resetCellSettings() {
        allowCommentViewModel?.switchListener.unbind()
    }
    
    private func addSwitchButtonTarget() {
        switchButton.addTarget(self, action: #selector(switchButtonTriggered(_:)), for: .valueChanged)
    }
    
    private func changeCellTitle(active: Bool) {
        
        UIView.transition(with: self.title, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            if active {
                self.title.text = LocalizedConstants.AdvancedSettingPrompts.allowComments
            } else {
                self.title.text = LocalizedConstants.AdvancedSettingPrompts.restrictComments
            }
            
        })
        
    }
    
    @objc func switchButtonTriggered(_ sender : UISwitch) {
        allowCommentViewModel?.switchListener.value = sender.isOn
    }
    
    private func addSwitchListener() {
        allowCommentViewModel?.switchListener.bindAndFire({ (switchState) in
            self.allowCommentViewModel!.postItemAdvancedSettingsManager()
            self.changeCellTitle(active: switchState)
            self.setSwitchValue(isOn: switchState)
            
        })
    }
    
    private func setSwitchValue(isOn: Bool) {
        switchButton.isOn = isOn
    }
}

// MARK: - outside functions
extension AllowCommentsTableViewCell {
    
    func initiateCellDesign(item: CommonMoreOptionsModelItem?) {
        print("\(#function)")
        
        guard let model = item as? AllowCommentViewModel else { return }
        
        self.allowCommentViewModel = model
        
        guard let allowCommentViewModel = allowCommentViewModel else { return }
        
        self.subTitle.text = allowCommentViewModel.subTitle
            
        addSwitchListener()
        
    }
    
}

