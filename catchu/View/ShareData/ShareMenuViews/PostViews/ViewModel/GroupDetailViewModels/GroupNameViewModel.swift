//
//  GroupNameViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupNameViewModel: BaseViewModel, CommonViewModel, CommonGroupViewModelItem {
    // to sync groupRelationView data
    var groupViewModel: CommonGroupViewModel?
    // to sync groupImageContainerView data 
    var groupImageViewModel: GroupImageViewModel?
    
    //var group: Group?
    var groupNameUpdated = CommonDynamic(String())
    
    init(group: Group?, groupViewModel: CommonGroupViewModel, groupImageViewModel: GroupImageViewModel) {
        //self.group = group
        self.groupViewModel = groupViewModel
        self.groupImageViewModel = groupImageViewModel
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
