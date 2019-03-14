//
//  InvitedContactTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class InvitedContactTableViewCell: CommonFollowTableViewCell {

    private var invitedContactTableCellViewModel : InvitedContactTableCellViewModel!
    
    override func initializeCellSettings() {
        addViews()
        configureCellSettings()
        configureStackView()
        configureFollowButtonSettings()
    }
    
    override func confirmButtonTapped(_ sender: UIButton) {
        print("\(#function)")
        AlertControllerManager.shared.startActionSheetManager(type: ActionControllerType.inviteContact, operationType: nil, delegate: self, title: nil, user: nil, contactData: invitedContactTableCellViewModel.returnContactData())
    }
    
    override func configureCellSettings() {
        self.selectionStyle = .none
    }
    
}

// MARK: - major functions
extension InvitedContactTableViewCell {
    
    private func addViews() {
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(mainStackView)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeUserImageView = self.userImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            userImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            userImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            userImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1),
            
            mainStackView.leadingAnchor.constraint(equalTo: safeUserImageView.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            mainStackView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10)
            
            ])
        
    }
    
    private func configureStackView() {
        stackViewForProcessButtons.arrangedSubviews[1].isHidden = true
        stackViewForProcessButtons.arrangedSubviews[1].alpha = 0
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        
        guard let contactViewModel = item as? CommonContactViewModel else { return }
        
        invitedContactTableCellViewModel = InvitedContactTableCellViewModel(commonContactViewModel: contactViewModel)
        
        guard let contact = contactViewModel.contact else { return }
        
        self.username.text = contact.givenName
        self.name.text = contact.givenName + " " + contact.middleName + " " + contact.familyName
        self.followButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.invite, for: .normal)
        self.userImageView.setImageInitialPlaceholder(self.name.text!, circular: true)
        
    }
    
    private func configureFollowButtonSettings() {
        self.followButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.followButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.followButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    func listenSelectedPhoneNumber(completion: @escaping(_ phoneNumber: String) -> Void) {
        invitedContactTableCellViewModel.selectedPhone.bind(completion)
    }
    
}

// MARK: - ActionSheetProtocols
extension InvitedContactTableViewCell: ActionSheetProtocols {
    
    func triggerContactInvitationProcess(phoneNumber: String) {
        invitedContactTableCellViewModel.selectedPhone.value = phoneNumber
    }
}
