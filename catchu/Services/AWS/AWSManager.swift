//
//  AWSManager.swift
//  catchu
//
//  Created by Erkut Baş on 7/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AWSAuthUI

class AWSManager {
    
    public static let shared = AWSManager()
    
    func startUserAuthenticationProcess(navigationController : UINavigationController) {
        
        checkUserAuthentication(navigationController: navigationController) { (result) in
            
            if result {
                
                self.getCredentials()
                
            }
            
        }
        
    }
    
    func getCredentials() {
        
        let identityPoolId = "us-east-1:4b70fd39-588a-439a-9241-6f35cb1beeab"
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: identityPoolId)
        
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        
        credentialProvider.getIdentityId().continueWith(block: { (task) -> Any? in
            
            if task.error != nil {
                
                print("task.error : \(task.error?.localizedDescription)")
                
            } else {
                
                print("identity id : \(task.result)")
                
                if let identityID = task.result {
                    
                    User.shared.userID = identityID as String
                    
                }
                
            }
            
            return nil
            
        })
        
    }
    
    func getUserProfileInformation() {
        
        APIGatewayManager.shared.getUserProfileInfo(userid: User.shared.userID) { (userProfileData, result) in
            
            if result {
                
                User.shared.setUserProfileData(httpRequest: userProfileData)
                
            }
            
        }
        
    }
    
    func checkUserAuthentication(navigationController : UINavigationController, completion : @escaping (_ result : Bool) -> Void) {
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            
            AWSAuthUIViewController.presentViewController(with: navigationController, configuration: nil) { (provider, error) in
                
                if error != nil {
                    
                    if let errorCode = error as NSError? {
                        
                        print("errorCode : \(errorCode.code)")
                        print("errorExp : \(errorCode.userInfo)")
                        
                    }
                    
                } else {
                    
                    print("Sign in successfull")
                    
                }
                
                completion(true)
                
            }
            
        } else {
            
            getCredentials()
            
        }
        
    }
    
    
    func showSignInView(navigationController : UINavigationController) {
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            
            AWSAuthUIViewController.presentViewController(with: navigationController, configuration: nil) { (provider, error) in
                
                if error != nil {
                    
                    if let errorCode = error as NSError? {
                        
                        print("errorCode : \(errorCode.code)")
                        print("errorExp : \(errorCode.userInfo)")
                        
                    }
                    
                } else {
                    
                    print("Sign in successfull")
                    
                }
                
            }
            
        }
        
    }
    
    func signOut() {
        
        AWSSignInManager.sharedInstance().logout { (task, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.code)")
                    print("errorExp : \(errorCode.userInfo)")
                    
                }
                
            }
            
        }
        
    }
    
    func goToFeed()  {
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: FeedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        let currentController = self.getCurrentViewController()
        currentController?.present(vc, animated: false, completion: nil)
        
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
}
