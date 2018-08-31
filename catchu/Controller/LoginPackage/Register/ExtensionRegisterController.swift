//
//  ExtensionRegisterController.swift
//  catchu
//
//  Created by Erkut Baş on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions

extension RegisterViewController {
    
    func registerUser() {
        
        guard validateRequiredFields() else {
            
            return
        }
        
        FirebaseManager.shared.registerFirebase(user: User.shared)
        
    }
    
}

// validation manager
extension RegisterViewController {
    
    func validateRequiredFields() -> Bool {
        
        let validateUserNameResult = Validation.shared.isUserNameValid(userName: userNameTextField.text!)
        
        if !validateUserNameResult.isValid {
            AlertViewManager.shared.createAlert(title: validateUserNameResult.title, message: validateUserNameResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        } else {
            
            if let userName = userNameTextField.text as String? {
                User.shared.userName = userName
            }
        }
        
        let validateEmailResult = Validation.shared.isValidEmail(email: emailTextField.text!)
        
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        } else {
            
            if let email = emailTextField.text {
                User.shared.email = email
            }
            
        }
        
        let validatePasswordResult = Validation.shared.isValidPassword(password: passwordTextField.text!)
        
        if !validatePasswordResult.isValid {
            AlertViewManager.shared.createAlert(title: validatePasswordResult.title, message: validatePasswordResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        } else {
            
            if let password = passwordTextField.text {
                User.shared.password = password
            }
            
        }
        
        return true
        
    }
    
}




















