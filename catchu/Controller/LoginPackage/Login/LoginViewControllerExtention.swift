//
//  LoginViewControllerExtention.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension LoginViewController {
    
    func customization() {
        self.emailText.delegate = self
        self.passwordText.delegate = self
    }

    func localized() {
        emailText.placeHolderTitle(title:  LocalizedConstants.Login.Email)
        passwordText.placeHolderTitle(title: LocalizedConstants.Login.Password)
        loginButton.setTitle(LocalizedConstants.Login.Login, for: .normal)
        
        forgotPasswordButton.setTitle(LocalizedConstants.Login.ForgotPassword, for: .normal)
        registerButton.setTitle(LocalizedConstants.Login.Register, for: .normal)
        dontHaveAccountLabel.text = LocalizedConstants.Login.DontHaveAccount
    }
    
}

// MARK: Validation
extension LoginViewController {
    
    func login() {
        guard validateRequiredField() else {return}
        let user = User(userID: Constants.CharacterConstants.SPACE, userName: Constants.CharacterConstants.SPACE, name: Constants.CharacterConstants.SPACE, email: emailText.text!, password: passwordText.text!, provider: Constants.CharacterConstants.SPACE, providerID: Constants.CharacterConstants.SPACE)
        FirebaseManager.shared.loginUser(user: user)
    }
    
    func loginWithFaceebook() {
        FirebaseManager.shared.loginWithFacebookAccount()
        
    }
    
    func loginWithTwitter() {
        FirebaseManager.shared.loginWithTwitterAccount()
        
    }
    
    func validateRequiredField() -> Bool {
        let validateEmailResult = Validation.shared.isValidEmail(email: emailText.text!)
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        let validatePasswordResult = Validation.shared.isValidPassword(password: passwordText.text!)
        if !validatePasswordResult.isValid {
            AlertViewManager.shared.createAlert(title: validatePasswordResult.title, message: validatePasswordResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        return true
    }
}

// MARK: Keyboard Setting
extension LoginViewController: UITextFieldDelegate {
    // to close keyboard when touches somewhere else but keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // to close keyboard when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: PerformSegue Manager
extension LoginViewController {
    
    func performSegueToRegisterView() {
        performSegue(withIdentifier: Constants.Segue.RegisterView, sender: self)
    }
    
    func performSegueToForgetPassword() {
        performSegue(withIdentifier: Constants.Segue.PasswwordResetView, sender: self)
    }
    
    func pushMainTabBarView() {
        let mainTabBarViewController: UIViewController = self.buildFromStoryboard(Constants.Storyboard.Name.Main, Constants.Storyboard.ID.MainTabBarViewController)
        navigationController?.pushViewController(mainTabBarViewController, animated: true)
    }
    
    private func buildFromStoryboard<T>(_ name: String, _ identifier: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Missing \(identifier) in Storyboard")
        }
        return viewController
    }
    
}

