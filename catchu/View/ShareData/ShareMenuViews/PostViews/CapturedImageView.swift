//
//  CapturedImageView.swift
//  catchu
//
//  Created by Erkut Baş on 11/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class CapturedImageView: UIView {

    private let capturedImage = UIImageView()
    private var deleteButtonEnlarged : Bool = false
    private var deleteButtonShrinked : Bool = false
    private var deleteButtonIntersectionDetected : Bool = false
    
    private var stickerManagementView : StickerManagementView?
    
    weak var delegatePostViewProtocol : PostViewProtocols!
    
    var activityIndicator: UIActivityIndicatorView!
    var labelText : UILabel?
    
    lazy var mainContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    lazy var contentContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    lazy var menuContainerView : UIView = {
        
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var footerContainerView: UIView = {
        
        let temp = UIView()
        
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
    
    lazy var commitButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        temp.addTarget(self, action: #selector(commitProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        
        return temp
        
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.layer.masksToBounds = true
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
    
    init(inputDelegate : PostViewProtocols) {
        super.init(frame: .zero)
        
        delegatePostViewProtocol = inputDelegate
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        
        initializeStickerManagementView()
        activationManagerDefault(granted: false)
        activationManagerOfDeleteButton(active: false, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CapturedImageView {
    
    func setupViews() {
        
        self.addSubview(mainContainerView)
        self.mainContainerView.addSubview(contentContainerView)
        self.contentContainerView.addSubview(capturedImage)
        self.contentContainerView.addSubview(menuContainerView)
        self.contentContainerView.addSubview(footerContainerView)
        self.contentContainerView.addSubview(deleteButton)
        
        self.menuContainerView.addSubview(closeButton)
        self.menuContainerView.addSubview(addTextContainerView)
        self.addTextContainerView.addSubview(addTextImage)
        self.footerContainerView.addSubview(downloadButton)
        self.footerContainerView.addSubview(commitButton)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFit
        
        let safe = self.safeAreaLayoutGuide
        let safeMainContainer = self.mainContainerView.safeAreaLayoutGuide
        let safeContentContainer = self.contentContainerView.safeAreaLayoutGuide
        let safeMenuContainer = self.menuContainerView.safeAreaLayoutGuide
        let safeAddTextContainer = self.addTextContainerView.safeAreaLayoutGuide
        let safeDeleteContainer = self.footerDeleteContainer.safeAreaLayoutGuide
        let safeFooterContainer = self.footerContainerView.safeAreaLayoutGuide
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        
        NSLayoutConstraint.activate([
            
            mainContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            contentContainerView.leadingAnchor.constraint(equalTo: safeMainContainer.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: safeMainContainer.trailingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: safeMainContainer.topAnchor, constant: statusBarHeight),
            contentContainerView.bottomAnchor.constraint(equalTo: safeMainContainer.bottomAnchor, constant: CGFloat(-Int(bottomPadding!))),
            
            capturedImage.leadingAnchor.constraint(equalTo: safeContentContainer.leadingAnchor),
            capturedImage.trailingAnchor.constraint(equalTo: safeContentContainer.trailingAnchor),
            capturedImage.topAnchor.constraint(equalTo: safeContentContainer.topAnchor),
            capturedImage.bottomAnchor.constraint(equalTo: safeContentContainer.bottomAnchor),
            
            menuContainerView.leadingAnchor.constraint(equalTo: safeContentContainer.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: safeContentContainer.trailingAnchor),
            menuContainerView.topAnchor.constraint(equalTo: safeContentContainer.topAnchor),
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
            
            footerContainerView.leadingAnchor.constraint(equalTo: safeContentContainer.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: safeContentContainer.trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: safeContentContainer.bottomAnchor),
            footerContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            downloadButton.bottomAnchor.constraint(equalTo: safeContentContainer.bottomAnchor, constant: -10),
            downloadButton.leadingAnchor.constraint(equalTo: safeContentContainer.leadingAnchor, constant: 20),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40),
            
            deleteButton.centerXAnchor.constraint(equalTo: safeContentContainer.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: safeContentContainer.bottomAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            
            commitButton.centerYAnchor.constraint(equalTo: safeFooterContainer.centerYAnchor),
            commitButton.trailingAnchor.constraint(equalTo: safeFooterContainer.trailingAnchor, constant: -10),
            commitButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            commitButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            ])
        
        addGradientView()
        addBlurEffectToCommitButton()
        
    }
    
    /// add gradient to menu and footer view
    func addGradientView() {
        
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: Constants.StaticViewSize.ViewSize.Height.height_60)
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        //gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        menuContainerView.layer.insertSublayer(gradient, at: 0)
        
        let gradientForFooter = CAGradientLayer()
        
        gradientForFooter.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: Constants.StaticViewSize.ViewSize.Height.height_50)
        gradientForFooter.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        //gradientForFooter.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        footerContainerView.layer.insertSublayer(gradientForFooter, at: 0)
        
    }
    
    private func addBlurEffectToCommitButton() {
        
        commitButton.insertSubview(blurView, at: 0)
        
        let safe = self.commitButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
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
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
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
            
        })
        
        UIView.transition(with: footerContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            self.menuFooterHiddenManagement(hidden: visibiltyVaule)
            
        })
        
    }
    
    func menuFooterHiddenManagement(hidden : Bool) {
        
        self.menuContainerView.isHidden = hidden
        self.footerContainerView.isHidden = hidden
        
    }
    
    func activationManagerDefault(granted : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if granted {
                self.alpha = 1
                
            } else {
                self.alpha = 0
            }
        }
        
        
    }
    
    func activationManagerWithImage(granted : Bool, inputImage : UIImage) {
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if granted {
                self.alpha = 1
                self.capturedImage.image = inputImage
            } else {
                self.alpha = 0
                self.capturedImage.image = UIImage()
            }
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
            
        } else {
            self.alpha = 0
            
            capturedImage.image = UIImage()
            
        }
        
    }
    
    func initializeStickerManagementView() {
        
        print("\(#function) starts")
        
        stickerManagementView = StickerManagementView(delegate: self, delegateOfCameraCapturedImageView: self)
        
        self.addSubview(stickerManagementView!)
        
        stickerManagementView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.contentContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stickerManagementView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            stickerManagementView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            stickerManagementView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            stickerManagementView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
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

                if active {
                    self.deleteButton.alpha = 1
                } else {
                    self.deleteButton.alpha = 0
                }
                
            }
        } else {
            
            if active {
                self.deleteButton.alpha = 1
            } else {
                self.deleteButton.alpha = 0
            }
            
        }
        
    }
    
    func setDelegationForSticker(inputDelegateView : CustomSticker2) {
        
        if stickerManagementView != nil {
            stickerManagementView!.delegateForEditedView = inputDelegateView
        }
        
    }
    
    func stickerVisibilityOperations(active : Bool) {
        
        guard let stickers = CommonSticker.shared.stickerArray else { return }
        
        for item in stickers {
            item.activationManager(active: active)
        }
        
    }
    
    func clearStickerFromCapturedArray() {
        
        if CommonSticker.shared.stickerArray != nil {
            
            for item in CommonSticker.shared.stickerArray! {
                item.removeFromSuperview()
            }
            
            CommonSticker.shared.emptyStickerArray()
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
    
    func startAnimation() {
        
        downloadButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.downloadButton.transform = CGAffineTransform.identity
                
                
        })
        self.downloadButton.layoutIfNeeded()
        
    }
    
    func startAnimationForCommitButton(completion : @escaping (_ finish : Bool) -> Void) {
        
        commitButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.commitButton.transform = CGAffineTransform.identity
            
        }, completion: completion)
        
    }
    
    @objc func commitProcess(_ sender : UIButton) {
        print("\(#function), \(#line) starts")
        // let's create an image with sticker if any exist on captured image
        self.createNewImageWithCommonStickers()
        
        print("selected image count : \(PostItems.shared.returnSelectedImageArrayCount())")
        
        startAnimationForCommitButton { (finish) in
            
            if finish {
                self.activationManagerDefault(granted: false)
                self.delegatePostViewProtocol.committedCapturedImage()
            }
            
        }
        
    }
    
    func createNewImageWithCommonStickers() {
        
        PostItems.shared.appendNewItemToSelectedOriginalImageArray(image: self.returnCapturedImage())
        
        let x = self.returnCapturedImage()
        print("image mokoko : \(x)")
        print("self.bound.size : \(self.bounds.size)")
        
        let imageOptionSize = CGSize(width: x.size.width, height: x.size.height)
        print("imageOptionSize : \(imageOptionSize)")
        
        let imageRect = CGRect(x: 0, y: 0, width: x.size.width, height: x.size.height)
        
        if let array = CommonSticker.shared.stickerArray {
            if !array.isEmpty {
                
                PostItems.shared.capturedImageEdited = true
                
                self.menuFooterHiddenManagement(hidden: true)
                
                UIGraphicsBeginImageContextWithOptions(capturedImage.bounds.size, self.isOpaque, 0.0)
                //UIGraphicsBeginImageContextWithOptions(imageOptionSize, self.isOpaque, 0.0)
                
                self.drawHierarchy(in: capturedImage.bounds, afterScreenUpdates: true)
                let snapShot = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                self.menuFooterHiddenManagement(hidden: false)
                PostItems.shared.appendNewItemToSelectedImageArray(image: snapShot!)
                
                
                self.menuFooterHiddenManagement(hidden: false)
                PostItems.shared.appendNewItemToSelectedImageArray(image: snapShot!)
                
                
            } else {
                PostItems.shared.appendNewItemToSelectedImageArray(image: self.returnCapturedImage())
            }
            
        } else {
            PostItems.shared.appendNewItemToSelectedImageArray(image: self.returnCapturedImage())
            
        }
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CapturedImageView: UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.dismissCustomCameraCapturedView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissCustomCameraCapturedView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraCapturedView starts")
        
        clearStickerFromCapturedArray()
        
        self.activationManagerDefault(granted: false)
        
        guard let image = capturedImage.image else { return }
        
        deleteCapturedImagesFromSelectedItems(image: image)
        
    }
    
    func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.saveCapturedImage(_:)))
        tapGesture.delegate = self
        downloadButton.addGestureRecognizer(tapGesture)
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.startAddingTextView(_:)))
        tapGesture.delegate = self
        addTextContainerView.addGestureRecognizer(tapGesture)
        addTextImage.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func startAddingTextView(_ sender : UITapGestureRecognizer) {
        
        print("startAddingTextView starts")
        print("stickerManagementView : \(stickerManagementView)")
        
        stickerVisibilityOperations(active: false)
        
        stickerManagementViewAnimationManagement(active: true)
        
    }
    
    func stickerManagementViewAnimationManagement(active : Bool) {
        
        guard stickerManagementView != nil  else {
            return
        }
        
//        stickerManagementView!.activationManagementDefault(granted: active)
        stickerManagementView!.activationManagementWithDelegations(granted: active)
        
        
    }
    
}

// MARK: - ShareDataProtocols
extension CapturedImageView : ShareDataProtocols {
    
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

extension CapturedImageView : StickerProtocols {
    
    func addTextStickerWithParameters(sticker: Sticker) {
        
        print("addTextStickerWithParameters starts")
        
        guard let stickerFrame = sticker.frame else { return }
        
        print("Sticker count : \(CommonSticker.shared.stickerArray?.count)")
        
        if CommonSticker.shared.stickerArray != nil {
            print("NILLLLLLLL değil")
            for item in CommonSticker.shared.stickerArray! {
                print("--> : \(item.sticker.text)")
            }
        }
        
        let stickerView = StickerCommonView(frame: .zero, inputSticker: sticker)
        
        /* setting necessary delegations for protocols */
        stickerView.setProtocols(delegateOfCapturedImageView: self, delegateOfCustomAddingText: self)
        
        self.addSubview(stickerView)
        
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stickerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            stickerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stickerView.heightAnchor.constraint(equalToConstant: stickerFrame.height),
            stickerView.widthAnchor.constraint(equalToConstant: stickerFrame.width)
            
            ])
        
        CommonSticker.shared.addStickerToArray(inputStickerView: stickerView)
        
        print("Sticker count : \(CommonSticker.shared.stickerArray?.count)")
        
        guard let items2 = CommonSticker.shared.stickerArray else { return }
        
        for item in items2 {
            print("--> : \(item.sticker.text)")
        }
        
    }
    
    func activateTextStickerCommonEditigMode(inputSticker: Sticker, selfView: StickerCommonView) {
        
        if stickerManagementView != nil {
            
            stickerManagementView!.delegateForEditedView = selfView
            
            stickerManagementViewAnimationManagement(active: true)
            
            //stickerManagementView!.activationManagementWithDelegations(granted: true)
            stickerManagementView!.updateEditingTextView(inputSticker: inputSticker, editingMode: true)
            stickerVisibilityOperations(active: false)
        }
        
    }
    
    func customStickerActivationManager(active: Bool) {
        
        stickerVisibilityOperations(active: active)
        
    }
    
    func detectDeleteButtonIntersect(inputView : UIView) {
        
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
    
    func deleteCommonSticker(selectedSticker: StickerCommonView) {
        
        if deleteButtonIntersectionDetected {
            selectedSticker.removeFromSuperview()
            
            if CommonSticker.shared.stickerArray != nil {
                
                if let i = CommonSticker.shared.stickerArray!.firstIndex(of: selectedSticker) {
                    CommonSticker.shared.stickerArray!.remove(at: i)
                }
                
            }
            
        }
        
    }
    
}
