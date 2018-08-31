//
//  GroupImageViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupImageViewController: UIViewController, UIGestureRecognizerDelegate {

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
        setConstraints()
        setupImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupImage() {
        imageView.setImagesFromCacheOrFirebaseForFriend(group.groupPictureUrl)
        
    }
    
    func setConstraints() {
        
        print("setConstraints starts")
        print("mainView.frame.width : \(mainView.frame.width)")
        print("view.bounds.size.width : \(view.bounds.size.width)")
        print("mainView.bounds.size.width : \(mainView.bounds.size.width)")
        heigthConstraint.constant = view.bounds.size.width
        
        print("heigthConstraint.constant : \(heigthConstraint.constant)")
        
        let x = mainView.bounds.size.height - containerImageView.frame.height
        
        print("x : \(x)")
        
        let topLine = x / 3
        
        print("topLine : \(topLine)")
        
        topConstraints.constant = topLine
            
        
        
    }
    
    func setGestureRecognizer() {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.exitFromViewController(_:)))

        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.direction = .up
        self.mainView.isUserInteractionEnabled = true
        self.mainView.addGestureRecognizer(swipeGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imagePickerStart(_:)))
        tapGestureRecognizer.delegate = self
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)

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

            ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
            
        }
        
        
        
    }

}
