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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - major functions
extension MainTabBarViewController {
    
    func viewDidLoadOperations() {
        
        self.delegate = self
        
        FirebaseManager.shared.checkUserLoggedIn()
        SlideMenuLoader.shared.createSlider(inputView: self.view)
        
    }
    
    func addTransitionToPresentationOfShareViews() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
    }
    
    func add_ShareDataViewController2() {
        
        if let destinationController = UIStoryboard(name: Constants.StoryBoardID.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ShareDataViewController2) as? ShareDataViewController2 {
            
            addTransitionToPresentationOfShareViews()
            tabBarHiddenManagement(hidden: true)
            destinationController.delegate = self
            destinationController.priorActiveTab = selectedIndexInfo
            self.present(destinationController, animated: false, completion: nil)
        }
        
    }
    
    func add_PostViewController() {
        
        if let destinationController = UIStoryboard(name: Constants.StoryBoardID.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.PostViewController) as? PostViewController {
            
            addTransitionToPresentationOfShareViews()
            tabBarHiddenManagement(hidden: true)
            destinationController.delegate = self
            destinationController.priorActiveTab = selectedIndexInfo
            self.present(destinationController, animated: false, completion: nil)
        }
        
    }
    
    
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("tabBarController starts")
        print("tabBarController : \(tabBarController.selectedIndex)")
        
        if tabBarController.selectedIndex == 2 {
            
            add_PostViewController()
//            add_ShareDataViewController2()
            
        } else {
            selectedIndexInfo = tabBarController.selectedIndex
        }
        
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
