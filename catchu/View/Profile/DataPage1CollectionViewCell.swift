//
//  DataPage1CollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

// the cell below contains a collectioView inside
class DataPage1CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var item1CollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.item1CollectionView.delegate = self
        self.item1CollectionView.dataSource = self
    }
    
}

extension DataPage1CollectionViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 60
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = item1CollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataItemCell1, for: indexPath) as? Item1CollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
    
    
    
}
