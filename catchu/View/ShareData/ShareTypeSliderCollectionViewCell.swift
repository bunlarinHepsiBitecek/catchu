//
//  ShareTypeSliderCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareTypeSliderCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet var shareTypeLabel: UILabel!
    
    @IBOutlet var shareTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        shareTypeImage.image = UIImage(named: "edit.png")?.withRenderingMode(.alwaysTemplate)
//        shareTypeImage.image!.withRenderingMode(.alwaysTemplate)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            
            shareTypeImage.tintColor = isHighlighted ? UIColor.black : UIColor.white
//            self.backgroundColor = isHighlighted ? UIColor.black : UIColor.white
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            shareTypeImage.tintColor = isSelected ? UIColor.black : UIColor.white
//            self.backgroundColor = isSelected ? UIColor.black : UIColor.white
            
        }
    }
    
    
}
