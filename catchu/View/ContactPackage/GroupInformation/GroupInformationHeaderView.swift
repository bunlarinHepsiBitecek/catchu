//
//  GroupInformationHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 8/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInformationHeaderView: UIView {

    @IBOutlet var groupName: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    func initialize() {
        
        groupName.text = Group.shared.groupName
        
        setupGestureRecognizerForView()
        
        
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        
        
    }
}

extension GroupInformationHeaderView : UIGestureRecognizerDelegate {
    
    func setupGestureRecognizerForView() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupInformationHeaderView.action(_:)))
        
        isUserInteractionEnabled = true
        tapGestureRecognizer.delegate = self
        
        addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func action(_ sender : UITapGestureRecognizer) {
        
        print("do something")
        
    }
    
    
}
