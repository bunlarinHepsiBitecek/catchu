//
//  Validation.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class Validation: NSObject {
    
    public static let shared = Validation()
    
    static let ConfirmationValidationCount = 6
    
    private func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        return stringTest.evaluate(with: testStr)
    }
    
    // MARK:
    func isUserNameValid(userName: String) -> ValidationResult {
        let title = LocalizedConstants.Register.UserName
        
        if (userName.isEmpty) {
            let message = LocalizedConstants.Register.EmptyUserName
            return ValidationResult(isValid: false, title: title, message: message)
        }
        
        return ValidationResult(isValid: true, title: title, message: Constants.CharacterConstants.SPACE)
    }
    
    // MARK:
    func isValidEmail(email: String) -> ValidationResult {
        let title = LocalizedConstants.Login.Email
        
        if (email.isEmpty) {
            let message = LocalizedConstants.Login.EmptyEmail
            return ValidationResult(isValid: false, title: title, message: message)
        }
        
        if !isValidRegEx(email, .email) {
            let message = LocalizedConstants.Login.InvalidEmail
            return ValidationResult(isValid: false, title: title, message: message)
        }
        
        return ValidationResult(isValid: true, title: title, message: Constants.CharacterConstants.SPACE)
    }
    
    // MARK: 
    func isValidPassword(password: String) -> ValidationResult {
        let title = LocalizedConstants.Login.Password
        
        if (password.isEmpty) {
            let message = LocalizedConstants.Login.EmptyPassword
            return ValidationResult(isValid: false, title: title, message: message)
        }
        
        if !isValidRegEx(password, .password) {
            let message = LocalizedConstants.Login.InvalidPassword
            return ValidationResult(isValid: false, title: title, message: message)
        }
        
        return ValidationResult(isValid: true, title: title, message: Constants.CharacterConstants.SPACE)
    }
    
    func isValidConfirmationCode(confirmationCode: String) -> Bool {
        return confirmationCode.count == Validation.ConfirmationValidationCount && isValidRegEx(confirmationCode, .confirmationCode)
    }
    
}

struct ValidationResult {
    var isValid: Bool
    var title: String
    var message: String
}

enum RegEx: String {
    case userName = ""
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case confirmationCode = "[0-9]{6}"
    
    /*
     https://krijnhoetmer.nl/stuff/regex/cheat-sheet/
     ^    The pattern has to appear at the beginning of a string.
     $    The pattern has to appear at the end of a string.
     .    Matches any character.
     []    Bracket expression. Matches one of any characters enclosed.
     
     ^[a-zA-Z0-9]{8,}$ #8 or more characters
     ^[a-zA-Z0-9]{,16}$ #Less than or equal to 16 characters
     ^[a-zA-Z0-9]{8}$ #Exactly 8 characters
 */
}

