//
//  AllowCommentViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class AllowCommentViewModel: CommonMoreOptionsModelItem, CommonViewModelItem {
    
    var subTitle = LocalizedConstants.AdvancedSettingPrompts.commentFeatureUpdateInfo
    var switchListener = CommonDynamic(true)
    
    init(switchValue: Bool) {
        self.switchListener.value = switchValue
    }
    
    var type: MoreOptionSectionTypes {
        return .allowComment
    }
    
    var sectionTitle: String {
        return LocalizedConstants.SectionTitles.commentSettings
    }
    
    var rowCount: Int {
        return 1
    }
    
    func postItemAdvancedSettingsManager() {
        PostItems.shared.allowComments = switchListener.value
    }
    
}
