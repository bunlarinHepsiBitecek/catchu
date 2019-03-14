//
//  CameraImagePickerManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/22/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

enum Controller<T> {
    case input(T)
}

class CameraImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public static var shared = CameraImagePickerManager()
    
    private weak var delegate : CameraImageVideoHandlerProtocol?
    
    func openImageGallery(delegate : CameraImageVideoHandlerProtocol) {
        
        print("PHPhotoLibrary.authorizationStatus() : \(PHPhotoLibrary.authorizationStatus().rawValue)")
        
        self.delegate = delegate
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            initializeGalery()
        case .notDetermined:
            delegate.triggerPermissionProcess(permissionType: .photoLibrary)
        case .restricted, .denied:
            delegate.triggerPermissionProcess(permissionType: .photoLibraryUnAuthorized)
        }
        
    }
    
    func openVideoGallery(delegate : CameraImageVideoHandlerProtocol) {
        print("\(#function) starts")
        
        self.delegate = delegate
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            initializeVideoGallery()
        case .notDetermined:
            delegate.triggerPermissionProcess(permissionType: .videoLibrary)
        case .denied, .restricted:
            delegate.triggerPermissionProcess(permissionType: .videoLibraryUnauthorized)
        }
        
    }
    
    func openSystemCamera(delegate : CameraImageVideoHandlerProtocol) {
        print("\(#function) starts")
        
        self.delegate = delegate
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            initializeSystemCamera()
        case .notDetermined:
            delegate.triggerPermissionProcess(permissionType: .camera)
            return
        case .denied, .restricted:
            delegate.triggerPermissionProcess(permissionType: .cameraUnathorized)
            return
        }
        
    }
    
    private func initializeGalery() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        
        self.triggerViewControllerPresenter(controller: Controller<UIImagePickerController>.input(picker))
        
    }
    
    private func initializeVideoGallery() {
        print("\(#function) start")
        
        print("UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) : \(UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum))")
        
        /*
         
            kUTTypeMovie in UTCoreTypes.h
         */
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.videoMaximumDuration = TimeInterval(15)
        
        picker.videoExportPreset = AVAssetExportPresetMediumQuality
        
        picker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
        
        self.triggerViewControllerPresenter(controller: Controller<UIImagePickerController>.input(picker))
        
    }
    
    private func initializeSystemCamera() {
        print("\(#function) starts")
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        
        self.triggerViewControllerPresenter(controller: Controller<UIImagePickerController>.input(picker))
        
    }
    
    private func findImageOrientation(image : UIImage) -> ImageOrientation {
        if image.size.width > image.size.height {
            return ImageOrientation.landScape
        } else if image.size.width < image.size.height {
            return ImageOrientation.portrait
        } else if image.size.width == image.size.height {
            return ImageOrientation.square
        } else {
            return ImageOrientation.other
        }
    }
    
    func triggerViewControllerPresenter(controller : Controller<UIImagePickerController>) {
        
        if let currentViewController = LoaderController.currentViewController() {
           
            switch controller {
            case .input(let controller):
                currentViewController.present(controller, animated: true) {
                    print("camera is presented")
                }
            }

        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("didFinishPickingMediaWithInfo starts")
        
        var selectedImageFromPicker : UIImage?
        var selectedMediaFromPicker : URL?
        var selectedMediaPathExtension: String?
        
        if let infoUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            selectedMediaPathExtension = infoUrl.pathExtension.lowercased()
        }
        
        // downcast any to UIImage
        if let editedPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedPickedImage
        } else if let originalPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalPickedImage
        } else if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            selectedMediaFromPicker = videoUrl
            
            let data = NSData(contentsOf: selectedMediaFromPicker!)
            print("video byte : \(data?.length)")
            
            let byteCount : Int = (data?.length)!
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(byteCount))
            print(string)
            
        }
        
        picker.dismiss(animated: true) {
            
            if let selectedImage = selectedImageFromPicker {
                
                if selectedMediaPathExtension == nil {
                    selectedMediaPathExtension = Constants.DEFAULT_PATH_EXT_JPG
                }
                
                if let delegate = self.delegate {
                    delegate.returnPickedImage(image: selectedImage, pathExtension: selectedMediaPathExtension!, orientation: self.findImageOrientation(image: selectedImage))
                }
            }
            
            if let selectedVideo = selectedMediaFromPicker {
                if let delegate = self.delegate {
                    delegate.returnPickedVideo(url: selectedVideo)
                }
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("\(#function) starts")
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}

