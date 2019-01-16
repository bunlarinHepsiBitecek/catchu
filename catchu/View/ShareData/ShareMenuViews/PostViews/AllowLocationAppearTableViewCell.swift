//
//  AllowLocationAppearTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AllowLocationAppearTableViewCell: CommonMoreOptionsTableCell, CommonDesignableCellForAdvancedCettings {
    
    var allowLocationViewModel: AllowLocationViewModel?

    override func initializeCellSettings() {
        print("\(#function) of AllowLocationAppeaTableViewCell")
        self.addViews()
        self.setupViewSettings()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetCellSettings()
    }
    
}

// MARK: - major functions
extension AllowLocationAppearTableViewCell {
    
    private func addViews() {
        
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
        
        self.selectionStyle = .none
        
    }
    
    private func resetCellSettings() {
        allowLocationViewModel?.switchListener.unbind()
    }
    
    private func addSwitchButtonTarget() {
        switchButton.addTarget(self, action: #selector(switchButtonTriggered(_:)), for: .valueChanged)
    }
    
    private func changeCellTitle(active: Bool) {
        
        UIView.transition(with: self.title, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            if active {
                self.title.text = LocalizedConstants.AdvancedSettingPrompts.allowLocation
            } else {
                self.title.text = LocalizedConstants.AdvancedSettingPrompts.restrictLocation
            }
            
        })
        
    }
    
    @objc func switchButtonTriggered(_ sender : UISwitch) {
        allowLocationViewModel?.switchListener.value = sender.isOn
    }
    
    private func addSwitchListener() {
        allowLocationViewModel?.switchListener.bindAndFire({ (switchState) in
            self.allowLocationViewModel!.postItemAdvancedSettingsManager()
            self.changeCellTitle(active: switchState)
            self.setSwitchValue(isOn: switchState)
            
        })
    }
    
    private func setSwitchValue(isOn: Bool) {
        switchButton.isOn = isOn
    }
    
}

// MARK: - outside functions
extension AllowLocationAppearTableViewCell {
    
    func initiateCellDesign(item: CommonMoreOptionsModelItem?) {
        print("\(#function)")
        
        guard let model = item as? AllowLocationViewModel else { return }
        
        self.allowLocationViewModel = model
        
        guard let allowLocationViewModel = allowLocationViewModel else { return }
        
        self.subTitle.text = allowLocationViewModel.subTitle
        
        addSwitchListener()
    }
    
}
