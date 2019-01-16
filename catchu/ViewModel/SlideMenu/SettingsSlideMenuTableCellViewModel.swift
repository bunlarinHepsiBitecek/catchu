//
//  SettingsTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SettingsSlideMenuTableCellViewModel: CommonSlideMenuTableCellViewModelItem {
    
    var type: SlideMenuViewTags {
        return .settings
    }
    
    var cellTitle: String {
        return LocalizedConstants.SlideMenu.settingsCell
    }
    
    var cellImage: UIImage {
        if let image = UIImage(named: "settings") {
            return image
        } else {
            return UIImage()
        }
    }
    
    var rowCount: Int {
        return 1
    }
    
}
