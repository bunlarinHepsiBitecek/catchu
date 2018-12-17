//
//  GroupParticipantViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupParticipantViewModel: CommonViewModelItem {
    
    var user : User?
    var group : Group?
    
    init(user : User?, group: Group?) {
        self.user = user
        self.group = group
    }
    
}

