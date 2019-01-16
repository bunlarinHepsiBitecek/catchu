//
//  MoreOptionsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class MoreOptionsViewModel {
    
    var moreOptionsSections = Array<CommonMoreOptionsModelItem>()
    
    func createMoreOptionsSections() {
        print("\(#function)")
        
        var sectionNumber = 0
        
        // first create a section for group name
        let allowCommentSection = AllowCommentViewModel(switchValue: PostItems.shared.allowComments)
        sectionNumber += 1
        
        moreOptionsSections.append(allowCommentSection)
        
        // second create exit section
        let allowLocationSection = AllowLocationViewModel(switchValue: PostItems.shared.allowLocationAppear)
        sectionNumber += 1
        moreOptionsSections.append(allowLocationSection)
        
    }
    
    func returnSectionCount() -> Int {
        return moreOptionsSections.count
    }
    
    func returnRowCount(section : Int) -> Int {
        return moreOptionsSections[section].rowCount
    }
    
    func returnMoreOptionsSectionItem(section : Int) -> CommonMoreOptionsModelItem {
        return moreOptionsSections[section]
    }
    
    func returnSectionTitle(_ section: Int) -> String? {
        let moreOptions = returnMoreOptionsSectionItem(section: section)
        
        var title : String? = nil
        
        switch moreOptions.type {
        case .allowComment:
            if let allowCommentItem = moreOptions as? AllowCommentViewModel {
                title = allowCommentItem.sectionTitle
            }
        case .allowLocationAppear:
            if let allowLocationItem = moreOptions as? AllowLocationViewModel {
                title = allowLocationItem.sectionTitle
            }
        }
        
        return title
    }
    
}
