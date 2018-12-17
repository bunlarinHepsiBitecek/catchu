//
//  GroupExitViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupExitViewModel: BaseViewModel, CommonViewModel, CommonGroupViewModelItem {
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var type: GroupDetailSectionTypes {
        return .exit
    }
    
    // api gateway handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
    }
    
}
