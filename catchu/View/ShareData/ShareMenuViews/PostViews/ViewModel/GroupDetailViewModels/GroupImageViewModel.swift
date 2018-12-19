//
//  GroupImageViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupImageViewModel: BaseViewModel, CommonViewModel {
    
    // this model is required to sync groupRelationView data (specially for groupImage)
    var groupViewModel: CommonGroupViewModel?
    
    var groupImageProcessState = CommonDynamic(GroupImageProcess.start)
    var stackTitleTapped = CommonDynamic(false)
    var groupParticipantCount = CommonDynamic(Int())
    var groupTitleChangeListener = CommonDynamic(String())
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function)")
    }
    
    
}
