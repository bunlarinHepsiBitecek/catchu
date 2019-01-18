
//
//  DynamicPageViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/12/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class DynamicPageViewModel {
    
    var pageItemCollectionViewState = CommonDynamic(CollectionViewState.empty)
    var viewArray = [UIView]()
    var pageItemCollectionViewTitleListener = CommonDynamic(String())
    
    func returnPageItemsCount() -> Int {
        return viewArray.count
    }
    
    func returnPageItem(index: Int) -> PageItems? {
        if let pageItem = viewArray[index] as? PageItems {
            return pageItem
        } else {
            return nil
        }
    }
    
}
