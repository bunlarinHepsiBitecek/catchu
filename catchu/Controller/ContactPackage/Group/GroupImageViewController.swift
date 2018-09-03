//
//  GroupImageViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupImageViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var selectedPhotoScrollview: PhotoSpecialScrollView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var closeView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var containerImageView: UIView!
    
    @IBOutlet var topConstraints: NSLayoutConstraint!
    @IBOutlet var heigthConstraint: NSLayoutConstraint!
    
    var group = Group()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGestureRecognizer()
//        setConstraints()
        setupImage()
        
        DispatchQueue.main.async {
           
            let temp = UIImageView()
            
            temp.setImagesFromCacheOrFirebaseForFriend(self.group.groupPictureUrl)
            
            self.selectedPhotoScrollview.imageToDisplay = temp.image
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupImage() {
//        imageView.setImagesFromCacheOrFirebaseForFriend(group.groupPictureUrl)
        
    }
    
    func setConstraints() {
        
        print("setConstraints starts")

        let deviceViewHeight = UIScreen.main.bounds.height
        let deviceViewWidth = UIScreen.main.bounds.width
        
        print("deviceViewHeight : \(deviceViewHeight)")
        print("deviceViewHeight : \(deviceViewHeight)")
        
        let dynamicSize = deviceViewHeight - deviceViewWidth
        
        let halfValue = dynamicSize / 2
        print("halfValue : \(halfValue)")
        
        topConstraints.constant = halfValue - UIApplication.shared.statusBarFrame.height
        heigthConstraint.constant = view.bounds.size.width
        
    }
    
    func setGestureRecognizer() {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.exitFromViewController(_:)))

        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.direction = .up
        self.mainView.isUserInteractionEnabled = true
        self.mainView.addGestureRecognizer(swipeGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imagePickerStart(_:)))
        tapGestureRecognizer.delegate = self
        self.selectedPhotoScrollview.isUserInteractionEnabled = true
        self.selectedPhotoScrollview.addGestureRecognizer(tapGestureRecognizer)

        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.exitFromViewControllerByTapGesture(_:)))
        closeTapGesture.delegate = self
        self.closeView.isUserInteractionEnabled = true
        self.closeView.addGestureRecognizer(closeTapGesture)
    }
    
    @objc func exitFromViewController(_ sender : UISwipeGestureRecognizer) {
        
        print("exitFromViewController starts")
        
        if sender.direction == .up {
            
            print("hihihihihihihih")
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func exitFromViewControllerByTapGesture(_ sender : UITapGestureRecognizer) {
        
        print("exitFromViewControllerByTapGesture starts")
        
        if sender.state == .ended {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func imagePickerStart(_ sender : UITapGestureRecognizer) {
        
        print("imagePickerStart starts")
        
        if sender.state == .ended {

            ImageVideoPickerHandler.shared.delegate = self
            ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
            
            
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }

}

extension GroupImageViewController: ImageHandlerProtocol {
    func returnImage(inputImage: UIImage) {
        selectedPhotoScrollview.imageToDisplay = inputImage
    }
    
    
}
