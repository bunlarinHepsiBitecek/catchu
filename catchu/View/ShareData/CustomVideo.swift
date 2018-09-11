//
//  CustomVideo.swift
//  catchu
//
//  Created by Erkut Baş on 9/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class CustomVideo: NSObject {

    var videoSession : AVCaptureSession?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoFileOutput = AVCaptureMovieFileOutput()
    
}

extension CustomVideo {
    
    func prepare(completionHandler: @escaping (Error?) -> Void)  {
        
        func createVideoSession() {
            self.videoSession = AVCaptureSession()
            
        }
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices.compactMap { $0 }
            
            guard !cameras.isEmpty else { throw CustomVideoError.noCamerasAvailable }
            
            for camera in cameras {
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    
                    camera.exposureMode = .continuousAutoExposure
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            
            guard let videoSession = videoSession else { throw CustomVideoError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if videoSession.canAddInput(self.rearCameraInput!) {
                    
                    videoSession.addInput(self.rearCameraInput!)
                    
                    videoFileOutput = AVCaptureMovieFileOutput()
                    let totalSeconds = 60.0 //Total Seconds of capture time
                    let timeScale: Int32 = 30 //FPS
                    
                    let maxDuration = CMTimeMakeWithSeconds(totalSeconds, timeScale)
                    
                    videoFileOutput.maxRecordedDuration = maxDuration
                    videoFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
                    
                } else {
                    throw CustomVideoError.inputsAreInvalid
                }
                
            } else {
                
                throw CustomVideoError.noCamerasAvailable
                
            }
            
        }
        
        func configurePhotoOutput() throws {
            guard let videoSession = videoSession else { throw CustomVideoError.captureSessionIsMissing }
            
            if videoSession.canAddOutput(self.videoFileOutput) { videoSession.addOutput(self.videoFileOutput) }
            
            videoSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createVideoSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
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
    
    func displayPreviewForVideo(on view: UIView) throws {
        guard let videoSession = self.videoSession, videoSession.isRunning else { throw CustomVideoError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        print("view.frame : \(view.frame)")
        
        self.previewLayer?.frame = view.frame
    }
    
}

extension CustomVideo {
    
    enum CustomVideoError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
}
