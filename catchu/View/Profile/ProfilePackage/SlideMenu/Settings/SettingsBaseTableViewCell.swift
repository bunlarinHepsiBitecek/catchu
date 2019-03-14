//
//  SettingsBaseTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SettingsBaseTableViewCell: CommonTableCell, CommonDesignableCell {

    private var settingBaseCellViewModel: SettingsBaseCellViewModel!
    
    override func initializeCellSettings() {

    }

}

// MARK: - major functions
extension SettingsBaseTableViewCell {
    
    private func addCellListeners() {
        settingBaseCellViewModel.listenLabelTextChange.bindAndFire { (prompt) in
            self.setCellPrompts(prompt: prompt)
        }
    }
    
    private func setCellPrompts(prompt: String) {
        DispatchQueue.main.async {
            self.textLabel?.text = prompt
        }
    }
    
    private func cellConfigurations(type: SettingsRowType) {
        DispatchQueue.main.async {
            switch type {
            case .addFacebookFriends, .addContacts, .accountPrivacyChange:
                self.accessoryType = .disclosureIndicator
            case .invitePeople:
                self.accessoryType = UITableViewCell.AccessoryType.none
            case .accountLogout:
                self.accessoryType = UITableViewCell.AccessoryType.none
                self.textLabel?.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        settingBaseCellViewModel = SettingsBaseCellViewModel(item: item!)
        settingBaseCellViewModel.parseRowData()
        addCellListeners()
        cellConfigurations(type: settingBaseCellViewModel.returnRowType()!)
    }
    
    func returnCellRowType() -> SettingsRowType? {
        return settingBaseCellViewModel.returnRowType()
    }
    
}
