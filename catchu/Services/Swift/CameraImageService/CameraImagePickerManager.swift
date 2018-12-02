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
        picker.sourceType = .savedPhotosAlbum
        picker.videoMaximumDuration = TimeInterval(15)
        picker.mediaTypes = [kUTTypeMovie as String]
        
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
        
        if let x = info[UIImagePickerControllerReferenceURL] as? URL {
            print("x.path : \(x.pathExtension)")
        }
        
        // downcast any to UIImage
        if let editedPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedPickedImage
        } else if let originalPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalPickedImage
        } else if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            selectedMediaFromPicker = videoUrl
        }
        
        picker.dismiss(animated: true) {
            
            if let selectedImage = selectedImageFromPicker {
                if let delegate = self.delegate {
                    delegate.returnPickedImage(image: selectedImage)
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

