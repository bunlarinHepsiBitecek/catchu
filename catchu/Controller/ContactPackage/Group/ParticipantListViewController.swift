//
//  ParticipantListViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ParticipantListViewController: UIViewController {
    
    @IBOutlet var participantListView: ParticipantListView!
    
    var referenceOfGroupInformationView = GroupInformationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupParticipantListView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TTTTT() {
        
        print("TTTTTTTTTTTTTTTTTTTt")
        
    }
    

}

extension ParticipantListViewController {
    
    func setupParticipantListView() {
        
        self.participantListView.translatesAutoresizingMaskIntoConstraints = false
        
        self.participantListView.referenceOfParticipantListViewController = self
        self.participantListView.initialize()
        
        self.view.addSubview(participantListView)
        
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        
        participantListView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        participantListView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor).isActive = true
        participantListView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor).isActive = true
        participantListView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor).isActive = true
        
    }
    
}
