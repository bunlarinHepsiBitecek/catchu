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
    
    weak var delegate : ShareDataProtocols!
    weak var delegateForShareDataView : ShareDataProtocols!
    
    func initialize() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.functionCollectionView.layer.cornerRadius = 7
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
        self.functionCollectionView.allowsMultipleSelection = false
        self.functionCollectionView.isMultipleTouchEnabled = false
        
    }
    
}


// MARK: - ShareDataProtocols
extension ShareFunctionSliderView : ShareDataProtocols {
    
    func selectFunctionCell(inputIndex: Int) {
        
        let indexPath = IndexPath(item: inputIndex, section: 0)
        
        // eger animated false yapmazsan animated olarak scroll ettigi icin 3. cell i de yukluyor
//        functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        functionCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        
    }
    
}

extension ShareFunctionSliderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = functionCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.textCell, for: indexPath) as? TextCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else if indexPath.row == 1 {
            
            guard let cell = functionCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.cameraGalleryCell, for: indexPath) as? CameraGalleryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.delegateForShareType  = self.delegate
            cell.delegate = self.delegateForShareDataView
            
            return cell
            
        } else if indexPath.row == 2 {
            
            guard let cell = functionCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.videoCell, for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height)
        
    }
    
}

// for sliding operations
extension ShareFunctionSliderView {
    
    // collectionview scroll ederken asagidaki function daima call edilir.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print("----> :\(scrollView.contentOffset.x)")
        
//        referenceOfMenubar4.testForReferenceConnection()
        
        delegate.resizeShareTypeSliderConstraint(input: scrollView.contentOffset.x)
        
//        referenceOfMenubar4.changeSlidingBarConstraints(input: scrollView.contentOffset.x)
        
    }
    
    // sliding page ile menubardaki collection view cell in selected higlihted secenegini yonetmek icin kullanacagiz
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("****> :\(targetContentOffset.pointee.x)")
        print("self.frame.width : \(self.frame.width)")
        
        let index = targetContentOffset.pointee.x / self.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        delegate.selectSliderTypeCell(inputIndexPath: indexPath)
        
    }
    
//    func returnActiveIndexPath() -> IndexPath {
////        return activePageIndexPath
//        return
//    }
    
}
