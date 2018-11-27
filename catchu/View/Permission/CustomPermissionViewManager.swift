//
//  CustomPermissionViewController.swift
//  catchu
//
//  Created by Erkut Baş on 9/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomPermissionViewManager: UIView {
    
    public static var shared = CustomPermissionViewManager()
    
    var customPermissionView : CustomPermissionView?
    
    func createAuthorizationView(inputView : UIView, permissionType : PermissionFLows, delegate: PermissionProtocol) {
        
        print("createAuthorizationView starts")
        
        customPermissionView = CustomPermissionView(inputPermissionType: permissionType)
        
        guard let customPermissionView = customPermissionView else { return }
        
        customPermissionView.delegate = delegate
        
        customPermissionView.translatesAutoresizingMaskIntoConstraints = false
        
        UIView.transition(with: inputView, duration: Constants.AnimationValues.aminationTime_07, options: .transitionCrossDissolve, animations: {
            
            inputView.addSubview(customPermissionView)
            
            let safe = inputView.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                customPermissionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                customPermissionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                customPermissionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
                customPermissionView.topAnchor.constraint(equalTo: safe.topAnchor)
                
                ])
            
        })
        
    }
    
}

