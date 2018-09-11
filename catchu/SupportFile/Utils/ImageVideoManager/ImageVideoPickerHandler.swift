//
//  ImageVideoPickerHandler.swift
//  catchu
//
//  Created by Erkut Baş on 8/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

enum ImageProcessPickerType {
    case profilePicture
}

class ImageVideoPickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public static var shared = ImageVideoPickerHandler()

    weak var delegate: ImageHandlerProtocol!
    
    // func createActionSheetForImageChoiceProcess(inputRequest : ImageProcessPickerType, inputCallerViewController : CallerViewController) {
    func createActionSheetForImageChoiceProcess(inputRequest : ImageProcessPickerType) {
        
        var title = Constants.CharacterConstants.SPACE
        
        switch inputRequest {
        case .profilePicture:
            title = LocalizedConstants.PickerControllerStrings.chooseProfilePicture
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: LocalizedConstants.PickerControllerStrings.takePhoto, style: .default) { (alertAction) in
        
            print("camera action selected")
//            self.takePictureByCamera(inputViewControllerChoice: inputCallerViewController)
            self.takePictureByCamera()
            
        }
        
        let galeryAction = UIAlertAction(title: LocalizedConstants.PickerControllerStrings.chooseFromLibrary, style: .default) { (alertAction) in
            
            print("galeery action selected")
            //self.getPictureByGalery(inputViewControllerChoice: inputCallerViewController)
            self.getPictureByGalery()
            
        }
        
        let cancelAction = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel) { (alertAction) in
            print("cancel is selected")
            
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        
    }
    
    // photo library permission request management
    // func getPictureByGalery(inputViewControllerChoice : CallerViewController) {
    func getPictureByGalery() {
        
        print("getPictureByGalery starts")
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        print("status : \(status.rawValue)")
        print("status : \(status.hashValue)")
        
        switch status {
        case .authorized:
            
            initializeGalery()
            
        case .notDetermined:
            
            gotoRequestProcessViewControllers(inputPermissionType: PermissionFLows.photoLibrary)
            
        default:
            
            gotoRequestProcessViewControllers(inputPermissionType: PermissionFLows.photoLibraryUnAuthorized)
            
        }
        
    }
    
    // camera permission request management
    // func takePictureByCamera(inputViewControllerChoice : CallerViewController) {
    func takePictureByCamera() {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        print("status : \(status.rawValue)")
        print("status : \(status.hashValue)")
        
        
        switch status {
        case .authorized:

            initializeCamera()

        case .notDetermined:
            
            gotoRequestProcessViewControllers(inputPermissionType: PermissionFLows.camera)

        default:

            gotoRequestProcessViewControllers(inputPermissionType: PermissionFLows.cameraUnathorized)

        }
        
        
    }
    
    func initializeGalery() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        UIApplication.topViewController()?.present(picker, animated: true, completion: nil)
        
    }
    
    func initializeCamera() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.allowsEditing = true
        UIApplication.topViewController()?.present(picker, animated: true, completion: nil)
        
        
    }
    
    
    /// The function below decides which controller is going to be presented according to input permission type such as camera permission request or photo library permission request
    ///
    /// - Parameter inputPermissionType: camera, photo library etc, it is embedded in EnumFiles
    func gotoRequestProcessViewControllers(inputPermissionType : PermissionFLows) {

        PermissionHandler.shared.delegate = self
        PermissionHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: inputPermissionType)
        
//        switch inputPermissionType {
//        case .camera, .photoLibrary:
//
//            if let destinationViewControler = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: "PhotoLibraryPrePermissionViewController") as? PhotoLibraryPrePermissionViewController {
//
//                destinationViewControler.viewControllerFlowType = inputPermissionType
//                destinationViewControler.delegate = self
//                UIApplication.topViewController()?.present(destinationViewControler, animated: true, completion: nil)
//
//            }
//
//        case .cameraUnathorized, .photoLibraryUnAuthorized:
//
//            if let destinationViewControler = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: "MediaPermissionUnAuthorizedViewController") as? MediaPermissionUnAuthorizedViewController {
//
//                destinationViewControler.flowType = inputPermissionType
//
//                UIApplication.topViewController()?.present(destinationViewControler, animated: true, completion: nil)
//
//            }
//
//        }
        
    }
    
    /// Image picker controller, after selecting picture, media, video etc to be used
    ///
    /// - Parameters:
    ///   - picker: picker
    ///   - info: info .....
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        // downcast any to UIImage
        if let editedPickedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedPickedImage
            
        } else if let originalPickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalPickedImage
        }
        
        if let selectedImage = selectedImageFromPicker {

            delegate.returnImage(inputImage: selectedImage)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK: - The extension below is used for gettion the top viewcontroller which is active at that moment
extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        print("topViewController starts")
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
            
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

extension ImageVideoPickerHandler : PermissionProtocol {
    func returnPermissionResult(status: PHAuthorizationStatus) {
        
        if status == .authorized {
            self.initializeGalery()
        }
        
    }
    
    
}
