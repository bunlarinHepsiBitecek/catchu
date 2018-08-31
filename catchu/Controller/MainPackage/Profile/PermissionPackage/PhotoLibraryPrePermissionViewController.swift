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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewControllerFlowType : \(viewControllerFlowType)")
        
        setupObjects(inputPermissionFlow: viewControllerFlowType)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notNowButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func giveAccessButtonTapped(_ sender: Any) {
        
        if let type = viewControllerFlowType as? PermissionFLows {
            
            switch type {
            case .camera:
                startRequestProcessForCamera()
                
            case .photoLibrary:
                startRequestProcessForPhotoLibrary()
                
            default:
                print("do nothing")
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension PhotoLibraryPrePermissionViewController {
    
    func startRequestProcessForPhotoLibrary() {
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            
            if authorizationStatus == .authorized {
                
                ImageVideoPickerHandler.shared.initializeGalery()
                
            }
            
        }
        
    }
    
    func startRequestProcessForCamera() {
        
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            
            if result {
                
                ImageVideoPickerHandler.shared.initializeCamera()
                
            }
            
        }
        
    }
    
    func setupObjects(inputPermissionFlow : PermissionFLows) {
        
        print("default setups in onlineimage")
        
        switch inputPermissionFlow {
        
        case .photoLibrary:
            setupPhotoLibraryFlow()
            
        case .camera:
            setupCameraRequestFlow()
            
        default:
            print("do nothing")
        }
        
    }
    
    func setupPhotoLibraryFlow() {

        mainImage.image = UIImage(named: "jon-tyson-762647-unsplash.jpg")
        mainImage.alpha = 1

        mainIcon.image = UIImage(named: "gallery_request.png")

        topicLabel.text = "Please Allow Access to Your Photos"
        detailLabel.text = "This allows CatchU to access your photo library"

    }

    func setupCameraRequestFlow() {

        mainImage.image = UIImage(named: "jakob-owens-168413-unsplash.jpg")
        mainImage.alpha = 1

        mainIcon.image = UIImage(named: "camera_request.png")

        topicLabel.text = "Please Allow Access to Your Camera"
        detailLabel.text = "This allows CatchU to access your camera"

    }
}
