//
//  FriendGroupRelationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FriendGroupRelationViewModel: BaseViewModel {
    
    var groupCreationRemovedParticipant = CommonDynamic(CommonUserViewModel())
    var resetFriendRelationView = CommonDynamic(false)
    var resetGroupRelationView = CommonDynamic(CommonGroupViewModel())
    var nextButtonActivation = CommonDynamic(CommitButtonStates.passise)
    
    var selectedCommonUserViewModelList = Array<CommonUserViewModel>()
    
    
}
