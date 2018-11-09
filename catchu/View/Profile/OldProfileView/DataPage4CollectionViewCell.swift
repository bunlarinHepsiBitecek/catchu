//
//  DataPage4CollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DataPage4CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var item4CollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.item4CollectionView.delegate = self
        self.item4CollectionView.dataSource = self
        
    }
    
}

extension DataPage4CollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = item4CollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataItemCell4, for: indexPath) as? Item4CollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return CGSize(width: self.frame.width, height: self.frame.height)
        return CGSize(width: self.frame.width, height: 381)
        
    }
    
    
    
}

