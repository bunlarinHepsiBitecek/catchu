//
//  SlidingView4.swift
//  catchu
//
//  Created by Erkut Baş on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

let colourArray : [UIColor] = [UIColor.black, UIColor.red, UIColor.gray, UIColor.brown]

class SlidingView4: UIView {

    @IBOutlet var slidingCollectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    lazy var referenceOfMenubar4 = MenuBar4()
    
    var activePageIndexPath : IndexPath!

    func initialize() {
        
        self.slidingCollectionView.delegate = self
        self.slidingCollectionView.dataSource = self
        
    }
    
    
    // resize islemi ne yazikki reload gerektiren bir duruma surukluyor bizi
    func resizeFlowLayoutItem(inputSize : CGFloat) {
        
        print("resizeFlowLayoutItem starts")
        print("inputSize : \(inputSize)")
        
        flowLayout.itemSize = CGSize(width: self.frame.width, height: inputSize)
        slidingCollectionView.reloadData()
        
    }
    
}

extension SlidingView4: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == Constants.NumberOrSections.section0 {
            guard let cell = slidingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataPageCell1, for: indexPath) as? DataPage1CollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else if indexPath.row == Constants.NumberOrSections.section1 {
            guard let cell = slidingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataPageCell2, for: indexPath) as? DataPage2CollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else if indexPath.row == Constants.NumberOrSections.section2 {
            guard let cell = slidingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataPageCell3, for: indexPath) as? DataPage3CollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else if indexPath.row == Constants.NumberOrSections.section3 {
            guard let cell = slidingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewDataPageCell4, for: indexPath) as? DataPage4CollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
        return UICollectionViewCell()
        
    }
    
    func startFirstCellProcess(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let cell = slidingCollectionView.dequeueReusableCell(withReuseIdentifier: "slidingCell", for: indexPath) as? SlidingView4CollectionViewCell else { return UICollectionViewCell() }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width, height: self.frame.height)
        
    }
    
    func scrollCollectionViewToIndex(inputMenuIndex : Int) {
        
        let scrollIndex = IndexPath(item: inputMenuIndex, section: 0)
        
        slidingCollectionView.scrollToItem(at: scrollIndex, at: .centeredHorizontally, animated: true)
        
    }
    
    
}

// sliding functions
extension SlidingView4 {
    
    // collectionview scroll ederken asagidaki function daima call edilir.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("----> :\(scrollView.contentOffset.x)")
        
        referenceOfMenubar4.testForReferenceConnection()
        referenceOfMenubar4.changeSlidingBarConstraints(input: scrollView.contentOffset.x)
        
    }
    
    // sliding page ile menubardaki collection view cell in selected higlihted secenegini yonetmek icin kullanacagiz
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("****> :\(targetContentOffset.pointee.x)")
        
        let index = targetContentOffset.pointee.x / self.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        activePageIndexPath = indexPath
        
        referenceOfMenubar4.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
    func returnActiveIndexPath() -> IndexPath {
        return activePageIndexPath
    }
    
}
