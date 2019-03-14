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
    
    // MARK: - doodle properties
    private var isDoodleActive: Bool = false
    private var isDoodled: Bool = false
    private var doodleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var lineColor : UIColor = UIColor.white
    private var lineWidth : CGFloat = 5
    
    private var delegate : DrawViewDelegate?
    
    private var shapeLayers = [DrawLayer]()
    private var currenShapeLayer : DrawLayer?
    
    // MARK: - main views
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
    
    lazy var bodyContainer: UIView = {
        
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
    
    lazy var addDoodleContainerView : UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        temp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.startAddingDoodleProcess(_:))))
        
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
    
    lazy var addDoodleImage: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "edit.png")?.withRenderingMode(.alwaysTemplate)
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
    
    // MARK: - doodle views
    lazy var colorPaletteForDoodle: ColorPaletteView = {
        let temp = ColorPaletteView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isHidden = true
        return temp
    }()
    
    lazy var doneForDoodle: UIView = {
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 12.5
        temp.backgroundColor = UIColor.clear
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.borderWidth = 1
        temp.isHidden = true
        temp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.doneDoodleProcess(_:))))
        return temp
    }()
    
    lazy var doneLabel: UILabel = {
        
        let temp = UILabel()
        temp.isUserInteractionEnabled = true
        temp.text = LocalizedConstants.TitleValues.ButtonTitle.done
        temp.font = UIFont.systemFont(ofSize: 17)
        temp.numberOfLines = 0
        temp.textAlignment = .center
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var closeDoodle: UIImageView = {
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        temp.isHidden = true
        temp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.closeDoodleProcess(_:))))
        return temp
    }()
    
    lazy var clearDoodle: UIImageView = {
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "broom.png")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        temp.isHidden = true
        temp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.eraseDoodleProcess(_:))))
        return temp
    }()
    
    lazy var doodleContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    
    // MARK: - initialize functions
    init(inputDelegate : PostViewProtocols) {
        super.init(frame: .zero)
        
        delegatePostViewProtocol = inputDelegate
        
        setupViews()
        setupCloseButtonGesture()
        downloadButtonGesture()
        setupAddTextGestures()
        
        initializeStickerManagementView()
        initializeDoodleView()
        activationManagerDefault(granted: false)
        activationManagerOfDeleteButton(active: false, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CapturedImageView {
    
    private func setupViews() {
        
        self.addSubview(mainContainerView)
        self.mainContainerView.addSubview(contentContainerView)
        self.contentContainerView.addSubview(capturedImage)
        self.contentContainerView.addSubview(menuContainerView)
        self.contentContainerView.addSubview(footerContainerView)
        self.contentContainerView.addSubview(deleteButton)
        self.contentContainerView.addSubview(bodyContainer)
        
        self.menuContainerView.addSubview(closeButton)
        self.menuContainerView.addSubview(addTextContainerView)
        self.menuContainerView.addSubview(addDoodleContainerView)
        self.addTextContainerView.addSubview(addTextImage)
        self.addDoodleContainerView.addSubview(addDoodleImage)
        self.footerContainerView.addSubview(downloadButton)
        self.footerContainerView.addSubview(commitButton)
        
        capturedImage.translatesAutoresizingMaskIntoConstraints = false
        capturedImage.contentMode = .scaleAspectFit
        
        let safe = self.safeAreaLayoutGuide
        let safeMainContainer = self.mainContainerView.safeAreaLayoutGuide
        let safeContentContainer = self.contentContainerView.safeAreaLayoutGuide
        let safeMenuContainer = self.menuContainerView.safeAreaLayoutGuide
        let safeAddTextContainer = self.addTextContainerView.safeAreaLayoutGuide
        let safeAddDoodleContainer = self.addDoodleContainerView.safeAreaLayoutGuide
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
            
            bodyContainer.leadingAnchor.constraint(equalTo: safeContentContainer.leadingAnchor),
            bodyContainer.trailingAnchor.constraint(equalTo: safeContentContainer.trailingAnchor),
            bodyContainer.topAnchor.constraint(equalTo: safeMenuContainer.bottomAnchor),
            bodyContainer.bottomAnchor.constraint(equalTo: safeFooterContainer.topAnchor),
            
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
            
            addDoodleContainerView.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor),
            addDoodleContainerView.trailingAnchor.constraint(equalTo: safeAddTextContainer.leadingAnchor),
            addDoodleContainerView.heightAnchor.constraint(equalToConstant: 60),
            addDoodleContainerView.widthAnchor.constraint(equalToConstant: 60),
            
            addDoodleImage.centerXAnchor.constraint(equalTo: safeAddDoodleContainer.centerXAnchor),
            addDoodleImage.centerYAnchor.constraint(equalTo: safeAddDoodleContainer.centerYAnchor),
            addDoodleImage.heightAnchor.constraint(equalToConstant: 30),
            addDoodleImage.widthAnchor.constraint(equalToConstant: 30),
            
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
    private func addGradientView() {
        
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
    private func setupSaveProcessView() {
        
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
    
    private func deleteSaveProcessView() {
        
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
    
    private func addLabelToSavedProcessView(result : Bool) {
        
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
    
    private func showSpinning() {
        
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
    
    private func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.deleteSaveProcessView()
        }
        
    }
    
    private func menuAndFooterVisibiltyManagement(visibiltyVaule : Bool) {
        
        UIView.transition(with: menuContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            self.menuFooterHiddenManagement(hidden: visibiltyVaule)
            
        })
        
        UIView.transition(with: footerContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            self.menuFooterHiddenManagement(hidden: visibiltyVaule)
            
        })
        
    }
    
    private func menuFooterHiddenManagement(hidden : Bool) {
        
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
    
    private func activationManagerWithImageCameraPositionInfo(granted : Bool, inputImage : UIImage, cameraPosition : CameraPosition) {
        
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
    
    private func initializeStickerManagementView() {

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
    
    private func deleteCapturedImagesFromSelectedItems(image : UIImage) {
        
        if PostItems.shared.selectedImageArray != nil {
            if let i = PostItems.shared.selectedImageArray!.firstIndex(of: image) {
                PostItems.shared.selectedImageArray?.remove(at: i)
                
            }
        }
        
    }
    
    private func activationManagerOfDeleteButton(active : Bool, animated : Bool) {
        
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
    
    private func setDelegationForSticker(inputDelegateView : CustomSticker2) {
        
        if stickerManagementView != nil {
            stickerManagementView!.delegateForEditedView = inputDelegateView
        }
        
    }
    
    private func stickerVisibilityOperations(active : Bool) {
        
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
    
    private func returnImage() -> UIImageView {
        
        return capturedImage
        
    }
    
    private func enlargeDeleteButton(inputView : UIView, active : Bool) {
        
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
    
    private func returnCapturedImage() -> UIImage {
        
        guard let image = capturedImage.image else { return UIImage() }
        
        return image
        
    }
    
    private func startAnimation() {
        
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
    
    private func startAnimationForCommitButton(completion : @escaping (_ finish : Bool) -> Void) {
        
        commitButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.commitButton.transform = CGAffineTransform.identity
            
        }, completion: completion)
        
    }
    
    @objc private func commitProcess(_ sender : UIButton) {
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
    
    private func createNewImageWithCommonStickers() {
        
        var isImageEdited = false
        
        PostItems.shared.appendNewItemToSelectedOriginalImageArray(image: self.returnCapturedImage())
        
        let x = self.returnCapturedImage()
        print("image mokoko : \(x)")
        print("self.bound.size : \(self.bounds.size)")
        
        let imageOptionSize = CGSize(width: x.size.width, height: x.size.height)
        print("imageOptionSize : \(imageOptionSize)")
        
        let imageRect = CGRect(x: 0, y: 0, width: x.size.width, height: x.size.height)
        
        if let array = CommonSticker.shared.stickerArray {
            if !array.isEmpty {
                isImageEdited = true
            }
        }
        
        if isDoodled {
            isImageEdited = true
        }
        
        if isImageEdited {
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
        
        isImageEdited = false
        
        /*
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
            
        }*/
        
    }
    
    private func activationManagerOfDoodleViews(active: Bool) {
        self.menuAndFooterVisibiltyManagement(visibiltyVaule: active)
        doodleObjectsActivationManager(active)
        
    }
    
    @objc private func startAddingDoodleProcess(_ sender: UITapGestureRecognizer) {
        self.activationManagerOfDoodleViews(active: true)
        
    }
    
    // MARK: - doodle view manager functions
    private func initializeDoodleView() {
        addDoodleViews()
        doodleObjectsActivationManager(false)
        listenColorChanges()
    }
    
    private func addDoodleViews() {
        
        self.addSubview(closeDoodle)
        self.addSubview(doneForDoodle)
        self.addSubview(colorPaletteForDoodle)
        self.addSubview(clearDoodle)
        self.doneForDoodle.addSubview(doneLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeDoneForDoodle = self.doneForDoodle.safeAreaLayoutGuide
        let safeMenuContainer = self.menuContainerView.safeAreaLayoutGuide
        let safeFooterContainer = self.footerContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            closeDoodle.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor, constant: 15),
            closeDoodle.leadingAnchor.constraint(equalTo: safeMenuContainer.leadingAnchor, constant: 15),
            closeDoodle.heightAnchor.constraint(equalToConstant: 30),
            closeDoodle.widthAnchor.constraint(equalToConstant: 30),
            
            doneForDoodle.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor, constant: 15),
            doneForDoodle.trailingAnchor.constraint(equalTo: safeMenuContainer.trailingAnchor, constant: -15),
            doneForDoodle.heightAnchor.constraint(equalToConstant: 25),
            doneForDoodle.widthAnchor.constraint(equalToConstant: 80),
            
            clearDoodle.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor, constant: 15),
            clearDoodle.trailingAnchor.constraint(equalTo: safeDoneForDoodle.leadingAnchor, constant: -10),
            clearDoodle.heightAnchor.constraint(equalToConstant: 30),
            clearDoodle.widthAnchor.constraint(equalToConstant: 30),
            
            doneLabel.leadingAnchor.constraint(equalTo: safeDoneForDoodle.leadingAnchor),
            doneLabel.trailingAnchor.constraint(equalTo: safeDoneForDoodle.trailingAnchor),
            doneLabel.topAnchor.constraint(equalTo: safeDoneForDoodle.topAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: safeDoneForDoodle.bottomAnchor),
            
            colorPaletteForDoodle.leadingAnchor.constraint(equalTo: safeFooterContainer.leadingAnchor),
            colorPaletteForDoodle.trailingAnchor.constraint(equalTo: safeFooterContainer.trailingAnchor),
            colorPaletteForDoodle.heightAnchor.constraint(equalToConstant: 50),
            colorPaletteForDoodle.bottomAnchor.constraint(equalTo: safeFooterContainer.bottomAnchor),
            
            ])
        
    }
    
    fileprivate func doodleObjectsActivationManager(_ active: Bool) {
        
        isDoodleActive = active
        
        UIView.transition(with: closeDoodle, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.closeDoodle.isHidden = !active
        })
        
        UIView.transition(with: doneForDoodle, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.doneForDoodle.isHidden = !active
        })
        
        UIView.transition(with: colorPaletteForDoodle, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.colorPaletteForDoodle.isHidden = !active
        })
        
        UIView.transition(with: clearDoodle, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.clearDoodle.isHidden = !active
        })
    }
    
    @objc private func doneDoodleProcess(_ sender: UITapGestureRecognizer) {
        self.activationManagerOfDoodleViews(active: false)
    }
    
    @objc private func closeDoodleProcess(_ sender: UITapGestureRecognizer) {
        self.activationManagerOfDoodleViews(active: false)
        self.erase()
        
    }
    
    @objc private func eraseDoodleProcess(_ sender: UITapGestureRecognizer) {
        self.erase()
    }
    
    private func erase() {
        self.shapeLayers.forEach { (layer) in
            layer.removeFromSuperlayer()
        }
        self.shapeLayers.removeAll()
        
        isDoodled = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CapturedImageView: UIGestureRecognizerDelegate {
    
    private func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.dismissCustomCameraCapturedView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func dismissCustomCameraCapturedView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraCapturedView starts")
        
        clearStickerFromCapturedArray()
        
        self.activationManagerDefault(granted: false)
        
        guard let image = capturedImage.image else { return }
        
        deleteCapturedImagesFromSelectedItems(image: image)
        
        // erase doodle
        self.erase()
        
    }
    
    private func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.saveCapturedImage(_:)))
        tapGesture.delegate = self
        downloadButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func saveCapturedImage(_ sender : UITapGestureRecognizer) {
        
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
    
    private func setupAddTextGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedImageView.startAddingTextView(_:)))
        tapGesture.delegate = self
        addTextContainerView.addGestureRecognizer(tapGesture)
        addTextImage.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func startAddingTextView(_ sender : UITapGestureRecognizer) {
        
        print("startAddingTextView starts")
        print("stickerManagementView : \(stickerManagementView)")
        
        stickerVisibilityOperations(active: false)
        
        stickerManagementViewAnimationManagement(active: true)
        
    }
    
    private func stickerManagementViewAnimationManagement(active : Bool) {
        
        guard stickerManagementView != nil  else {
            return
        }
        
//        stickerManagementView!.activationManagementDefault(granted: active)
        stickerManagementView!.activationManagementWithDelegations(granted: active)
    }
    
    private func listenColorChanges() {
        colorPaletteForDoodle.listenColorChanges { (changedColor) in
            self.doodleColor = changedColor
        }
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

// MARK: - StickerProtocols
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
        
        print("Sticker count : \(String(describing: CommonSticker.shared.stickerArray?.count))")
        
        guard let items2 = CommonSticker.shared.stickerArray else { return }
        
        for item in items2 {
            print("--> : \(String(describing: item.sticker.text))")
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

// MARK: - doodle delegation protocol functions
protocol DrawViewDelegate: NSObjectProtocol{
    func storyDoodleView(drawing:Bool)
}

// MARK: - touches function for doodle
extension CapturedImageView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDoodleActive {
            let touch = (touches as NSSet).anyObject() as! UITouch
            let point = touch.location(in: self)
            
            currenShapeLayer = DrawLayer.init()
            currenShapeLayer?.frame = self.contentContainerView.bounds
            //currenShapeLayer?.strokeColor = lineColor.cgColor
            currenShapeLayer?.strokeColor = doodleColor.cgColor
            currenShapeLayer?.lineWidth = 10
            
            self.contentContainerView.layer.addSublayer(currenShapeLayer!)
            self.shapeLayers.append(currenShapeLayer!)
            
            currenShapeLayer?.begin(at: point)
            
            if let d = delegate {
                d.storyDoodleView(drawing: true)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDoodleActive {
            let touch = (touches as NSSet).anyObject() as! UITouch
            let point = touch.location(in: self)
            
            currenShapeLayer?.move(at: point)
            
            isDoodled = true
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDoodleActive {
            self.touchEndOrCancel()
            
            if let d = delegate {
                d.storyDoodleView(drawing: false)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDoodleActive {
            self.touchEndOrCancel()
            
            if let d = delegate {
                d.storyDoodleView(drawing: false)
            }
        }
    }
    
    private func touchEndOrCancel() {
        if isDoodleActive {
            currenShapeLayer?.end()
            currenShapeLayer = nil
        }
    }
    
}



