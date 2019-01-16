//
//  ManageGroupsTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class ManageGroupsSlideMenuTableCellViewModel: CommonSlideMenuTableCellViewModelItem {
    
    var type: SlideMenuViewTags {
        return .manageGroupOperations
    }
    
    var cellTitle: String {
        return LocalizedConstants.SlideMenu.manageGroupsCell
    }
    
    var cellImage: UIImage {
        if let image = UIImage(named: "group") {
            return image
        } else {
            return UIImage()
        }
    }
    
    var rowCount: Int {
        return 1
    }
    
}
