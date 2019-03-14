//
//  SettingsBaseCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsBaseCellViewModel: CommonViewModel {
    
    var settingsRowViewModel: CommonViewModelItem!
    var listenLabelTextChange = CommonDynamic(String())
    
    init(item : CommonViewModelItem) {
        self.settingsRowViewModel = item
    }
    
    func parseRowData() {
        guard let settingsRowViewModel = settingsRowViewModel as? SettingsRowViewModel else { return }
        guard let rowType = settingsRowViewModel.rowProcessType else { return }
        
        switch rowType {
        case .addFacebookFriends:
            listenLabelTextChange.value = LocalizedConstants.SettingsPrompts.addFacebookFriends
        case .addContacts:
            listenLabelTextChange.value = LocalizedConstants.SettingsPrompts.addContactFriends
        case .invitePeople:
            listenLabelTextChange.value = LocalizedConstants.SettingsPrompts.inviteFriends
        case .accountPrivacyChange:
            listenLabelTextChange.value = LocalizedConstants.SettingsPrompts.privacyAndSecurity
        case .accountLogout:
            listenLabelTextChange.value = LocalizedConstants.SettingsPrompts.logout
        }
        
    }
    
    func returnRowType() -> SettingsRowType?  {
        if let settingsRowViewModel = settingsRowViewModel as? SettingsRowViewModel {
            if let rowType = settingsRowViewModel.rowProcessType {
                return rowType
            }
        }
        return nil
    }
    
    // for api gateway process
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
    }
    
}
