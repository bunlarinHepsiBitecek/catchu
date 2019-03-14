//
//  ContactRequestView.swift
//  catchu
//
//  Created by Erkut Baş on 11/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Contacts

class ContactRequestView: UIView {

    private var phoneContactRequestViewModel = PhoneContactRequestViewModel()
    private var connectButtonBusiness : ContactRequestType!
    
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
        temp.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        return temp
    }()
    
    // facebook blue theme color code : 3A559F
    lazy var contactIcon: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "user-shape")
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_4
        return temp
    }()
    
    lazy var informationSubject: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = LocalizedConstants.SlideMenu.contactFriendRequest
        temp.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
    }()
    
    lazy var informationDetail: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = LocalizedConstants.SlideMenu.contactFriendSuggestion
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 0
        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
    }()
    
    // facebook connect button blue theme code : 2196F3
    lazy var connectButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_5
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.connectToContacts, for: .normal)
        temp.addTarget(self, action: #selector(ContactRequestView.startGettingContactFriends(_:)), for: .touchUpInside)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        phoneContactRequestViewModel.connectButtonProcess.unbind()
        phoneContactRequestViewModel.connectButtonProcessType.unbind()
    }
    
}

// MARK: - major functions
extension ContactRequestView {
    
    func initializeViewSettings() {
        addViews()
        addContactRequestViewListeners()
        decideConnectButtonBusiness()
        
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(iconContainer)
        self.iconContainer.addSubview(contactIcon)
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
            
            contactIcon.centerXAnchor.constraint(equalTo: safeIconContainer.centerXAnchor),
            contactIcon.centerYAnchor.constraint(equalTo: safeIconContainer.centerYAnchor),
            contactIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            contactIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_40),
            
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
    
    private func addContactRequestViewListeners() {
        phoneContactRequestViewModel.connectButtonProcessType.bind { (requestType) in
            self.setConnectButtonBusiness(type: requestType)
        }
    }
    
    @objc func startGettingContactFriends(_ sender : UIButton) {
        
        switch phoneContactRequestViewModel.connectButtonProcessType.value {
        case .enableSettings:
            ContactListManager.shared.directToSettingsForEnableContactAccess()
        case .fetchContact:
            phoneContactRequestViewModel.connectButtonProcess.value = true
            return
        }
        
    }
    
    private func setConnectButtonBusiness(type : ContactRequestType) {
        connectButtonBusiness = type
        
        switch type {
        case .enableSettings:
            connectButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.enableAccessContacts, for: .normal)
            
        case .fetchContact:
            connectButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.connectToContacts, for: .normal)
        }
    }
    
    private func decideConnectButtonBusiness() {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .notDetermined:
            self.phoneContactRequestViewModel.connectButtonProcessType.value = .fetchContact
        case .restricted, .denied:
            self.phoneContactRequestViewModel.connectButtonProcessType.value = .enableSettings
        }
    }
    
    func listenConnectButtonProcess(completion: @escaping(_ pressed: Bool) -> Void) {
        phoneContactRequestViewModel.connectButtonProcess.bind(completion)
    }
    
}
