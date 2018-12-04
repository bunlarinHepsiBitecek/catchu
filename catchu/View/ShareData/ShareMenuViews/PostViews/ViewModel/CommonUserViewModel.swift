//
//  CommonUserViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CommonUserViewModel: CommonViewModelItem {
    
    var user : User?
    var userSelected = CommonDynamic(TableViewRowSelected.deSelected)
    
    init(user : User?) {
        self.user = user
    }
    
    func selectUserManagement(choise : TableViewRowSelected) {
        userSelected.value = choise
    }
    
}
