//
//  CommonGroupViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class CommonGroupViewModel: CommonViewModelItem {
    
    var group : Group?
    var groupSelected = CommonDynamic(TableViewRowSelected.deSelected)
    var groupNameChanged = CommonDynamic(String())
    var groupImageChanged = CommonDynamic(UIImage())

    init(group : Group?) {
        self.group = group
    }
    
    func selectGroupManagement(choise : TableViewRowSelected) {
        groupSelected.value = choise
    }
    
    func displayProperties() {
        print("group : \(group)")
        print("groupSelected : \(groupSelected.value)")
    }
    
}
