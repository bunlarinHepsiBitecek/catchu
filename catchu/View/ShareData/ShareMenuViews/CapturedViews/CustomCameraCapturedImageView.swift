//
//  CustomCameraCapturedImageView.swift
//  catchu
//
//  Created by Erkut Baş on 9/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class CustomCameraCapturedImageView: UIView {

    private let capturedImage = UIImageView()
    private var gradientUploaded = false
    private var deleteButtonEnlarged : Bool = false
    private var deleteButtonShrinked : Bool = false
    private var deleteButtonIntersectionDetected : Bool = false
    
    weak var delegateForShareMenuViews : ShareDataProtocols!
    
//    weak var customAddingTextView : CustomAddingTextView!
    private var customAddingTextView : CustomAddingTextView?
    
//    private var customAddingTextView : CustomAddingTextView?
    
    var activityIndicator: UIActivityIndicatorView!
    var labelText : UILabel?
    
    lazy var menuContainerView : UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 7
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var footerContainerView: UIView = {
        
        let temp = UIView()
        
        temp.layer.cornerRadius = 7
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var downloadButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var saveProcessView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        temp.layer.cornerRadius = 10
        
        return temp
    }()
    
    lazy var addTextContainerView : UIView = {

        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var addTextImage: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "text-label")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
        
    }()
    
    lazy var footerDeleteContainer: UIView = {
        
        let temp = UIView()
        
        temp.layer.cornerRadius = 7
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var deleteButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "garbage")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    /*
    required init() {
        super.init(frame: .zero)
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        
        initializeTextEditingView()
        activationManagerDefault(granted: false)
        
    }*/
    
    init(inputDelegate : ShareDataProtocols) {
        super.init(frame: .zero)
        
        delegateForShareMenuViews = inputDelegate
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        
        initializeTextEditingView()
        activationManagerDefault(granted: false)
        activationManagerOfDeleteButton(active: false, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomCameraCapturedImageView {
    
    func setupViews() {
        
        self.addSubview(capturedImage)
        self.addSubview(menuContainerView)
        self.addSubview(footerContainerView)
//        self.addSubview(footerDeleteContainer)
        self.addSubview(deleteButton)
        
        self.menuContainerView.addSubview(closeButton)
        self.menuContainerView.addSubview(addTextContainerView)
        self.addTextContainerView.addSubview(addTextImage)
        self.footerContainerView.addSubview(downloadButton)
//        self.footerDeleteContainer.addSubview(deleteButton)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFill
        
        let safe = self.safeAreaLayoutGuide
        let safeMenuContainer = self.safeAreaLayoutGuide
        let safeAddTextContainer = self.addTextContainerView.safeAreaLayoutGuide
        let safeDeleteContainer = self.footerDeleteContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            capturedImage.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            capturedImage.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            capturedImage.topAnchor.constraint(equalTo: safe.topAnchor),
            capturedImage.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            menuContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            menuContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
            menuContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            closeButton.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: safeMenuContainer.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            addTextContainerView.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor),
            addTextContainerView.trailingAnchor.constraint(equalTo: safeMenuContainer.trailingAnchor),
            addTextContainerView.heightAnchor.constraint(equalToConstant: 60),
            addTextContainerView.widthAnchor.constraint(equalToConstant: 60),
            
            addTextImage.centerXAnchor.constraint(equalTo: safeAddTextContainer.centerXAnchor),
            addTextImage.centerYAnchor.constraint(equalTo: safeAddTextContainer.centerYAnchor),
            addTextImage.heightAnchor.constraint(equalToConstant: 30),
            addTextImage.widthAnchor.constraint(equalToConstant: 30),
            
            footerContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            footerContainerView.heightAnchor.constraint(equalToConstant: 50),
            
//            footerDeleteContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            footerDeleteContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            footerDeleteContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//            footerDeleteContainer.heightAnchor.constraint(equalToConstant: 50),
            
            downloadButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -5),
            downloadButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40),
            
//            deleteButton.bottomAnchor.constraint(equalTo: safeDeleteContainer.bottomAnchor, constant: -5),
//            deleteButton.centerXAnchor.constraint(equalTo: safeDeleteContainer.centerXAnchor),
//            deleteButton.heightAnchor.constraint(equalToConstant: 40),
//            deleteButton.widthAnchor.constraint(equalToConstant: 40)

            deleteButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
        addGradientView()
        
    }
    
    /// add gradient to menu and footer view
    func addGradientView() {
        
        print("menuContainerView.bounds : \(menuContainerView.bounds)")
        print("menuContainerView.frame : \(menuContainerView.frame)")
        
        gradientUploaded = true
        
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        menuContainerView.layer.insertSublayer(gradient, at: 0)
        
        let gradientForFooter = CAGradientLayer()
        
        gradientForFooter.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
        gradientForFooter.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        footerContainerView.layer.insertSublayer(gradientForFooter, at: 0)
        
    }
    
    /// save captured image to gallery
    func setupSaveProcessView() {
        
        UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            self.addSubview(self.saveProcessView)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.saveProcessView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
                self.saveProcessView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
                self.saveProcessView.heightAnchor.constraint(equalToConstant: 80),
                self.saveProcessView.widthAnchor.constraint(equalToConstant: 120)
                
                ])
            
            self.showSpinning()
            
        })
        
    }
    
    func deleteSaveProcessView() {
        
        guard let saveProcessViewSuperview = saveProcessView.superview else { return }
        
        UIView.transition(with: saveProcessView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            
            self.addLabelToSavedProcessView(result: true)
            
        }) { (result) in
            
            if result {
                
                guard let labelText = self.labelText else { return }
                
                UIView.transition(with: saveProcessViewSuperview, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                    
                    self.saveProcessView.removeFromSuperview()
                    labelText.removeFromSuperview()
                    
                })
                
            }
            
        }
        
    }
    
    func addLabelToSavedProcessView(result : Bool) {
        
        labelText = UILabel()
        
        guard let labelText = labelText else { return }
        
        if result {
            labelText.text = LocalizedConstants.TitleValues.LabelTitle.saved
        } else {
            labelText.text = LocalizedConstants.TitleValues.LabelTitle.failed
        }
        
        labelText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelText.textAlignment = .center
        
        saveProcessView.addSubview(labelText)
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = saveProcessView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            labelText.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            labelText.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 20),
            labelText.widthAnchor.constraint(equalToConstant: 100)
            
            ])
        
    }
    
    func showSpinning() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        
        activityIndicator.startAnimating()
        
        saveProcessView.addSubview(activityIndicator)
        
        let safe = saveProcessView.safeAreaLayoutGuide
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.deleteSaveProcessView()
        }
        
    }
    
    func menuAndFooterVisibiltyManagement(visibiltyVaule : Bool) {
        
        UIView.transition(with: menuContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {

            self.menuFooterHiddenManagement(hidden: visibiltyVaule)
            
//            if visibiltyVaule {
//                self.menuContainerView.isHidden = true
//            } else {
//                self.menuContainerView.isHidden = false
//            }
            
        })
        
        UIView.transition(with: footerContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            self.menuFooterHiddenManagement(hidden: visibiltyVaule)
            
//            if visibiltyVaule {
//                self.footerContainerView.isHidden = true
//            } else {
//                self.footerContainerView.isHidden = false
//            }
            
        })
        
    }
    
    func menuFooterHiddenManagement(hidden : Bool) {
        
        self.menuContainerView.isHidden = hidden
        self.footerContainerView.isHidden = hidden
        
    }
    
    func activationManagerDefault(granted : Bool) {
        
        if granted {
            self.alpha = 1
            
        } else {
            self.alpha = 0
        }
        
    }
    
    func activationManagerWithImage(granted : Bool, inputImage : UIImage) {
        if granted {
            self.alpha = 1
            capturedImage.image = inputImage
        } else {
            self.alpha = 0
            capturedImage.image = UIImage()
        }
    }
    
    func activationManagerWithImageCameraPositionInfo(granted : Bool, inputImage : UIImage, cameraPosition : CameraPosition) {
        
        if granted {
            self.alpha = 1
            
            if cameraPosition == .front {
                capturedImage.image = UIImage(cgImage: inputImage.cgImage!, scale: 1.0, orientation: .leftMirrored)
            } else {
                capturedImage.image = inputImage
            }
            
//            saveCapturedImagesToSelectedItems(image : inputImage)
            
        } else {
            self.alpha = 0
            
            capturedImage.image = UIImage()
            
        }
        
    }
    
    func initializeTextEditingView() {
        
        print("initializeTextEditingView starts")
        
        customAddingTextView = CustomAddingTextView(delegate: self, delegateForShareMenuViews: delegateForShareMenuViews, delegateOfCameraCapturedImageView: self)

        self.addSubview(customAddingTextView!)
        
        customAddingTextView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customAddingTextView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customAddingTextView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customAddingTextView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            customAddingTextView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func saveCapturedImagesToSelectedItems(image : UIImage) {
        
        if PostItems.shared.selectedImageArray == nil {
            PostItems.shared.selectedImageArray = Array<UIImage>()
        }
        
        PostItems.shared.selectedImageArray!.append(image)
        
        print("")
        
    }
    
    func deleteCapturedImagesFromSelectedItems(image : UIImage) {
        
        if PostItems.shared.selectedImageArray != nil {
            if let i = PostItems.shared.selectedImageArray!.firstIndex(of: image) {
                PostItems.shared.selectedImageArray?.remove(at: i)
                
            }
        }
        
    }
    
    func activationManagerOfDeleteButton(active : Bool, animated : Bool) {
        
        if animated {
            UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
                /*
                if active {
                    self.footerDeleteContainer.alpha = 1
                } else {
                    self.footerDeleteContainer.alpha = 0
                }*/
                
                if active {
                    self.deleteButton.alpha = 1
                } else {
                    self.deleteButton.alpha = 0
                }
                
            }
        } else {
            /*
            if active {
                self.footerDeleteContainer.alpha = 1
            } else {
                self.footerDeleteContainer.alpha = 0
            }*/
            
            if active {
                self.deleteButton.alpha = 1
            } else {
                self.deleteButton.alpha = 0
            }
            
        }

    }
    
    func setDelegationForSticker(inputDelegateView : CustomSticker2) {
        
        if customAddingTextView != nil {
            customAddingTextView!.delegateForEditedView = inputDelegateView
        }
        
    }
    
    func stickerVisibilityOperations(active : Bool) {
        
        guard let stickers = Stickers.shared.stickerArray else { return }
        
        for item in stickers {
            item.activationManager(active: active)
        }
        
    }
    
    func clearStickerFromCapturedArray() {
        
        if Stickers.shared.stickerArray != nil {
        
            for item in Stickers.shared.stickerArray! {
                item.removeFromSuperview()
            }
            
            Stickers.shared.emptyStickerArray()
        }
        
    }
    
    func returnImage() -> UIImageView {
        
        return capturedImage
        
    }
    
    func enlargeDeleteButton(inputView : UIView, active : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            
            if active {
                
                if !self.deleteButtonEnlarged {
                    inputView.transform = inputView.transform.scaledBy(x: 1.5, y: 1.5)
                    self.deleteButtonEnlarged = true
                    self.deleteButtonShrinked = false
                }
                
            } else {
                
                if !self.deleteButtonShrinked {
                    inputView.transform = .identity
                    self.deleteButtonShrinked = true
                    self.deleteButtonEnlarged = false
                }
                
            }
            
        }
        
    }
    
    func returnCapturedImage() -> UIImage {
        
        guard let image = capturedImage.image else { return UIImage() }
        
        return image
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomCameraCapturedImageView: UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraCapturedImageView.dismissCustomCameraCapturedView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        //        self.mainView.bringSubview(toFront: closeButton)
        
    }

    @objc func dismissCustomCameraCapturedView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraCapturedView starts")
        
        clearStickerFromCapturedArray()

        self.activationManagerDefault(granted: false)
        
        guard let image = capturedImage.image else { return }
        
        deleteCapturedImagesFromSelectedItems(image: image)
        
    }
    
    func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraCapturedImageView.saveCapturedImage(_:)))
        tapGesture.delegate = self
        downloadButton.addGestureRecognizer(tapGesture)
        
    }
    
    func startAnimation() {
        
        downloadButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: .allowUserInteraction,
            animations: {
                self.downloadButton.transform = CGAffineTransform.identity
                
                
        })
        self.downloadButton.layoutIfNeeded()
        
    }
    
    @objc func saveCapturedImage(_ sender : UITapGestureRecognizer) {
        
        print("saveCapturedImage starts")
        
        startAnimation()
        setupSaveProcessView()
        
        guard let savedImage = self.capturedImage.image else { return }
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: savedImage)
            
            
        }) { (response, error) in
            
            print("error : \(error)")
            print("response : \(response)")
            
            if response {

                self.stopSpinning()

            }
            
        }
        
    }
    
    func setupAddTextGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraCapturedImageView.startAddingTextView(_:)))
        tapGesture.delegate = self
        addTextContainerView.addGestureRecognizer(tapGesture)
        addTextImage.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func startAddingTextView(_ sender : UITapGestureRecognizer) {
        
        print("startAddingTextView starts")
        print("customAddingTextView : \(customAddingTextView)")
        
        stickerVisibilityOperations(active: false)
        
        guard customAddingTextView != nil else {
            return
        }
        
        customAddingTextView!.activationManagementWithDelegations(granted: true)
        
    }
    
}

extension CustomCameraCapturedImageView : ShareDataProtocols {
    
    func menuContainersHideManagement(inputValue: Bool) {
        
        menuAndFooterVisibiltyManagement(visibiltyVaule: inputValue)
        activationManagerOfDeleteButton(active: inputValue, animated: true)
        
    }
    
    func returnTextViewScreenShot(inputScreenShot: UIImage) {
        
        _ = UIScrollView(frame: .zero)
        
    }
    
    
    func addTextSticker(inputView: UIView) {
        
        print("addTextSticker starts")
        print("inputView.frame : \(inputView.frame)")
        print("inputView.bounds : \(inputView.bounds)")
        
        var newTextView = UIView()
        newTextView = inputView
        
        newTextView.translatesAutoresizingMaskIntoConstraints = false
        newTextView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        self.addSubview(newTextView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            newTextView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            newTextView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            newTextView.heightAnchor.constraint(equalToConstant: inputView.frame.height),
            newTextView.widthAnchor.constraint(equalToConstant: inputView.frame.width)
            
            ])
        
    }
    
}

extension CustomCameraCapturedImageView : StickerProtocols {
    
    func addTextStickerWithParameters(sticker: Sticker) {
    
        print("addTextStickerWithParameters starts")
        
        guard let stickerFrame = sticker.frame else { return }
        
        print("Sticker count : \(Stickers.shared.stickerArray?.count)")
        
        if Stickers.shared.stickerArray != nil {
            print("NILLLLLLLL değil")
            for item in Stickers.shared.stickerArray! {
                print("--> : \(item.sticker.text)")
            }
        }
        
        let stickerView = CustomSticker2(frame: .zero, inputSticker: sticker)
        
        /* setting necessary delegations for protocols */
        stickerView.setProtocols(delegateOfCapturedImageView: self, delegateForMenuViewOperations: delegateForShareMenuViews, delegateOfCustomAddingText: self)
        
//        setDelegationForSticker(inputDelegateView: stickerView)
        
        self.addSubview(stickerView)
        
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stickerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            stickerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stickerView.heightAnchor.constraint(equalToConstant: stickerFrame.height),
            stickerView.widthAnchor.constraint(equalToConstant: stickerFrame.width)
            
            ])
        
        Stickers.shared.addStickerToArray(inputStickerView: stickerView)
        
        print("Sticker count : \(Stickers.shared.stickerArray?.count)")
        
        guard let items2 = Stickers.shared.stickerArray else { return }
        
        for item in items2 {
            print("--> : \(item.sticker.text)")
        }
        
    }
    
    func activateTextStickerEditigMode(inputSticker: Sticker, selfView : CustomSticker2) {
        
        if customAddingTextView != nil {
            
            customAddingTextView!.delegateForEditedView = selfView
            
            customAddingTextView!.activationManagementWithDelegations(granted: true)
            customAddingTextView!.updateEditingTextView(inputSticker: inputSticker, editingMode: true)
            stickerVisibilityOperations(active: false)
        }
        
    }
    
    func customStickerActivationManager(active: Bool) {
        
        stickerVisibilityOperations(active: active)
        
    }
    
    func detectDeleteButtonIntersect(inputView : UIView) {
        /*
        if footerDeleteContainer.frame.intersects(inputView.frame) {
            print("intersection detected!")
            enlargeDeleteButton(inputView: deleteButton, active: true)
            deleteButtonIntersectionDetected = true
        } else {
            enlargeDeleteButton(inputView: deleteButton, active: false)
            deleteButtonIntersectionDetected = false
        }*/
        
        if deleteButton.frame.intersects(inputView.frame) {
            
            print("intersection detected!")
            enlargeDeleteButton(inputView: deleteButton, active: true)
            deleteButtonIntersectionDetected = true
            
        } else {
            enlargeDeleteButton(inputView: deleteButton, active: false)
            deleteButtonIntersectionDetected = false
        }
        
    }
    
    func stickerDeleteAnimationManager(active: Bool) {
        
        enlargeDeleteButton(inputView: deleteButton, active: active)
        
    }
    
    func deleteSticker(selectedSticker: CustomSticker2) {
        
        if deleteButtonIntersectionDetected {
            selectedSticker.removeFromSuperview()
            
            if Stickers.shared.stickerArray != nil {
                
                if let i = Stickers.shared.stickerArray!.firstIndex(of: selectedSticker) {
                    Stickers.shared.stickerArray!.remove(at: i)
                }

            }
            
        }
        
        
    }
    
}
