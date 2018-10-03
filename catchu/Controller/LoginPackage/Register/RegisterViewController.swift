//
//  RegisterViewController.swift
//  catchu
//
//  Created by Erkut Baş on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let registerView: RegisterView = {
        let view = RegisterView(frame: .zero)
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
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        let safeLayout = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(registerView)
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
    }
}
