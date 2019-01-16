//
//  PendingRequestTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PendingRequestSlideMenuTableCellViewModel: CommonSlideMenuTableCellViewModelItem {
    
    var badgeData = CommonDynamic(String())
    
    var type: SlideMenuViewTags {
        return .viewPendingFriendRequests
    }
    
    var cellTitle: String {
        return LocalizedConstants.SlideMenu.viewPendingRequestCell
    }
    
    var cellImage: UIImage {
        if let image = UIImage(named: "eye") {
            return image
        } else {
            return UIImage()
        }
    }
    
    var rowCount: Int {
        return 1
    }
    
}
