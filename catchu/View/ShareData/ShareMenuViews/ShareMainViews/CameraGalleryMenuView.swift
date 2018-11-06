//
//  CameraGalleryMenuView.swift
//  catchu
//
//  Created by Erkut Baş on 9/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CameraGalleryMenuView: UIView {

    var imageManagementView : ImageManagementView?
    
    weak var delegate : ShareDataProtocols!
    
    init(frame: CGRect, inputDelegate : ShareDataProtocols) {
        super.init(frame: frame)
        
        self.delegate = inputDelegate
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - major functions
extension CameraGalleryMenuView {
    
    func setupView() {

        // change self background color to clear  
        self.backgroundColor = UIColor.clear
        
        imageManagementView = ImageManagementView(frame: .zero, inputDelegate: self.delegate)
        
//        imageManagementView!.delegate = self.delegate
        
        self.addSubview(imageManagementView!)

        imageManagementView!.translatesAutoresizingMaskIntoConstraints = false

        let safe = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            imageManagementView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            imageManagementView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            imageManagementView!.topAnchor.constraint(equalTo: safe.topAnchor),
            imageManagementView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),

            ])

    }
    
    func checkIfCustomCameraSessionActive() {
        
        guard imageManagementView != nil else {
            return
        }
        
        guard let customCameraObject = imageManagementView!.customCameraView else {
            return
        }
        
        customCameraObject.disableCustomCameraProcess()
        
    }
    
    func callCreationOfSnapShot() {
        
        guard imageManagementView != nil else {
            return
        }
        
        imageManagementView!.createNewImageWithStickers()
        
    }
    
    /// 1 - capturedImageView
    /// 2 - croppedImageView
    /// 3 - selectedImageContainer
    func getActiveCustomView() {

        PostItems.shared.emptySelectedImageArray()
        
        if let captureImageView = imageManagementView!.captureImageView {
            print("captureImageView alpha : \(captureImageView.alpha)")
            
            if captureImageView.alpha == 1 {
                if imageManagementView != nil {
                    imageManagementView!.createNewImageWithStickers()
                }
                return
            }
            
        }
        
        if let croppedImage = imageManagementView!.croppedImage {
            print("croppedImage alpha : \(croppedImage.alpha)")
         
            if croppedImage.alpha == 1 {
                if imageManagementView != nil {
                    imageManagementView!.saveSelectedImageFromCroppedImage()
                }
                return
            }
            
        }

        if let customSelectedImageContainer = imageManagementView!.customSelectedImageContainer {
            print("customSelectedImageContainer alpha : \(customSelectedImageContainer.alpha)")
            
            if customSelectedImageContainer.alpha == 1 {
                if imageManagementView != nil {
                    imageManagementView!.saveSelectedImageFromZoomView()
                }
                return
            }
            
        }
        
    }
    
    
    
}
