//
//  CustomCamera.swift
//  catchu
//
//  Created by Erkut Baş on 9/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCamera: NSObject {
    
    var captureSession : AVCaptureSession?
    
    var currentCameraPosition: CameraPosition?
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.auto
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var movieFileOutput = AVCaptureMovieFileOutput()
    
    var deviceMaxZoomFactor : CGFloat?
    var cameraZoomed : Bool = false
    var stoppedZoomFactor : CGFloat?
    
}

extension CustomCamera {
    
    func prepare(completionHandler: @escaping (Error?) -> Void)  {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
            self.captureSession?.sessionPreset = AVCaptureSession.Preset.photo
            
        }
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices.compactMap { $0 }
            
            guard !cameras.isEmpty else { throw CustomCameraError.noCamerasAvailable }
            
            for camera in cameras {
                
                if camera.position == .front {
                    self.frontCamera = camera
                    
                    try camera.lockForConfiguration()
                    
//                    camera.automaticallyAdjustsVideoHDREnabled = true
//                    camera.isVideoHDREnabled = true
                    
                    print("camera.isFocusModeSupported(.continuousAutoFocus) : \(camera.isFocusModeSupported(.continuousAutoFocus))")
                    print("camera.isFocusModeSupported(.autoFocus) : \(camera.isFocusModeSupported(.autoFocus))")
                    
                    
//                    if camera.isFocusModeSupported(.continuousAutoFocus) {
//                        camera.focusMode = .continuousAutoFocus
//                    } else {
//                        camera.focusMode = .autoFocus
//                    }
                    
                    // Adjust the iso to clamp between minIso and maxIso based on the active format
//                    let minISO = camera.activeFormat.minISO
//                    let maxISO = camera.activeFormat.maxISO
//                    let clampedISO = 0.3 * (maxISO - minISO) + minISO
//
//                    camera.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: clampedISO, completionHandler: nil)
//
                    camera.exposureMode = .continuousAutoExposure
                    camera.unlockForConfiguration()
                    
                    
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    
//                    camera.automaticallyAdjustsVideoHDREnabled = true
//                    camera.isVideoHDREnabled = true
                    
                    camera.exposureMode = .continuousAutoExposure
                    camera.focusMode = .continuousAutoFocus
                    
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = captureSession else { throw CustomCameraError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) {
                    
                    captureSession.addInput(self.rearCameraInput!)
                    
                }
                
                currentCameraPosition = .rear
            
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) {
                    
                    captureSession.addInput(self.frontCameraInput!)
                    
                } else {
                    throw CustomCameraError.inputsAreInvalid
                }
                
                currentCameraPosition = .front
            
            } else {
                
                throw CustomCameraError.noCamerasAvailable
                
            }
            
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = captureSession else { throw CustomCameraError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
//            captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
//                try setHDR_Mode()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
        
    }
    
    func displayPreview(on view: UIView) throws {
//        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CustomCameraError.captureSessionIsMissing }
        guard let captureSession = self.captureSession else { throw CustomCameraError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        print("view.frame : \(view.frame)")
        
        self.previewLayer?.frame = view.frame
    }
    
    
    /// it is starts to stop capture session while other views uses AVCaptureSession
    ///
    /// - Throws: captureSession nil exception
    func enableCameraSession() throws {
        
        print("enableCameraSession starts")
        
        guard let captureSession = self.captureSession else { throw CustomCameraError.captureSessionIsMissing }
        
        print("captureSession.isRunning : \(captureSession.isRunning)")
        
        if !captureSession.isRunning {
            
            captureSession.startRunning()
            
        }
        
        print("captureSession.isRunning : \(captureSession.isRunning)")
        
    }
    
    /// it is used to stop capture session while other views uses AVCaptureSession
    ///
    /// - Throws: captureSession nil exception
    func disableCameraSession() throws {
        
        print("disableCameraSession starts")
        
        guard let captureSession = self.captureSession else { throw CustomCameraError.captureSessionIsMissing }
        
        print("captureSession.isRunning : \(captureSession.isRunning)")
        
        if captureSession.isRunning {
            
            captureSession.stopRunning()
            
        }
        
        print("captureSession.isRunning : \(captureSession.isRunning)")
        
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CustomCameraError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            
            guard let rearCameraInput = self.rearCameraInput, captureSession.inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CustomCameraError.invalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            // manuel off, default auto mode causes application crash
            flashMode = .off
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else {
                throw CustomCameraError.invalidOperation
            }
        }
        
        func switchToRearCamera() throws {
            
            guard let frontCameraInput = self.frontCameraInput, captureSession.inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw CustomCameraError.invalidOperation }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
            }
                
            else { throw CustomCameraError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CustomCameraError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }

    
    /// to manage camera zoom process
    ///
    /// - Parameter input: pinch zoom is stop or not
    func cameraZoomEnded(input : Bool, inputZoomEndedScale : CGFloat) {
        
        cameraZoomed = input
        stoppedZoomFactor = inputZoomEndedScale
        
    }
    
    /// to make camera zoom
    ///
    /// - Parameter inputScale: input zoom scale
    func zoom(inputScale : CGFloat) {
        
        var zoomFactor = inputScale
        
        print("cameraZoomed: \(cameraZoomed)")
        
        guard let currentCameraPosition = currentCameraPosition else { return }
        
        switch currentCameraPosition {
        case .front:
            guard let frontCamera = frontCamera else { return }
            
            deviceMaxZoomFactor = frontCamera.activeFormat.videoMaxZoomFactor
            
            do {
                try frontCamera.lockForConfiguration()
                
                guard let deviceMaxZoomFactor = deviceMaxZoomFactor else { return }
                
                if zoomFactor <= deviceMaxZoomFactor {
                    frontCamera.videoZoomFactor = max(1.0, min(zoomFactor, deviceMaxZoomFactor))
                }
                
                frontCamera.unlockForConfiguration()
                
            } catch {
                print("zoom error")
            }
            
        case .rear:
            
            guard let rearCamera = rearCamera else { return }
            
            print("rearCamera.videoZoomFactor : \(rearCamera.videoZoomFactor)")
            
            deviceMaxZoomFactor = rearCamera.activeFormat.videoMaxZoomFactor
            
            do {
                try rearCamera.lockForConfiguration()
                
                guard let deviceMaxZoomFactor = deviceMaxZoomFactor else { return }
                
//                if rearCamera.videoZoomFactor >= Constants.CameraZoomScale.deviceInitialZoomScale_01 && cameraZoomed {
//                    
//                    guard let stoppedZoomFactor = stoppedZoomFactor else { return }
//                    
//                    zoomFactor = inputScale + stoppedZoomFactor
////                    cameraZoomed = false
//                    
//                    print("-----")
//                    print("zoomFactor : \(zoomFactor)")
//                    print("stoppedZoomFactor : \(stoppedZoomFactor)")
//                    print("rearCamera.videoZoomFactor : \(rearCamera.videoZoomFactor)")
//                    
//                    print("-----")
//                }
                
                if zoomFactor <= deviceMaxZoomFactor {
                    rearCamera.videoZoomFactor = max(1.0, min(zoomFactor, deviceMaxZoomFactor))
                    
                    print("++++++ rearCamera.videoZoomFactor : \(rearCamera.videoZoomFactor)")
                    
                }
                
                rearCamera.unlockForConfiguration()
                
            } catch {
                print("zoom error")
            }
            
        }
        
    }
    
}

extension CustomCamera: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CustomCameraError.unknown)
        }
    }
    
}

//extension CustomCamera {
//    
//    enum CustomCameraError: Swift.Error {
//        case captureSessionAlreadyRunning
//        case captureSessionIsMissing
//        case inputsAreInvalid
//        case invalidOperation
//        case noCamerasAvailable
//        case unknown
//    }
//    
//}
