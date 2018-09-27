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
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var audioDevice: AVCaptureDevice?
    var audioDeviceInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
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
            
            if let audioDevice = self.audioDevice {
                self.audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                
                if videoSession.canAddInput(self.audioDeviceInput!) {
                    videoSession.addInput(audioDeviceInput!)
                    
                }
                
            }
            
        }
        
        /// start video session
        ///
        /// - Throws: throw exceptions
        func configurePhotoOutput() throws {
            guard let videoSession = videoSession else { throw CustomVideoError.captureSessionIsMissing }
            
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
        guard let videoSession = self.videoSession else { throw CustomVideoError.captureSessionIsMissing }
        
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
        
        guard let videoSession = videoSession else { throw CustomVideoError.captureSessionIsMissing }
        
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
        
        guard let videoSession = videoSession else { throw CustomVideoError.captureSessionIsMissing }
        
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
    
}

extension CustomVideo : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        print("started recording to: \(fileURL)")
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("stopped recording to: \(outputFileURL)")
        
        self.delegate.directToCapturedVideoView(url: outputFileURL)
        
        
        
        try? PHPhotoLibrary.shared().performChangesAndWait {

            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)

        }
        
    }
    
    
    
    
}

//extension CustomVideo {
//    
//    enum CustomVideoError: Swift.Error {
//        case captureSessionAlreadyRunning
//        case captureSessionIsMissing
//        case inputsAreInvalid
//        case invalidOperation
//        case noCamerasAvailable
//        case noMicrophoneAvailable
//        case unknown
//        case previewLayerIsMissing
//    }
//    
//}
