//
//  MenuBar4.swift
//  catchu
//
//  Created by Erkut Baş on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MenuBar4: UIView {

    @IBOutlet var menuBarCollectionView: UICollectionView!
    @IBOutlet var menuBarSliderContainer: UIView!
    @IBOutlet var menubarSlider: UIView!
    
    @IBOutlet var menubarSliderLeadingConstraints: NSLayoutConstraint!
    
    // reference lazy tanımlamassan UICollectionView init edemez view, Thread 1: EXC_BAD_ACCESS (code=2, address=0x7ffeeaa39ea8)
    lazy var referenceOfSlidingView4 = SlidingView4()
    
    func initialize() {
        
        self.menuBarCollectionView.delegate = self
        self.menuBarCollectionView.dataSource = self
        
        self.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        menuBarCollectionView.backgroundColor = UIColor.clear
        menuBarSliderContainer.backgroundColor = UIColor.clear
//        menubarSlider.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        menubarSlider.backgroundColor = UIColor.black
        menubarSlider.tintColor = UIColor.white
        
    }
    
    func testForReferenceConnection() {
        
        print("erisebildik")
        
    }
    
    func changeSlidingBarConstraints(input : CGFloat) {
        
        menubarSliderLeadingConstraints.constant = input / 4
        
    }
    
}

extension MenuBar4: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: "menubarCell", for: indexPath) as? MenuBar4CollectionViewCell else { return UICollectionViewCell() }
        
        cell.menubarTitle.text = "menu " + String(describing: indexPath.row)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // asagıdaki kısmı yorum satırına aldık, cunku slidingView4 içerisindeki collectionview a ait olan scrollview functionları menubar item a ait olan constraints i set ediyor
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        menubarSliderLeadingConstraints.constant = x
//
//        UIView.animate(withDuration: 0.2 ) {
//            self.layoutIfNeeded()
//        }

        referenceOfSlidingView4.scrollCollectionViewToIndex(inputMenuIndex: indexPath.item)
        
        referenceOfSlidingView4.slidingCollectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    func setFirstItemSelected() {
        
        let indexPath = IndexPath(item: 0, section: 0)
        self.menuBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)

//        menuBarCollectionView.performBatchUpdates(nil) { (result) in
//            if result {
//
//            }
//        }
        
        
    }
    
}
