//
//  ExtensionSearchViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension SearchViewController {
    
    func prepareViewLoadProcess() {
        
        //self.searchProgressActive = false
        
        addSubViewIntoSafeArea()
        
    }
    
    func addSubViewIntoSafeArea() {
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(searchView)
        searchView.initializeView()
        
        searchView.heightAnchor.constraint(equalToConstant: 734).isActive = true
        //searchView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        
        let safeGuide = self.view.safeAreaLayoutGuide
        searchView.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        searchView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        searchView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor ).isActive = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        print("yarro yarro yarro")
        print("segue : \(segue.identifier)")
        
        if segue.identifier == Constants.Segue.SegueToSearch {
            
            childReferenceContainerSearchResultViewController = segue.destination as! ContainerSearchResultViewController
            
            childReferenceContainerSearchResultViewController?.parentReferenceSearchViewController = self
            
        }
        
    }
    
    
}
