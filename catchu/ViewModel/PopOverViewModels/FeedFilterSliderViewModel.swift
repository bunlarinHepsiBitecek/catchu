//
//  FeedFilterSliderViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FeedFilterSliderViewModel: CommonFeedFilterOptionsModelItem, CommonViewModelItem {
    
    var subTitle = LocalizedConstants.FeedFilterOptionsPrompts.feedFilterRangeInfo
    var sliderRangeChangeListener = CommonDynamic(Int())
    let step : Float = 50 
    
    init() {
        // set initial value
    }
    
    var type: FeedFilterOptionsSectionTypes {
        return .filterRange
    }
    
    var sectionTitle: String {
        return LocalizedConstants.FeedFilterOptionsPrompts.feedFilterRange
    }
    
    var rowCount: Int {
        return 1
    }
    
}
