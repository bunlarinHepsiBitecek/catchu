//
//  ContainerGroupViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ContainerGroupViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    // parent view controller object to update value from container view controller to contact view on contact view controller
    var parentReferenceContactViewController : ContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContainerGroupViewController  viewDidLoad")
        print("ContainerGroupViewController starts")
        
        SectionBasedGroup.shared.createInitialLetterBasedGroupDictionary()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ContainerGroupViewController viewWillAppear")
    }
    
    func deneme() {
        
        print("GAGAGAGAGAGAGAGAGAGAGGAGA")
        
    }
    
}
