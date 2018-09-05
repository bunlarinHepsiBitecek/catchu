//
//  ShareFunctionSliderView.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareFunctionSliderView: UIView {

    @IBOutlet var functionCollectionView: UICollectionView!
    
    func initialize() {
        
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
    }
    
}

extension ShareFunctionSliderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = functionCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.shareFunctionCell, for: indexPath) as? ShareFunctionCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = UIColor.red
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
    }
    
    
    
}
