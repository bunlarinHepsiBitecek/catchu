//
//  FollowingsTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowingsTableCellViewModel: CommonViewModel {
    
    var commonUserViewModel: CommonUserViewModel?
    
    init(commonUserViewModel: CommonUserViewModel) {
        self.commonUserViewModel = commonUserViewModel
    }
    
}
