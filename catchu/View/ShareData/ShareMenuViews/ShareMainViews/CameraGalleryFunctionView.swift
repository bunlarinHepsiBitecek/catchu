//
//  CameraGalleryFunctionView.swift
//  catchu
//
//  Created by Erkut Baş on 9/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CameraGalleryFunctionView: UIView {

    @IBOutlet var collectionView: UICollectionView!
 
    func initialize() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.collectionView.layer.cornerRadius = 7
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.allowsSelection = false
        self.collectionView.isMultipleTouchEnabled = false
        self.collectionView.isPrefetchingEnabled = false
        
    }
    

}

extension CameraGalleryFunctionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
        
    }
    
    
    
}
