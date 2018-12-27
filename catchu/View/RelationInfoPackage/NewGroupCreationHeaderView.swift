//
//  NewGroupCreationHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class NewGroupCreationHeaderView: UIView {
    
    var headerViewModel = TableViewHeaderViewModel()
    var inputViewForPermissionDisplay: UIView?
    
    private var groupProfileImageContainerLoaded : Bool = false
    
    private var maxLetterCount = Constants.NumericConstants.MAX_LETTER_COUNT_25

    lazy var groupProfileImageContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewGroupCreationHeaderView.startSettingGroupPhotoProcess(_:)))
        tapGesture.delegate = self
        temp.addGestureRecognizer(tapGesture)
        
        return temp
    }()
    
    lazy var groupProfileIcon: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "icon_camera")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        return temp
    }()
    
    lazy var groupProfileImage: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        return temp
    }()
    
    lazy var groupNameTextField: UITextField = {
        let temp = UITextField()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.clearButtonMode = .whileEditing
        temp.keyboardType = .namePhonePad
        temp.keyboardAppearance = .dark
        temp.autocorrectionType = .no
        temp.placeholder = LocalizedConstants.TitleValues.LabelTitle.groupNameDefault
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        temp.leftView = paddingView
        temp.leftViewMode = UITextFieldViewMode.always
        
        temp.delegate = self
        
        temp.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: UIControlEvents.editingChanged)
        
        return temp
    }()
    
    lazy var infoLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        //temp.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        temp.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        temp.numberOfLines = 0
        temp.lineBreakMode = .byWordWrapping
        temp.text = LocalizedConstants.TitleValues.LabelTitle.provideGroupName
        return temp
    }()
    
    lazy var letterCountSticker: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.text = "\(maxLetterCount)"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.contentMode = .center
        
        return label
        
    }()
    
    
    init(frame: CGRect, backgroundColor: UIColor) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        
        initializeViews()
        groupProfileImageActivationManager(active: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addShadowToProfileContainerView()
    }
    
    deinit {
        headerViewModel.groupNameTextFieldFilled.unbind()
        headerViewModel.groupName.unbind()
        headerViewModel.groupImage.unbind()
    }
    
}

// MARK: - major funtcions
extension NewGroupCreationHeaderView {
    
    private func initializeViews() {
        addViews()
    }
    
    private func addViews() {
        
        self.addSubview(groupProfileImageContainer)
        self.addSubview(groupNameTextField)
        self.addSubview(infoLabel)
        self.addSubview(letterCountSticker)
        self.groupProfileImageContainer.addSubview(groupProfileIcon)
        self.groupProfileImageContainer.addSubview(groupProfileImage)
        
        let safe = self.safeAreaLayoutGuide
        let safeImageContainer = self.groupProfileImageContainer.safeAreaLayoutGuide
        let safeTextField = self.groupNameTextField.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupProfileImageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupProfileImageContainer.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_25),
            //groupProfileImageContainer.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupProfileImageContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            groupProfileImageContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            groupProfileIcon.centerXAnchor.constraint(equalTo: safeImageContainer.centerXAnchor),
            groupProfileIcon.centerYAnchor.constraint(equalTo: safeImageContainer.centerYAnchor),
            groupProfileIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            groupProfileIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_30),
            
            groupProfileImage.leadingAnchor.constraint(equalTo: safeImageContainer.leadingAnchor),
            groupProfileImage.trailingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor),
            groupProfileImage.topAnchor.constraint(equalTo: safeImageContainer.topAnchor),
            groupProfileImage.bottomAnchor.constraint(equalTo: safeImageContainer.bottomAnchor),
            
            groupNameTextField.leadingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            //groupNameTextField.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupNameTextField.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            
            infoLabel.leadingAnchor.constraint(equalTo: safeTextField.leadingAnchor),
            infoLabel.topAnchor.constraint(equalTo: safeTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            infoLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            infoLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            letterCountSticker.trailingAnchor.constraint(equalTo: safeTextField.trailingAnchor),
            letterCountSticker.topAnchor.constraint(equalTo: safeTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            letterCountSticker.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            letterCountSticker.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            /*
            groupProfileIcon.leadingAnchor.constraint(equalTo: safeImageContainer.leadingAnchor),
            groupProfileIcon.trailingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor),
            groupProfileIcon.topAnchor.constraint(equalTo: safeImageContainer.topAnchor),
            groupProfileIcon.bottomAnchor.constraint(equalTo: safeImageContainer.bottomAnchor),
            */
            
            ])
        
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        print("\(#function)")
        
        if let text = sender.text {
            
            headerViewModel.groupNameTextFieldFilled.value = !text.isEmpty
            headerViewModel.groupName.value = text
            
            let countString = maxLetterCount - text.count
            
            UIView.transition(with: letterCountSticker, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.letterCountSticker.text = "\(countString)"
            })
            
        }
        
    }
    
    func addGroupNameTextFieldFilledListener(completion : @escaping (_ filled : Bool) -> Void) {
        headerViewModel.groupNameTextFieldFilled.bind { (filled) in
            completion(filled)
        }
    }
    
    func addGroupNameListener(completion : @escaping (_ groupName : String) -> Void) {
        headerViewModel.groupName.bind { (groupName) in
            completion(groupName)
        }
    }
    
    func addGroupImageListener(completion: @escaping (_ groupImage: UIImage) -> Void) {
        headerViewModel.groupImage.bind { (image) in
            completion(image)
        }
    }
    
    func addGroupImagePickerListener(completion: @escaping (_ imagePickerResult: ImagePickerData) -> Void) {
        headerViewModel.imagePickerData.bind { (imagePickerData) in
            completion(imagePickerData)
        }
    }
    
    private func initiateOpenImageGallery() {
        CameraImagePickerManager.shared.openImageGallery(delegate: self)
    }
    
    private func initiateOpenSystemCamera() {
        CameraImagePickerManager.shared.openSystemCamera(delegate: self)
    }
    
    func setInputView(inputView: UIView) {
        self.inputViewForPermissionDisplay = inputView
    }
    
    private func addShadowToProfileContainerView() {
        
        print("addShadowToProfileContainerView starts")
        print("profilePictureView.bounds : \(groupProfileImageContainer.bounds)")
        
        if groupProfileImageContainer.bounds.height > 0 {
            
            if !groupProfileImageContainerLoaded {
                
                self.groupProfileImageContainer.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.groupProfileImageContainer.layer.shadowOffset = .zero
                self.groupProfileImageContainer.layer.shadowOpacity = 2;
                self.groupProfileImageContainer.layer.shadowRadius = 3;
                self.groupProfileImageContainer.layer.shadowPath = UIBezierPath(roundedRect: groupProfileImageContainer.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_50).cgPath
                
                groupProfileImageContainerLoaded = true
                
            }
            
        }
        
    }
    
    private func groupProfileImageActivationManager(active: Bool) {
        if active {
            groupProfileImage.alpha = 1
        } else {
            groupProfileImage.alpha = 0
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension NewGroupCreationHeaderView: UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLetterCount
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate
extension NewGroupCreationHeaderView: UIGestureRecognizerDelegate {
    
    @objc func startSettingGroupPhotoProcess(_ sender : UITapGestureRecognizer) {
        AlertControllerManager.shared.startActionSheetManager(type: .camera, operationType: ActionControllerOperationType.select, delegate: self, title: nil)
    }
    
}

// MARK: - ActionSheetProtocols
extension NewGroupCreationHeaderView: ActionSheetProtocols {
    
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
extension NewGroupCreationHeaderView: CameraImageVideoHandlerProtocol {
    
    func triggerPermissionProcess(permissionType: PermissionFLows) {
        
        if let inputViewForPermissionDisplay = inputViewForPermissionDisplay {
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: inputViewForPermissionDisplay, permissionType: permissionType, delegate: self)
        }
        
    }
    
    // return from camera shot or library picker
    func returnPickedImage(image: UIImage, pathExtension: String, orientation: ImageOrientation) {
        
        groupProfileImage.image = image
        groupProfileImageActivationManager(active: true)
    
        headerViewModel.groupImage.value = image
        
        let tempImagePickerData = ImagePickerData(image: image, pathExtension: pathExtension, orientation: orientation)
        
        headerViewModel.imagePickerData.value = tempImagePickerData
        
    }
    
}

// MARK: - PermissionProtocol
extension NewGroupCreationHeaderView: PermissionProtocol {
    
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

