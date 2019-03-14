//
//  GroupImageContainerView.swift
//  catchu
//
//  Created by Erkut Baş on 12/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class GroupImageContainerView: UIView {
    
    var groupImageViewModel = GroupImageViewModel()
    var inputViewForPermissionDisplay: UIView?
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    lazy var imageHolder: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.image = UIImage(named: "multiple_users.png")
        temp.image = UIImage(named: "multiple_users.png")
        
        temp.layer.insertSublayer(gradientViewForImageHolder, at: 0)
        
        return temp
    }()
    
    // gradient for image holder
    lazy var gradientViewForImageHolder: CAGradientLayer = {
        let temp = CAGradientLayer()
        temp.frame = self.bounds
        temp.colors = [ UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        return temp
    }()
    
    // button for cancel, to go back
    lazy var cancelButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        //temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        // if you are using an imageview for a button, you need to bring it to forward to make it visible
        temp.setImage(UIImage(named: "icon_left"), for: UIControl.State.normal)
        
        if let buttonImage = temp.imageView {
            temp.bringSubviewToFront(buttonImage)
        
            temp.imageView?.translatesAutoresizingMaskIntoConstraints = false
            let safe = temp.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                (temp.imageView?.centerXAnchor.constraint(equalTo: safe.centerXAnchor))!,
                (temp.imageView?.centerYAnchor.constraint(equalTo: safe.centerYAnchor))!,
                (temp.imageView?.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20))!,
                (temp.imageView?.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20))!,
                
                ])
        }
        
        
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        temp.addTarget(self, action: #selector(backProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        
        return temp
        
    }()
    
    // blur view
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        return temp
    }()
    
    // max size blur view container
    lazy var maxSizeContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    // blur view
    lazy var blurViewForMaxSizeContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        return temp
    }()
    
    lazy var stackViewGroupTitle: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [title, titleExtra])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(direcToGroupInfoEditViewController(_:)))
        tapGesture.delegate = self
        temp.addGestureRecognizer(tapGesture)
        
        return temp
    }()
    
    var title: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.text = "Erkut Deneme Grup"
        
        return temp
        
    }()
    
    var titleExtra: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.text = "\(Constants.NumericConstants.INTEGER_ZERO)"
        
        return temp
        
    }()
    
    // button for cancel, to go back
    lazy var cameraButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        //temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        // if you are using an imageview for a button, you need to bring it to forward to make it visible
        temp.setImage(UIImage(named: "icon_camera"), for: UIControl.State.normal)
        
        if let buttonImage = temp.imageView {
            temp.bringSubviewToFront(buttonImage)
            
            temp.imageView?.translatesAutoresizingMaskIntoConstraints = false
            let safe = temp.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                (temp.imageView?.centerXAnchor.constraint(equalTo: safe.centerXAnchor))!,
                (temp.imageView?.centerYAnchor.constraint(equalTo: safe.centerYAnchor))!,
                (temp.imageView?.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20))!,
                (temp.imageView?.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20))!,
                
                ])
        }
        
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        temp.addTarget(self, action: #selector(imageChangeProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        
        return temp
        
    }()
    
    // blur view
    lazy var blurViewForCameraButton: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        return temp
    }()
    
    lazy var activityIndicatorContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        return temp
    }()
    
    // updating process indicator
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .whiteLarge)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        temp.hidesWhenStopped = true
        temp.startAnimating()
        return temp
    }()
    
    init(frame: CGRect, groupViewModel: CommonGroupViewModel, callerView: UIView) {
        super.init(frame: frame)
        inputViewForPermissionDisplay = callerView
        groupImageViewModel.groupViewModel = groupViewModel
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        groupImageViewModel.groupParticipantCount.unbind()
        groupImageViewModel.groupImageChangeProcess.unbind()
        groupImageViewModel.groupInfoViewExit.unbind()
        groupImageViewModel.stackTitleTapped.unbind()
        groupImageViewModel.groupTitleChangeListener.unbind()
        groupImageViewModel.groupImageChangeProcess.unbind()
        groupImageViewModel.groupImageChangeProcess.unbind()
        
    }
    
}

// MARK: - major functions
extension GroupImageContainerView {
    
    private func initializeView() {
        addViews()
        addBlurEffectToCancelButton()
        addBlurEffectToMaxSizeContainerView()
        addBlurEffectToCameraButton()
        
        alphaManagerOfMaxContainerView(active: false)
        alphaManagerOfStackViewGroupInfo(active: false)
        
        addListeners()
        
        setValuesToViews()
        
        activityIndicatorAnimationManagement(active: false, animated: false)
        
    }
    
    private func addViews() {
        
        self.addSubview(imageHolder)
        self.addSubview(cancelButton)
        self.addSubview(maxSizeContainerView)
        self.addSubview(stackViewGroupTitle)
        self.addSubview(cameraButton)
        self.addSubview(activityIndicatorContainerView)
        self.activityIndicatorContainerView.addSubview(activityIndicatorView)
        
        self.bringSubviewToFront(cancelButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeActivityIndicatorContainerView = self.activityIndicatorContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            imageHolder.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            imageHolder.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            imageHolder.topAnchor.constraint(equalTo: safe.topAnchor),
            imageHolder.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            cancelButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: statusBarHeight + Constants.StaticViewSize.ConstraintValues.constraint_5),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_36),
            cancelButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_36),
           
            maxSizeContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            maxSizeContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            maxSizeContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
            maxSizeContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            stackViewGroupTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stackViewGroupTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: statusBarHeight + Constants.StaticViewSize.ConstraintValues.constraint_10),
           
            cameraButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            cameraButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: statusBarHeight + Constants.StaticViewSize.ConstraintValues.constraint_5),
            cameraButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_36),
            cameraButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_36),
            
            activityIndicatorContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            activityIndicatorContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            activityIndicatorContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
            activityIndicatorContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: safeActivityIndicatorContainerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: safeActivityIndicatorContainerView.centerYAnchor),
            
            ])
        
    }

    private func addBlurEffectToCancelButton() {
        
        cancelButton.insertSubview(blurView, at: 0)
        
        let safe = self.cancelButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addBlurEffectToMaxSizeContainerView() {
        
        maxSizeContainerView.insertSubview(blurViewForMaxSizeContainer, at: 0)
        
        let safe = self.maxSizeContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurViewForMaxSizeContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurViewForMaxSizeContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurViewForMaxSizeContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            blurViewForMaxSizeContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addBlurEffectToCameraButton() {
        
        cameraButton.insertSubview(blurViewForCameraButton, at: 0)
        
        let safe = self.cameraButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurViewForCameraButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurViewForCameraButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurViewForCameraButton.topAnchor.constraint(equalTo: safe.topAnchor),
            blurViewForCameraButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func alphaManagerOfMaxContainerView(active : Bool) {
        if active {
            self.maxSizeContainerView.alpha = 1
            
        } else {
            self.maxSizeContainerView.alpha = 0
        }
    }
    
    private func alphaManagerOfStackViewGroupInfo(active : Bool) {
        if active {
            self.stackViewGroupTitle.alpha = 1
            
        } else {
            self.stackViewGroupTitle.alpha = 0
        }
    }
    
    private func setValuesToViews() {
        if let groupViewModel = groupImageViewModel.groupViewModel {
            if let group = groupViewModel.group {
                if let groupName = group.groupName {
                    self.title.text = groupName
                }
                
                if let url = group.groupPictureUrl {
                    //self.imageHolder.setImagesFromCacheOrFirebaseForGroup(url)
                    if let urlToBeValidCheck = URL(string: url) {
                        if UIApplication.shared.canOpenURL(urlToBeValidCheck) {
                            self.imageHolder.setImagesFromCacheOrDownloadWithTypes(url, type: .originals)
                        }
                    }
                }
                
            }
        }
        
    }
    
    private func processChangeGroupData(groupStruct: UpdatedGroupImageInformation) {
        UIView.transition(with: self.imageHolder, duration: Constants.AnimationValues.aminationTime_03, options: .curveEaseInOut, animations: {
            self.imageHolder.image = groupStruct.newGroupImage
            
        })
        // save newImage to cache
        ImageCacheManager.shared.saveImageToCache((groupStruct.newGroupObject?.groupPictureUrl)!, image: groupStruct.newGroupImage!)
    }
    
    /// Description : adding adding dynamic listeners
    private func addListeners() {
        groupImageViewModel.groupParticipantCount.bind { (participantCount) in
            DispatchQueue.main.async {
                self.titleExtra.text = "\(participantCount)" + " " + LocalizedConstants.TitleValues.LabelTitle.participants
            }
        }
        
        groupImageViewModel.groupTitleChangeListener.bind { (newTitle) in
            DispatchQueue.main.async {
                self.title.text = newTitle
            }
        }
        
        groupImageViewModel.groupDataChangeListener.bind { (updatedGroup) in
            DispatchQueue.main.async {
                self.processChangeGroupData(groupStruct: updatedGroup)
            }
        }
        
        groupImageViewModel.groupImageChangeProcess.bind { (operationState) in
            
            DispatchQueue.main.async {
                switch operationState {
                case .processing:
                    self.activityIndicatorAnimationManagement(active: true, animated: false)
                case .done:
                    self.activityIndicatorAnimationManagement(active: false , animated: true)
                }
            }
            
        }
        
    }
    
    func activationManagerOfMaxSizeContainerView(active : Bool) {
        UIView.transition(with: self.maxSizeContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.alphaManagerOfMaxContainerView(active: active)
        })
    }
    
    func activationManagerOfStackViewGroupInfo(active : Bool) {
        UIView.transition(with: self.stackViewGroupTitle, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            self.alphaManagerOfStackViewGroupInfo(active: active)
        })
    }
    
    
    /// Description : it's used to close group info view
    ///
    /// - Parameter sender: sender button
    /// - Author: Erkut Bas
    @objc func backProcess(_ sender : UIButton) {
        print("\(#function)")
        
        groupImageViewModel.groupInfoViewExit.value = .exit
        
    }
    
    /// Description : it's used to change group image
    ///
    /// - Parameter sender: sender button
    /// - Author: Erkut Bas
    @objc func imageChangeProcess(_ sender : UIButton) {
        print("\(#function)")
        
        AlertControllerManager.shared.startActionSheetManager(type: .camera, operationType: .select, delegate: self, title: nil)
        
    }
    
    private func initiateOpenImageGallery() {
        CameraImagePickerManager.shared.openImageGallery(delegate: self)
    }
    
    private func initiateOpenSystemCamera() {
        CameraImagePickerManager.shared.openSystemCamera(delegate: self)
    }
    
    private func activityIndicatorAnimationManagement(active : Bool, animated: Bool) {
        
        if animated {
            UIView.transition(with: self.activityIndicatorContainerView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                
                if active {
                    self.activityIndicatorContainerView.alpha = 1
                } else {
                    self.activityIndicatorContainerView.alpha = 0
                }
                
            })
        } else {
            if active {
                self.activityIndicatorContainerView.alpha = 1
            } else {
                self.activityIndicatorContainerView.alpha = 0
            }
        }
        
    }
    
    func startCancelButtonObserver(completion : @escaping (_ state : GroupInfoLifeProcess) -> Void) {
        groupImageViewModel.groupInfoViewExit.bind { (imageProcessState) in
            completion(imageProcessState)
        }
    }
    
    func startListenStackViewGroupTitleTapped(completion : @escaping(_ tapped : Bool) -> Void) {
        groupImageViewModel.stackTitleTapped.bind { (tapped) in
            completion(tapped)
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension GroupImageContainerView : UIGestureRecognizerDelegate {
    
    @objc func direcToGroupInfoEditViewController(_ sender : UITapGestureRecognizer) {
        print("\(#function)")
        
        stackViewGroupTitle.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
            self.stackViewGroupTitle.transform = CGAffineTransform.identity
        }) { (finish) in
            if finish {
                
            }
        }
        
    }
    
}

// MARK: - ActionSheetProtocols
extension GroupImageContainerView: ActionSheetProtocols {
    
    func returnOperations(selectedProcessType: ActionButtonOperation) {
        switch selectedProcessType {
        case .cameraOpen:
            print("camera open")
            initiateOpenSystemCamera()
        case .imageGalleryOpen:
            print("image gallery open")
            initiateOpenImageGallery()
        default:
            return
        }
    }
    
}

// MARK: - CameraImageVideoHandlerProtocol
extension GroupImageContainerView: CameraImageVideoHandlerProtocol {
    
    func triggerPermissionProcess(permissionType: PermissionFLows) {
        
        if let inputViewForPermissionDisplay = inputViewForPermissionDisplay {
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: inputViewForPermissionDisplay, permissionType: permissionType, delegate: self)
        }
        
    }
    
    // return from camera shot or library picker
    func returnPickedImage(image: UIImage, pathExtension: String, orientation: ImageOrientation) {
        print("\(#function)")
        print("pathExtension : \(pathExtension)")
        print("image orientation : \(image.imageOrientation.rawValue)")
        print("image.size : \(image.size)")
        print("image.alignmentRectInsets : \(image.alignmentRectInsets)")
        print("image : \(image)")
        
        //guard let imageAsData = UIImageJPEGRepresentation(image, CGFloat(integerLiteral: Constants.NumericConstants.INTEGER_ONE)) else { return }
        //guard let imageAsData = UIImageJPEGRepresentation(image, 0.80) else { return }
        
        let x = image.reSizeImage(inputWidth: Constants.ImageResizeValues.Width.width_1080)
        print("x : \(x)")
        
        guard let imageAsData = x?.jpegData(compressionQuality: 0.80) else { return }
    
        print("There were \(imageAsData.count) bytes")
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(imageAsData.count))
        print("formatted result: \(string)")
        
        groupImageViewModel.prepareUpdatedGroupImageInformation(newImage: image, newImagePathExtension: pathExtension, newImageAsData: imageAsData, newGroupObject: nil, newGroupImageOrientation: orientation, newGroupImageDownloadUrl: nil)
        
        do {
            try groupImageViewModel.updateGroupImage()
        } catch let error as ClientPresentErrors {
            print("\(Constants.ALERT)\(error)")
        } catch {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
}


// MARK: - PermissionProtocol
extension GroupImageContainerView: PermissionProtocol {
    
    // return for library process videoLibrary or photoLibrary
    func returnPermissionResult(status: PHAuthorizationStatus, permissionType: PermissionFLows) {
        
        switch status {
        case .authorized:
            switch permissionType {
            case .photoLibrary:
                CameraImagePickerManager.shared.openImageGallery(delegate: self)
            default:
                return
            }
        default:
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    // return for library process videoSession, cameraSession or audioSession
    func returnPermissinResultBoolValue(result: Bool, permissionType: PermissionFLows) {
        print("\(#function) starts")
        
        if result {
            switch permissionType {
            case .camera:
                CameraImagePickerManager.shared.openSystemCamera(delegate: self)
            default:
                print("\(Constants.CRASH_WARNING)")
            }
        }
        
    }
    
}
