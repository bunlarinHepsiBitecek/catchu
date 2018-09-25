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
    
    private var tempIndexPath : IndexPath?
    
    func initialize() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.functionCollectionView.layer.cornerRadius = 7
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.functionCollectionView.delegate = self
        self.functionCollectionView.dataSource = self
        
        self.functionCollectionView.allowsMultipleSelection = true
        self.functionCollectionView.allowsSelection = true
        self.functionCollectionView.isMultipleTouchEnabled = true
        self.functionCollectionView.isPrefetchingEnabled = false
        
    }
    
    
}

// MARK: - Major functions
extension ShareFunctionSliderView {
    
    func disableCameraSession() {
        
        print("disableCameraSession starts")
        
        let indexPath = IndexPath(item: 1, section: 0)
        
        guard let cell = functionCollectionView.cellForItem(at: indexPath) as? CameraGalleryCollectionViewCell else {
            return
        }
        
        cell.stopCameraSession()
        
    }
    
    func disableVideoSession() {
        
        print("disableVideoSession starts")
        
        let indexPath = IndexPath(item: 2, section: 0)
        
        guard let cell = functionCollectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell else { return }
        
    }
    
    func shareFunctionScreenOperationManagement(indexPath : IndexPath) {
        
        print("shareFunctionScreenOperationManagement starts")
        print("indexPath : \(indexPath.row)")
        
        functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
    }
}


// MARK: - ShareDataProtocols
extension ShareFunctionSliderView : ShareDataProtocols {
    
    func selectFunctionCell2(indexPath: IndexPath) {
        
        print("selectFunctionCell2 triggered")

        DispatchQueue.main.async {
            //        functionCollectionView.deselectItem(at: indexPath, animated: false)
            self.functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.functionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            let cell = self.functionCollectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell
            
//            guard let cell = self.functionCollectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell else { return }
            
            print("cell : \(cell)")
            
        }
        
        
    }
    
    func selectFunctionCell(inputIndex: Int) {
        
        print("selectFunctionCell triggered")
        
        let indexPath = IndexPath(item: inputIndex, section: 0)
        
        print("indexPath : \(indexPath)")
        
        // eger animated false yapmazsan animated olarak scroll ettigi icin 3. cell i de yukluyor
//        functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//        functionCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//        functionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
    func selectFunctionCell2(inputIndex: Int, complete : @escaping(_ finished : Bool) -> Void) {
        
        print("selectFunctionCell triggered")
        
        let indexPath = IndexPath(item: inputIndex, section: 0)
        
        // eger animated false yapmazsan animated olarak scroll ettigi icin 3. cell i de yukluyor
        //        functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        //        functionCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        functionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        complete(true)
        
    }
    
    
    func closeCameraOperations() {
        print("closeCameraOperations starts")
        
        disableCameraSession()
        
    }
    
    func closeVideoOperations() {
        print("closeVideoOperations starts")
    }
    
}

extension ShareFunctionSliderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
            
            cell.delegate = self
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == 2 {
            print("boko boko boko")

            functionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            
            let cell = self.functionCollectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell
            
            print("cell : \(cell)")
            

        }

    }
    
    
    
    
}

// for sliding operations
extension ShareFunctionSliderView {
    
    // collectionview scroll ederken asagidaki function daima call edilir.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate.resizeShareTypeSliderConstraint(input: scrollView.contentOffset.x)
        
    }
    
    // sliding page ile menubardaki collection view cell in selected higlihted secenegini yonetmek icin kullanacagiz
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("ShareFunctionSliderView scrollViewWillEndDragging triggered")
        
        let index = targetContentOffset.pointee.x / self.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        print("indexPath item : \(indexPath.item)")
        
        delegate.selectSliderTypeCell(inputIndexPath: indexPath)
        
        shareFunctionScreenOperationManagement(indexPath : indexPath)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("yakaladik ")
        
        
        
    }
    
}
