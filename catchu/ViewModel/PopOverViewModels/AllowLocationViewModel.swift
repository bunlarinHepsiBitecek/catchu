//
//  AllowLocationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class AllowLocationViewModel: CommonMoreOptionsModelItem {
   
    var subTitle = LocalizedConstants.AdvancedSettingPrompts.locationFeatureUpdateInfo
    var switchListener = CommonDynamic(true)
    
    init(switchValue: Bool) {
        self.switchListener.value = switchValue
    }
    
    var type: MoreOptionSectionTypes {
        return .allowLocationAppear
    }
    
    var sectionTitle: String {
        return LocalizedConstants.SectionTitles.locationSettings
    }
    
    var rowCount: Int {
        return 1
    }
    
    func postItemAdvancedSettingsManager() {
        PostItems.shared.allowLocationAppear = switchListener.value
        
    }
    
}
