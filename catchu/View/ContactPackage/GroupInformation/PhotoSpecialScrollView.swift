
//  PhotoSpecialScrollView.swift
//  Project Version 0_1
//
//  Created by Erkut Baş on 19.02.2018.
//  Copyright © 2018 Erkut Baş. All rights reserved.
//

import UIKit

class PhotoSpecialScrollView : UIScrollView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewConfigurations()
        
    }
    
    var imageView : UIImageView = UIImageView()
    
    var imageToDisplay : UIImage? = nil {
        
        didSet{
        
            zoomScale = 1.0
            minimumZoomScale = 1.0
            imageView.image = imageToDisplay
            imageView.frame.size = sizeForImageToDisplay()
            imageView.center = center
            contentSize = imageView.frame.size
            contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            
            self.contentOffset.x = 0
            self.contentOffset.y = 0
            
            updateLayout()
            
        }
    }
//    var gridView:UIView = Bundle.main.loadNibNamed("GridView", owner: nil, options: nil)?.first as! UIView
    
    //var gridView = GridViewStructure()
    
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
    
    func updateLayout() {
        imageView.center = center;
        var frame:CGRect = imageView.frame;
        if (frame.origin.x < 0) { frame.origin.x = 0 }
        if (frame.origin.y < 0) { frame.origin.y = 0 }
        imageView.frame = frame
    }
    
    private func viewConfigurations(){
        
        //clipsToBounds = false;
        clipsToBounds = true;
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        bouncesZoom = true
        decelerationRate = UIScrollViewDecelerationRateFast
        delegate = self
        maximumZoomScale = 5.0
        addSubview(imageView)
        
//        gridView.frame = frame
//        gridView.isHidden = true
//        gridView.isUserInteractionEnabled = false
//        addSubview(gridView)
    }
    
    
    private func zoomScaleWithNoWhiteSpaces() -> CGFloat{
        
        let imageViewSize:CGSize  = imageView.bounds.size
        let scrollViewSize:CGSize = bounds.size;
        let widthScale:CGFloat  = scrollViewSize.width / imageViewSize.width
        let heightScale:CGFloat = scrollViewSize.height / imageViewSize.height
        return max(widthScale, heightScale)
    }

    
}

extension PhotoSpecialScrollView : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        /*
        if scrollView.zoomScale > 1 {
            
            if let image = imageView.image {
                
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW:ratioH
                
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }*/
        
        updateLayout()
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        gridView.isHidden = false
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        gridView.isHidden = true
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        var frame:CGRect = gridView.frame;
//        frame.origin.x = scrollView.contentOffset.x
//        frame.origin.y = scrollView.contentOffset.y
//        gridView.frame = frame
//        
//        switch scrollView.pinchGestureRecognizer!.state {
//        case .changed:
//            gridView.isHidden = false
//            break
//        case .ended:
//            gridView.isHidden = true
//            break
//        default: break
//        }
//        
//    }
    
}

