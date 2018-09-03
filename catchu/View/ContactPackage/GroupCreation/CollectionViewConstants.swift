//
//  CollectionViewConstants.swift
//  catchu
//
//  Created by Erkut Baş on 9/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

let contentSize = CollectionViewConstants()

class CollectionViewConstants {
    
    static let sectionInsetsTop : CGFloat = 15
    static let sectionInsetsBottom : CGFloat = 15
    
    static let minSpaceForCell : CGFloat = 10
    static let minSpaceForRow : CGFloat = 10
    
    static let itemHeight : CGFloat = 100
    
    private var _contentSizeOfCell : CGFloat!
    
    var contentSizeOfCell: CGFloat {
        get {
            return _contentSizeOfCell
        }
        set {
            _contentSizeOfCell = newValue
        }
    }
    
    func calculateContentSizeForTableRowHeight(inputItemCount : Int) -> CGFloat {
        
        var result : CGFloat = 0
        
        if inputItemCount % 3 == 0 {
            
            result = CollectionViewConstants.sectionInsetsTop + (CollectionViewConstants.itemHeight * CGFloat((inputItemCount / 3))) + (CGFloat(inputItemCount / 3) * CollectionViewConstants.minSpaceForRow)
            
        } else {
            
            let roundedValue = Int(inputItemCount / 3) + 1
            
            result = CollectionViewConstants.sectionInsetsTop + (CollectionViewConstants.itemHeight * CGFloat(roundedValue)) + (CGFloat(roundedValue) * CollectionViewConstants.minSpaceForRow)
            
        }
        
        return result
    }
    
}
