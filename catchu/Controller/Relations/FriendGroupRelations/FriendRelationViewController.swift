//
//  FriendRelationViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationViewController: UIViewController {
    
    private var friendRelationView : FriendGroupRelationView!
    var friendRelationChoise : FriendRelationViewChoise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
}

// MARK: - major functions
extension FriendRelationViewController {
    
    func setupViews() {
        
        viewConfiguration()
        addViews()
        
    }
    
    func viewConfiguration() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        
    }
    
    func addViews() {
        
        addFriendRelationView()
    }
    
    func addFriendRelationView() {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        friendRelationView = FriendGroupRelationView(frame: .zero, delegate: self, friendRelationChoise: friendRelationChoise)
        
        friendRelationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(friendRelationView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            friendRelationView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendRelationView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendRelationView.topAnchor.constraint(equalTo: safe.topAnchor),
            friendRelationView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func addTransitionToPresentationOfFriendRelationViewController() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
}

// MARK: - ViewPresentationProtocols
extension FriendRelationViewController: ViewPresentationProtocols {

    func dismissViewController() {
        addTransitionToPresentationOfFriendRelationViewController()
        self.dismiss(animated: false) {
            print("controller dismissed")
        }
    }
    
}

