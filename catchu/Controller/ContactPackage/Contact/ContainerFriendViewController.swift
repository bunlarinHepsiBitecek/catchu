//
//  ContainerFriendViewController.swift
//  catchu
//
//  Created by Erkut Baş on 6/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ContainerFriendViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // parent view controller object to update value from container view controller to contact view on contact view controller
    var parentReferenceContactViewController : ContactViewController?
    
    var isCollectionViewOpen : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ContainerFriendViewController starts")
        
        prepareViewDidLoadProcess()
        
        collectionViewHeightConstraint.constant = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func testDeneme() {
        
        print("we did it")
        
    }
    
}
