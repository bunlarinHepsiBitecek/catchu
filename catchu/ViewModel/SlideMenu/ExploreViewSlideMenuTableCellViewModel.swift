
//
//  ExploreViewTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class ExploreViewSlideMenuTableCellViewModel: CommonSlideMenuTableCellViewModelItem {

    var type: SlideMenuViewTags {
        return .explore
    }
    
    var cellTitle: String {
        return LocalizedConstants.SlideMenu.explorePeopleCell
    }
    
    var cellImage: UIImage {
        return UIImage(named: "search")!
    }
    
    var rowCount: Int {
        return 1
    }
    
}
