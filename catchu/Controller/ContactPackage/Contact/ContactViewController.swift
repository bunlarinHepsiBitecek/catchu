 //
//  ContactViewController.swift
//  catchu
//
//  Created by Erkut Baş on 6/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import FirebaseFunctions

class ContactViewController: UIViewController {

    @IBOutlet var contactView: ContactView!
    
    // let's create a child view controller of container view controller get data from container view controller to main controller view controller
    var childReferenceFriendContainerFriendController : ContainerFriendViewController?
    var childReferenceGroupContainerGroupController : ContainerGroupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactView.referenceMasterViewController = self
        
        prepareViewLoadProcess()
        
        print("------------> \(GeoFireData.shared.geofireDictionary.count)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }

