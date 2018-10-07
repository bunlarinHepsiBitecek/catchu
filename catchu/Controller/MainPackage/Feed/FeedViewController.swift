//
//  FeedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    lazy var feedView: FeedView = {
        let view = FeedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizedConstants.Feed.CatchU
        
        guard checkLoginAuth() else { return }
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLoginAuth() -> Bool {
        if !FirebaseManager.shared.checkUserLoggedIn() {
            FirebaseManager.shared.redirectSignin()
            return false
        }
        
        return true
    }
    
    func setupViews() {
        self.view.addSubview(self.feedView)

        NSLayoutConstraint.activate([
            feedView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
            feedView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            feedView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            feedView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
            ])
    }
}
