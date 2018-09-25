//
//  CustomCapturedMainBackground.swift
//  catchu
//
//  Created by Erkut Baş on 9/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomCapturedMainBackground: UIView {

    private let capturedImage = UIImageView()
    
    lazy var imageContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    required init(image : UIImage, cameraPosition : CameraPosition) {
        super.init(frame: .zero)
        
        setupMajorViews(image : image, cameraPosition : cameraPosition)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomCapturedMainBackground {
    
    func setupMajorViews(image : UIImage, cameraPosition : CameraPosition) {
        
        switch cameraPosition {
        case .front:
            capturedImage.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
        case .rear:
            capturedImage.image = image
        }
        
        self.addSubview(imageContainer)
        self.imageContainer.addSubview(capturedImage)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFill
        
        let safe = self.safeAreaLayoutGuide
        let safeImageContainer = self.imageContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            imageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            imageContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            
            capturedImage.leadingAnchor.constraint(equalTo: safeImageContainer.leadingAnchor),
            capturedImage.trailingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor),
            capturedImage.bottomAnchor.constraint(equalTo: safeImageContainer.bottomAnchor),
            capturedImage.topAnchor.constraint(equalTo: safeImageContainer.topAnchor),
            
            ])
    }
    
}
