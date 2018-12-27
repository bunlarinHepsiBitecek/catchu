//
//  GroupCreationCellSizeCalculator.swift
//  catchu
//
//  Created by Erkut Baş on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupCreationCellSizeCalculator {
    
    public static var shared = GroupCreationCellSizeCalculator()
    
    static let sectionInsetsTop : CGFloat = Constants.StaticViewSize.ConstraintValues.constraint_15
    static let sectionInsetsBottom : CGFloat = Constants.StaticViewSize.ConstraintValues.constraint_15
    
    static let minSpaceForCell : CGFloat = Constants.StaticViewSize.ConstraintValues.constraint_10
    static let minSpaceForRow : CGFloat = Constants.StaticViewSize.ConstraintValues.constraint_10
    
    static let itemHeight : CGFloat = Constants.StaticViewSize.ViewSize.Height.height_100
    static let itemWidth : CGFloat = Constants.StaticViewSize.ViewSize.Width.width_100
    
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
        print("\(#function)")
        var result : CGFloat = 0
        
        if inputItemCount % Constants.Cell.numberOfItemPerRow_3 == 0 {
            
            result = CollectionViewConstants.sectionInsetsTop + (CollectionViewConstants.itemHeight * CGFloat((inputItemCount / Constants.Cell.numberOfItemPerRow_3))) + (CGFloat(inputItemCount / Constants.Cell.numberOfItemPerRow_3) * CollectionViewConstants.minSpaceForRow)
            
        } else {
            
            let roundedValue = Int(inputItemCount / Constants.Cell.numberOfItemPerRow_3) + 1
            
            result = CollectionViewConstants.sectionInsetsTop + (CollectionViewConstants.itemHeight * CGFloat(roundedValue)) + (CGFloat(roundedValue) * CollectionViewConstants.minSpaceForRow)
            
        }
        
        print("result : \(result)")
        
        
        return result
    }
    
}
