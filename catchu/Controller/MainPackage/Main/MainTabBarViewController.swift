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
        
        let _ = FirebaseManager.shared.checkUserLoggedIn()
        SlideMenuLoader.shared.createSlider(inputView: self.view)
        InformerLoader.shared.createPostResult(inputView: self.view)
        
    }
    
    func addTransitionToPresentationOfShareViews() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionFade
        //transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
    }
    
    func add_PostViewController() {
        
        if let destinationController = UIStoryboard(name: Constants.StoryBoardID.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.PostViewController) as? PostViewController {
            
            addTransitionToPresentationOfShareViews()
            tabBarHiddenManagement(hidden: true)
            
            self.present(destinationController, animated: false, completion: nil)
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
