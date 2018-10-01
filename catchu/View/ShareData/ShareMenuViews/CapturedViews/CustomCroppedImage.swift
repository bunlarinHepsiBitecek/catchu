//
//  CustomCroppedImage.swift
//  catchu
//
//  Created by Erkut Baş on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomCroppedImage: UIView {
    
    weak var delegate : ShareDataProtocols!
    
    lazy var imageContainer: UIImageView = {
        
        let temp = UIImageView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setupViews()
        setupCloseButtonGesture()
        
        activationManagement(granted : false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setContainerHeightWidth()
        
    }
    
}

// MARK: - major functions
extension CustomCroppedImage {
    
    func setupViews() {
        
        self.addSubview(imageContainer)
        self.addSubview(closeButton)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            imageContainer.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            //            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            //            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            closeButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func setContainerHeightWidth() {
        print("setContainerHeightWidth starts")
        
        print("self.frame.size : \(self.frame.size)")
        
        imageContainer.heightAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        imageContainer.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        
    }
    
    func activationManagement(granted : Bool) {
        
        if granted {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
        
    }
    
    public func setImage(inputImage : UIImage) {
        
        print("setImage starts")
        print("input image size : \(inputImage.size)")
        
        imageContainer.image = inputImage
        activationManagement(granted: true)
        
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomCroppedImage : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollViewContainer.dismissCustomScrollView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissCustomScrollView(_ sender : UITapGestureRecognizer) {
        
        activationManagement(granted: false)
        
    }
    
    
}

