//
//  CustomVideo.swift
//  catchu
//
//  Created by Erkut Baş on 9/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CustomVideo: NSObject {

    var videoSession : AVCaptureSession?
    
    var currentCameraPosition : CameraPosition?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var audioDevice: AVCaptureDevice?
    var audioDeviceInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.auto
    
    var videoFileOutput = AVCaptureMovieFileOutput()
    
    var isRecording : Bool = false
    
    weak var delegate : ShareDataProtocols!
    
}

extension CustomVideo {
    
    func prepare(completionHandler: @escaping (Error?) -> Void)  {
        
        /// create session
        func createVideoSession() {
            self.videoSession = AVCaptureSession()
            
        }
        
        /// find devices
        ///
        /// - Throws: throws exceptions
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTelephotoCamera, .builtInTrueDepthCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let devices = session.devices.compactMap { $0 }
            
            guard !devices.isEmpty else { throw CustomVideoError.noCamerasAvailable }
            
            for device in devices {
                
                if device.position == .back {
                    self.rearCamera = device
                    
                    try device.lockForConfiguration()
                    
                    device.exposureMode = .continuousAutoExposure
                    device.focusMode = .continuousAutoFocus
                    device.unlockForConfiguration()
                    
                }
                
                if device.position == .front {
                    self.frontCamera = device
                    
                    try device.lockForConfiguration()
                    
                    if device.isExposureModeSupported(.continuousAutoExposure) {
                        device.exposureMode = .continuousAutoExposure
                    }
                    
                    if device.isFocusModeSupported(.continuousAutoFocus) {
                        device.focusMode = .continuousAutoFocus
                    }
                    
                    device.unlockForConfiguration()
                    
                }
                
            }
            
            let sessionForAudio = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: AVMediaType.audio, position: .unspecified)
            
            let devicesForAudio = sessionForAudio.devices.compactMap { $0 }
            
            guard !devicesForAudio.isEmpty else { throw CustomVideoError.noMicrophoneAvailable }
            
            for device in devicesForAudio {
                
                if device.hasMediaType(.audio) {
                    self.audioDevice = device
                }
                
            }
            
        }
        
        /// adding input devices into session
        ///
        /// - Throws: throws exceptions
        func configureDeviceInputs() throws {
            
            guard let videoSession = videoSession else { throw CustomVideoError.videoSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if videoSession.canAddInput(self.rearCameraInput!) {
                    
                    videoSession.addInput(self.rearCameraInput!)
                    
                    currentCameraPosition = .rear
                    
//                    videoFileOutput = AVCaptureMovieFileOutput()
//                    let totalSeconds = 60.0 //Total Seconds of capture time
//                    let timeScale: Int32 = 30 //FPS
//
//                    let maxDuration = CMTimeMakeWithSeconds(totalSeconds, timeScale)
//
//                    videoFileOutput.maxRecordedDuration = maxDuration
//                    videoFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
                    
                } else {
                    throw CustomVideoError.inputsAreInvalid
                }
                
            } else if let frontCamera = self.frontCamera {
              
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if videoSession.canAddInput(frontCameraInput!) {
                    videoSession.addInput(frontCameraInput!)
                    
                    currentCameraPosition = .front
                }
                
            } else {
                
                throw CustomVideoError.noCamerasAvailable
                
            }
            
            if let audioDevice = self.audioDevice {
                self.audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                
                if videoSession.canAddInput(self.audioDeviceInput!) {
                    videoSession.addInput(audioDeviceInput!)
                    
                }
                
            }
            
            videoFileOutput = AVCaptureMovieFileOutput()
            let totalSeconds = 60.0 //Total Seconds of capture time
            let timeScale: Int32 = 30 //FPS
            
            let maxDuration = CMTimeMakeWithSeconds(totalSeconds, timeScale)
            
            videoFileOutput.maxRecordedDuration = maxDuration
            videoFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
            
        }
        
        /// start video session
        ///
        /// - Throws: throw exceptions
        func configurePhotoOutput() throws {
            guard let videoSession = videoSession else { throw CustomVideoError.videoSessionIsMissing }
            
            if videoSession.canAddOutput(self.videoFileOutput) { videoSession.addOutput(self.videoFileOutput) }
            
//            videoSession.startRunning()
            
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
        /* videoSession.isRunning control is removed */
//        guard let videoSession = self.videoSession, videoSession.isRunning else { throw CustomVideoError.captureSessionIsMissing }
        guard let videoSession = self.videoSession else { throw CustomVideoError.videoSessionIsMissing }
        
        print("displayPreviewForVideo starts")
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        print("view.frame : \(view.frame)")
        print("preview connection : \(previewLayer?.connection)")
        
        
        self.previewLayer?.frame = view.frame
    }
    
    func enableVideoSession() throws {
        
        guard let videoSession = videoSession else { throw CustomVideoError.videoSessionIsMissing }
        
        print("videoSession is running : \(videoSession.isRunning)")
        print("preview connection : \(previewLayer?.connection)")
        
        if !videoSession.isRunning {
            
//            if let previewConnection = previewLayer?.connection {
//                previewConnection.isEnabled = true
//            }
            
            
            videoSession.startRunning()
            
        }
    }
    
    func disableVideoSession() throws {
        
        guard let videoSession = videoSession else { throw CustomVideoError.videoSessionIsMissing }
        
        print("videoSession is running : \(videoSession.isRunning)")
        
        if videoSession.isRunning {
            
//            self.previewLayer?.removeFromSuperlayer()
//            self.previewLayer = nil
            
//            if let previewConnection = previewLayer?.connection {
//                previewConnection.isEnabled = false
//            }
            
            videoSession.stopRunning()

        }

    }
    
    func startRecording() {
        
        let outputPath = "\(NSTemporaryDirectory())output.mov"
        let outputURL = URL(fileURLWithPath: outputPath)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: outputPath) {
            
            do {
                
                try fileManager.removeItem(atPath: outputPath)
                
            } catch {
                
                print("error removing item at path: \(outputPath)")
                return
            }
        }
        
        videoFileOutput.startRecording(to: outputURL, recordingDelegate: self)
        
    }
    
    func stopRecording() {
        
        videoFileOutput.stopRecording()
        
    }
    
    
    /// Switching camera position
    ///
    /// - Throws: if application crashes, throws exceptions
    func switchCameras() throws {
        
        print("switchCameras starts")
        print("currentCameraPosition : \(currentCameraPosition)")
        print("self.videoSession : \(self.videoSession)")
        print("videoSession.isRunning : \(videoSession!.isRunning)")
        
        guard let currentCameraPosition = currentCameraPosition, let videoSession = self.videoSession, videoSession.isRunning else { throw CustomVideoError.videoSessionIsMissing }
        
        videoSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            
            print("rearCameraInput : \(rearCameraInput)")
            print("frontCamera : \(frontCamera)")
            
            guard let rearCameraInput = rearCameraInput, videoSession.inputs.contains(rearCameraInput), let frontCamera = frontCamera else { throw CustomVideoError.invalidOperation }
            
            // initialize front camera input
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            videoSession.removeInput(rearCameraInput)
            
            // in order not to cause crashes, close flash mode
            flashMode = .off
            
            if videoSession.canAddInput(frontCameraInput!) {
                videoSession.addInput(frontCameraInput!)
                
                self.currentCameraPosition = .front
                
            } else {
                throw CustomVideoError.invalidOperation
            }
            
        }
        
        func switchToRearCamera() throws {
            
            print("frontCameraInput : \(frontCameraInput)")
            print("rearCamera : \(rearCamera)")
            
            guard let frontCameraInput = frontCameraInput, videoSession.inputs.contains(frontCameraInput), let rearCamera = rearCamera else { throw CustomVideoError.invalidOperation }
            
            // initialize rear camera input
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            videoSession.removeInput(frontCameraInput)
            
            // do not need for rear camera
            //flashMode = .off
            
            if videoSession.canAddInput(rearCameraInput!) {
                videoSession.addInput(rearCameraInput!)
                
                self.currentCameraPosition = .rear
                
            } else {
                throw CustomVideoError.invalidOperation
            }
            
            
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
        case .rear:
            try switchToFrontCamera()
        }
        
        videoSession.commitConfiguration()

    }
    
}

extension CustomVideo : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        print("started recording to: \(fileURL)")
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("stopped recording to: \(outputFileURL)")
        
        self.delegate.directToCapturedVideoView(url: outputFileURL)
        
//        try? PHPhotoLibrary.shared().performChangesAndWait {
//
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
//
//        }
        
    }
    
}
