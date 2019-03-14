//
//  MainTabBarViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var selectedIndexInfo : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadOperations()
        tabBarConfigurations()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - major functions
extension MainTabBarViewController {
    
    private func viewDidLoadOperations() {
        self.delegate = self
        
        let _ = FirebaseManager.shared.checkUserLoggedIn()
        SlideMenuLoader.shared.createSlider(inputView: self.view)
        InformerLoader.shared.createPostResult(inputView: self.view)
        
        FirebaseManager.getUserShortInfo()
    }
    
    private func tabBarConfigurations() {
        self.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        if let array = tabBar.items {
            for item in array {
                item.title = nil
                item.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
            }
        }
        
    }
    
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("tabBarController starts")
        print("tabBarController : \(tabBarController.selectedIndex)")
        
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: PostViewController.self) {
            
            if let destinationController = UIStoryboard(name: Constants.StoryBoardID.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.PostViewController) as? PostViewController {
                
                destinationController.modalPresentationStyle = .fullScreen
                
                self.present(destinationController, animated: true, completion: nil)
                return false
            }
            
        }
        return true
    }
    
}

// MARK: - TabBarControlProtocols
extension MainTabBarViewController : TabBarControlProtocols {
    
    func tabBarHiddenManagement(hidden: Bool) {
        if hidden {
            self.tabBar.isHidden = true
        } else {
            self.tabBar.isHidden = false
        }
    }
    
}
