//
//  SaySomethingView.swift
//  catchu
//
//  Created by Erkut Baş on 11/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

enum ViewObjects<T> {
    case input(T)
}

class SaySomethingView: UIView {
    
    var saySomethingViewModel = SaySomethingViewModel()
    
    weak var delegate : PostViewProtocols!
    weak var delegateCameraImageVideoHandlerProtocol : CameraImageVideoHandlerProtocol!
    
    private var circleViewForCamera : CircleView?
    private var circleViewForVideo : CircleView?
    private var circleViewForNote : CircleView?
    
    private var cameraContentActive : PostContentCheckView?
    private var videoContentActive : PostContentCheckView?
    private var noteContentActive : PostContentCheckView?
    
    private var keyboardActive : Bool = false
    private var textViewHasText : Bool = false
    
    private var maxFontSize : CGFloat = 28
    private var minFontSize : CGFloat = 18
    private var fontIncrement : CGFloat = 1
    
    private var leadingConstraintsOfPostTargetStackview = NSLayoutConstraint()
    
    lazy var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        //temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var topView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    lazy var bodyView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    lazy var footerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var cancelButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        temp.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.tintColor = #colorLiteral(red: 0.8588235294, green: 0.1960784314, blue: 0.2117647059, alpha: 1)
//        temp.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.1960784314, blue: 0.2117647059, alpha: 1)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        temp.addTarget(self, action: #selector(dismissPostViewController(_:)), for: .touchUpInside)
        
        temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        temp.layer.borderColor = #colorLiteral(red: 0.8588235294, green: 0.1960784314, blue: 0.2117647059, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_15
        
        return temp
    }()
    
    lazy var postButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.post, for: .normal)
        temp.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        temp.addTarget(self, action: #selector(initiatePostProcess(_:)), for: .touchUpInside)
        
        temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        temp.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_15
        
        return temp
    }()
    
    lazy var stackViewForButtons: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [cancelButton, postButton])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.spacing = Constants.StaticViewSize.ConstraintValues.constraint_10
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillEqually
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var stackContentContainer: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [cameraContainer, videoContainer, noteContainer])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.spacing = Constants.StaticViewSize.ConstraintValues.constraint_5
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fill
        
        return temp
    }()
    
    lazy var cameraContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.layer.borderColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        //temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        return temp
    }()
    
    lazy var videoContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.layer.borderColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        //temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        return temp
    }()
    
    lazy var noteContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.layer.borderColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        //temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        return temp
    }()
    
    lazy var cameraImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "photo-camera.png")
        temp.contentMode = .scaleAspectFill
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        //temp.clipsToBounds = true
        return temp
    }()
    
    lazy var videoImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "video-player.png")
        temp.contentMode = .scaleAspectFill
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        //temp.clipsToBounds = true
        return temp
    }()
    
    lazy var noteImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "notepad.png")
        temp.contentMode = .scaleAspectFill
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        //temp.clipsToBounds = true
        return temp
    }()
    
    lazy var mapContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.layer.borderColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        //temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        return temp
    }()
    
    lazy var mapImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "map.png")
        temp.contentMode = .scaleAspectFill
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        //temp.clipsToBounds = true
        return temp
    }()
    
    lazy var stackViewForPostAttachments: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: createStackViewObjects())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .equalSpacing
        
        return temp
    }()
    
    lazy var informationLabel: UILabel = {
        let temp = UILabel()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.text = LocalizedConstants.PostAttachmentInformation.publicInformation
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.textAlignment = .left
        temp.alpha = 0
        temp.numberOfLines = 1
        
        temp.textColor = #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1)
        
        return temp
    }()
    
    lazy var attachmentContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = 10
        
        return temp
    }()
    
    lazy var saySomethingTextView: UITextView = {
        let temp = UITextView()
        temp.backgroundColor = UIColor.clear
        temp.textColor = UIColor.lightGray
        temp.text = LocalizedConstants.PostAttachmentInformation.saySomething
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        temp.textAlignment = .justified
        temp.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        //        temp.font = UIFont.boldSystemFont(ofSize: 28)
        temp.isScrollEnabled = false
        temp.textContainer.lineBreakMode = .byWordWrapping
        temp.textContainer.widthTracksTextView = true
        temp.isScrollEnabled = false
        temp.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        temp.dataDetectorTypes = UIDataDetectorTypes.link
        
        // keyboard settings
        temp.autocorrectionType = .no
        temp.keyboardAppearance = .dark
        temp.keyboardType = .alphabet
        temp.keyboardDismissMode = .interactive
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        temp.delegate = self
        
        return temp
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    init(frame: CGRect, delegate : PostViewProtocols) {
        super.init(frame: frame)
        self.delegate = delegate
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - major functions
extension SaySomethingView {
    
    private func initializeView() {
        
        print("initializeView starts")
        
        addViews()
        addCircleToContainers()
        addGestures()
        addKeyboardNotificationObservers()
        addStackViewFotPostTargetButtons()
        selectFirstItem()
        addContentCheckViews()

    }
    
    private func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(topView)
        self.containerView.addSubview(bodyView)
        self.containerView.addSubview(footerView)
        self.bodyView.addSubview(saySomethingTextView)
        self.footerView.addSubview(stackViewForButtons)
        self.topView.addSubview(stackContentContainer)
        self.cameraContainer.addSubview(cameraImageView)
        self.videoContainer.addSubview(videoImageView)
        self.noteContainer.addSubview(noteImageView)
        self.topView.addSubview(mapContainer)
        self.mapContainer.addSubview(mapImageView)
        self.footerView.addSubview(attachmentContainerView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeTopView = self.topView.safeAreaLayoutGuide
        let safeFooterView = self.footerView.safeAreaLayoutGuide
        let safeBodyView = self.bodyView.safeAreaLayoutGuide
        let safeCameraContainer = self.cameraContainer.safeAreaLayoutGuide
        let safeVideoContainer = self.videoContainer.safeAreaLayoutGuide
        let safeNoteContainer = self.noteContainer.safeAreaLayoutGuide
        let safeMapContainer = self.mapContainer.safeAreaLayoutGuide
        let safeStackViewForButtons = self.stackViewForButtons.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            topView.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            topView.topAnchor.constraint(equalTo: safeContainer.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_70),
            
            footerView.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: safeContainer.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_80),
            
            attachmentContainerView.leadingAnchor.constraint(equalTo: safeFooterView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            attachmentContainerView.trailingAnchor.constraint(equalTo: safeFooterView.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            attachmentContainerView.bottomAnchor.constraint(equalTo: safeStackViewForButtons.topAnchor),
            attachmentContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            
            bodyView.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeFooterView.topAnchor),
            bodyView.topAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            
            saySomethingTextView.leadingAnchor.constraint(equalTo: safeBodyView.leadingAnchor),
            saySomethingTextView.trailingAnchor.constraint(equalTo: safeBodyView.trailingAnchor),
            saySomethingTextView.topAnchor.constraint(equalTo: safeBodyView.topAnchor),
            saySomethingTextView.bottomAnchor.constraint(equalTo: safeBodyView.bottomAnchor),
            
            stackViewForButtons.leadingAnchor.constraint(equalTo: safeFooterView.leadingAnchor, constant: Constants.StaticViewSize.ViewSize.Height.height_10),
            stackViewForButtons.trailingAnchor.constraint(equalTo: safeFooterView.trailingAnchor, constant: -Constants.StaticViewSize.ViewSize.Height.height_10),
            stackViewForButtons.bottomAnchor.constraint(equalTo: safeFooterView.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            stackViewForButtons.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            stackContentContainer.centerYAnchor.constraint(equalTo: safeTopView.centerYAnchor),
            stackContentContainer.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            
            /*
            stackContentContainer.bottomAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            stackContentContainer.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),*/
            
            cameraContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            videoContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            noteContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            
            cameraContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            videoContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            noteContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            
            cameraImageView.centerYAnchor.constraint(equalTo: safeCameraContainer.centerYAnchor),
            cameraImageView.centerXAnchor.constraint(equalTo: safeCameraContainer.centerXAnchor),
            cameraImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            cameraImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_44),
            
            videoImageView.centerYAnchor.constraint(equalTo: safeVideoContainer.centerYAnchor),
            videoImageView.centerXAnchor.constraint(equalTo: safeVideoContainer.centerXAnchor),
            videoImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            videoImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_44),
            
            noteImageView.centerYAnchor.constraint(equalTo: safeNoteContainer.centerYAnchor),
            noteImageView.centerXAnchor.constraint(equalTo: safeNoteContainer.centerXAnchor),
            noteImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            noteImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_44),
            
            mapContainer.centerYAnchor.constraint(equalTo: safeTopView.centerYAnchor),
            //mapContainer.bottomAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            mapContainer.trailingAnchor.constraint(equalTo: safeTopView.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            mapContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            mapContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            
            mapImageView.centerYAnchor.constraint(equalTo: safeMapContainer.centerYAnchor),
            mapImageView.centerXAnchor.constraint(equalTo: safeMapContainer.centerXAnchor),
            mapImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            mapImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_44),
            
            
            ])
        
    }
    
    private func addContentCheckViews() {
        
        cameraContentActive = PostContentCheckView()
        cameraContentActive?.translatesAutoresizingMaskIntoConstraints = false
        
        videoContentActive = PostContentCheckView()
        videoContentActive?.translatesAutoresizingMaskIntoConstraints = false
        
        noteContentActive = PostContentCheckView()
        noteContentActive?.translatesAutoresizingMaskIntoConstraints = false
        
        self.cameraContainer.addSubview(cameraContentActive!)
        self.videoContainer.addSubview(videoContentActive!)
        self.noteContainer.addSubview(noteContentActive!)
        
        let safeCameraContainer = self.cameraContainer.safeAreaLayoutGuide
        let safeVideoContainer = self.videoContainer.safeAreaLayoutGuide
        let safeNoteContainer = self.noteContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            cameraContentActive!.trailingAnchor.constraint(equalTo: safeCameraContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            cameraContentActive!.topAnchor.constraint(equalTo: safeCameraContainer.topAnchor),
            cameraContentActive!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            cameraContentActive!.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            videoContentActive!.trailingAnchor.constraint(equalTo: safeVideoContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            videoContentActive!.topAnchor.constraint(equalTo: safeVideoContainer.topAnchor),
            videoContentActive!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            videoContentActive!.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            noteContentActive!.trailingAnchor.constraint(equalTo: safeNoteContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            noteContentActive!.topAnchor.constraint(equalTo: safeNoteContainer.topAnchor),
            noteContentActive!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            noteContentActive!.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            ])
        
    }
    
    @objc func dismissPostViewController(_ sender : UIButton) {
        
        delegate.dismissPostView()
        
    }
    
    @objc func initiatePostProcess(_ sender : UIButton) {
        
        print("\(#function) starts")
        startAnimationCommon(inputObject: postButton)
        
        print("PostItems.shared.returnTotalPostItems() : \(PostItems.shared.returnTotalPostItems())")
        print("saySomethingTextView.hasText : \(saySomethingTextView.hasText)")
        print("textViewHasText : \(textViewHasText)")
        
        if PostItems.shared.returnTotalPostItems() <= 0 && !textViewHasText {
            // there is nothing to post
            AlertViewManager.show(type: .error, placement: .top, body: LocalizedConstants.PostAttachmentInformation.thereIsNothingToPost)
        } else {
            saySomethingTextView.resignFirstResponder()
            saySomethingViewModel.startPostProcess()
        }
        
    }
    
    func addCircleToContainers() {
        
        addCircleViewToCameraContainer()
        addCircleViewToVideoContainer()
        addCircleViewToNoteContainer()
        
    }
    
    func addCircleViewToCameraContainer() {
        // Create a new CircleView for camera container
        circleViewForCamera = CircleView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_60, height: Constants.StaticViewSize.ViewSize.Height.height_60))
        
        cameraContainer.addSubview(circleViewForCamera!)
    }
    
    func addCircleViewToVideoContainer() {
        // Create a new CircleView for video container
        circleViewForVideo = CircleView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_60, height: Constants.StaticViewSize.ViewSize.Height.height_60))
        
        videoContainer.addSubview(circleViewForVideo!)
    }
    
    func addCircleViewToNoteContainer() {
        // Create a new CircleView note container
        circleViewForNote = CircleView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_60, height: Constants.StaticViewSize.ViewSize.Height.height_60))
        
        noteContainer.addSubview(circleViewForNote!)
    }
    
    func contentAnimationManagement(postContentType : PostContentType, active : Bool) {
        
        switch postContentType {
        case .camera:
            guard let circleViewForCamera = circleViewForCamera else { return }
            
            if active {
                circleViewForCamera.setColor(inputColor: #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1))
                circleViewForCamera.animateCircleWithDelegation(duration: 1, delegate: self, postContentType: postContentType)
            } else {
                //circleViewForCamera.setColor(inputColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                circleViewForCamera.animateCircleWithDelegationToBack(duration: 1, delegate: self)
            }
            
        case .video:
            guard let circleViewForVideo = circleViewForVideo else { return }
            
            if active {
                circleViewForVideo.setColor(inputColor: #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1))
                circleViewForVideo.animateCircleWithDelegation(duration: 1, delegate: self, postContentType: postContentType)
            } else {
                circleViewForVideo.animateCircleWithDelegationToBack(duration: 1, delegate: self)
            }
            
        case .note:
            guard let circleViewForNote = circleViewForNote else { return }
            
            if active {
                circleViewForNote.setColor(inputColor: #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1))
                circleViewForNote.animateCircleWithDelegation(duration: 1, delegate: self, postContentType: postContentType)
            } else {
                circleViewForNote.animateCircleWithDelegationToBack(duration: 1, delegate: self)
            }

        }
    }
    
    func startAnimationCommon(inputObject: UIView) {
        
        inputObject.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                
                inputObject.transform = CGAffineTransform.identity
                
                
        })
        inputObject.layoutIfNeeded()
    }
    
    func startAnimation() {
        
        mapContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.mapContainer.transform = CGAffineTransform.identity
                
                
        })
        self.mapContainer.layoutIfNeeded()
        
    }
    
    func startAnimationForCameraContent() {
        
        cameraContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.cameraContainer.transform = CGAffineTransform.identity
                
                
        })
        self.cameraContainer.layoutIfNeeded()
        
    }
    
    func startAnimationForVideoContent() {
        
        videoContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.videoContainer.transform = CGAffineTransform.identity
                
                
        })
        self.videoContainer.layoutIfNeeded()
        
    }
    
    func addKeyboardNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SaySomethingView.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SaySomethingView.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    @objc func keyboardShow(_ notification: NSNotification) {
        print("keyboardShow")
        
        keyboardActive = true
    }
    
    @objc func keyboardHide(_ notification: NSNotification) {
        print("keyboardHide")
        
        keyboardActive = false
    }
    
    /// create objects which is used to specify the target for post
    ///
    /// - Returns: returns a couple of views for stackview
    /// - Author: Erkut Bas
    private func createStackViewObjects() -> [UIView] {
        
        var attachmentArray = [UIView]()
        
        let attachment1 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment1.setType(type: PostAttachmentTypes.publicPost)
        attachment1.setImage(inputImage: UIImage(named: "earth")!)
        attachment1.setLabel(inputText: LocalizedConstants.PostAttachments.publicInfo)
        
        attachmentArray.append(attachment1)
        
        let attachment2 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment2.setType(type: PostAttachmentTypes.allFollowers)
        attachment2.setImage(inputImage: UIImage(named: "all_followers")!)
        attachment2.setLabel(inputText: LocalizedConstants.PostAttachments.allFollowers)
        
        attachmentArray.append(attachment2)
        
        let attachment3 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment3.setType(type: PostAttachmentTypes.friends)
        attachment3.setImage(inputImage: UIImage(named: "friend")!)
        attachment3.setLabel(inputText: LocalizedConstants.PostAttachments.friends)
        
        attachmentArray.append(attachment3)
        
        let attachment4 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment4.setType(type: PostAttachmentTypes.group)
        attachment4.setImage(inputImage: UIImage(named: "group")!)
        attachment4.setLabel(inputText: LocalizedConstants.PostAttachments.group)
        
        attachmentArray.append(attachment4)
        
        let attachment5 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment5.setType(type: PostAttachmentTypes.onlyMe)
        attachment5.setImage(inputImage: UIImage(named: "unlocked")!)
        attachment5.setLabel(inputText: LocalizedConstants.PostAttachments.onlyMe)
        
        attachmentArray.append(attachment5)
        
        print("hihihihi")
        
        return attachmentArray
        
    }
    
    private func addStackViewFotPostTargetButtons() {
        
        setDelegatesForSaySomethingView()
        
        self.attachmentContainerView.addSubview(stackViewForPostAttachments)
        self.attachmentContainerView.addSubview(informationLabel)
        
        self.attachmentContainerView.bringSubview(toFront: stackViewForPostAttachments)
        
        let safeAttachmentContainer = self.attachmentContainerView.safeAreaLayoutGuide
        
        leadingConstraintsOfPostTargetStackview = stackViewForPostAttachments.leadingAnchor.constraint(equalTo: safeAttachmentContainer.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            stackViewForPostAttachments.trailingAnchor.constraint(equalTo: safeAttachmentContainer.trailingAnchor, constant: -10),
            leadingConstraintsOfPostTargetStackview,
            stackViewForPostAttachments.centerYAnchor.constraint(equalTo: safeAttachmentContainer.centerYAnchor),
            
            informationLabel.leadingAnchor.constraint(equalTo: safeAttachmentContainer.leadingAnchor, constant: 10),
            informationLabel.trailingAnchor.constraint(equalTo: safeAttachmentContainer.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_50),
            informationLabel.topAnchor.constraint(equalTo: safeAttachmentContainer.topAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: safeAttachmentContainer.bottomAnchor),
            
            ])
        
    }
    
    /// Description: reset post target views
    /// - Author: Erkut Bas
    private func resetPostAttachmentViews() {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            if let view = item as? PostAttachmentView {
                view.setSelected(isSelected: false)
                view.clearTintColor()
                view.isHidden = false
                view.alpha = 1
            }
        }
        
        self.leadingConstraintsOfPostTargetStackview.isActive = true
        self.attachmentContainerView.backgroundColor = UIColor.clear
        self.informationLabel.alpha = 0
        
    }
    
    
    /// Description : Decides information about which post target(s) is/are selected
    ///
    /// - Parameter postType: post target type
    /// - Author: Erkut BAs
    private func decideInformationText(postType : PostAttachmentTypes) {
        
        switch postType {
        case .friends:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.gettingFriends
        case .group:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.gettingGroup
        case .publicPost:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.publicInformation
        case .onlyMe:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.onlyMeInformation
        case .allFollowers:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.allFollowersInformation
        }
        
    }
    
    private func setDelegatesForSaySomethingView() {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let postAttachmentItem = item as? PostAttachmentView {
                postAttachmentItem.setDelegationOfPostAttachmentView(delegate: self)
            }
            
        }
        
    }
    
    private func selectFirstItem() {
        if let firstItemPublicPost = stackViewForPostAttachments.arrangedSubviews.first as? PostAttachmentView {
            firstItemPublicPost.triggerFirstSelection(postType: .publicPost)
        }
    }
    
    func addGestures() {
        addGestureToMapContainer()
        addGestureToCameraContent()
        addGestureToVideoContent()
    }
    
    func scrollManagementOfSaySomethingTextView(active : Bool) {
        saySomethingTextView.isScrollEnabled = active
    }
    
    func startPhotoPickerProcess() {
        
        if PostItems.shared.returnSelectedImageArrayCount() > 0 {
            AlertControllerManager.shared.startActionSheetManager(type: .camera, operationType: .update, delegate: self, title: nil)
        } else {
            AlertControllerManager.shared.startActionSheetManager(type: .camera, operationType: .select, delegate: self, title: nil)
        }
        
    }
    
    func startVideoPickerProcess() {
        
        if PostItems.shared.returnSelectedVideoArrayCount() > 0 {
            AlertControllerManager.shared.startActionSheetManager(type: .video, operationType: .update, delegate: self, title: nil)
        } else {
            AlertControllerManager.shared.startActionSheetManager(type: .video, operationType: .select, delegate: self, title: nil)
        }
        
    }
    
    func setCameraGalleryPermissionDelegation(delegate : CameraImageVideoHandlerProtocol) {
        self.delegateCameraImageVideoHandlerProtocol = delegate
    }
    
    func initiateOpenImageGallery() {
        CameraImagePickerManager.shared.openImageGallery(delegate: delegateCameraImageVideoHandlerProtocol)
    }
    
    func initiateOpenSystemCamera() {
        CameraImagePickerManager.shared.openSystemCamera(delegate: delegateCameraImageVideoHandlerProtocol)
    }
    
    func initiateVideoGallery() {
        CameraImagePickerManager.shared.openVideoGallery(delegate: delegateCameraImageVideoHandlerProtocol)
    }
    
    func initiateVideoView() {
        print("delegate : \(delegate)")
        delegateCameraImageVideoHandlerProtocol.initiateVideoViewPermissionProcess()
    }
    
}

// MARK: - outside call functions
extension SaySomethingView {
    
    func postProcessFinishListener(completion : @escaping (_ finish : Bool) -> Void) {
        saySomethingViewModel.closePostPage.bind { (finish) in
            completion(finish)
        }
    }
    
    func postProcessStateListener(completion : @escaping (_ state : PostProcessState) -> Void) {
        saySomethingViewModel.postState.bind(completion)
    }
    
}

// MARK: - UITextViewDelegate
extension SaySomethingView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizedConstants.PostAttachmentInformation.saySomething
            textView.textColor = UIColor.lightGray
        }
    }
    
    fileprivate func textViewContentAnimation(_ textView: UITextView) {
        print("\(#function) starts")
        print("textView.hasText : \(textView.hasText)")
        
        if !textView.hasText {
//            contentAnimationManagement(postContentType: .note, active: false)
            triggerContentCheckAnimation(active: false, postContentType: .note)
            self.textViewHasText = false
        } else {
            if !self.textViewHasText {
//                contentAnimationManagement(postContentType: .note, active: true)
            triggerContentCheckAnimation(active: true, postContentType: .note)
            self.textViewHasText = true
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: .infinity))
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        if (newFrame.height > textView.frame.size.height) {
            
            let newFontSize = maxFontSize - fontIncrement
            
            if newFontSize > minFontSize {
                textView.font = UIFont.systemFont(ofSize: maxFontSize - fontIncrement)
                fontIncrement += 1
            } else {
                scrollManagementOfSaySomethingTextView(active: true)
            }
        }
        
        // everytime textViewDidChange triggers, set new value to postItems
        PostItems.shared.message = textView.text
        
        textViewContentAnimation(textView)

    }
    
    func contentActiveCheckIconAnimationManagement(postContentType : PostContentType, active : Bool) {
        
        switch postContentType {
        case .camera:
            guard let cameraContentActive = cameraContentActive else { return }
            if active {
                cameraContentActive.activationManager(active: true)
            } else {
                cameraContentActive.activationManager(active: false)
            }
        case .video:
            guard let videoContentActive = videoContentActive else { return }
            if active {
                videoContentActive.activationManager(active: true)
            } else {
                videoContentActive.activationManager(active: false)
            }
        case .note:
            guard let noteContentActive = noteContentActive else { return }
            if active {
                noteContentActive.activationManager(active: true)
            } else {
                noteContentActive.activationManager(active: false)
            }
        }
        
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension SaySomethingView : UIGestureRecognizerDelegate {
    
    func addGestureToMapContainer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SaySomethingView.keyboardActivationManager(_:)))
        tapGesture.delegate = self
        mapContainer.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func keyboardActivationManager(_ sender : UITapGestureRecognizer) {
        
        //startAnimation()
        startAnimationCommon(inputObject: mapContainer)
        
        if keyboardActive {
            saySomethingTextView.resignFirstResponder()
        } else {
            saySomethingTextView.becomeFirstResponder()
        }
        
    }
    
    func addGestureToCameraContent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SaySomethingView.initiateCameraContentSelectionProcess(_:)))
        tapGesture.delegate = self
        cameraContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc func initiateCameraContentSelectionProcess(_ sender : UITapGestureRecognizer) {
        //startAnimationForCameraContent()
        startAnimationCommon(inputObject: cameraContainer)
        startPhotoPickerProcess()
    }
    
    func addGestureToVideoContent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SaySomethingView.initiateVideoContentSelectionProcess(_:)))
        tapGesture.delegate = self
        videoContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc func initiateVideoContentSelectionProcess(_ sender : UITapGestureRecognizer) {
        //startAnimationForVideoContent()
        startAnimationCommon(inputObject: videoContainer)
        startVideoPickerProcess()
    }
    
}

// MARK: - PostViewProtocols
extension SaySomethingView : PostViewProtocols {
    
    func triggerContentCheckAnimation(active: Bool, postContentType: PostContentType) {
        
        switch postContentType {
        case .camera:
            contentActiveCheckIconAnimationManagement(postContentType: .camera, active: active)
            
        case .video:
            contentActiveCheckIconAnimationManagement(postContentType: .video, active: active)
        
        case .note:
            contentActiveCheckIconAnimationManagement(postContentType: .note, active: active)
        }
        
    }
    
    func selectedPostAttachmentAnimations(selectedAttachmentType : PostAttachmentTypes, completion : @escaping (_ finished : Bool) -> Void) {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                
                if view.postAttachmentType != selectedAttachmentType {
                    
                    UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
                        view.isHidden = true
                        view.alpha = 0
                        
                    })
                    
                    /*
                    UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
                        view.isHidden = true
                        view.alpha = 0
                        
                    }) { (result) in
                        
                        completion(true)
                        
                    }*/
                    
                }
                
            }
            
        }
        
        decideInformationText(postType: selectedAttachmentType)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
            self.leadingConstraintsOfPostTargetStackview.isActive = false
            self.attachmentContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.1)
            self.informationLabel.alpha = 1
            
            self.layoutIfNeeded()
            
        }) { (result) in
            completion(result)
        }
        
    }
    
    func deselectPostAttachmentAnimations() {
        
        print("deselectPostAttachmentAnimations starts")
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                
                view.isHidden = false
                view.alpha = 1
                
            }
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraintsOfPostTargetStackview.isActive = true
            self.attachmentContainerView.backgroundColor = UIColor.clear
            self.informationLabel.alpha = 0
            
            self.layoutIfNeeded()
            
        }
        
    }
    
    func setPostTargetInformation(info: String) {
        self.informationLabel.text = info
    }
    
    
}

// MARK: - ActionSheetProtocols
extension SaySomethingView : ActionSheetProtocols {
    
    func returnOperations(selectedProcessType: ActionButtonOperation) {
        
        print("returnOperations starts")
        print("selectedProcessType : \(selectedProcessType)")
        
        switch selectedProcessType {
        case .cameraOpen:
            self.initiateOpenSystemCamera()
        case .imageGalleryOpen:
            self.initiateOpenImageGallery()
        case .selectedImageUpdate:
            delegateCameraImageVideoHandlerProtocol.updateProcessOfCapturedImage()
        case .selectedImageDelete:
            PostItems.shared.emptySelectedImageArray()
            contentAnimationManagement(postContentType: .camera, active: false)
        case .videoGalleryOpen:
            self.initiateVideoGallery()
        case .videoOpen:
            self.initiateVideoView()
        case .selectedVideoDelete:
            PostItems.shared.emptySelectedVideoUrl()
            contentAnimationManagement(postContentType: .video, active: false)
        default:
            return
        }
    }
    
}

