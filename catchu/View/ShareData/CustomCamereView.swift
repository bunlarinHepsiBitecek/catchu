//
//  CustomCamereView.swift
//  catchu
//
//  Created by Erkut Baş on 9/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CustomCamereView: UIView {
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let customCamera = CustomCamera()

    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    lazy var switchButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "switch-camera")?.withRenderingMode(.alwaysTemplate)
//        temp.image = UIImage(named: "switch_camera_default")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var flashButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "auto_flash")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.tag = 1
        
        return temp
        
    }()
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
        setupCloseButtonGesture()
        setupGestureRecognizerForSwitchCamera()
        setupGestureRecognizerForFlashButton()
        setupGestureRecognizerForCameraShoot()
        
//        mainView.layer.insertSublayer(previewLayer, at: 0)
//        previewLayer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//        previewLayer.frame = mainView.bounds
//
//        print("mainView.bounds : \(mainView.bounds)")
//
//        mainView.layer.addSublayer(previewLayer)
        
//        setupCameraSettings()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        setupCameraSettings()
        
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
    
    func koko() {
        
        previewLayer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        previewLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        print("mainView.bounds : \(mainView.bounds)")
        
        mainView.layer.addSublayer(previewLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(mainView)
        self.mainView.addSubview(closeButton)
        self.mainView.addSubview(cameraShootButton)
        self.mainView.addSubview(switchButton)
        self.mainView.addSubview(flashButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeMain = self.mainView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeMain.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            cameraShootButton.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor, constant: -10),
            cameraShootButton.centerXAnchor.constraint(equalTo: safeMain.centerXAnchor),
            cameraShootButton.heightAnchor.constraint(equalToConstant: 80),
            cameraShootButton.widthAnchor.constraint(equalToConstant: 80),
            
            switchButton.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor, constant: -30),
            switchButton.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor, constant: -20),
            switchButton.heightAnchor.constraint(equalToConstant: 40),
            switchButton.widthAnchor.constraint(equalToConstant: 40),
            
            flashButton.topAnchor.constraint(equalTo: safeMain.topAnchor, constant: 10),
            flashButton.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor, constant: 10),
            flashButton.heightAnchor.constraint(equalToConstant: 30),
            flashButton.widthAnchor.constraint(equalToConstant: 30),

            ])
        
    }
    
    func setupCameraSettings() {
    
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices

        if let availableFirst = availableDevices.first {
            captureDevice = availableFirst
            beginSession()
        }
        
        
    }
    
    func beginSession() {
        
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
        } catch  {
            print("ERROR : \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.videoGravity = AVLayerVideoGravity(rawValue: kCAGravityResizeAspectFill)
//        previewLayer.connection?.videoOrientation = .portrait
//        previewLayer.connection?.videoOrientation = .portrait
        
        self.previewLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.previewLayer.frame = self.mainView.bounds
        self.mainView.layer.addSublayer(previewLayer)
        
        print("previewLayer.bounds : \(previewLayer.bounds)")
        
        captureSession.startRunning()
        
//        let dataOutput = AVCaptureVideoDataOutput()
//
//        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
//
//        dataOutput.alwaysDiscardsLateVideoFrames = true
//
//        if captureSession.canAddOutput(dataOutput) {
//            captureSession.addOutput(dataOutput)
//        }
//
//        captureSession.commitConfiguration()
//
//        let queue = DispatchQueue(label: "com.brianadvent.captureQueue")
//        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    
}

extension CustomCamereView : AVCaptureVideoDataOutputSampleBufferDelegate {
    
}

extension CustomCamereView : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCamereView.dismissCustomCameraView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
//        self.mainView.bringSubview(toFront: closeButton)
        
    }
    
    @objc func dismissCustomCameraView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraView starts")
        
        self.removeFromSuperview()
        
    }
    
    func setupGestureRecognizerForSwitchCamera() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCamereView.switchCamera(_:)))
        tapGesture.delegate = self
        switchButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func switchCamera(_ sender : UITapGestureRecognizer) {
        
        print("switchCamera starts")

        do {
            try customCamera.switchCameras()
        }
            
        catch {
            print(error)
        }
        
    }
    
    func setupGestureRecognizerForCameraShoot() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCamereView.cameraShootProcess(_:)))
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
            
            let capturedView = CustomCameraCapturedImageView(image: image, cameraPosition: self.customCamera.currentCameraPosition!)
            
            capturedView.translatesAutoresizingMaskIntoConstraints = false
            
            self.mainView.addSubview(capturedView)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                capturedView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                capturedView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                capturedView.topAnchor.constraint(equalTo: safe.topAnchor),
                capturedView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
                
                ])
            
            
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
            
        }
        
        
        
    }
    
    func setupGestureRecognizerForFlashButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCamereView.flashManagement(_:)))
        tapGesture.delegate = self
        flashButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func flashManagement(_ sender : UITapGestureRecognizer) {
        
        print("flashManagement starts")
        
        print("customCamera flash : \(customCamera.flashMode)")
        print("flash tag : \(flashButton.tag)")
        
        if flashButton.tag == 1 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "on_flash")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 2
                self.customCamera.flashMode = .on
                
            }
            
        } else if flashButton.tag == 2 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "off_flash")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 3
                self.customCamera.flashMode = .off
                
            }
            
        } else if flashButton.tag == 3 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "auto_flash")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 1
                self.customCamera.flashMode = .auto
                
            }
            
            
        }
        
        
        
    }
    
}
