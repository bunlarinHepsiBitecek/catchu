//
//  GroupParticipantsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupParticipantsViewModel: BaseViewModel, CommonViewModel, CommonGroupViewModelItem {
    
    var participantList = [GroupParticipantViewModel]()
    
    var sectionTitle: String {
        return LocalizedConstants.TitleValues.LabelTitle.participants
    }
    
    var rowCount: Int {
        return participantList.count
    }
    
    var type: GroupDetailSectionTypes {
        return .participant
    }
    
    // api gateway handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
    }
    
}

