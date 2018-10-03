//
//  CustomScrollViewContainer.swift
//  catchu
//
//  Created by Erkut Baş on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomScrollViewContainer: UIView {
    
    weak var delegate : ShareDataProtocols!

    lazy var containerView: UIView = {
        
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
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
    
    lazy var cropButton: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "crop_tool")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    lazy var scrollView: CustomScrollView4 = {
        let temp = CustomScrollView4()
        
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        setupViews()
        setupCloseButtonGesture()
        setupCropButtonGesture()

        activationManagement(granted : false)

    }
    
//    init(image : UIImage) {
//        super.init(frame: .zero)
//
//        setupViews()
//        setupCloseButtonGesture()
//
//        activationManagement(granted : false)
//
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setContainerHeightWidth()

    }
    
}

// MARK: - major functions
extension CustomScrollViewContainer {
    
    func setDelegate(delegate : ShareDataProtocols) {
        self.delegate = delegate
    }
    
    func setupViews() {
        
        self.addSubview(containerView)
        self.addSubview(closeButton)
        self.addSubview(cropButton)
        self.containerView.addSubview(scrollView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
//            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            closeButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            cropButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -15),
            cropButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -15),
            cropButton.heightAnchor.constraint(equalToConstant: 30),
            cropButton.widthAnchor.constraint(equalToConstant: 30),
            
            scrollView.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeContainer.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeContainer.topAnchor),
            
            ])
        
    }
    
    func setContainerHeightWidth() {
        print("setContainerHeightWidth starts")
        
        print("self.frame.size : \(self.frame.size)")
        
        containerView.heightAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        
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
        
        scrollView.imageToDisplay = inputImage
        activationManagement(granted: true)
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomScrollViewContainer : UIGestureRecognizerDelegate {

    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollViewContainer.dismissCustomScrollView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissCustomScrollView(_ sender : UITapGestureRecognizer) {
        
        activationManagement(granted: false)
        
    }
    
    func setupCropButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollViewContainer.cropImage(_:)))
        tapGesture.delegate = self
        cropButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func cropImage(_ sender : UITapGestureRecognizer) {
        
        let scale:CGFloat = 1/self.scrollView.zoomScale
        let x:CGFloat = self.scrollView.contentOffset.x * scale
        let y:CGFloat = self.scrollView.contentOffset.y * scale
        let width:CGFloat = self.frame.size.width * scale
        let height:CGFloat = self.frame.size.height * scale
        let croppedCGImage = scrollView.imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        delegate.setCroppedImage(inputImage: croppedImage)
        
    }
    
}

