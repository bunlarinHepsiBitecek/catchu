//
//  PostViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    private var postMainView : PostMainView!
    
    var priorActiveTab : Int!
    weak var delegate : TabBarControlProtocols!
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

// MARK: - major functions
extension PostViewController {
    
    func prepareViewController() {
        
        addViews()
        
    }
    
    func addViews() {
        
        postMainView = PostMainView(frame: .zero, delegate: self)
        postMainView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(postMainView)

        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            postMainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            postMainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            postMainView.topAnchor.constraint(equalTo: safe.topAnchor),
            postMainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    // adding transition for dismissing view controller
    func addTransitionToPresentationOfShareViews() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }

    
    
}

// MARK: - PostViewProtocols
extension PostViewController : PostViewProtocols {
    
    func dismissPostView() {
        
        if let destionation = LoaderController.shared.currentViewController() as? MainTabBarViewController {
            
            destionation.selectedIndex = priorActiveTab
        }
        
        guard delegate != nil else {
            return
        }
        
        addTransitionToPresentationOfShareViews()
        delegate.tabBarHiddenManagement(hidden: false)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
}
