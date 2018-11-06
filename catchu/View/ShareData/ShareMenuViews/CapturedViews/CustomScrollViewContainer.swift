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
    
    private var customGridView : CustomGridView?
    private var image : UIImage?

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
    
    lazy var maximizeButton: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "maximize")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    lazy var scrollView: CustomScrollView4 = {
        let temp = CustomScrollView4()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        // if clipToBounds does not set to true, zoom image bounds jumps out of uiview frames
        temp.clipsToBounds = true
        temp.delegateShareData = self
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        setupViews()
        setupCloseButtonGesture()
        setupCropButtonGesture()
        setupMaximizeButtonGesture()
        
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
extension CustomScrollViewContainer {
    
    func setDelegate(delegate : ShareDataProtocols) {
        self.delegate = delegate
    }
    
    func setupViews() {
        
        self.addSubview(containerView)
        self.addSubview(closeButton)
        self.addSubview(cropButton)
        self.addSubview(maximizeButton)
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
            
            maximizeButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            maximizeButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -15),
            maximizeButton.heightAnchor.constraint(equalToConstant: 30),
            maximizeButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func setContainerHeightWidth() {
        print("setContainerHeightWidth starts")
        
        print("self.frame.size : \(self.frame.size)")
        
        // to make containerView square, self.frame.size.width is used for both anchors
        containerView.heightAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        
        addGridView()
        
    }
    
    func addGridView() {
        
        customGridView = CustomGridView(frame: .zero, inputLineCount: 4)
        
        customGridView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(customGridView!)
        
        let safe = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customGridView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customGridView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customGridView!.topAnchor.constraint(equalTo: safe.topAnchor),
            customGridView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func activationManagement(granted : Bool) {
        
        if granted {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
        
    }
    
    func gridViewActivationManagement(hidden : Bool) {
        
        if customGridView != nil {
            
            customGridView!.activationManager(hidden: hidden)
            
        }
        
    }
    
    public func setImage(inputImage : UIImage) {
        
        print("setImage starts")
        print("input image size : \(inputImage.size)")
        
        self.image = inputImage
        scrollView.imageToDisplay = inputImage
        activationManagement(granted: true)
        
    }
    
    func addTransformToCropButton() {
        
        cropButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, delay: 0, usingSpringWithDamping: 0.20, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            
            self.cropButton.transform = CGAffineTransform.identity
            
        })
        
        cropButton.layoutIfNeeded()
        
    }
    
    func addTransformToMaximizeButton() {
        
        maximizeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, delay: 0, usingSpringWithDamping: 0.20, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            
            self.maximizeButton.transform = CGAffineTransform.identity
            
        })
        
        maximizeButton.layoutIfNeeded()
        
    }
    
    func returnImage() -> UIImage {
        guard let image = self.image else { return UIImage() }
        return image
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
        gridViewActivationManagement(hidden: true)
        
    }
    
    func setupCropButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollViewContainer.cropImage(_:)))
        tapGesture.delegate = self
        cropButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func cropImage(_ sender : UITapGestureRecognizer) {
        
        addTransformToCropButton()
        
        delegate.setCroppedImage(inputImage: captureVisibleRect())
        
    }
    
    private func captureVisibleRect() -> UIImage{
        
        var croprect = CGRect.zero
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView.frame.width) / (scrollView.contentSize.width)
        let normalizedHeight = (scrollView.frame.height) / (scrollView.contentSize.height)
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixImageOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        
        return cropped
        
    }
    
    func setupMaximizeButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomScrollViewContainer.maximizeImage(_:)))
        tapGesture.delegate = self
        maximizeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func maximizeImage(_ sender : UITapGestureRecognizer) {
        addTransformToMaximizeButton()
        scrollView.zoom()
    }
    
}

extension UIImage {

    func fixImageOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if (self.imageOrientation == UIImageOrientation.up) {
            return self;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (self.imageOrientation == UIImageOrientation.down
            || self.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (self.imageOrientation == UIImageOrientation.left
            || self.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }
        
        if (self.imageOrientation == UIImageOrientation.right
            || self.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        }
        
        if (self.imageOrientation == UIImageOrientation.upMirrored
            || self.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (self.imageOrientation == UIImageOrientation.leftMirrored
            || self.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: self.cgImage!.colorSpace!,
                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        
        if (self.imageOrientation == UIImageOrientation.left
            || self.imageOrientation == UIImageOrientation.leftMirrored
            || self.imageOrientation == UIImageOrientation.right
            || self.imageOrientation == UIImageOrientation.rightMirrored
            ) {
            
            
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.height,height:self.size.width))
            
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }


}

extension CustomScrollViewContainer : ShareDataProtocols {
    
    func gridViewTriggerManagement(hidden: Bool) {
        
        gridViewActivationManagement(hidden: hidden)
        
    }
    
}
