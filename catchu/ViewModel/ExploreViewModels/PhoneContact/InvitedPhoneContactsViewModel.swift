//
//  InvitedPhoneContactsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class InvitedPhoneContactsViewModel: CommonExplorePhoneContactTableCellViewModelItem {
    
    var invitedPhoneContactsUserArray = [CommonViewModelItem]()
    
    var type: ExploreCellViewTags {
        return .invitedContact
    }
    
    var rowCount: Int {
        return invitedPhoneContactsUserArray.count
    }
    
    func sortInvitedPhoneContactsUserArray() {
        if let array = invitedPhoneContactsUserArray as? [CommonContactViewModel] {
            invitedPhoneContactsUserArray = array.sorted(by: { $0.contact!.givenName < ($1.contact?.givenName)! })
        }
        
    }
    
}
