//
//  SlideMenuTableViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SlideMenuTableViewModel {
    
    var slideMenuCellArray = Array<CommonSlideMenuTableCellViewModelItem>()
    var followRequesterArray = [CommonViewModelItem]()
    var refreshProcessState = CommonDynamic(CRUD_OperationStates.done)
    
    func createSlideMenuCellArray() {
        print("\(#function)")
        
        let exploreCell = ExploreViewSlideMenuTableCellViewModel()
        slideMenuCellArray.append(exploreCell)
        
        let pendingRequestCell = PendingRequestSlideMenuTableCellViewModel()
        slideMenuCellArray.append(pendingRequestCell)
        
        let manageGroupsCell = ManageGroupsSlideMenuTableCellViewModel()
        slideMenuCellArray.append(manageGroupsCell)
        
        let settingsCell = SettingsSlideMenuTableCellViewModel()
        slideMenuCellArray.append(settingsCell)
        
    }
    
    func returnSlideMenuCellArrayCount() -> Int {
        return self.slideMenuCellArray.count
    }
    
    func returnViewModel(index : Int) -> CommonSlideMenuTableCellViewModelItem {
        return self.slideMenuCellArray[index]
    }
    
    func returnUpdatedFollowRequestArrayCount(array : [CommonViewModelItem]) -> Int {
        self.followRequesterArray = array
        
        return followRequesterArray.count
    }
    
}
