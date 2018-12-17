//
//  GroupAddParticipantViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupAddParticipantViewModel: BaseViewModel, CommonViewModel, CommonGroupViewModelItem {
    
    var group: Group?
    
    init(group: Group?) {
        self.group = group
    }
    
    var sectionTitle: String {
        return "Participant List"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var type: GroupDetailSectionTypes {
        return .admin
    }
    
    // api gateway handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
    }
    
}
