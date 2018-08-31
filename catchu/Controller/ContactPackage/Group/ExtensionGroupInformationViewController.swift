//
//  ExtensionGroupInformationViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension GroupInformationViewController {
    
    func setupGroupInformationView() {
        
        self.groupInformationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.groupInformationView.group = self.group
        self.groupInformationView.referenceViewController = self
        self.groupInformationView.initialize()
        self.view.addSubview(groupInformationView)
        
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        
        groupInformationView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        groupInformationView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor).isActive = true
        groupInformationView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor).isActive = true
        groupInformationView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor).isActive = true
        
    }
    
}
