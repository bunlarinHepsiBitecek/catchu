//
//  ImagePickerManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 2/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Photos
import AVFoundation
import MobileCoreServices

class ImagePickerManager: NSObject {
    static let shared = ImagePickerManager()
    
    // MARK: - Internal Properties
    var imagePicked: ((UIImage, String) -> Void)?
    var videoPicked: ((URL, String) -> Void)?
    
    weak var currentVC: UIViewController?
    private var pickerController: UIImagePickerController?
    
    enum PermissionType {
        case camera
        case video
        case photoLibrary
        case videoLibrary
    }
    
    // MARK: - Functions
    func accessCamera(vc: UIViewController) {
        currentVC = vc
        cameraAuthorization()
    }
    
    func accessPhotoLibrary(vc: UIViewController) {
        currentVC = vc
        photoLibraryAuthorization()
    }
    
    func accessVideoLibrary(vc: UIViewController) {
        currentVC = vc
        videoLibraryAuthorization()
    }
    
    private func cameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("open")
            presentCamera()
        case .notDetermined:
            print("trigger first time")
            requestFirstTimePermission(.camera)
        case .denied, .restricted:
            print("open settings")
            requestUnauthorizedPermission(.camera)
        }
    }
    
    private func photoLibraryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            print("open")
            presentPhotoLibrary()
        case .notDetermined:
            print("trigger first time")
            requestFirstTimePermission(.photoLibrary)
        case .denied, .restricted:
            print("open settings")
            requestUnauthorizedPermission(.photoLibrary)
        }
    }
    
    private func videoLibraryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            print("open")
            presentVideoLibrary()
        case .notDetermined:
            print("trigger first time")
            requestFirstTimePermission(.videoLibrary)
        case .denied, .restricted:
            print("open settings")
            requestUnauthorizedPermission(.videoLibrary)
        }
    }
    
    private func presentCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.pickerController = pickerController
            currentVC?.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    private func presentPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.allowsEditing = false
            self.pickerController = pickerController
            currentVC?.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func presentVideoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            // delegate ?
            pickerController.delegate = self
            pickerController.sourceType = .savedPhotosAlbum
            pickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            pickerController.videoExportPreset = AVAssetExportPresetMediumQuality
            self.pickerController = pickerController
            currentVC?.present(pickerController, animated: true, completion: nil)
        }
    }
    
    private func requestFirstTimePermission(_ permissionType: PermissionType) {
        switch permissionType {
        case .camera:
            print("requestFirstTimePermission camera")
            showPermissionView(.camera)
        case .video:
            print("requestFirstTimePermission video")
            showPermissionView(.video)
        case .photoLibrary:
            print("requestFirstTimePermission photoLib")
            showPermissionView(.photoLibrary)
        case .videoLibrary:
            print("requestFirstTimePermission videoLib")
            showPermissionView(.videoLibrary)
        }
    }
    
    private func requestUnauthorizedPermission(_ permissionType: PermissionType) {
        switch permissionType {
        case .camera:
            showPermissionView(.cameraUnathorized)
        case .video:
            showPermissionView(.videoUnauthorized)
        case .photoLibrary:
            showPermissionView(.photoLibraryUnAuthorized)
        case .videoLibrary:
            showPermissionView(.videoLibraryUnauthorized)
        }
    }
    
    private func showPermissionView(_ type: PermissionFLows) {
        guard let currentVC = currentVC, let currentView = currentVC.view else { return }
        let permissionView = CustomPermissionView(inputPermissionType: type)
        permissionView.mainView.backgroundColor = UIColor.white
        permissionView.translatesAutoresizingMaskIntoConstraints = false
        currentView.addSubview(permissionView)
        NSLayoutConstraint.activate([
            permissionView.safeTopAnchor.constraint(equalTo: currentView.safeTopAnchor),
            permissionView.safeBottomAnchor.constraint(equalTo: currentView.safeBottomAnchor),
            permissionView.safeLeadingAnchor.constraint(equalTo: currentView.safeLeadingAnchor),
            permissionView.safeTrailingAnchor.constraint(equalTo: currentView.safeTrailingAnchor)
            ])
        
        permissionView.isAuthorized.bind { [unowned self] in
            self.authorizationCheckAgain($0, type)
        }
    }
    
    private func authorizationCheckAgain(_ isAuthorized: Bool, _ type:PermissionFLows ) {
        guard isAuthorized else { return }
        DispatchQueue.main.async {
            self.accessAgain(type)
        }
    }
    
    private func accessAgain(_ type: PermissionFLows) {
        switch type {
        case .camera:
            cameraAuthorization()
        case .photoLibrary:
            photoLibraryAuthorization()
        case .videoLibrary:
            videoLibraryAuthorization()
        default:
            return
        }
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController?.dismiss(animated: true, completion: nil)
    }
    
    // image or video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var mediaPathExtension: String = Constants.DEFAULT_PATH_EXT_JPG
        // deprecated
        //        if let mediaReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
        //            mediaPathExtension = mediaReferenceUrl.pathExtension.lowercased()
        //        }
        
        if let mediaReferenceUrl = info[UIImagePickerController.InfoKey.phAsset] as? URL {
            mediaPathExtension = mediaReferenceUrl.pathExtension.lowercased()
        }
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imagePicked?(editedImage, mediaPathExtension)
        }
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePicked?(originalImage, mediaPathExtension)
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("videoUrl: \(videoUrl)")
            self.videoPicked?(videoUrl, mediaPathExtension)
            
            // try compression of video
            guard let data = NSData(contentsOf: videoUrl) else { return }
            print("File size before compression: \(Double(data.length / 1048576)) mb")
        }
        
        pickerController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    //                    self.videoPicked?(compressedURL, "mov")
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
