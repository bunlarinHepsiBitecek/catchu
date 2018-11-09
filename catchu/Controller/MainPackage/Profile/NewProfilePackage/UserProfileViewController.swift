//
//  UserProfileViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    private var leftItem = UIImageView(image: UIImage(named: "menu"))
    private var rigthItem = UIImageView(image: UIImage(named: "user_black"))
    
    private var userProfileMainView : UserProfileMainView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
        
        
        
    }
    

}

// MARK: - major functions
extension UserProfileViewController {
    
    func prepareViewController() {
        
        addBarButtons()
        addSwipeGestureRecognizer()
        addUserProfileMainView()
        
    }
    
    func addBarButtons() {
        
        addGestureRecognizersToTopBarItems()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthItem)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func startAnimationForLeftItem() {
        
        leftItem.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.leftItem.transform = CGAffineTransform.identity
                
                
        })
        self.leftItem.layoutIfNeeded()
        
    }
    
    func startAnimationForRigthItem() {
        
        rigthItem.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.rigthItem.transform = CGAffineTransform.identity
                
                
        })
        self.rigthItem.layoutIfNeeded()
        
    }
    
    func addUserProfileMainView() {
        
        userProfileMainView = UserProfileMainView(frame: .zero, delegate: self)
        userProfileMainView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userProfileMainView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userProfileMainView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            userProfileMainView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            userProfileMainView!.topAnchor.constraint(equalTo: safe.topAnchor),
            userProfileMainView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        
    }
    
}

// MARK: - UIGestureRecognizer
extension UserProfileViewController : UIGestureRecognizerDelegate {
    
    func addGestureRecognizersToTopBarItems() {
        
        let tapGestureRecognizerLeftBarItem = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.leftBarItemPressed(_:)))
        tapGestureRecognizerLeftBarItem.delegate = self
        leftItem.addGestureRecognizer(tapGestureRecognizerLeftBarItem)
        
        let tapGestureRecognizerRigthBarItem = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.rightBarItemPressed(_:)))
        tapGestureRecognizerRigthBarItem.delegate = self
        rigthItem.addGestureRecognizer(tapGestureRecognizerRigthBarItem)
        
    }
    
    @objc func rightBarItemPressed(_ sender : UITapGestureRecognizer) {
        
        print("rightBarItemPressed pressed")
        
        startAnimationForRigthItem()
        
    }
    
    @objc func leftBarItemPressed(_ sender : UITapGestureRecognizer) {
        
        print("leftBarItemPressed pressed")
        
        startAnimationForLeftItem()
        
        print("self.navigationController?.viewControllers.count :\(self.navigationController?.viewControllers.count)")
        print("self.navigationController?.viewControllers :\(self.navigationController?.view)")
        print("self.navigationController?.viewControllers.count :\(self.navigationController?.view)")
        
        SlideMenuLoader.shared.animateSlideMenu(active: true)
        
    }
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UserProfileViewController.swipeToClose(_:)))
        swipeGesture.direction = .right
        swipeGesture.delegate = self
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

extension UserProfileViewController : NavigationControllerProtocols {
    
    func setNavigationTitle(input: String) {
//        self.navigationItem.title = input
//        self.navigationController?.title = input
        self.title = input
    }
    
}

