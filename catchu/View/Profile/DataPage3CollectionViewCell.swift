//
//  DataPage3CollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DataPage3CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var item3CollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.item3CollectionView.delegate = self
        self.item3CollectionView.dataSource = self
        
    }
    
}

extension DataPage3CollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = item3CollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataItemCell3, for: indexPath) as? Item3CollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
}
