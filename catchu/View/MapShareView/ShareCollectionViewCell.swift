//
//  ShareCollectionViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ShareCollectionViewCell: UICollectionViewCell {
    
    //  MARK: outlets
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:
    public var originalImage: UIImage!
    public var originalImageSmall: UIImage!
    
    override var isSelected: Bool {
        didSet{
            selectionView.isHidden = isSelected ? false : true
            if !isSelected {
                self.originalImage = nil
                self.originalImageSmall = nil
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.imageView != nil {
            imageView.image = nil
        }
        if self.originalImage != nil {
            self.originalImage = nil
        }
        if self.originalImageSmall != nil {
            self.originalImageSmall = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewConfigurations()
    }
    
    private func viewConfigurations(){
        selectionView.layer.borderWidth = 2
        selectionView.layer.borderColor = UIColor.clear.cgColor
        selectionView.isHidden = true
    }
    
    func populateDataWith(asset:PHAsset) {
        MediaLibraryManager.shared.imageFrom(asset: asset, size: Constants.MediaLibrary.ImageHolderSize) { (image) in
        
        DispatchQueue.main.async {
                if self.imageView != nil{
                    self.imageView.image = image
                }
            }
        }
    }
    
    func getOriginalImageFromLibrary(asset:PHAsset) {
        MediaLibraryManager.shared.imageFrom(asset: asset, size: PHImageManagerMaximumSize) { (image) in
            DispatchQueue.main.async {
                self.originalImage = image
            }
        }
        
        MediaLibraryManager.shared.imageFrom(asset: asset, size: Constants.MediaLibrary.ImageSmallSize) { (image) in
            DispatchQueue.main.async {
                self.originalImageSmall = image
            }
        }
    }
    
    
}
