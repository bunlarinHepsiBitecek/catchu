//
//  CustomPermissionView.swift
//  catchu
//
//  Created by Erkut Baş on 9/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class CustomPermissionView: UIView {

    var permissionType : PermissionFLows?
    
    weak var delegate : PermissionProtocol!
    
    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.layer.cornerRadius = 7
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.clipsToBounds = true
        temp.isUserInteractionEnabled = true
        
        return temp
        
    }()
    
    lazy var containerView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 10
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.clipsToBounds = true
        
        return temp
        
    }()
    
    lazy var imageContainer: UIImageView = {
        
        let temp = UIImageView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var whiteView: UIView = {
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.cornerRadius = 40
        
        return temp
    }()
    
    lazy var iconContainerView: UIView = {
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.75)
        temp.layer.cornerRadius = 36
        
        return temp
    }()
    
    lazy var iconImageViev: UIImageView = {
        
        let temp = UIImageView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        
        return temp
    }()
    
    lazy var infoProcessContainer: UIView = {
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 10
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return temp
    }()
    
    lazy var topicLabel: UILabel = {
        
        let temp = UILabel(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.numberOfLines = 0
        temp.sizeToFit()
//        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
    }()
    
    lazy var detailLabelContainer: UIView = {
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 5
        temp.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        
        return temp
    }()
    
    lazy var detailLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
//        temp.contentMode = .center
        temp.textAlignment = .center
        temp.font = UIFont.systemFont(ofSize: 12)
        temp.numberOfLines = 0
        return temp
    
    }()
    
    lazy var actionContainerView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 5
        
        return temp
        
    }()
    
    lazy var notNowButtonContainer: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 5
        temp.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.75)
        
        return temp
        
    }()
    
    lazy var giveAccessButtonContainer: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 5
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return temp
        
    }()
    
    
    lazy var notNowButton: UIButton = {
        
        let temp = UIButton(type: .system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.notNow, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        temp.contentVerticalAlignment = .center
        temp.contentHorizontalAlignment = .center
        temp.addTarget(self, action: #selector(CustomPermissionView.dismisView(_:)), for: .touchUpInside)
        
        return temp
        
    }()
    
    lazy var giveAccessButton: UIButton = {
        
        let temp = UIButton(type: .system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.giveAccess, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        temp.contentVerticalAlignment = .center
        temp.contentHorizontalAlignment = .center
        temp.addTarget(self, action: #selector(CustomPermissionView.requestPermissionMajor(_:)), for: .touchUpInside)
        
        return temp
        
    }()
    
    lazy var enableAccessButton: UIButton = {
        
        let temp = UIButton(type: .system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        temp.contentVerticalAlignment = .center
        temp.contentHorizontalAlignment = .center
        temp.addTarget(self, action: #selector(CustomPermissionView.openSettings(_:)), for: .touchUpInside)
        
        return temp
        
    }()
    
    required init(inputPermissionType : PermissionFLows) {
        super.init(frame: .zero)
        
        setupCloseButtonGesture()
        
        permissionType = inputPermissionType
        
        guard let permissionType = permissionType else { return }
        
        majorFields()
        setPhotoLibrarySettings(permissionType: permissionType)
        
        switch permissionType {
        case .camera, .microphone, .photoLibrary, .videoLibrary, .video:
            startAuthorizedProcess(permissionType: permissionType)
        case .cameraUnathorized, .microphoneUnAuthorizated, .photoLibraryUnAuthorized, .videoLibraryUnauthorized, .videoUnauthorized:
            startUnAuthorizedProcess(permissionType: permissionType)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension CustomPermissionView {
    
    private func majorFields() {
        
        self.layer.cornerRadius = 10
        
        self.addSubview(mainView)
        self.mainView.addSubview(containerView)
        self.containerView.addSubview(imageContainer)
        self.containerView.addSubview(whiteView)
        self.containerView.addSubview(iconContainerView)
        self.iconContainerView.addSubview(iconImageViev)
        self.containerView.addSubview(infoProcessContainer)
        self.infoProcessContainer.addSubview(topicLabel)
        self.infoProcessContainer.addSubview(detailLabelContainer)
        self.detailLabelContainer.addSubview(detailLabel)
        self.containerView.addSubview(actionContainerView)
//        self.actionContainerView.addSubview(giveAccessButtonContainer)
//        self.actionContainerView.addSubview(notNowButtonContainer)
//        self.giveAccessButtonContainer.addSubview(giveAccessButton)
//        self.notNowButtonContainer.addSubview(notNowButton)
        
        let safeArea = self.safeAreaLayoutGuide
        let safeMainArea = self.containerView.safeAreaLayoutGuide
        let whiteViewSafeArea = self.whiteView.safeAreaLayoutGuide
        let iconContainerSafeAre = self.iconContainerView.safeAreaLayoutGuide
        let infoContainerSafeArea = self.infoProcessContainer.safeAreaLayoutGuide
        let topicLabelSafeArea = self.topicLabel.safeAreaLayoutGuide
//        let actionContainerSafeArea = self.actionContainerView.safeAreaLayoutGuide
        let detailContainerSafeArea = self.detailLabelContainer.safeAreaLayoutGuide
//        let notNowContainerSafeArea = self.notNowButtonContainer.safeAreaLayoutGuide
//        let giveAccessContainerSafeArea = self.giveAccessButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 380),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            
            imageContainer.leadingAnchor.constraint(equalTo: safeMainArea.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: safeMainArea.trailingAnchor),
            imageContainer.topAnchor.constraint(equalTo: safeMainArea.topAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 200),
            
            whiteView.leadingAnchor.constraint(equalTo: safeMainArea.leadingAnchor, constant: 110),
            whiteView.trailingAnchor.constraint(equalTo: safeMainArea.trailingAnchor, constant: -110),
            whiteView.topAnchor.constraint(equalTo: safeMainArea.topAnchor, constant: 155),
            whiteView.heightAnchor.constraint(equalToConstant: 80),
            
            iconContainerView.leadingAnchor.constraint(equalTo: whiteViewSafeArea.leadingAnchor, constant: 4),
            iconContainerView.trailingAnchor.constraint(equalTo: whiteViewSafeArea.trailingAnchor, constant: -4),
            iconContainerView.topAnchor.constraint(equalTo: whiteViewSafeArea.topAnchor, constant: 4),
            iconContainerView.bottomAnchor.constraint(equalTo: whiteViewSafeArea.bottomAnchor, constant: -4),
            
            iconImageViev.leadingAnchor.constraint(equalTo: iconContainerSafeAre.leadingAnchor, constant: 20),
            iconImageViev.trailingAnchor.constraint(equalTo: iconContainerSafeAre.trailingAnchor, constant: -20),
            iconImageViev.bottomAnchor.constraint(equalTo: iconContainerSafeAre.bottomAnchor, constant: -20),
            iconImageViev.topAnchor.constraint(equalTo: iconContainerSafeAre.topAnchor, constant: 20),
            
            infoProcessContainer.topAnchor.constraint(equalTo: whiteViewSafeArea.bottomAnchor),
            infoProcessContainer.leadingAnchor.constraint(equalTo: safeMainArea.leadingAnchor),
            infoProcessContainer.trailingAnchor.constraint(equalTo: safeMainArea.trailingAnchor),
            infoProcessContainer.bottomAnchor.constraint(equalTo: safeMainArea.bottomAnchor),
            
            topicLabel.leadingAnchor.constraint(equalTo: infoContainerSafeArea.leadingAnchor, constant: 4),
            topicLabel.trailingAnchor.constraint(equalTo: infoContainerSafeArea.trailingAnchor, constant: -4),
            topicLabel.topAnchor.constraint(equalTo: infoContainerSafeArea.topAnchor, constant: 4),
            topicLabel.heightAnchor.constraint(equalToConstant: 20),
            
            detailLabelContainer.topAnchor.constraint(equalTo: topicLabelSafeArea.bottomAnchor, constant: 4),
            detailLabelContainer.trailingAnchor.constraint(equalTo: infoContainerSafeArea.trailingAnchor, constant: -16),
            detailLabelContainer.leadingAnchor.constraint(equalTo: infoContainerSafeArea.leadingAnchor, constant: 16),
            detailLabelContainer.heightAnchor.constraint(equalToConstant: 50),
            
            detailLabel.leadingAnchor.constraint(equalTo: detailContainerSafeArea.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: detailContainerSafeArea.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: detailContainerSafeArea.bottomAnchor),
            detailLabel.topAnchor.constraint(equalTo: detailContainerSafeArea.topAnchor),
            
            actionContainerView.leadingAnchor.constraint(equalTo: infoContainerSafeArea.leadingAnchor, constant: 16),
            actionContainerView.trailingAnchor.constraint(equalTo: infoContainerSafeArea.trailingAnchor, constant: -16),
            actionContainerView.topAnchor.constraint(equalTo: detailContainerSafeArea.bottomAnchor, constant: 8),
            actionContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            ])
        
        
    }
    
    private func startAuthorizedProcess(permissionType : PermissionFLows) {
        
        self.actionContainerView.addSubview(giveAccessButtonContainer)
        self.actionContainerView.addSubview(notNowButtonContainer)
        self.giveAccessButtonContainer.addSubview(giveAccessButton)
        self.notNowButtonContainer.addSubview(notNowButton)
        
        let actionContainerSafeArea = self.actionContainerView.safeAreaLayoutGuide
        let infoContainerSafeArea = self.infoProcessContainer.safeAreaLayoutGuide
        let detailContainerSafeArea = self.detailLabelContainer.safeAreaLayoutGuide
        let notNowContainerSafeArea = self.notNowButtonContainer.safeAreaLayoutGuide
        let giveAccessContainerSafeArea = self.giveAccessButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            notNowButtonContainer.leadingAnchor.constraint(equalTo: actionContainerSafeArea.leadingAnchor),
            notNowButtonContainer.topAnchor.constraint(equalTo: actionContainerSafeArea.topAnchor),
            notNowButtonContainer.bottomAnchor.constraint(equalTo: actionContainerSafeArea.bottomAnchor),
            notNowButtonContainer.widthAnchor.constraint(equalToConstant: 130),
            
            notNowButton.leadingAnchor.constraint(equalTo: notNowContainerSafeArea.leadingAnchor, constant: 4),
            notNowButton.trailingAnchor.constraint(equalTo: notNowContainerSafeArea.trailingAnchor, constant: -4),
            notNowButton.topAnchor.constraint(equalTo: notNowContainerSafeArea.topAnchor, constant: 4),
            notNowButton.bottomAnchor.constraint(equalTo: notNowContainerSafeArea.bottomAnchor, constant: -4),
            
            giveAccessButtonContainer.trailingAnchor.constraint(equalTo: actionContainerView.trailingAnchor),
            giveAccessButtonContainer.topAnchor.constraint(equalTo: actionContainerSafeArea.topAnchor),
            giveAccessButtonContainer.bottomAnchor.constraint(equalTo: actionContainerView.bottomAnchor),
            giveAccessButtonContainer.widthAnchor.constraint(equalToConstant: 130),
            
            giveAccessButton.leadingAnchor.constraint(equalTo: giveAccessContainerSafeArea.leadingAnchor, constant: 4),
            giveAccessButton.trailingAnchor.constraint(equalTo: giveAccessButtonContainer.trailingAnchor, constant: -4),
            giveAccessButton.topAnchor.constraint(equalTo: giveAccessContainerSafeArea.topAnchor, constant: 4),
            giveAccessButton.bottomAnchor.constraint(equalTo: giveAccessContainerSafeArea.bottomAnchor, constant: -4)
                
            ])
        
    }
    
    private func startUnAuthorizedProcess(permissionType : PermissionFLows) {
        
        self.actionContainerView.addSubview(enableAccessButton)
        
        let actionContainerSafeArea = self.actionContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            enableAccessButton.leadingAnchor.constraint(equalTo: actionContainerSafeArea.leadingAnchor),
            enableAccessButton.trailingAnchor.constraint(equalTo: actionContainerSafeArea.trailingAnchor),
            enableAccessButton.bottomAnchor.constraint(equalTo: actionContainerSafeArea.bottomAnchor),
            enableAccessButton.heightAnchor.constraint(equalToConstant: 50),
            
            ])
        
    }
    
    private func setPhotoLibrarySettings(permissionType : PermissionFLows) {
        
        switch permissionType {
        case .photoLibrary:
            photoLibraryAuthorized()
            
        case .photoLibraryUnAuthorized:
            photoLibraryUnAuthorized()
            
        case .camera, .video:
            cameraAuthorized()
            
        case .cameraUnathorized, .videoUnauthorized:
            cameraUnAuthorized()
            
        case .microphone:
            microphoneAuthorized()
            
        case .microphoneUnAuthorizated:
            microphoneUnAuthorized()
        
        case .videoLibrary:
            photoLibraryAuthorized()
            
        case .videoLibraryUnauthorized:
            photoLibraryUnAuthorized()
        }
        
        
    }
    
    private func photoLibraryAuthorized() {
        
        imageContainer.image = UIImage(named: "galleryRequest.jpg")
        iconImageViev.image = UIImage(named: "gallery_request.png")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForPhotos
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForPhotos
        
    }
    
    private func photoLibraryUnAuthorized() {
        
        imageContainer.image = UIImage(named: "galleryRequest.jpg")
        imageContainer.alpha = 0.5
        iconImageViev.image = UIImage(named: "gallery_request.png")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForPhotos
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForPhotos
        
        enableAccessButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.enableAccessGallery, for: .normal)
        
    }
    
    private func cameraAuthorized() {
        
        imageContainer.image = UIImage(named: "cameraRequest.jpg")
        iconImageViev.image = UIImage(named: "camera_request.png")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForCamera
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForCamera
        
    }
    
    private func cameraUnAuthorized() {
        
        imageContainer.image = UIImage(named: "cameraRequest.jpg")
        imageContainer.alpha = 0.5
        iconImageViev.image = UIImage(named: "camera_request.png")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForCamera
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForCamera
        
        enableAccessButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.enableAccessCamera, for: .normal)
        
    }
    
    private func microphoneAuthorized() {
        
        imageContainer.image = UIImage(named: "microphoneMain.jpeg")
        iconImageViev.image = UIImage(named: "microphone")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForMicrophone
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForMicrophone
        
    }
    
    private func microphoneUnAuthorized() {
        
        imageContainer.image = UIImage(named: "microphoneMain.jpeg")
        imageContainer.alpha = 0.5
        iconImageViev.image = UIImage(named: "microphone")
        
        topicLabel.text = LocalizedConstants.PermissionStatements.topicLabelForMicrophone
        detailLabel.text = LocalizedConstants.PermissionStatements.detailLabelForMicrophone
        
        enableAccessButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.enableAccessMicrophone, for: .normal)
        
    }
    
}

// MARK: - permission requet functions
extension CustomPermissionView {
    
    @objc func requestPermissionMajor(_ sender : UIButton) {
        
        print("requestPermissionMajor starts")
        
        self.removeFromSuperview()

        guard let permissionType = permissionType else { return }

        switch permissionType {
        case .photoLibrary, .videoLibrary:

            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in

                DispatchQueue.main.async {
                    self.delegate.returnPermissionResult(status: authorizationStatus, permissionType: permissionType)
                }
            }
            
        case .camera, .video:
            
            AVCaptureDevice.requestAccess(for: .video) { (result) in

                if result {
                    DispatchQueue.main.async {
                        self.delegate.returnPermissinResultBoolValue(result: result, permissionType: permissionType)
                    }
                }
            }
            
            break
            
        case .microphone:
            
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                
                if granted {
                    DispatchQueue.main.async {
                        self.delegate.returnPermissinResultBoolValue(result: granted, permissionType: permissionType)
                    }
                }
                
            }

        default:
            return
        }
    }
    
    @objc func dismisView(_ sender : UIButton) {
        
        print("dismisView starts")
        
        guard let callerView = self.superview else { return }
        
        UIView.transition(with: callerView, duration: Constants.AnimationValues.aminationTime_07, options: .transitionCrossDissolve, animations: {
            self.removeFromSuperview()
            
        })
        
    }
    
    @objc func openSettings(_ sender : UIButton) {
        
        print("dismisView starts")

        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        
    }
    
    
}


// MARK: - UIGestureRecognizerDelegate
extension CustomPermissionView : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomPermissionView.dismissCustomCameraView(_:)))
        tapGesture.delegate = self
        mainView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissCustomCameraView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraView starts")
        
        guard let permissionType = permissionType else { return }
        
        switch permissionType {
        case .cameraUnathorized, .microphoneUnAuthorizated, .photoLibraryUnAuthorized, .videoLibraryUnauthorized:
            
            guard let callerView = self.superview else { return }
            
            UIView.transition(with: callerView, duration: Constants.AnimationValues.aminationTime_07, options: .transitionCrossDissolve, animations: {
                self.removeFromSuperview()
            })
            
        default:
            break
        }
        
    }
}
