//
//  SettingsAuthenticationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsAuthenticationViewModel: CommonGroupViewModelItem {
    
    var processType = Array<CommonViewModelItem>()
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return processType.count
    }
    
    var type: GroupDetailSectionTypes {
        return .authentication
    }
    
}
