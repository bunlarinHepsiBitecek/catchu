//
//  MenuBar4CollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MenuBar4CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var menubarTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        menubarTitle.textColor = UIColor.white
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            menubarTitle.textColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menubarTitle.textColor = isSelected ? UIColor.black : UIColor.white
        }
    }
    
}
