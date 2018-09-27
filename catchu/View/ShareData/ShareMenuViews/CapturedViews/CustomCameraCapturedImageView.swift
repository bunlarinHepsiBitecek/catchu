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
    
//    weak var customAddingTextView : CustomAddingTextView!
    private var customAddingTextView : CustomAddingTextView?
    
//    private var customAddingTextView : CustomAddingTextView?
    
    var activityIndicator: UIActivityIndicatorView!
    var tempView : UIView!
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
    
    /*
    required init(image: UIImage, cameraPosition : CameraPosition) {
        super.init(frame: .zero)
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        addObserver()
        
        activationManager(granted : false, inputImage: image, cameraPosition : cameraPosition)
        
    }*/
    
    required init() {
        super.init(frame: .zero)
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        
        initializeTextEditingView()
        activationManagerDefault(granted: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomCameraCapturedImageView {
    
//    func addObserver() {
//
//        NotificationCenter.default.addObserver(self, selector: #selector(CustomCameraCapturedImageView.setKeyboardHideProperties(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(CustomCameraCapturedImageView.setKeyboardShowProperties(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//    }
//
//    @objc func setKeyboardHideProperties(notification : Notification) {
//
//        print("setKeyboardHideProperties starts")
//
//    }
//
//    @objc func setKeyboardShowProperties(notification : Notification) {
//
//        print("setKeyboardHideProperties starts")
//
//    }
    
    func setupViews() {
        
        self.addSubview(capturedImage)
        self.addSubview(menuContainerView)
        self.addSubview(footerContainerView)
        
        self.menuContainerView.addSubview(closeButton)
        self.menuContainerView.addSubview(addTextImage)
        self.menuContainerView.addSubview(addTextContainerView)
        self.addTextContainerView.addSubview(addTextImage)
        
        self.footerContainerView.addSubview(downloadButton)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFill
        
        let safe = self.safeAreaLayoutGuide
        let safeMenuContainer = self.safeAreaLayoutGuide
        let safeAddTextContainer = self.addTextContainerView.safeAreaLayoutGuide
        
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
            
            downloadButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -5),
            downloadButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40)
            
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
            
            if visibiltyVaule {
                self.menuContainerView.isHidden = true
            } else {
                self.menuContainerView.isHidden = false
            }
            
        })
        
        UIView.transition(with: footerContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            if visibiltyVaule {
                self.footerContainerView.isHidden = true
            } else {
                self.footerContainerView.isHidden = false
            }
            
        })
        
    }
    
    func activationManagerDefault(granted : Bool) {
        
        if granted {
            self.alpha = 1
            
        } else {
            self.alpha = 0
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
    
    func initializeTextEditingView() {
        
        print("initializeTextEditingView starts")
        
        customAddingTextView = CustomAddingTextView(delegate: self)
        
//        customAddingTextView!.delegate = self
        
        self.addSubview(customAddingTextView!)
        
        customAddingTextView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
//        menuAndFooterVisibiltyManagement(visibiltyVaule: true)
        
        NSLayoutConstraint.activate([
            
            customAddingTextView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customAddingTextView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customAddingTextView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            customAddingTextView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
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
        
//        self.removeFromSuperview()
        self.activationManagerDefault(granted: false)
        
        
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
            options: UIViewAnimationOptions.allowUserInteraction,
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
        
        guard customAddingTextView != nil else {
            return
        }
        
        customAddingTextView!.activationManagementWithDelegations(granted: true)
        
    }
    
}

extension CustomCameraCapturedImageView : ShareDataProtocols {
    
    func menuContainersHideManagement(inputValue: Bool) {
        
        menuAndFooterVisibiltyManagement(visibiltyVaule: inputValue)
        
    }
    
    func returnTextViewScreenShot(inputScreenShot: UIImage) {
        
        let scrollViewForTextScreenShot = UIScrollView(frame: .zero)
        
    }
    
}
