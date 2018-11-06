//
//  CustomCameraView.swift
//  catchu
//
//  Created by Erkut Baş on 9/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CustomCameraView: UIView {
    
//    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let customCamera = CustomCamera()
    
    var stoppedZoomScale : CGFloat = 0.0
    
    weak var delegate : ShareDataProtocols!
    weak var delegatePermissionControl : PermissionProtocol!
    
    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        //        temp.layer.shadowOffset = CGSize(width: 0, height: 10)
        //        temp.layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        temp.layer.shadowRadius = 30
        //        temp.layer.shadowOpacity = 0.4
        
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var cameraShootButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        temp.layer.borderWidth = 5
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 40
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var switchButtonContainer: UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var switchButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "rotate-1")?.withRenderingMode(.alwaysTemplate)
        //        temp.image = UIImage(named: "switch_camera_default")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var flashButtonContainer: UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var flashButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "flash")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.tag = 1
        
        return temp
        
    }()
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    
    init(delegateShareDataProtocols : ShareDataProtocols, delegatePermissionProtocol : PermissionProtocol) {
        super.init(frame: .zero)
        
        self.delegate = delegateShareDataProtocols
        self.delegatePermissionControl = delegatePermissionProtocol
        
        do {
            
            try checkAuthorization()
            
        }
        catch let error as DelegationErrors {
            if error == .PermissionProtocolDelegateIsNil {
                print("PermissionDelegation is nil")
            }
        }
        catch {
            print("Something terribly goes wrong")
        }
        
        
    }
    
//    override init(frame: CGRect, delegateShareDataProtocols : ShareDataProtocols, delegatePermissionProtocol : PermissionProtocol) {
//        super.init(frame: frame)
//        
//        self.delegate = delegateShareDataProtocols
//        self.delegatePermissionControl = delegatePermissionProtocol
//        
//        do {
//            
//            try checkAuthorization()
//            
//        }
//        catch let error as DelegationErrors {
//            if error == .PermissionProtocolDelegateIsNil {
//                print("PermissionDelegation is nil")
//            }
//        }
//        catch {
//            print("Something terribly goes wrong")
//        }
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        startCustomCameraProcess()
//    }
    
}

// MARK: - major functions
extension CustomCameraView {
    
    func checkAuthorization() throws {
        
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorization {
        case .authorized:
            initiateCustomCameraView()
            
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
    
    func initiateCustomCameraView() {
        
        setupViews()
        setupCloseButtonGesture()
        setupGestureRecognizerForSwitchCamera()
        setupGestureRecognizerForFlashButton()
        setupGestureRecognizerForCameraShoot()
        setPinchZoom()
        
        // awaken customCamera object
        startCustomCameraProcess()
        
    }
    
    func startCustomCameraProcess() {
        
        func configureCameraController() {
            customCamera.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.customCamera.displayPreview(on: self.mainView)
            }
        }
        
        configureCameraController()
        
    }
    
    func disableCustomCameraProcess() {
        
        customCameraViewActivationManager(active: false)
        
        do {
            try customCamera.disableCameraSession()
        }
        catch let error as CustomCameraError {
            
            switch error {
            case .captureSessionIsMissing:
                print("Capture Session is missing")
            default:
                print(error)
            }
        }
        catch {
            print("camera can not be disabled")
        }
        
    }
    
    func enableCustomCameraProcess() {
        
        customCameraViewActivationManager(active: true)
        
        do {
            try customCamera.enableCameraSession()
            
        }
        catch let error as CustomCameraError {
            
            switch error {
            case .captureSessionIsMissing:
                print("Capture Session is missing")
            default:
                print(error)
            }
        }
        catch {
            print("camera can not be enabled")
        }
        
    }
    
    func setupViews() {
        
        // let's make is opaque for performans issues
        self.isOpaque = true
        
        self.addSubview(mainView)
        self.mainView.addSubview(flashButtonContainer)
        self.mainView.addSubview(switchButtonContainer)
        self.flashButtonContainer.addSubview(flashButton)
        self.switchButtonContainer.addSubview(switchButton)
        self.mainView.addSubview(closeButton)
        self.mainView.addSubview(cameraShootButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeMain = self.mainView.safeAreaLayoutGuide
        let safeFlashContainer = self.flashButtonContainer.safeAreaLayoutGuide
        let safeSwitchContainer = self.switchButtonContainer.safeAreaLayoutGuide
        let safeCameraShoot = self.cameraShootButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeMain.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            cameraShootButton.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor, constant: -10),
            cameraShootButton.centerXAnchor.constraint(equalTo: safeMain.centerXAnchor),
            cameraShootButton.heightAnchor.constraint(equalToConstant: 80),
            cameraShootButton.widthAnchor.constraint(equalToConstant: 80),
            
            switchButtonContainer.leadingAnchor.constraint(equalTo: safeCameraShoot.trailingAnchor, constant: 20),
            switchButtonContainer.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor, constant: -20),
            switchButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            switchButtonContainer.widthAnchor.constraint(equalToConstant: 60),
            
            switchButton.centerXAnchor.constraint(equalTo: safeSwitchContainer.centerXAnchor),
            switchButton.centerYAnchor.constraint(equalTo: safeSwitchContainer.centerYAnchor),
            switchButton.heightAnchor.constraint(equalToConstant: 30),
            switchButton.widthAnchor.constraint(equalToConstant: 30),
            
            flashButtonContainer.trailingAnchor.constraint(equalTo: safeCameraShoot.leadingAnchor, constant: -20),
            flashButtonContainer.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor, constant: -20),
            flashButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            flashButtonContainer.widthAnchor.constraint(equalToConstant: 60),
            
            flashButton.centerXAnchor.constraint(equalTo: safeFlashContainer.centerXAnchor),
            flashButton.centerYAnchor.constraint(equalTo: safeFlashContainer.centerYAnchor),
            flashButton.heightAnchor.constraint(equalToConstant: 30),
            flashButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func customCameraViewActivationManager(active : Bool) {
        
        if active {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
        
    }
    
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CustomCameraView : AVCaptureVideoDataOutputSampleBufferDelegate {
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomCameraView : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraView.dismissCustomCameraView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        self.mainView.bringSubview(toFront: closeButton)
        
    }
    
    @objc func dismissCustomCameraView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraView starts")
        
        self.disableCustomCameraProcess()
        
    }
    
    func setupGestureRecognizerForSwitchCamera() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraView.switchCamera(_:)))
        tapGesture.delegate = self
        switchButton.addGestureRecognizer(tapGesture)
        switchButtonContainer.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func switchCamera(_ sender : UITapGestureRecognizer) {
        
        print("switchCamera starts")
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_05) {
            
            self.switchButton.transform = self.switchButton.transform == CGAffineTransform(rotationAngle: CGFloat(Double.pi)) ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        do {
            try customCamera.switchCameras()
        }
            
        catch {
            print(error)
        }
        
    }
    
    func setupGestureRecognizerForCameraShoot() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraView.cameraShootProcess(_:)))
        tapGesture.delegate = self
        cameraShootButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func cameraShootProcess(_ sender : UITapGestureRecognizer) {
        
        print("cameraShootProcess starts")
        
        UIView.transition(with: cameraShootButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            
            self.cameraShootButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.5)
            
        }, completion: { (result) in
            
            if result {
                
                UIView.transition(with: self.cameraShootButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    
                    self.cameraShootButton.backgroundColor = UIColor.clear
                    
                })
                
            }
            
        })
        
        customCamera.captureImage { (image, error) in
            
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            guard let cameraPosition = self.customCamera.currentCameraPosition else {
                return
            }
            
            self.delegate.setCapturedImage(inputImage: image, cameraPosition: cameraPosition)
            
        }
        
    }
    
    func setupGestureRecognizerForFlashButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraView.flashManagement(_:)))
        tapGesture.delegate = self
        //        flashButton.addGestureRecognizer(tapGesture)
        flashButtonContainer.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func flashManagement(_ sender : UITapGestureRecognizer) {
        
        print("flashManagement starts")
        
        print("customCamera flash : \(customCamera.flashMode)")
        print("flash tag : \(flashButton.tag)")
        
        if flashButton.tag == 1 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 2
                self.customCamera.flashMode = .on
                
            }
            
        } else if flashButton.tag == 2 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash-2")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 3
                self.customCamera.flashMode = .off
                
            }
            
        } else if flashButton.tag == 3 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash-3")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 1
                self.customCamera.flashMode = .auto
                
            }
            
        }
        
    }
    
    func setPinchZoom() {
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CustomCameraView.zoomCamera(_:)))
        pinchGestureRecognizer.delegate = self
        self.mainView.addGestureRecognizer(pinchGestureRecognizer)
        //        guard let captureSession = captureSession else { return }
        
    }
    
    @objc func zoomCamera(_ sender : UIPinchGestureRecognizer) {
        
        //        customCamera.zoom(inputScale: sender.scale)
        
        /*
         let deviceZoomScale = stoppedZoomScale + sender.scale
         
         print("deviceZoomScale : \(deviceZoomScale)")
         
         if sender.state == .changed {
         
         customCamera.zoom(inputScale: deviceZoomScale)
         
         } else if sender.state == .ended {
         
         stoppedZoomScale = sender.scale
         }*/
        
        let deviceZoomScale = sender.scale
        
        if sender.state == .changed {
            
            if deviceZoomScale <= Constants.CameraZoomScale.maximumZoomScale_05 {
                
                print("deviceZoomScale :\(deviceZoomScale) ")
                
                customCamera.zoom(inputScale: sender.scale)
            }
            
        } else if sender.state == .ended {
            
            //            stoppedZoomScale = sender.scale
            customCamera.cameraZoomEnded(input: true, inputZoomEndedScale: sender.scale)
            
        }
        
    }
    
}

