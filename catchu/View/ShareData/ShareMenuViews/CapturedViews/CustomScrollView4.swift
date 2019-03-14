//
//  CustomScrollView4.swift
//  catchu
//
//  Created by Erkut Baş on 10/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomScrollView4: UIScrollView {
    
    // MARK: Class properties
    
    weak var delegateShareData : ShareDataProtocols!
    
    var imageView:UIImageView = UIImageView()
    var imageToDisplay:UIImage? = nil{
        didSet{
            zoomScale = 1.0
            minimumZoomScale = 1.0
            imageView.image = imageToDisplay
            imageView.frame.size = sizeForImageToDisplay()
            imageView.center = center
            contentSize = imageView.frame.size
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            updateLayout()
        }
    }
//    var gridView:UIView = Bundle.main.loadNibNamed("FAGridView", owner: nil, options: nil)?.first as! UIView
    
    
    // MARK : Class Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfigurations()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        imageView.center = center;
        var frame:CGRect = imageView.frame;
        if (frame.origin.x < 0) { frame.origin.x = 0 }
        if (frame.origin.y < 0) { frame.origin.y = 0 }
        imageView.frame = frame
        
    }
    
    func zoom() {
        if (zoomScale <= 1.0) { setZoomScale(zoomScaleWithNoWhiteSpaces(), animated: true) }
        else{ setZoomScale(minimumZoomScale, animated: true) }
        updateLayout()
    }
    
    
    
    // MARK: Private Functions
    
    private func viewConfigurations(){
        
        clipsToBounds = false;
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
        maximumZoomScale = 5.0
        addSubview(imageView)
        
//        gridView.frame = frame
//        gridView.isHidden = true
//        gridView.isUserInteractionEnabled = false
//        addSubview(gridView)
    }
    
    private func sizeForImageToDisplay() -> CGSize{
        
        var actualWidth:CGFloat = imageToDisplay!.size.width
        var actualHeight:CGFloat = imageToDisplay!.size.height
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = frame.size.width/frame.size.height
        
        if imgRatio != maxRatio{
            if(imgRatio < maxRatio){
                imgRatio = frame.size.height / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = frame.size.height
            }
            else{
                imgRatio = frame.size.width / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = frame.size.width
            }
        }
        else {
            imgRatio = frame.size.width / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = frame.size.width
        }
        
        return  CGSize(width: actualWidth, height: actualHeight)
    }
    
    private func zoomScaleWithNoWhiteSpaces() -> CGFloat{
        
        let imageViewSize:CGSize  = imageView.bounds.size
        let scrollViewSize:CGSize = bounds.size;
        let widthScale:CGFloat  = scrollViewSize.width / imageViewSize.width
        let heightScale:CGFloat = scrollViewSize.height / imageViewSize.height
        return max(widthScale, heightScale)
    }
    
    func zoomOrijinalSize() {
        if (zoomScale <= 1.0) { setZoomScale(zoomScaleWithNoWhiteSpaces(), animated: true) }
        else{ setZoomScale(minimumZoomScale, animated: true) }
        updateLayout()
    }
    
}

// MARK: - UIScrollViewDelegate
extension CustomScrollView4 : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateLayout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollViewDidScroll")
        
        print("scrollView.pinchGestureRecognizer : \(scrollView.pinchGestureRecognizer)")
        
        guard let state = scrollView.pinchGestureRecognizer?.state else { return }
        
        print("state : \(state.rawValue)")
        print("check 1")
        
        switch state {
        case .changed:
            print("check 2")
            delegateShareData.gridViewTriggerManagement(hidden: false)
        case .ended:
            print("check 3")
            delegateShareData.gridViewTriggerManagement(hidden: true)
        default:
            print("check 4")
            break
        }
        
        print("check 5")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        delegateShareData.gridViewTriggerManagement(hidden: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        delegateShareData.gridViewTriggerManagement(hidden: false)
    }
    
}
