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
        let view = FeedView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let safeLayout = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.feedView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            self.feedView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            self.feedView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.feedView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
    }
}
