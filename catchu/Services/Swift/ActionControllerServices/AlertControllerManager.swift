//
//  ActionSheetManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/22/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AlertControllerManager {
    
    public static var shared = AlertControllerManager()
    
    weak var delegate : ActionSheetProtocols!
    
    func startActionSheetManager(type : ActionControllerType, operationType: ActionControllerOperationType, delegate : ActionSheetProtocols) {
        
        self.delegate = delegate
        
        switch type {
        case .camera:
            starCameraOperations(operationType: operationType)
            break
        case .video:
            starVideoOperations(operationType: operationType)
            break
        }
        
    }
    
    private func starCameraOperations(operationType : ActionControllerOperationType) {
        print("starCameraOperations starts")
        
        let alertController = UIAlertController(title: LocalizedConstants.ActionSheetTitles.cameraGalleryTitle, message: LocalizedConstants.ActionSheetTitles.cameraGalleryExplanation, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.camera, style: .default, handler: { (action) in
            // to do
            self.delegate.returnOperations(selectedProcessType: .cameraOpen)
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.gallery, style: .default, handler: { (action) in
            // to do
            
            self.delegate.returnOperations(selectedProcessType: .imageGalleryOpen)
        }))
        
        if operationType == .update {
            alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.update, style: .destructive, handler: { (action) in
                // to do
                self.delegate.returnOperations(selectedProcessType: .selectedImageUpdate)
            }))
            
            alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.delete, style: .destructive, handler: { (action) in
                // to do
                self.delegate.returnOperations(selectedProcessType: .selectedImageDelete)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
    private func starVideoOperations(operationType : ActionControllerOperationType) {
        print("starVideoOperations starts")
        
        let alertController = UIAlertController(title: LocalizedConstants.ActionSheetTitles.videoGalleryTitle, message: LocalizedConstants.ActionSheetTitles.viodeGalleryExplanation, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.video, style: .default, handler: { (action) in
            // to do
            self.delegate.returnOperations(selectedProcessType: .videoOpen)
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.gallery, style: .default, handler: { (action) in
            // to do
            
            self.delegate.returnOperations(selectedProcessType: .videoGalleryOpen)
        }))
        
        if operationType == .update {

            alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.delete, style: .destructive, handler: { (action) in
                // to do
                self.delegate.returnOperations(selectedProcessType: .selectedVideoDelete)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
    private func triggerViewControllerPresenter(controller : Controller<UIAlertController>) {
        
        if let currentViewController = LoaderController.currentViewController() {
            
            switch controller {
            case .input(let controller):
                currentViewController.present(controller, animated: true) {
                    print("alertController is presented")
                }
            }
            
        }
        
    }
    
}
