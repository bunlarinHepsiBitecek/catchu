//
//  PhotoLibraryPrePermissionViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/22/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class PhotoLibraryPrePermissionViewController: UIViewController {

    @IBOutlet var notNowButton: UIButton!
    @IBOutlet var giveAccessButton: UIButton!

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var mainIcon: UIImageView!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    var viewControllerFlowType : PermissionFLows!
    var callerClass : CallerClass!
    
    weak var delegate : PermissionProtocol!
    weak var delegateForExternalClass : PermissionProtocol!
    weak var delegateForShareData : ShareDataProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObjects(inputPermissionFlow: viewControllerFlowType)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notNowButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let type = viewControllerFlowType {
            
            switch type {
            case .camera: break
//                startRequestProcessForCamera()
                
            case .photoLibrary:
//                self.delegateForExternalClass.initiateSpecificActions()
                break
                
            case .microphone:
                self.delegateForShareData.initiateCustomVideo()
                
            default:
                print("do nothing")
            }
            
        }
        
    }
    
    
    @IBAction func giveAccessButtonTapped(_ sender: Any) {
        
//        if let type = viewControllerFlowType {
//
//            switch type {
//            case .camera:
//                startRequestProcessForCamera()
//
//            case .photoLibrary:
//                startRequestProcessForPhotoLibrary()
//
//            case .microphone:
//                startRequestProcessForMicrophone()
//
//            default:
//                print("do nothing")
//            }
//
//        }
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension PhotoLibraryPrePermissionViewController {
    
    private func startRequestProcessForPhotoLibrary() {
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            
            DispatchQueue.main.async {
                //self.delegate.returnPermissionResult(status: authorizationStatus, permissionType: permissionType)
            }
            
        }
        
    }
    
    private func startRequestProcessForCamera() {
        
//        AVCaptureDevice.requestAccess(for: .video) { (result) in
//            
//            if result {
//                
////                ImageVideoPickerHandler.shared.initializeCamera()
//                
//                // the function below triggers a uiview addsubview in main tread
//                DispatchQueue.main.async {
//                    self.delegate.returnPermissinResultBoolValue(result: result)
//                }
//                
//            }
//            
//        }
        
    }
    
    private func startRequestProcessForMicrophone() {
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            
            if granted {
                self.delegateForShareData.initiateCustomVideo()
            } 
            
        }
        
    }
    
    private func setupObjects(inputPermissionFlow : PermissionFLows) {
        
        print("default setups in onlineimage")
        
        switch inputPermissionFlow {
        
        case .photoLibrary:
            setupPhotoLibraryFlow()
            
        case .camera:
            setupCameraRequestFlow()
            
        case .microphone:
            setupMicrophoneRequestFlow()
            
        default:
            print("do nothing")
        }
        
    }
    
    private func setupPhotoLibraryFlow() {

        mainImage.image = UIImage(named: "jon-tyson-762647-unsplash.jpg")
        mainImage.alpha = 1

        mainIcon.image = UIImage(named: "gallery_request.png")

        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForPhotos
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForPhotos

    }

    private func setupCameraRequestFlow() {

        mainImage.image = UIImage(named: "jakob-owens-168413-unsplash.jpg")
        mainImage.alpha = 1

        mainIcon.image = UIImage(named: "camera_request.png")

        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForCamera
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForCamera

    }
    
    private func setupMicrophoneRequestFlow() {
        
        mainImage.image = UIImage(named: "microphoneMain")
        mainImage.alpha = 1
        
        mainIcon.image = UIImage(named: "microphone")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForMicrophone
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForMicrophone
        
    }
}
