//
//  PhotoCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCell: UICollectionViewCell {
 
    //
    // 5433FF 20BDFF A5FECB
    
    @IBOutlet var containerViewTrailingConstraints: NSLayoutConstraint!
    @IBOutlet var containerView: UIViewDesign!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imageViewTrailing: NSLayoutConstraint!
    @IBOutlet var imageViewBottom: NSLayoutConstraint!
    @IBOutlet var imageViewLeading: NSLayoutConstraint!
    @IBOutlet var imageViewTop: NSLayoutConstraint!
    
    weak var delegate : ShareDataProtocols!
    weak var delegatePermissionControl : PermissionProtocol!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.6
        
        imageView.image = UIImage(named: "photo_camera")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        setupGestureRecognizer()
        
    }
    
    func setConstraints(inputSize : CGFloat) {
        
        let x = (inputSize - containerViewTrailingConstraints.constant) / 3
        
        imageViewTop.constant = x
        imageViewBottom.constant = x
        imageViewLeading.constant = x
        imageViewTrailing.constant = x
        
    }
        
}

extension PhotoCell : UIGestureRecognizerDelegate {
    
    func setupGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoCell.openCustomCamera(_:)))
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openCustomCamera(_ sender : UITapGestureRecognizer) {
        
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorization {
        case .authorized:
            delegate.initiateCustomCamera()
            
        case .notDetermined:
            delegatePermissionControl.requestPermission(permissionType: .camera)
            
        default:
            delegatePermissionControl.requestPermission(permissionType: .cameraUnathorized)
        
        }
        
    }
    
}
