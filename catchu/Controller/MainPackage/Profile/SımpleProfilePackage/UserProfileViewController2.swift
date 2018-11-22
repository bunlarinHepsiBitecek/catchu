//
//  UserProfileViewController2.swift
//  catchu
//
//  Created by Erkut Baş on 11/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfileViewController2: UIViewController {

    private var userTopView : UserProfileTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear starts")
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear starts")
        self.navigationController?.isNavigationBarHidden = false
    }

}

// MARK: - major functions
extension UserProfileViewController2 {
    
    func prepareViewController() {
        
        addViews()
        addSwipeGestureRecognizer()
        setDelegateToSlideMenuLoader(delegate: self)
        
    }
    
    func addViews() {
        
        userTopView = UserProfileTopView(frame: .zero, delegate: self, delegateOfUserProfile: self)
        userTopView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userTopView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userTopView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            userTopView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            userTopView.topAnchor.constraint(equalTo: safe.topAnchor),
            userTopView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ConstraintValues.constraint_200)
            
            ])
        
    }
    
    func setDelegateToSlideMenuLoader(delegate : ViewPresentationProtocols) {
        SlideMenuLoader.shared.setSlideMenuDelegation(delegate: self)
    }
    
    /* viewController passing */
    func gotoContactViewController() {
        
        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ContactViewController) as? ContactViewController {
            
            self.navigationController?.pushViewController(destination, animated: true)
            
        }
        
    }
    
    func gotoExplorePeopleViewController() {
        
        print("gotoExplorePeopleViewController starts")
        
        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Profile, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ExplorePeopleViewController) as? ExplorePeopleViewController {
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
    }
    /* viewController passing */
    
}

// MARK: - NavigationControllerProtocols
extension UserProfileViewController2 : NavigationControllerProtocols {
    
}

// MARK: - UserProfileViewProtocols
extension UserProfileViewController2 : UserProfileViewProtocols {
    
}

// MARK: - UIGestureRecognizerDelegate
extension UserProfileViewController2 : UIGestureRecognizerDelegate {
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UserProfileViewController2.swipeToClose(_:)))
        swipeGesture.direction = .right
        swipeGesture.delegate = self
        // if you add slide gesture to main view, it conflicts pageviewcontroller scroll functions
        //self.view.addGestureRecognizer(swipeGesture)
        self.view.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeToClose(_ sender : UISwipeGestureRecognizer) {
        
        print("swipeToClose starts")
        
        switch sender.direction {
        case .right:
            SlideMenuLoader.shared.animateSlideMenu(active: true)
            return
        default:
            break
        }
        
    }
    
}

// MARK: - ViewPresentationProtocols
extension UserProfileViewController2 : ViewPresentationProtocols {
    
    func directFromSlideMenu(inputSlideMenuType: SlideMenuViewTags) {
        
        SlideMenuLoader.shared.animateSlideMenu(active: false)
        
        switch inputSlideMenuType {
        case .manageGroupOperations:
            gotoContactViewController()
        case .explore:
            gotoExplorePeopleViewController()
            return
        case .settings:
            return
        case .viewPendingFriendRequests:
            return
        }
        
    }
    
}
