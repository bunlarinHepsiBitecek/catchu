//
//  SettingsRowViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsRowViewModel: CommonViewModelItem {
    
    var rowProcessType: SettingsRowType!
    
    init(rowProcessType: SettingsRowType) {
        self.rowProcessType = rowProcessType
    }
    
}
