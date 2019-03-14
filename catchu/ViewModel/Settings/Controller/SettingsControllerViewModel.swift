//
//  SettingsControllerViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsControllerViewModel {
    
    var groupSectionArray = Array<CommonGroupViewModelItem>()
    var state = CommonDynamic(TableViewState.suggest)

    func returnSectionCount() -> Int {
        return groupSectionArray.count
    }
    
    func returnNumberOfRowsInSections(section: Int) -> Int {
        return groupSectionArray[section].rowCount
    }
    
    func returnGroupSections(index: Int) -> CommonGroupViewModelItem {
        return groupSectionArray[index]
    }
    
    func returnGroupSectionTitles(section: Int) -> String {
        return groupSectionArray[section].sectionTitle
    }
    
    func createSections() {
        
        groupSectionArray.removeAll()
        
        // MARK - create add friend section
        let addFriendSection = SettingsAddFriendsViewModel()
        let facebookFriendRow = SettingsRowViewModel(rowProcessType: .addFacebookFriends)
        let contactFriendRow = SettingsRowViewModel(rowProcessType: .addContacts)
        
        addFriendSection.processType.append(facebookFriendRow)
        addFriendSection.processType.append(contactFriendRow)
        
        groupSectionArray.append(addFriendSection)
        
        // MARK -  create invite friend section
        let inviteFriendSection = SettingsInviteFriendsViewModel()
        let inviteFriendRow = SettingsRowViewModel(rowProcessType: .invitePeople)

        inviteFriendSection.processType.append(inviteFriendRow)
        
        groupSectionArray.append(inviteFriendSection)
        
        // MARK -  create account settings section
        let accountSection = SettingsAccountViewModel()
        let accountPrivacyRow = SettingsRowViewModel(rowProcessType: .accountPrivacyChange)
        
        accountSection.processType.append(accountPrivacyRow)
        
        groupSectionArray.append(accountSection)
        
        // MARK -  create authentication settings section
        let authenticationSection = SettingsAuthenticationViewModel()
        let logoutRow = SettingsRowViewModel(rowProcessType: .accountLogout)
        
        authenticationSection.processType.append(logoutRow)
        
        groupSectionArray.append(authenticationSection)
        
        state.value = groupSectionArray.count == 0 ? .empty : .populate
        
    }
    
}
