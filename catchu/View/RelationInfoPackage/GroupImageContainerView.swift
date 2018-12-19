//
//  GroupImageContainerView.swift
//  catchu
//
//  Created by Erkut Baş on 12/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupImageContainerView: UIView {
    
    var groupImageViewModel = GroupImageViewModel()
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    lazy var imageHolder: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //temp.image = UIImage(named: "multiple_users.png")
        temp.image = UIImage(named: "8771.jpg")
        
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
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        //temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        // if you are using an imageview for a button, you need to bring it to forward to make it visible
        temp.setImage(UIImage(named: "icon_left"), for: UIControlState.normal)
        
        if let buttonImage = temp.imageView {
            temp.bringSubview(toFront: buttonImage)
        
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
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
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
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
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
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        //temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        // if you are using an imageview for a button, you need to bring it to forward to make it visible
        temp.setImage(UIImage(named: "icon_camera"), for: UIControlState.normal)
        
        if let buttonImage = temp.imageView {
            temp.bringSubview(toFront: buttonImage)
            
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
    lazy var blurViewForCameraButton: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        return temp
    }()
    
    init(frame: CGRect, groupViewModel: CommonGroupViewModel) {
        super.init(frame: frame)
        groupImageViewModel.groupViewModel = groupViewModel
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        groupImageViewModel.groupParticipantCount.unbind()
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
        
    }
    
    private func addViews() {
        
        self.addSubview(imageHolder)
        self.addSubview(cancelButton)
        self.addSubview(maxSizeContainerView)
        self.addSubview(stackViewGroupTitle)
        self.addSubview(cameraButton)
        
        self.bringSubview(toFront: cancelButton)
        
        let safe = self.safeAreaLayoutGuide
        
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
                    self.imageHolder.setImagesFromCacheOrFirebaseForGroup(url)
                }
                
            }
        }
        
        
    }
    
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
    
    @objc func backProcess(_ sender : UIButton) {
        print("\(#function)")
        
        groupImageViewModel.groupImageProcessState.value = .exit
        
    }
    
    func startCancelButtonObserver(completion : @escaping (_ state : GroupImageProcess) -> Void) {
        
        groupImageViewModel.groupImageProcessState.bind { (imageProcessState) in
            completion(imageProcessState)
        }
        
    }
    
    /*
    func setParticipantCount(participantCount : Int) {
        titleExtra.text = "\(participantCount)" + " " + LocalizedConstants.TitleValues.LabelTitle.participants
    }*/
    
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
