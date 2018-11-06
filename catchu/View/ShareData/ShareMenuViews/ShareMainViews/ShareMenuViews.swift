//
//  ShareMenuViews.swift
//  catchu
//
//  Created by Erkut Baş on 9/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareMenuViews: UIView {

    @IBOutlet var mainScrollView: UIScrollView!
    
    weak var delegate : ShareDataProtocols!
    
    private var customVideoMenu : VideoMenuView?
    private var customTextMenu : TextMenuView?
    private var customCameraGalleryMenu : CameraGalleryMenuView?
    
    func initialize() {
        // we need something to do
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layoutSubviews starts")
        
        setupSlideScrollView()
        
    }
    
}

// MARK: - major functions
extension ShareMenuViews {
    
    func setupSlideScrollView() {
        
        print("setupSlideScrollView")
        print("self.frame.width : \(self.frame.width)")
        print("self.frame.height : \(self.frame.height)")
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        mainScrollView.contentSize = CGSize(width: self.frame.width * CGFloat(2), height: self.frame.height)
        mainScrollView.isPagingEnabled = true
        mainScrollView.backgroundColor = UIColor.black
        
        let safe = self.safeAreaLayoutGuide
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        mainScrollView.heightAnchor.constraint(equalTo: safe.heightAnchor).isActive = true
        //        mainScrollView.heightAnchor.constraint(equalTo: safe.heightAnchor).isActive = true
        
        //        setupViews()
        
        configureSubviewsFrames()
        
    }
    
    func setupViews() {
        
        print("setupViews starts")
        print("self.frame.width : \(self.frame.width)")
        print("self.frame.height : \(self.frame.height)")
        
    }
    
    func configureSubviewsFrames() {
        
//        setupTextViewFrame()
        setupCameraGalleryMenuViewFrame()
        setupVideoMenuViewFrame()
        
        addMenuViews()
        
    }
    
    func setupTextViewFrame() {
        
        customTextMenu = TextMenuView(frame: CGRect(x: self.frame.width * 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        guard customTextMenu != nil else {
            return
        }
        
        customTextMenu!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    func setupCameraGalleryMenuViewFrame() {
        
//        customCameraGalleryMenu = CameraGalleryMenuView(frame: CGRect(x: self.frame.width * 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        // to use override protocol funtions of this view itself
        // specials functions for view
        customCameraGalleryMenu = CameraGalleryMenuView(frame: CGRect(x: self.frame.width * 0, y: 0, width: self.frame.width, height: self.frame.height), inputDelegate: self)
        
        guard customCameraGalleryMenu != nil else {
            return
        }
        
        //        customCameraGalleryMenu!.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
    }
    
    func setupVideoMenuViewFrame() {
        
        customVideoMenu = VideoMenuView(frame: CGRect(x: self.frame.width * 1, y: 0, width: self.frame.width, height: self.frame.height), delegate : self)
        
        guard customVideoMenu != nil else {
            return
        }
        
        customVideoMenu!.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
    }
    
    func addMenuViews() {
        
//        mainScrollView.addSubview(customTextMenu!)
        mainScrollView.addSubview(customCameraGalleryMenu!)
        mainScrollView.addSubview(customVideoMenu!)
        
    }
    
    private func menuViewCoordination(activeIndex : Int) {
        
        // it means video view is activated
        if activeIndex == 1 {
            customVideoViewCaptureManagement()
            keyboardManagementOfTextMenuView(active: false)
            
        } else if activeIndex == 0 {
            // it means that camera gallery view is activated
            keyboardManagementOfTextMenuView(active: false)
        
        }
        
//        else if activeIndex == 0 {
//            keyboardManagementOfTextMenuView(active: true)
//        }
        
    }
    
    private func customVideoViewCaptureManagement() {
    
        // close camera session if it's running
        disableCameraSession()
        /*
        guard customCameraGalleryMenu != nil else {
            return
        }
        
        customCameraGalleryMenu!.checkIfCustomCameraSessionActive()
        */
        
        // start camera session if it's stopping
        guard customVideoMenu != nil else {
            return
        }
        
        customVideoMenu!.startVideoProcess()
        
    }
    
    private func keyboardManagementOfTextMenuView(active : Bool) {
        
        guard customTextMenu != nil else {
            return
        }
        
        if active {
            customTextMenu!.focusTextView()
        } else {
            customTextMenu!.stopFocusingTextView()
        }
        
    }
    
    private func disableCameraSession() {
        
        // close camera session if it's running
        guard customCameraGalleryMenu != nil else {
            return
        }
        
        customCameraGalleryMenu!.checkIfCustomCameraSessionActive()
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension ShareMenuViews : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
        delegate.resizeShareTypeSliderConstraint(input: scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("scrollViewWillEndDragging")
        
        print("targetContentOffset : \(targetContentOffset.pointee.x)")
        
        let index = targetContentOffset.pointee.x / self.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        print("indexPath item : \(indexPath.item)")
        
        delegate.selectSliderTypeCell(inputIndexPath: indexPath)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / self.frame.width
        
        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
        print("scrollViewDidEndDecelerating")
        print("index :\(index)")
        
        menuViewCoordination(activeIndex : Int(index))
        
    }
    
}

extension ShareMenuViews : ShareDataProtocols {
    
    func forceScrollMenuScrollView(selectedMenuIndex: Int) {
        
        print("forceScrollMenuScrollView starts")
        print("selectedMenuIndex : \(selectedMenuIndex)")
        mainScrollView.scrollRectToVisible(CGRect(x: self.frame.width * CGFloat(selectedMenuIndex), y: 0, width: self.frame.width, height: self.frame.height), animated: true)
        
    }
    
    func customVideoViewSessionManagement(inputIndex : Int) {
        
        menuViewCoordination(activeIndex: inputIndex)
        
    }
    
    func scrollableManagement(enabled: Bool) {
        if enabled {
            self.mainScrollView.isScrollEnabled = true
        } else {
            self.mainScrollView.isScrollEnabled = false
        }
    }
    
    func closeCameraOperations() {
        
        print("closeCameraOperations starts")
        disableCameraSession()
        
    }
    
    func createSnapShotProcess() {
        
        if customCameraGalleryMenu != nil {
            customCameraGalleryMenu!.callCreationOfSnapShot()
        }
        
    }
    
    func checkAlphaValuesOfCustomEmbeddedViews() {
        
        if customCameraGalleryMenu != nil {
            customCameraGalleryMenu!.getActiveCustomView()
        }
        
    }
    
}

