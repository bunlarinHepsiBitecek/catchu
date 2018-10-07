//
//  LoginView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class LoginView: BaseView {
    
    let padding = Constants.Login.Padding
    let height = Constants.Login.Height
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.text = Constants.CATCHU
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = LocalizedConstants.Login.Email
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = LocalizedConstants.Login.Password
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.Login.uppercased(with: NSLocale.current), for: UIControlState.normal)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginWithFirebase(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.ForgotPassword, for: UIControlState.normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPassword(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var facebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "icon-like"), for: UIControlState())
        button.setTitle("Facebook", for: UIControlState.normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginWithFacebook(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var twitterLoginButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "icon-like"), for: UIControlState())
        button.setTitle("Twitter", for: UIControlState.normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginWithTwitter(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var socialStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [facebookLoginButton, twitterLoginButton])
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.Register, for: UIControlState.normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(register(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var registerStackView: UIStackView = {
        let dontHaveAccountLabel = UILabel()
        dontHaveAccountLabel.font = UIFont.systemFont(ofSize: 14)
        dontHaveAccountLabel.numberOfLines = 1
        dontHaveAccountLabel.text = LocalizedConstants.Login.DontHaveAccount
        dontHaveAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [dontHaveAccountLabel, registerButton])
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.spacing = 5
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupView() {
        
        let loginStackViewHeight = CGFloat(loginStackView.subviews.count) * height + loginStackView.spacing
        
        self.addSubview(titleLable)
        self.addSubview(loginStackView)
        self.addSubview(socialStackView)
        self.addSubview(forgotPasswordButton)
        self.addSubview(registerStackView)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 100),
            titleLable.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            
            loginStackView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 100),
            loginStackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
            loginStackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
            loginStackView.heightAnchor.constraint(equalToConstant: loginStackViewHeight),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: padding),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: height),
            
            socialStackView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: padding),
            socialStackView.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            
            registerStackView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -padding),
            registerStackView.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            ])
    }
}

extension LoginView {
    
    @objc func loginWithFacebook(_ sender: UIButton) {
        FirebaseManager.shared.loginWithFacebookAccount()
    }
    
    @objc func loginWithTwitter(_ sender: UIButton) {
        FirebaseManager.shared.loginWithTwitterAccount()
    }
    
    @objc func loginWithFirebase(_ sender: UIButton) {
        guard validateRequiredField() else { return }

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let user = User(email: email, password: password)
        

        FirebaseManager.shared.loginFirebase(user: user)
    }
    
    func validateRequiredField() -> Bool {
        guard let email = emailTextField.text else { return false }
        guard let password = passwordTextField.text else { return false }
        
        // MARK: Email validation
        let validateEmailResult = Validation.shared.isValidEmail(email: email)
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        // MARK: Password validation
        let validatePasswordResult = Validation.shared.isValidPassword(password: password)
        if !validatePasswordResult.isValid {
            AlertViewManager.shared.createAlert(title: validatePasswordResult.title, message: validatePasswordResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        return true
    }
    
    @objc func forgotPassword(_ sender: UIButton) {
        LoaderController.pushViewController(controller: PasswordResetViewController())
    }
    
    @objc func register(_ sender: UIButton) {
        LoaderController.pushViewController(controller: RegisterViewController())
    }
}

// MARK: Keyboard Setting
extension LoginView: UITextFieldDelegate {
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
