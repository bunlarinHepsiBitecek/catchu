//
//  MediaPermissionUnAuthorizedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MediaPermissionUnAuthorizedViewController: UIViewController {

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var mainIcon: UIImageView!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var processButton: UIButton!
    
    var flowType : PermissionFLows!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController(inputFlowType: flowType)
        setupGestureRecognizer()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func processButtonTapped(_ sender: Any) {
        
        initiateDirectToSettings()
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

extension MediaPermissionUnAuthorizedViewController: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MediaPermissionUnAuthorizedViewController.dismissViewController(_:)))
        
        tapGestureRecognizer.delegate = self
       
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func dismissViewController(_ sender : UITapGestureRecognizer) {
        
        print("yarro baskan")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupViewController(inputFlowType : PermissionFLows) {
        
        switch inputFlowType {
        case .photoLibraryUnAuthorized:
            setupPhotoLibraryFlow()
            
        case .cameraUnathorized:
            setupCameraRequestFlow()
            
        default:
            print("do nothing")
        }
        
    }
    
    
    func setupPhotoLibraryFlow() {
        
        mainImage.image = UIImage(named: "jon-tyson-762647-unsplash.jpg")
        mainImage.alpha = 0.45
        
        mainIcon.image = UIImage(named: "gallery_request.png")
        
        topicLabel.text = "Please Allow Access to Your Photos"
        detailLabel.text = "This allows CatchU to access your photo library"
        
        processButton.setTitle("Enable Library Access", for: .normal)
        
    }
    
    func setupCameraRequestFlow() {
        
        mainImage.image = UIImage(named: "jakob-owens-168413-unsplash.jpg")
        mainImage.alpha = 0.45
        
        mainIcon.image = UIImage(named: "camera_request.png")
        
        topicLabel.text = "Please Allow Access to Your Camera"
        detailLabel.text = "This allows CatchU to access your camera"
        
        processButton.setTitle("Enable Camera Access", for: .normal)
        
    }
    
    func initiateDirectToSettings() {
        
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        
    }
    
}
