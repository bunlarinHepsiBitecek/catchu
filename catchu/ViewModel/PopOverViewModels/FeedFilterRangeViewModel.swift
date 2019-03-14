//
//  FeedFilterRangeViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FeedFilterOptionsViewModel {
    
    var feedFilterOptionsSections = Array<CommonFeedFilterOptionsModelItem>()
    
    func createFeedFilterRangeSections() {
        print("\(#function)")
        
        var sectionNumber = 0
        
        // first create a section for group name
        let feedFilterRangeSection = FeedFilterSliderViewModel()
        sectionNumber += 1
        
        feedFilterOptionsSections.append(feedFilterRangeSection)
        
    }
    
    func returnSectionCount() -> Int {
        return feedFilterOptionsSections.count
    }
    
    func returnRowCount(section : Int) -> Int {
        return feedFilterOptionsSections[section].rowCount
    }
    
    func returnFeedFilterRangeSectionsItems(section : Int) -> CommonFeedFilterOptionsModelItem {
        return feedFilterOptionsSections[section]
    }
    
    func returnSectionTitle(_ section: Int) -> String? {
        let feedFilters = returnFeedFilterRangeSectionsItems(section: section)
        
        var title : String? = nil
        
        switch feedFilters.type {
        case .filterRange:
            if let feedFiltersSliderItem = feedFilters as? FeedFilterSliderViewModel {
                title = feedFiltersSliderItem.sectionTitle
            }
        }
        
        return title
    }
    
}
