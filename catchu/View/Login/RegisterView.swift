//
//  RegisterView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class RegisterView: BaseView {
    
    let padding = Constants.Login.Padding
    let height = Constants.Login.Height
    
    lazy var usernameTextField: DesignableUITextField = {
        let textField = DesignableUITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeHolderColor = UIColor.lightGray
        textField.placeholder = LocalizedConstants.Login.UserName
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var emailTextField: DesignableUITextField = {
        let textField = DesignableUITextField()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeHolderColor = UIColor.lightGray
        textField.placeholder = LocalizedConstants.Login.Email
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var passwordTextField: DesignableUITextField = {
        let textField = DesignableUITextField()
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeHolderColor = UIColor.lightGray
        textField.placeholder = LocalizedConstants.Login.Password
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.Register.uppercased(with: NSLocale.current), for: UIControlState.normal)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerUser(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, registerButton])
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupView() {
        let stackViewHeight = CGFloat(stackView.subviews.count) * height + stackView.spacing
        
        self.addSubview(stackView)
        
        let safeLayout = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 200),
            stackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
            ])
    }
}

extension RegisterView {
    
    @objc func registerUser(_ sender: UIButton) {
        
        guard validateRequiredFields() else { return }
        
        FirebaseManager.shared.registerFirebase(user: User.shared)
    }
    
    func validateRequiredFields() -> Bool {
        
        guard let username = usernameTextField.text else { return false }
        guard let email = emailTextField.text else { return false }
        guard let password = passwordTextField.text else { return false }
        
        let validateUserNameResult = Validation.shared.isUserNameValid(userName: username)
        
        if !validateUserNameResult.isValid {
            AlertViewManager.shared.createAlert(title: validateUserNameResult.title, message: validateUserNameResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        let validateEmailResult = Validation.shared.isValidEmail(email: email)
        
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        let validatePasswordResult = Validation.shared.isValidPassword(password: password)
        
        if !validatePasswordResult.isValid {
            AlertViewManager.shared.createAlert(title: validatePasswordResult.title, message: validatePasswordResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        // MARK: set user info
        User.shared.userName = username
        User.shared.email = email
        User.shared.password = password
        
        return true
    }
    
    /// After successfully register
    func goToConfirmation() {
        let confirmationViewController = ConfirmationViewController()
        LoaderController.pushViewController(controller: confirmationViewController)
    }
}

// MARK: Keyboard Setting
extension RegisterView: UITextFieldDelegate {
    // to close keyboard when touches somewhere else but keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // to close keyboard when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
