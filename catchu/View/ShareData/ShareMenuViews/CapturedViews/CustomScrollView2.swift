//
//  CustomScrollView2.swift
//  catchu
//
//  Created by Erkut Baş on 9/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

final class CustomScrollView2: UIScrollView {

    private let imageView = UIImageView()
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size { print("frame : \(frame)") ;setZoomScale() }
        }
    }
    
    lazy var closeButtonContainer: UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.cornerRadius = 20
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var cropButtonContainer: UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.cornerRadius = 20
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var cropImageButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "crop_tool")
        
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
    
    required init(image: UIImage) {
        super.init(frame: .zero)
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        print("imageView size : \(imageView.frame)")
        
        imageView.image = image
        imageView.sizeToFit()
        addSubview(imageView)
        contentSize = imageView.bounds.size
        
        print("imageView size : \(imageView.frame)")
        
        contentInsetAdjustmentBehavior = .never // Adjust content according to safe area if necessary
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        delegate = self
        
//        minimumZoomScale = 0.12
//        zoomScale = 0.12
        
        print("imageView size : \(imageView.frame)")
        
        setupViews()
        addGestures()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    func setZoomScale() {
        
        print("frame.size.width : \(frame.size.width)")
        print("imageView.bounds.width : \(imageView.bounds.width)")
        
        print("frame.size.height : \(frame.size.height)")
        print("imageView.bounds.height : \(imageView.bounds.height)")
        
        let widthScale = frame.size.width / imageView.bounds.width
        let heightScale = frame.size.height / imageView.bounds.height
        
        print("widthScale : \(widthScale)")
        print("heightScale : \(heightScale)")
        
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
        
        print("frame : \(frame)")
        
        print("imageView size : \(imageView.frame)")
        
    }
    
    func setupViews() {
        
        self.addSubview(closeButtonContainer)
        self.addSubview(cropButtonContainer)
        self.closeButtonContainer.addSubview(closeButton)
        self.cropButtonContainer.addSubview(cropImageButton)
        
        let safeAreaForMainView = self.safeAreaLayoutGuide
        let safeAreaForCloseButton = self.closeButtonContainer.safeAreaLayoutGuide
        let safeAreaForCropButton = self.cropButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            closeButtonContainer.topAnchor.constraint(equalTo: safeAreaForMainView.topAnchor, constant: 10),
            closeButtonContainer.trailingAnchor.constraint(equalTo: safeAreaForMainView.trailingAnchor, constant: -10),
            closeButtonContainer.heightAnchor.constraint(equalToConstant: 30),
            closeButtonContainer.widthAnchor.constraint(equalToConstant: 30),
            
            closeButton.centerXAnchor.constraint(equalTo: safeAreaForCloseButton.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: safeAreaForCloseButton.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            cropButtonContainer.bottomAnchor.constraint(equalTo: safeAreaForMainView.bottomAnchor, constant: -10),
            cropButtonContainer.trailingAnchor.constraint(equalTo: safeAreaForMainView.trailingAnchor, constant: -10),
            cropButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            cropButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            cropImageButton.centerXAnchor.constraint(equalTo: safeAreaForCropButton.centerXAnchor),
            cropImageButton.centerYAnchor.constraint(equalTo: safeAreaForCropButton.centerYAnchor),
            cropImageButton.heightAnchor.constraint(equalToConstant: 30),
            cropImageButton.widthAnchor.constraint(equalToConstant: 30)
            
            ])
        
        
    }
    
    func addGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollView2.disappearView(_:)))
        tapGesture.delegate = self
        
        closeButtonContainer.addGestureRecognizer(tapGesture)
        
        let tapGestureForCrop = UITapGestureRecognizer(target: self, action: #selector(CustomScrollView2.cropImage(_:)))
        tapGestureForCrop.delegate = self
        
        cropButtonContainer.addGestureRecognizer(tapGestureForCrop)
        
    }
    
    
}

extension CustomScrollView2: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("imageView size : \(imageView.frame)")
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
//        scrollView.contentInset = UIEdgeInsets(top: 100, left: 10, bottom: 20, right: 0)
        
        print("imageView size : \(imageView.frame)")
    }
    
}

extension CustomScrollView2 : UIGestureRecognizerDelegate {
    
    @objc func disappearView(_ sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (result) in
            
            if result {
                self.removeFromSuperview()
            }
            
        }
        
    }
    
    @objc func cropImage(_ sender : UITapGestureRecognizer) {
        print("cropImage pressed")
        
        UIView.transition(with: cropButtonContainer, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.cropButtonContainer.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
        }, completion: { (result) in
            
            if result {
                
                UIView.transition(with: self.cropButtonContainer, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    
                    self.cropButtonContainer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    
                })
                
            }
            
        })
        
        let scale:CGFloat = 1/self.zoomScale
        let x:CGFloat = self.contentOffset.x * scale
        let y:CGFloat = self.contentOffset.y * scale
        let width:CGFloat = self.frame.size.width * scale
        let height:CGFloat = self.frame.size.height * scale
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
    
//        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ShareDataViewController2) as? ShareDataViewController2 {
//            
//            destination.imageFinal = croppedImage
//            UIApplication.topViewController()?.present(destination, animated: true, completion: nil)
//            
//        }
        
        
        
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }

    
}

