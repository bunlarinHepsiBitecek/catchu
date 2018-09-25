//
//  ImageCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageSelected: UIImageView!
    @IBOutlet var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var selectedView: UIView!
//    @IBOutlet var selectedIconTrailing: NSLayoutConstraint!
//    @IBOutlet var selectedIconBottom: NSLayoutConstraint!
//    @IBOutlet var selectedIconTop: NSLayoutConstraint!
//    @IBOutlet var selectedIconLeading: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.6
        
        imageSelected.image = UIImage(named: "imageSelected")?.withRenderingMode(.alwaysTemplate)
        imageSelected.tintColor = UIColor.clear
        imageSelected.contentMode = .scaleToFill
        
        selectedView.layer.cornerRadius = 10
        
    }
    
    func setConstraints(inputSize : CGFloat) {
        
//        let x = (inputSize - containerViewLeadingConstraint.constant) / 3
//        
//        selectedIconTop.constant = x
//        selectedIconBottom.constant = x
//        selectedIconLeading.constant = x
//        selectedIconTrailing.constant = x
        
    }
    
    func setImage(asset : PHAsset) {
        
        MediaLibraryManager.shared.imageFrom(asset: asset, size: imageView.frame.size) { (image) in
            
            DispatchQueue.main.async {
                
                self.imageView.image = image
                
            }
            
        }
        
    }
    
}
