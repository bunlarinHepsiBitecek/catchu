//
//  ExplorePeopleViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExplorePeopleViewController: UIViewController {

    private var searchController = UISearchController(searchResultsController: nil)
    
    private var exploreView : ExploreView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewDidLoadOperations()
        
    }
    
}

// MARK: - major functions
extension ExplorePeopleViewController {
    
    func prepareViewDidLoadOperations() {
        
        setViewControllerSettings()
        addViews()
        addSearchController()
        
    }
    
    func addViews() {
        
        exploreView = ExploreView()
        exploreView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(exploreView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            exploreView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            exploreView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            exploreView!.topAnchor.constraint(equalTo: safe.topAnchor),
            exploreView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func addSearchController()  {
        
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
        
    }
    
    func setViewControllerSettings() {
        
        self.title = LocalizedConstants.SlideMenu.explorePeople
        
    }
    
}

// MARK: - UISearchResultsUpdating
extension ExplorePeopleViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults starts")
    }
    
    
}
