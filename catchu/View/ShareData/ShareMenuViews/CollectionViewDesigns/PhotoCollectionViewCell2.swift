//
//  PhotoCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCollectionViewCell2: UICollectionViewCell {
    
    weak var delegate : ShareDataProtocols!
    weak var delegatePermissionControl : PermissionProtocol!
    
    lazy var containerView: UIView = {
        
        let temp = UIView()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        temp.layer.cornerRadius = 10
//        temp.layer.shadowOffset = CGSize(width: 0, height: 2)
//        temp.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        temp.layer.shadowRadius = 3
//        temp.layer.shadowOpacity = 0.6
        
        return temp
        
    }()
    
    lazy var imageView: UIImageView = {
        
        let temp = UIImageView()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        //        temp.layer.cornerRadius = 25
        temp.backgroundColor = UIColor.clear
        temp.contentMode = .scaleToFill
        temp.image = UIImage(named: "photo_camera")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupGestureRecognizer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension PhotoCollectionViewCell2 {
    
    func setupViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(imageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeContainerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            ])
        
    }
    
}

extension PhotoCollectionViewCell2 : UIGestureRecognizerDelegate {
    
    func setupGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoCollectionViewCell2.openCustomCamera(_:)))
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openCustomCamera(_ sender : UITapGestureRecognizer) {
        
        do {
            try callDelegationProtocols()
        }
        catch let error as DelegationErrors {
            
            switch error {
            case .PermissionProtocolDelegateIsNil:
                print("PermissionProtocol delegate is nil")
                
            case .ShareDataProtocolsDelegateIsNil:
                print("ShareDataProtocols delegate is nil")
            default:
                print("something terribly goes wrong")
            }
        }
        catch {
            print("Sictik kim bilir ne oldu aq!")
        }
        
    }
    
    func callDelegationProtocols() throws {
        
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorization {
        case .authorized:
            
            guard delegate != nil else {
                throw DelegationErrors.ShareDataProtocolsDelegateIsNil
            }
            
            do {
                try delegate.initiateCustomCamera()
            }
            catch let error as DelegationErrors {
                
                if error == .CustomCameraViewIsNil {
                    print("CustomCameraView is nil")
                }
            }
            catch  {
                print("something is badly wrong")
            }
            
        case .notDetermined:
            
            guard delegatePermissionControl != nil else {
                throw DelegationErrors.PermissionProtocolDelegateIsNil
            }
            
            delegatePermissionControl.requestPermission(permissionType: .camera)
            
        default:
            
            guard delegatePermissionControl != nil else {
                throw DelegationErrors.PermissionProtocolDelegateIsNil
            }
            
            delegatePermissionControl.requestPermission(permissionType: .cameraUnathorized)
            
        }
        
    }
    
}
