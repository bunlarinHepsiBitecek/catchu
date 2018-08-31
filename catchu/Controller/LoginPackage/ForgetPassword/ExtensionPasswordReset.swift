//
//  ExtensionPasswordReset.swift
//  catchu
//
//  Created by Erkut Baş on 5/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Firebase

extension PasswordResetViewController {
    
    func manageForegroundActions() {
        
        print("manageForegroundActions starts")
        let action = #selector(backToLoginViewController)
        
        NotificationCenter.default.addObserver(self, selector: action, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    @objc func backToLoginViewController() {
        
        performSegueToReturnBack()
        
    }
    
    func performSegueToReturnBack()  {
        
        if let navigation = self.navigationController {
            
            navigation.popViewController(animated: true)
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func resetPasswordWithEmail(email: String) {
        
        guard validateRequiredFields() else {
            return
        }
        
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
    
}

// validation manager
extension PasswordResetViewController {
    
    func validateRequiredFields() -> Bool {
        
        let validateEmailResult = Validation.shared.isValidEmail(email: emailTextField.text!)
        
        if !validateEmailResult.isValid {
            AlertViewManager.shared.createAlert(title: validateEmailResult.title, message: validateEmailResult.message, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            return false
        }
        
        return true
        
    }
    
}
