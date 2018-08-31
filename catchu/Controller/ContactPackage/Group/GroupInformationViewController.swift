//
//  GroupInformationViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInformationViewController: UIViewController {

    @IBOutlet var groupInformationView: GroupInformationView!
    @IBOutlet var groupInformationHeaderView: GroupInformationHeaderView!
    
    var referenceOfContainerGroupViewController = ContainerGroupViewController()
    
    var group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGroupInformationView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
