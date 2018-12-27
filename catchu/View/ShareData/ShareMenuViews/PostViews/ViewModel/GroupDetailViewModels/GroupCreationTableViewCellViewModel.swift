//
//  GroupCreationTableViewCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupCreationTableViewCellViewModel {
    
    var groupParticipantArray = [CommonViewModelItem]()
    
    // GroupCreationViewModel to sync total participant count to dismiss view controller when there is no participant in create group view controller
    var groupCreationViewModel: GroupCreationViewModel?
    
    // to sync participant count with tableView sectionHeader
    var sectionHeaderViewModel: SectionHeaderViewModel?
    
    // to sync removed item with previous friend relation view
    var friendGroupRelationViewModel: FriendGroupRelationViewModel?
    
    func returnGroupParticipantArrayCount() -> Int {
        return groupParticipantArray.count
    }
    
    func returnParticipant(index : Int) -> CommonViewModelItem {
        return groupParticipantArray[index]
    }
    
    func removeItemFromGroupParticipantArray(removedItem : CommonUserViewModel) {
        
        if let array = groupParticipantArray as? [CommonUserViewModel] {
            if let index = array.firstIndex(where: { $0.user?.userid == removedItem.user?.userid}) {
                groupParticipantArray.remove(at: index)
            }
        }
        
    }
}

