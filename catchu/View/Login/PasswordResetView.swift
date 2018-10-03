//
//  PasswordResetView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import Firebase

class PasswordResetView: BaseView {
    
    let padding = Constants.Login.Padding
    let height = Constants.Login.Height
    
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
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Login.Reset.uppercased(with: NSLocale.current), for: UIControlState.normal)
        
        button.backgroundColor = UIColor.groupTableViewBackground
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, resetButton])
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func setupView() {
        
        self.addSubview(stackView)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 200),
            stackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 2 * height + stackView.spacing)
            ])
        
    }
    
    @objc func resetPassword(_ sender: UIButton) {
        self.resetPassword()
        
    }
}

extension PasswordResetView {
    
    func resetPassword() {
        
        guard validateRequiredFields() else {
            return
        }
        guard let email = emailTextField.text else { return }
        
        LoaderController.shared.showLoader()
        
        let actionCodeSetting = ActionCodeSettings.init()
        
        actionCodeSetting.url = URL(string: String(format: "passwordReset://catchu-594ca.firebaseapp.com?email=%@", email))
        
        actionCodeSetting.setIOSBundleID("com.uren.catchu")
        
        Auth.auth().sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSetting) { (error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    if let firebaseErrorCode = Firebase.AuthErrorCode(rawValue: errorCode.code) {
                        
                        print("firebaseErrorCode :\(firebaseErrorCode)")
                        
                    }
                    
                }
                
            } else {
                
                print("PasswordReset process finished successfully")
                
                LoaderController.shared.removeLoader()
                self.informUserAboutEmailSend()
                
            }
        }
    }
    
    func informUserAboutEmailSend() {
        
        AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Login.ForgotPassword, message: LocalizedConstants.PasswordReset.PasswordResetMailSend, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        
    }
    
    func validateRequiredFields() -> Bool {
        guard let email = emailTextField.text else { return false }
        
        let validateEmailResult = Validation.shared.isValidEmail(email: email)
        
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        return true
        
    }
}

// MARK: control for Foreground
extension PasswordResetView {
    
    func manageForegroundActions() {
        
        print("manageForegroundActions starts")
        let action = #selector(self.backToLoginViewController)
        
        NotificationCenter.default.addObserver(self, selector: action, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    @objc func backToLoginViewController() {
        
        performSegueToReturnBack()
        
    }
    
    func performSegueToReturnBack()  {
        
        if let navigationController = LoaderController.currentNavigationController() {
            
            navigationController.popViewController(animated: true)
            
        } else {
            
            guard let controller = LoaderController.currentViewController() else { return }
            controller.dismiss(animated: true, completion: nil)
            
        }
    }
}


// MARK: Keyboard Setting
extension PasswordResetView: UITextFieldDelegate {
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
