//
//  ConfirmationView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class ConfirmationView: BaseView {
    
    var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = LocalizedConstants.Login.UserName
        textField.isUserInteractionEnabled = false
//        textField.isEnabled = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var confirmationCodeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = LocalizedConstants.Login.ConfirmationCode
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var resendConfirmationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.ResendConfirmationCode.uppercased(with: NSLocale.current), for: UIControl.State.normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resendConfirmation(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func setupView() {
        self.addSubview(confirmationCodeTextField)
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            confirmationCodeTextField.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 300),
            confirmationCodeTextField.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            confirmationCodeTextField.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            ])
    }
}

extension ConfirmationView {
    
    @objc func resendConfirmation(_ sender: UIButton) {
        
    }
}
