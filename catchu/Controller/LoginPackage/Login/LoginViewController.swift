//
//  LoginViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var emailText: DesignableUITextField!
    @IBOutlet weak var passwordText: DesignableUITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.customization()
        self.localized()
        
        let navigationController = UINavigationController()
        
        
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        self.login()
    }
    
    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        self.loginWithFaceebook()
        
    }
    
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
        self.loginWithTwitter()
    }
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        self.performSegueToRegisterView()
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {
        self.performSegueToForgetPassword()
    }
    @IBAction func test(_ sender: Any) {
        
        
    }
}

