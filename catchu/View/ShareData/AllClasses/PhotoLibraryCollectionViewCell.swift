//
//  PhotoLibraryCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var containerViewTrailignConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIViewDesign!
    @IBOutlet var image: UIImageView!
    @IBOutlet var imageTrailing: NSLayoutConstraint!
    @IBOutlet var imageBottom: NSLayoutConstraint!
    @IBOutlet var imageTop: NSLayoutConstraint!
    @IBOutlet var imageLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupTapGestureRecognizer()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.6
        
        image.image = UIImage(named: "gallery")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    func setConstraints(inputSize : CGFloat) {
        
        let x = (inputSize - containerViewTrailignConstraint.constant) / 3
        
        imageTop.constant = x
        imageBottom.constant = x
        imageLeading.constant = x
        imageTrailing.constant = x
        
    }
    
    
}

extension PhotoLibraryCollectionViewCell : UIGestureRecognizerDelegate {
    
    func setupTapGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoLibraryCollectionViewCell.openGallery(_:)))
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openGallery(_ sender : UITapGestureRecognizer) {
        
        ImageVideoPickerHandler.shared.getPictureByGalery()
        
    }
    
}
