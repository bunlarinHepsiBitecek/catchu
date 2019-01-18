//
//  FollowersTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct FollowerCellButtonProcessData {
    var state: CRUD_OperationStates
    var buttonOperation: ButtonOperation
}

class FollowersTableCellViewModel: CommonViewModel {
    
    var commonUserViewModel: CommonUserViewModel?
    var buttonProcessData = CommonDynamic(FollowerCellButtonProcessData(state: CRUD_OperationStates.done, buttonOperation: ButtonOperation.none))
    
    init(commonUserViewModel: CommonUserViewModel) {
        self.commonUserViewModel = commonUserViewModel
    }
    
}
