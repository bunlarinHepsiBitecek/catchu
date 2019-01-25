//
//  FacebookContactRequestView.swift
//  catchu
//
//  Created by Erkut Baş on 11/12/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FacebookContactRequestView: UIView {
    
    private var facebookContactRequestViewModel = FacebookContactRequestViewModel()
    
    lazy var containerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
    }()

    lazy var iconContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_2
        temp.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.3333333333, blue: 0.6235294118, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        return temp
    }()
    
    // facebook blue theme color code : 3A559F
    lazy var facebookIcon: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "facebook")
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_4
        return temp
    }()
    
    lazy var informationSubject: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = LocalizedConstants.SlideMenu.facebookFriendRequest
        temp.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
    }()
    
    lazy var informationDetail: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = LocalizedConstants.SlideMenu.findFriendSuggestion
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 0
        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
    }()
    
    // facebook connect button blue theme code : 2196F3
    lazy var connectButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_5
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.connectToFacebook, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        temp.addTarget(self, action: #selector(FacebookContactRequestView.startGettingFacebookFriends(_:)), for: .touchUpInside)
        return temp
    }()
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FacebookContactRequestView {
    
    private func initializeViewSettings() {
        addViews()
    }
    
    private func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(iconContainer)
        self.iconContainer.addSubview(facebookIcon)
        self.containerView.addSubview(informationSubject)
        self.containerView.addSubview(informationDetail)
        self.containerView.addSubview(connectButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeIconContainer = self.iconContainer.safeAreaLayoutGuide
        let safeInformationSubject = self.informationSubject.safeAreaLayoutGuide
        let safeInformationDetail = self.informationDetail.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            informationSubject.centerXAnchor.constraint(equalTo: safeContainer.centerXAnchor),
            informationSubject.centerYAnchor.constraint(equalTo: safeContainer.centerYAnchor),
            informationSubject.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            informationSubject.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_250),
            
            iconContainer.bottomAnchor.constraint(equalTo: safeInformationSubject.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            iconContainer.centerXAnchor.constraint(equalTo: safeContainer.centerXAnchor),
            iconContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100),
            iconContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            facebookIcon.centerXAnchor.constraint(equalTo: safeIconContainer.centerXAnchor),
            facebookIcon.centerYAnchor.constraint(equalTo: safeIconContainer.centerYAnchor),
            facebookIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            facebookIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_40),
            
            informationDetail.topAnchor.constraint(equalTo: safeInformationSubject.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            informationDetail.centerXAnchor.constraint(equalTo: safeContainer.centerXAnchor),
            informationDetail.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            informationDetail.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_250),
            
            connectButton.topAnchor.constraint(equalTo: safeInformationDetail.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            connectButton.centerXAnchor.constraint(equalTo: safeContainer.centerXAnchor),
            connectButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            connectButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_250),
            
            
            ])
        
    }
    
    func listenConnectionRequestTriggered(completion: @escaping(_ triggered: Bool) -> Void) {
        facebookContactRequestViewModel.connectionTriggered.bind(completion)
    }
    
    @objc func startGettingFacebookFriends(_ sender : UIButton) {
        facebookContactRequestViewModel.connectionTriggered.value = true
    }
    
}
