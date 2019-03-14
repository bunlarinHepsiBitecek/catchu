//
//  SettingsAccountViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsAccountViewModel: CommonGroupViewModelItem {
    
    var processType = Array<CommonViewModelItem>()
    
    var sectionTitle: String {
        return LocalizedConstants.TitleValues.LabelTitle.account
    }
    
    var rowCount: Int {
        return processType.count
    }
    
    var type: GroupDetailSectionTypes {
        return .account
    }
    
}
