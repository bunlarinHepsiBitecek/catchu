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
    
    func startActionSheetManager(type : ActionControllerType, operationType: ActionControllerOperationType?, delegate : ActionSheetProtocols?, title: String?, image: UIImage? = nil) {
        
        self.delegate = delegate
        
        switch type {
        case .camera:
            if let operationType = operationType {
                starCameraOperations(operationType: operationType)
            }
        case .video:
            if let operationType = operationType {
                starVideoOperations(operationType: operationType)
            }
        case .groupInformation:
            presentGroupInformationViewController()
        case .userInformation:
            if let operationType = operationType {
                startUserInformationOperations(title: title!, operationType: operationType)
            }
        case .newParticipant:
            if let title = title {
                startAddingNewParticipantProcess(title: title)
            }
        case .removeFollower:
            startRemovingProcess()
            if let image = image {
            }
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
    
    private func presentGroupInformationViewController() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.groupInformation, style: .default, handler: { (action) in
            // to do
            self.delegate.presentViewController()
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.exitGroup, style: .destructive, handler: { (action) in
            
            self.delegate.exitFromGroup()
            
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
    /// Description : called from group participants
    ///
    /// - Parameters:
    ///   - title: action sheet title comes from outside
    ///   - operationType: operation type for dynamic action sheet list
    /// - Author: Erkut Bas
    private func startUserInformationOperations(title: String, operationType: ActionControllerOperationType) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.gotoInfo, style: .default, handler: { (action) in
            // to do
             self.delegate.returnOperations(selectedProcessType: .gotoUserInfo)
        }))
        
        if operationType == .admin {
            
            alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.makeGroupAdmin, style: .default, handler: { (action) in
                // to do
                
                self.delegate.returnOperations(selectedProcessType: .makeGroupAdmin)
            }))
            
            alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.exitGroup, style: .destructive, handler: { (action) in
                // to do
                self.delegate.returnOperations(selectedProcessType: .exitGroup)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
    /// Description: when add new participants to group, creates an action sheet
    ///
    /// - Parameter title: title contains participant information
    /// - Author: Erkut Bas
    private func startAddingNewParticipantProcess(title: String) {
     
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.add, style: .default, handler: { (action) in
            // to do
            self.delegate.returnOperations(selectedProcessType: .addNewParticipant)
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        alertController.view.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
    private func startRemovingProcess() {
        
        let alertController = UIAlertController(title: "KOKO", message: nil, preferredStyle: .actionSheet)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
        imageView.image = UIImage(named: "8771.jpg")
        
        alertController.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = alertController.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: safe.topAnchor),
            //imageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
            
            ])
        
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.ActionSheetTitles.add, style: .default, handler: { (action) in
            // to do
            self.delegate.returnOperations(selectedProcessType: .removeFollower)
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel, handler: { (action) in
            // to do
        }))
        
        alertController.view.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.triggerViewControllerPresenter(controller: Controller<UIAlertController>.input(alertController))
        
    }
    
}
