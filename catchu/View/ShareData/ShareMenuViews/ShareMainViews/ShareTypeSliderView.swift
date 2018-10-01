//
//  ShareTypeSliderView.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ShareTypeSliderView: UIView {

    @IBOutlet var shareTypeCollectionView: UICollectionView!
    @IBOutlet var sliderContainerView: UIView!
    @IBOutlet var sliderObject: UIView!
    
    @IBOutlet var sliderWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sliderLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var closeView: UIImageView!
    
    let sliderImageArray = ["edit", "gallery", "play-button"]
    
    weak var delegate : ShareDataProtocols!
    weak var delegateForFunction : ShareDataProtocols!
    weak var delegateForViewController : ShareDataProtocols!
    
    var selectedIndexPath = IndexPath()
    
    func initialize() {
        
        self.backgroundColor = UIColor.clear
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
//        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.shareTypeCollectionView.delegate = self
        self.shareTypeCollectionView.dataSource = self
        self.shareTypeCollectionView.isPrefetchingEnabled = false
        
        // setup view settings
        setCollectionViewSettings()
        setWidthForSliderObject()
        addGestureRecognizerToCloseView()
        
    }
    
}

// MARK: - ShareDataProtocols
extension ShareTypeSliderView : ShareDataProtocols {
    
    func resizeShareTypeSliderConstraint(input: CGFloat) {
        
        let divider = UIScreen.main.bounds.size.width / (shareTypeCollectionView.contentSize.width / 3)
        
        sliderLeadingConstraint.constant = (input) / divider
        
    }
    
    func selectSliderTypeCell(inputIndexPath: IndexPath) {
        
        shareTypeCollectionView.selectItem(at: inputIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
}

// MARK: - Major functions
extension ShareTypeSliderView {
    
    private func setCollectionViewSettings() {
        
        shareTypeCollectionView.backgroundColor = UIColor.clear
        
    }
    
    private func setWidthForSliderObject() {
        
        print("calculateCellSize : \(calculateCellSize())")
        
        sliderObject.frame.size.width = calculateCellSize()
        sliderWidthConstraint.constant = calculateCellSize()
        
        print("sliderObject.frame.width : \(String(describing: sliderObject.frame.width))")
        
    }
    
}


// MARK: - CollectionView
extension ShareTypeSliderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: calculateCellSize(), height: self.shareTypeCollectionView.frame.height)
        
        
    }
    
    private func calculateCellSize() -> CGFloat {
        
//        let deviceWidthSize = UIScreen.main.bounds.width
        let deviceWidthSize = delegate.returnSliderWidth()
        
        print("deviceWidthSize : \(String(describing: deviceWidthSize))")
        
        return (deviceWidthSize - 88) / 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = shareTypeCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.sliderShareTypeCell, for: indexPath) as? ShareTypeSliderCollectionViewCell else { return UICollectionViewCell() }
        
        cell.shareTypeImage.image = UIImage(named: sliderImageArray[indexPath.row])?.withRenderingMode(.alwaysTemplate)
//        cell.shareTypeImage.tintColor = UIColor.white
        
//        cell.shareTypeLabel.text = "Type" + "\(String(describing: indexPath.row))"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didselect for shareTypeSliderCollectionView")
        
//        delegateForFunction.selectFunctionCell2(indexPath: indexPath)
        delegateForFunction.forceScrollMenuScrollView(selectedMenuIndex: indexPath.row)
        delegateForFunction.customVideoViewSessionManagement(inputIndex: indexPath.row)
        
    }
    
    // to call function from controller, make it public
    public func didSelectFirstCellForInitial() {
        
        print("didSelectFirstCellForInitial starts")
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        shareTypeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
}

extension ShareTypeSliderView : UIGestureRecognizerDelegate {

    func addGestureRecognizerToCloseView() {
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareTypeSliderView.closeView(_:)))
        tapGestureRecognizer.delegate = self
        closeView.isUserInteractionEnabled = true
        closeView.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        
        delegateForViewController.dismisViewController()
        
    }
    
}


