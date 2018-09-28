//
//  FeedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    // MARK: outlets
    
    lazy var feedView: FeedView = {
        let view = FeedView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // yeniden Firebase authentication için kapattık
//        AWSManager.shared.startUserAuthenticationProcess(navigationController: self.navigationController!)
        
//        AWSManager.shared.showSignInView(navigationController: self.navigationController!)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !FirebaseManager.shared.checkUserLoggedIn() {
            
            if let destination = UIStoryboard.init(name: Constants.Storyboard.Name.Login, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.ID.LoginViewController) as? LoginViewController {
                
                self.present(destination, animated: true, completion: nil)
                
            }
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews() {

        self.view.addSubview(self.feedView)
        let safeLayout = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.feedView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            self.feedView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            self.feedView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.feedView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
        
        pushDummyComment()
    }
    
    func pushDummyComment() {
//        let
//
//        let commentViewController = CommentViewController()
//        commentViewController.commentView.dataSource.post = post
//        LoaderController.pushViewController(controller: commentViewController)
    }
    
}
