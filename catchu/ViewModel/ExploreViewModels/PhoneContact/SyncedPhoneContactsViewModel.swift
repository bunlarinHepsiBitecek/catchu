//
//  SyncedPhoneContactsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SyncedPhoneContactsViewModel: CommonExplorePhoneContactTableCellViewModelItem {
   
    var syncedPhoneContactsUserArray = [CommonViewModelItem]()
    
    var type: ExploreCellViewTags {
        return .syncedContact
    }
    
    var rowCount: Int {
        return syncedPhoneContactsUserArray.count
    }
    
}
