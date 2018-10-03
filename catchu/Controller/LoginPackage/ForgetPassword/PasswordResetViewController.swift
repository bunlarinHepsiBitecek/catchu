//
//  PasswordResetViewController.swift
//  catchu
//
//  Created by Erkut Baş on 5/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    let passwordResetView: PasswordResetView = {
        let view = PasswordResetView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        let safeLayout = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(passwordResetView)
        
        NSLayoutConstraint.activate([
            passwordResetView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            passwordResetView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            passwordResetView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            passwordResetView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
        
    }

}
