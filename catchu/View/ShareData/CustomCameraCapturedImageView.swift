//
//  CustomCameraCapturedImageView.swift
//  catchu
//
//  Created by Erkut Baş on 9/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class CustomCameraCapturedImageView: UIView {

    private let capturedImage = UIImageView()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var downloadButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    required init(image: UIImage, cameraPosition : CameraPosition) {
        super.init(frame: .zero)
        
        if cameraPosition == .front {
            capturedImage.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
        } else {
            capturedImage.image = image
        }
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(capturedImage)
        self.addSubview(closeButton)
        self.addSubview(downloadButton)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFill
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            capturedImage.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            capturedImage.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            capturedImage.topAnchor.constraint(equalTo: safe.topAnchor),
            capturedImage.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            downloadButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20),
            downloadButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40)
            
            ])
        
    }
    
    
    
}

extension CustomCameraCapturedImageView: UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraCapturedImageView.dismissCustomCameraCapturedView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        //        self.mainView.bringSubview(toFront: closeButton)
        
    }
    
    @objc func dismissCustomCameraCapturedView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraCapturedView starts")
        
        self.removeFromSuperview()
        
    }
    
    func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraCapturedImageView.saveCapturedImage(_:)))
        tapGesture.delegate = self
        downloadButton.addGestureRecognizer(tapGesture)
        //        self.mainView.bringSubview(toFront: closeButton)
        
    }
    
    @objc func saveCapturedImage(_ sender : UITapGestureRecognizer) {
        
        print("saveCapturedImage starts")
        
        try? PHPhotoLibrary.shared().performChangesAndWait {
            
            PHAssetChangeRequest.creationRequestForAsset(from: self.capturedImage.image!)
            
        }
        
    }
    
}
