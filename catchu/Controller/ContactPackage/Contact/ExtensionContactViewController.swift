//
//  ExtensionContactViewController.swift
//  catchu
//
//  Created by Erkut Baş on 6/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension ContactViewController {
    
    func prepareViewLoadProcess() {
        
        //startTableViewDataSourceManagement()
        addSubViewIntoSafeArea()

    }

    func addSubViewIntoSafeArea() {
        
        contactView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contactView)
        contactView.initializeView()
        
        print("contactView heightAnchor : \(contactView.heightAnchor)")
        
        contactView.heightAnchor.constraint(equalToConstant: 734).isActive = true
        //contactView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        
        let safeGuide = self.view.safeAreaLayoutGuide
        contactView.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        contactView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
//        contactView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        contactView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        contactView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor ).isActive = true
        
    }
    
    func startTableViewDataSourceManagement() {
        
        SectionBasedFriend.shared.createInitialLetterBasedFriendDictionary()
        
        print("_friendUsernameInitialBasedDictionary :\(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("prepare prepare prepare prepare")
        
        if segue.identifier == Constants.Segue.SegueToFriend {
            
            childReferenceFriendContainerFriendController = segue.destination as? ContainerFriendViewController
            childReferenceFriendContainerFriendController?.parentReferenceContactViewController = self
            
        } else if segue.identifier == Constants.Segue.SegueToGroup {
            
            print("Group is activated")
            
            childReferenceGroupContainerGroupController = segue.destination as? ContainerGroupViewController
            childReferenceGroupContainerGroupController?.parentReferenceContactViewController = self
        }
        
    }
    
}
