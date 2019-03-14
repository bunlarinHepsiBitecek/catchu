//
//  AccountPrivacyTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AccountPrivacyTableViewCell: CommonMoreOptionsTableCell {

    private var accountPrivacyTableCellViewModel = AccountPrivacyTableCellViewModel()
    
    override func initializeCellSettings() {
        addViews()
        addTargetToSwitchButton()
        setTitles()
        setValuesToSwitchButton()
        addListeners()
    }

}

// MARK: - major functions
extension AccountPrivacyTableViewCell {

    private func addViews() {
        self.contentView.addSubview(stackViewAdvancedSettings)
        self.contentView.addSubview(switchButton)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeSwitch = self.switchButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewAdvancedSettings.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            stackViewAdvancedSettings.trailingAnchor.constraint(equalTo: safeSwitch.leadingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackViewAdvancedSettings.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            stackViewAdvancedSettings.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            
            switchButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            switchButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            ])
    }
    
    private func addListeners() {
        accountPrivacyTableCellViewModel.switchListener.bind { (value) in
            self.accountPrivacyTableCellViewModel.updatePrivacyInformation(isPrivateValue: value)
        }
        
        accountPrivacyTableCellViewModel.updateProcess.bind { (operationState) in
            self.networkProcessManager(operationState: operationState)
        }
        
    }
    
    private func setValuesToSwitchButton() {
        guard let userPrivate = User.shared.isUserHasAPrivateAccount else { return }
        
        switchButton.isOn = userPrivate
    }
    
    private func networkProcessManager(operationState: CRUD_OperationStates) {
        DispatchQueue.main.async {
            switch operationState {
            case .processing:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .done:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private func setTitles() {
        
        self.title.text = LocalizedConstants.SettingsPrompts.privateAccount
        self.subTitle.text = LocalizedConstants.SettingsPrompts.privateAccountInfo
        self.subTitle.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.switchButton.onTintColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        
    }
    
    private func addTargetToSwitchButton() {
        switchButton.addTarget(self, action: #selector(AccountPrivacyTableViewCell.switchButtonTriggered(_:)), for: .valueChanged)
    }
    
    @objc private func switchButtonTriggered(_ sender: UISwitch) {
        accountPrivacyTableCellViewModel.switchListener.value = sender.isOn
    }
    
}

