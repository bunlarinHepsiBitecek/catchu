//
//  PendingRequestTableViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/4/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PendingRequestTableViewModel {
    
    var followRequesterArray = [CommonViewModelItem]()
    var searchedFollowRequesterArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.empty)
    var slideMenuPendingRequestCounterListener = CommonDynamic([CommonViewModelItem]())
    
    var searchTools = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    func returnFollowRequestArrayCount() -> Int {
        if searchTools.value.searchIsProgress {
            return searchedFollowRequesterArray.count
        } else {
            return followRequesterArray.count
        }
    }
    
    func returnCommonViewItem(index: Int) -> CommonViewModelItem {
        if searchTools.value.searchIsProgress {
            return searchedFollowRequesterArray[index]
        } else {
            return followRequesterArray[index]
        }
    }
    
    
    func searchFollowRequesterInTableViewData(inputText : String) {
        print("\(#function) starts")
        
        // remove items from searchFriendArray
        searchedFollowRequesterArray.removeAll()
        
        if let array = followRequesterArray as? [CommonUserViewModel] {
            for item in array {
                
                if let user = item.user {
                    if let name = user.name {
                        if name.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowRequesterArray.append(item)
                            continue
                        }
                    }
                    
                    if let username = user.username {
                        print("username : \(username)")
                        if username.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowRequesterArray.append(item)
                            continue
                        }
                    }
                }
            }
        }
        
        searchTools.value.searchIsProgress = true
        state.value = .populate
        
    }
    
    func removeFollowRequestFromArray(userid: String) {
       
        if let commonUserViewModelArray = followRequesterArray as? [CommonUserViewModel] {
            if let index = commonUserViewModelArray.firstIndex(where: { $0.user?.userid == userid}) {
                followRequesterArray.remove(at: index)
                // to update slide menu tableview follower request badge number
                slideMenuPendingRequestCounterListener.value = followRequesterArray
            }
        }
        
        if searchTools.value.searchIsProgress {
            if let commonUserViewModelArray = searchedFollowRequesterArray as? [CommonUserViewModel] {
                if let index = commonUserViewModelArray.firstIndex(where: { $0.user?.userid == userid}) {
                    searchedFollowRequesterArray.remove(at: index)
                }
            }
            
        }
        
    }
    
}
