//
//  CustomScrollView.swift
//  catchu
//
//  Created by Erkut Baş on 9/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

    private let imageView = UIImageView()
    
    private var imageViewTopConstraint = NSLayoutConstraint()
    private var imageViewBottomConstraint = NSLayoutConstraint()
    private var imageViewLeadingConstraint = NSLayoutConstraint()
    private var imageViewTrailingConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(image : UIImage) {

        super.init(frame: .zero)

        imageView.image = image
        imageView.sizeToFit()
        addSubview(imageView)
        
        self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([imageViewTopConstraint, imageViewBottomConstraint, imageViewLeadingConstraint, imageViewTrailingConstraint])

        contentInsetAdjustmentBehavior = .never // Adjust content according to safe area if necessary
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        delegate = self

    }
    
    // MARK: - Helper methods
    
    func setZoomScale() {
        let widthScale = frame.size.width / imageView.bounds.width
        let heightScale = frame.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
    }
    
}

extension CustomScrollView : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let yOffset = max(0, (bounds.size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (bounds.size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        layoutIfNeeded()
        
    }
    
    
    
}
