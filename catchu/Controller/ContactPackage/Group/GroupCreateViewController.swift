//
//  GroupCreateViewController.swift
//  catchu
//
//  Created by Erkut Baş on 9/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController {

    @IBOutlet var groupCreateView: GroupCreateView!
    
    var referenceOfContactViewController = ContactViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewSettings()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GroupCreateViewController {
    
    func prepareViewSettings() {
        
        groupCreateView.translatesAutoresizingMaskIntoConstraints = false
        
        groupCreateView.referenceOfGroupCreateViewController = self
        groupCreateView.initialize()
        
        self.view.addSubview(groupCreateView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        groupCreateView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        groupCreateView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        groupCreateView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        groupCreateView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
    }
    
}
