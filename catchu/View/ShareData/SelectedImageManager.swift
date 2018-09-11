//
//  SelectedImageManager.swift
//  catchu
//
//  Created by Erkut Baş on 9/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SelectedImageManager: UIView {

    var timeInterval : TimeInterval!
    var image : UIImage!
    
    private var customScrollView = CustomScrollView()
    
    lazy var mainView : UIView = {
       
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var containerView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        return temp
    }()
    
    lazy var selectedImageScrollView: UIScrollView = {
        
        let temp = UIScrollView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        temp.clipsToBounds = false;
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        temp.alwaysBounceHorizontal = true
        temp.alwaysBounceVertical = true
        temp.bouncesZoom = true
        temp.decelerationRate = UIScrollViewDecelerationRateFast
        temp.delegate = self
        temp.minimumZoomScale = 1.0
        temp.maximumZoomScale = 5.0
        temp.contentInset = UIEdgeInsets.zero;
//        temp.maximumZoomScale = 5.0
        
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
    }()
    
    lazy var selectedImage: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFit
        temp.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

        return temp
    }()
    
    lazy var cropImageButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "crop_tool")
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.alpha = 0
        
        setupViews()
//        setupInitialView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.addSubview(mainView)
        mainView.addSubview(containerView)
        mainView.addSubview(closeButton)
        mainView.addSubview(cropImageButton)
//        containerView.addSubview(selectedImageScrollView)
//        selectedImageScrollView.addSubview(selectedImage)
        
        let safeAreaForMainView = self.safeAreaLayoutGuide
        let safeAreaForCloseButton = self.mainView.safeAreaLayoutGuide
        let safeAreaForScrollView = self.containerView.safeAreaLayoutGuide
        let sadeAreaForSelectedImage = self.selectedImageScrollView.safeAreaLayoutGuide
        let safeAreaSelectedImage = self.selectedImageScrollView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safeAreaForMainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safeAreaForMainView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: safeAreaForMainView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: safeAreaForMainView.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: safeAreaForCloseButton.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaForCloseButton.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safeAreaForCloseButton.topAnchor, constant:50),
            containerView.bottomAnchor.constraint(equalTo: safeAreaForCloseButton.bottomAnchor, constant: -50),
            
//            selectedImageScrollView.topAnchor.constraint(equalTo: safeAreaForScrollView.topAnchor),
//            selectedImageScrollView.bottomAnchor.constraint(equalTo: safeAreaForScrollView.bottomAnchor),
//            selectedImageScrollView.leadingAnchor.constraint(equalTo: safeAreaForScrollView.leadingAnchor),
//            selectedImageScrollView.trailingAnchor.constraint(equalTo: safeAreaForScrollView.trailingAnchor),
//
//            selectedImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
//            selectedImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
////            selectedImage.leadingAnchor.constraint(equalTo: sadeAreaForSelectedImage.leadingAnchor),
////            selectedImage.trailingAnchor.constraint(equalTo: sadeAreaForSelectedImage.trailingAnchor),
////            selectedImage.centerXAnchor.constraint(equalTo: sadeAreaForSelectedImage.centerXAnchor),
////            selectedImage.centerYAnchor.constraint(equalTo: sadeAreaForSelectedImage.centerYAnchor),
////            selectedImage.bottomAnchor.constraint(equalTo: sadeAreaForSelectedImage.bottomAnchor),
////            selectedImage.topAnchor.constraint(equalTo: sadeAreaForSelectedImage.topAnchor),

            closeButton.topAnchor.constraint(equalTo: safeAreaForCloseButton.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaForCloseButton.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            cropImageButton.bottomAnchor.constraint(equalTo: safeAreaForCloseButton.bottomAnchor, constant: -10),
            cropImageButton.trailingAnchor.constraint(equalTo: safeAreaForCloseButton.trailingAnchor, constant: -10),
            cropImageButton.heightAnchor.constraint(equalToConstant: 30),
            cropImageButton.widthAnchor.constraint(equalToConstant: 30)
            
        ])
        
        setupGestureRecognizerToCloseButton()
        
    }
    
    func setupGestureRecognizerToCloseButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectedImageManager.disappearView(_:)))
        tapGesture.delegate = self
        
        closeButton.addGestureRecognizer(tapGesture)
    }
    
//    func setImage(input : UIImage) {
//
//        customScrollView.setupScrollView(inputImage: input)
//        
//        containerView.addSubview(customScrollView)
//        
//        customScrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let area = containerView.safeAreaLayoutGuide
//        
//        customScrollView.topAnchor.constraint(equalTo: area.topAnchor).isActive = true
//        customScrollView.bottomAnchor.constraint(equalTo: area.bottomAnchor).isActive = true
//        customScrollView.leadingAnchor.constraint(equalTo: area.leadingAnchor).isActive = true
//        customScrollView.trailingAnchor.constraint(equalTo: area.trailingAnchor).isActive = true
//        
//    }
    
    override func layoutSubviews() {
        customScrollView.setZoomScale()
    }
    
}

extension SelectedImageManager : UIGestureRecognizerDelegate {
    
    @objc func disappearView(_ sender : UITapGestureRecognizer) {
        
        if let time = timeInterval {
            
            UIView.animate(withDuration: time, animations: {
                self.alpha = 0
            }) { (result) in
                
                if result {
                    self.removeFromSuperview()
                }
                
            }
            
        } else {
            
            UIView.animate(withDuration: 0.4, animations: {
//                self.alpha = 0
                self.removeFromSuperview()
            })
            
        }
        
    }
    
}


// MARK: - scrollview operations
extension SelectedImageManager : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("viewForZooming starts")
        return selectedImage
    }
    
}


