//
//  PostMainView.swift
//  catchu
//
//  Created by Erkut Baş on 11/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class PostMainView: UIView {

    private var customMapView : CustomMapView?
    private var saySomethingView : SaySomethingView?
    private var postTopBarView : PostTopBarView?
//    private var capturedCameraView : CustomCameraCapturedImageView!
    private var capturedCameraView : CapturedImageView!
    private var videoView : VideoView?
    
    weak var delegate : PostViewProtocols!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    init(frame: CGRect, delegate : PostViewProtocols) {
        super.init(frame: frame)
        self.delegate = delegate
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - major functions
extension PostMainView {
    
    private func initializeView() {
        
        print("initializeView starts")
        print("keyboard height : \(KeyboardService.keyboardHeight())")
        print("keyboard size   : \(KeyboardService.keyboardSize())")
        
        addCustomMapView()
        addPostTopBarView()
        addSaySomethingView()
        addCapturedCameraView()
        addCustomVideoView()
        
    }
    
    private func addCustomMapView() {
        
        customMapView = CustomMapView()
        customMapView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(customMapView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customMapView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.heightAnchor.constraint(equalToConstant: KeyboardService.keyboardHeight() - Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            ])
        
    }
    
    private func addPostTopBarView() {
        
        postTopBarView = PostTopBarView()
        postTopBarView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(postTopBarView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            postTopBarView!.topAnchor.constraint(equalTo: safe.topAnchor),
            postTopBarView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            postTopBarView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            postTopBarView!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100 + UIApplication.shared.statusBarFrame.height)
            
            ])
        
    }
    
    private func addSaySomethingView() {
        
        saySomethingView = SaySomethingView(frame: .zero, delegate: delegate)
        saySomethingView!.setCameraGalleryPermissionDelegation(delegate: self)
        saySomethingView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(saySomethingView!)
        
        let safe = self.safeAreaLayoutGuide
        let safeCustomMapView = self.customMapView!.safeAreaLayoutGuide
        let safePostTopBarView = self.postTopBarView!.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            saySomethingView!.bottomAnchor.constraint(equalTo: safeCustomMapView.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            saySomethingView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            saySomethingView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            saySomethingView!.topAnchor.constraint(equalTo: safePostTopBarView.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10)
            
            ])
        
    }
    
    private func addCapturedCameraView() {
        
        capturedCameraView = CapturedImageView(inputDelegate: self)
        capturedCameraView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(capturedCameraView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            capturedCameraView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            capturedCameraView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            capturedCameraView.topAnchor.constraint(equalTo: safe.topAnchor),
            capturedCameraView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func activateCapturedCameraView(image : UIImage?, actionType : ActionControllerOperationType) {
        
        switch actionType {
        case .select:
            /* either a new photo is selected, or after selection an image user would like to select another one from image picker.
             So, before setting captured image to capturedImageView, let's erase all sticker from sticker list.*/
            capturedCameraView.clearStickerFromCapturedArray()
            
            if let image = image {
                capturedCameraView.activationManagerWithImage(granted: true, inputImage: image)
            } else {
                print("there is no image")
            }
            
        case .update:
            capturedCameraView.activationManagerDefault(granted: true)
        }
        
    }
    
    private func addCustomVideoView() {
        
        videoView = VideoView()
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(videoView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            videoView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            videoView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            videoView!.topAnchor.constraint(equalTo: safe.topAnchor),
            videoView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func activationManagerOfVideoView(granted : Bool) {
        if videoView != nil {
            videoView?.activationManager(active: granted)
        }
    }
    
}

// MARK: - CameraImageVideoHandlerProtocol
extension PostMainView : CameraImageVideoHandlerProtocol {
    
    func triggerPermissionProcess(permissionType: PermissionFLows) {
        CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: permissionType, delegate: self)
    }
    
    func returnPickedImage(image: UIImage) {
        print("returnPickedImage starts")
        
        activateCapturedCameraView(image: image, actionType: .select)
    }

    func updateProcessOfCapturedImage() {
        print("\(#function) starts")
        
        activateCapturedCameraView(image: nil, actionType: .update)
    }
    
    func initiateVideoViewPermissionProcess() {
        print("\(#function) starts")
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            
            switch AVAudioSession.sharedInstance().recordPermission() {
            case .granted:
                self.activationManagerOfVideoView(granted: true)
            case .undetermined:
                CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .microphone, delegate: self)
            case .denied:
                CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .microphoneUnAuthorizated, delegate: self)
            }
            
        case .notDetermined:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .video, delegate: self)
            
        case .denied, .restricted:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .videoUnauthorized, delegate: self)
        }
        
    }
    
    func returnPickedVideo(url: URL) {
        print("\(#function) starts")
        
        
        
        /*
        let capturedVideoView = CapturedVideoView(outputFileURL: url, delegate: self)
        
        capturedVideoView.backgroundColor = UIColor.clear
        
        self.addSubview(capturedVideoView)
        
        capturedVideoView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            capturedVideoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            capturedVideoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            capturedVideoView.topAnchor.constraint(equalTo: safe.topAnchor),
            capturedVideoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])*/
        
    }
    
}

// MARK: - PermissionProtocol
extension PostMainView : PermissionProtocol {
    
    func returnPermissionResult(status: PHAuthorizationStatus, permissionType: PermissionFLows) {
        
        switch status {
        case .authorized:
            switch permissionType {
            case .photoLibrary:
                CameraImagePickerManager.shared.openImageGallery(delegate: self)
                
            case .videoLibrary:
                CameraImagePickerManager.shared.openVideoGallery(delegate: self)
                
            default:
                return
            }
        default:
            print("Something goes wrong!")
        }
        
    }
    
    func returnPermissinResultBoolValue(result: Bool, permissionType: PermissionFLows) {
        print("\(#function) starts")
        
        if result {
            switch permissionType {
            case .camera:
                CameraImagePickerManager.shared.openSystemCamera(delegate: self)
                
            case .video:
                // after checking camera permissin, it's required to ask microphone
                self.initiateVideoViewPermissionProcess()
                return
            default:
                print("Something goes wrong!")
            }
        }
        
    }
    
}

// MARK: - PostViewProtocols
extension PostMainView : PostViewProtocols {

    /// Description: used to trigger image selected animation circle on camera container view in say something view
    /// - Author: Erkut Bas
    func committedCapturedImage() {
        print("\(#function) starts")
        
        let image = PostItems.shared.selectedImageArray?.first
        let image2 = PostItems.shared.selectedOriginalImageArray?.first
        
        guard saySomethingView != nil else {
            return
        }
        
        saySomethingView!.contentAnimationManagement(postContentType: .camera, active: true)
        
    }
    
}

