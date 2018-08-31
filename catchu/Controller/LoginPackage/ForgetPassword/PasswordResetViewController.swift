//
//  PasswordResetViewController.swift
//  catchu
//
//  Created by Erkut Baş on 5/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageForegroundActions()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordResetClicked(_ sender: Any) {
        
        resetPasswordWithEmail(email: emailTextField.text!)
        
    }

}
