//
//  LoginViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginView: LoginView = {
        let view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        let safeLayout = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            loginView.safeTopAnchor.constraint(equalTo: safeLayout.topAnchor),
            loginView.safeBottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            loginView.safeLeadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            loginView.safeTrailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
    }

}
