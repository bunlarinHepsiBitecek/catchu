//
//  GroupCreationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupCreationViewModel: BaseViewModel, CommonViewModel {
    
    //var groupParticipantArray = [CommonViewModelItem]()
    var selectedCommonUserViewModelList = Array<CommonUserViewModel>()
    var totalParticipantCount = CommonDynamic(Int())
    
    // to sync group creation participant count and friend group relation view count
    var friendGroupRelationViewModel: FriendGroupRelationViewModel?
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        return
    }
    
    func returnNumberOfSelectedCommonUserViewModelList() -> Int {
        return selectedCommonUserViewModelList.count
    }
    
}
