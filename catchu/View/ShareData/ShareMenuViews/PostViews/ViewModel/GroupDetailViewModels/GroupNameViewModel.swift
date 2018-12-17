//
//  GroupNameViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation


class GroupNameViewModel: BaseViewModel, CommonViewModel, CommonGroupViewModelItem {
    
    var groupViewModel: CommonGroupViewModel?
    
    var group: Group?
    var groupNameUpdated = CommonDynamic(String())
    
    init(group: Group?, groupViewModel: CommonGroupViewModel) {
        self.group = group
        self.groupViewModel = groupViewModel
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var type: GroupDetailSectionTypes {
        return .name
    }
    
    // api gateway handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
    }
    
}
