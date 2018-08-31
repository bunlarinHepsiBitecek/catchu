//
//  EditProfileViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet var editProfile4View: EditProfile4View!
    @IBOutlet var editableProfileView: EditableProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editProfile4View.translatesAutoresizingMaskIntoConstraints = false
        
        editableProfileView.referenceOfViewController = self
        editProfile4View.referenceOfRootView = self
        editProfile4View.initialize()
        editableProfileView.initialize()
        
        self.view.addSubview(editProfile4View)
        
        let safeLayout = self.view.safeAreaLayoutGuide
        
        editProfile4View.topAnchor.constraint(equalTo: safeLayout.topAnchor).isActive = true
        editProfile4View.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor).isActive = true
        editProfile4View.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor).isActive = true
        editProfile4View.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
