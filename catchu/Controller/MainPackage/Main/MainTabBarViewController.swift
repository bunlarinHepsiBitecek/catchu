//
//  MainTabBarViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.selectedIndex = 3
        
        
        
        self.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
        
        self.delegate = self
        
        if let vc = self.selectedViewController as? Profile4ViewController {
            vc.referenceForMainTabBarController = self
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("tabBarController starts")
        print("tabBarController : \(tabBarController.selectedIndex)")
        
        if tabBarController.selectedIndex == 2 {
            
            if let destinationController = UIStoryboard(name: Constants.StoryBoardID.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ShareDataViewController) as? ShareDataViewController {
                
                self.present(destinationController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    
}
