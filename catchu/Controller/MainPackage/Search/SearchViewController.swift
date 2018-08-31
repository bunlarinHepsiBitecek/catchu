//
//  SearchViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchView: SearchView!
    
    // let's create a child view controller of container view controller get data from container view controller to main controller view controller
    var childReferenceContainerSearchResultViewController : ContainerSearchResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.referenceMasterViewController = self

        prepareViewLoadProcess()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        
    }
    


}
