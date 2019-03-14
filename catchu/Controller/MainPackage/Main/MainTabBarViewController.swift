//
//  MainTabBarViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MainTabBarViewController: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        viewDidLoadOperations()
        tabBarConfigurations()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        
        let homeViewController = HomeViewController()
        let postViewController = PostViewController()
        let userProfileViewController = UserProfileViewController()
        
        homeViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "home"), tag: 0)
        postViewController.tabBarItem = UITabBarItem(title: "Share", image: UIImage(named: "home"), tag: 1)
        userProfileViewController.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "home"), tag: 2)
        
        viewControllers = [BaseNavigationController(rootViewController: homeViewController), postViewController, BaseNavigationController(rootViewController: userProfileViewController)]
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: PostViewController.self) {
            
            let viewController = PostViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.view.backgroundColor = .white
            self.present(viewController, animated: true, completion: nil)
            return false
            
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
