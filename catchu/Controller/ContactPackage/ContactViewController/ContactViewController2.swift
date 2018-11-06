//
//  ContactViewController2.swift
//  catchu
//
//  Created by Erkut Baş on 11/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ContactViewController2: UIViewController {

    private var topControlView : TopControlView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViewController()
        
    }
    
}

// MARK: - major functions
extension ContactViewController2 {
    
    func initializeViewController() {
        
        topControlView = TopControlView()
        
        topControlView!.translatesAutoresizingMaskIntoConstraints = false
        topControlView!.isUserInteractionEnabled = true
        
        self.view.addSubview(topControlView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            topControlView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            topControlView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            topControlView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            topControlView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])

        
    }
    
}
