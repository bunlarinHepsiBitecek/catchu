//
//  SelectedFriendsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SelectedFriendsViewModel: BaseViewModel {
    
    var friendArray = [CommonViewModelItem]()
    var operation = CommonDynamic(CollectionViewOperation.none)
    var selectedFriendListEmpty = CommonDynamic(CollectionViewActivation.disable)
    var selectedFriendListCount = CommonDynamic(Int())
    
    func appendItemToFriendArray(friend: CommonUserViewModel) {
        friendArray.append(friend)
    }
    
    func removeItemFromFriendArray(friend: CommonViewModelItem) {
        if let array = friendArray as? [CommonUserViewModel], let friend = friend as? CommonUserViewModel {
            if let index = array.firstIndex(where: { $0.user?.userid == friend.user?.userid}) {
                friendArray.remove(at: index)
            }
        }
        
        operation.value = .delete
        selectedFriendListCount.value = friendArray.count
    }
    
    
    
}


