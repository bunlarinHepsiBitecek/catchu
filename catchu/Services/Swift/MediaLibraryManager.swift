//
//  MediaLibraryManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

typealias Success = (_ photos:[PHAsset])->Void

class MediaLibraryManager {
    public static let shared = MediaLibraryManager()
    public var assets = [PHAsset]()
    public var success:Success? = nil
    
    weak var delegateForExternalSources : PermissionProtocol!
    
    func loadPhotos(success:Success!){
        self.success = success
        self.assets = [PHAsset]()
//        self.photoAuthorizationCheck()
        self.photoAuthorizationCheckWithCustomViewController()
    }
    
    private func photoAuthorizationCheckWithCustomViewController() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        PermissionHandler.shared.delegateForExternalClass = delegateForExternalSources
        PermissionHandler.shared.delegate = self
        
        switch status {
        case .authorized:
            self.loadAllPhotos()
            break
        case .notDetermined:
            PermissionHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .photoLibrary)
//            ImageVideoPickerHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .photoLibrary)
            break
        case .restricted, .denied:
            PermissionHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .photoLibraryUnAuthorized)
//            ImageVideoPickerHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .photoLibraryUnAuthorized)
            break
        }
    }
    
    private func photoAuthorizationCheck() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            self.loadAllPhotos()
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.loadAllPhotos()
                }
            }
            break
        case .restricted, .denied:
            self.permissionAlert()
            break
        }
    }
    
    func permissionAlert() {
        AlertViewManager.shared.createAlert(title: LocalizedConstants.Library.AccessLibraryDisableTitle, message: LocalizedConstants.Library.AccessLibraryDisable, preferredStyle: .alert, actionTitleLeft: LocalizedConstants.Library.Settings, actionTitleRight: LocalizedConstants.Library.Ok, actionStyle: .default, completionHandlerLeft: { (action) in
            LoaderController.shared.goToSettings()
        }, completionHandlerRight: nil)
    }
    
    // MARK: Photos
    // private func loadAllPhotos()
    func loadAllPhotos() {
        
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = Constants.MediaLibrary.ImageFetchLimit100
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects({ (object, index, stop) -> Void in
            self.assets.append(object)
            if self.assets.count == fetchResult.count{ self.success!(self.assets) }
        })
    }
    
    public func imageFrom(asset:PHAsset, size:CGSize, compilation:@escaping (_ photo:UIImage)->Void){
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = (size == PHImageManagerMaximumSize) ? .highQualityFormat : .opportunistic
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
            compilation(image!)
        })
    }
    
    // MARK: Videos
    private func loadAllVideos() {
        
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        fetchResult.enumerateObjects({ (object, index, stop) -> Void in
            self.assets.append(object)
            if self.assets.count == fetchResult.count{ self.success!(self.assets) }
        })
    }

}

extension MediaLibraryManager : PermissionProtocol {
    func returnPermissionResult(status: PHAuthorizationStatus) {
        
        self.loadAllPhotos()
        
//        assets.reverse()
    }
    
}
