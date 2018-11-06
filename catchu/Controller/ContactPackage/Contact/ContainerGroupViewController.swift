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
    
    var selectedGroupIndexPath : IndexPath = IndexPath()
    
    /// refresh control for tableView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ParticipantListView.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContainerGroupViewController  viewDidLoad")
        print("ContainerGroupViewController starts")
        
        SectionBasedGroup.shared.groupNameInitialBasedDictionary.removeAll()
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
    
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        guard let userid = User.shared.userid else { return }
//
//        API
//
//
//        APIGatewayManager.shared.getUserFriendList(userid: userid) { (friendList, response) in
//
//            if response {
//
//                User.shared.userFriendList.removeAll()
//
//                User.shared.appendElementIntoFriendListAWS(httpResult: friendList)
//
//                SectionBasedParticipant.sharedParticipant = SectionBasedParticipant()
//
//                SectionBasedParticipant.sharedParticipant.emptyIfUserSelectedDictionary()
//                SectionBasedParticipant.sharedParticipant.createInitialLetterBasedFriendDictionary()
//
//                DispatchQueue.main.async {
//
//                    self.setCollectionViewProperties()
//                    self.setSelectedParticipantLabel()
//                    self.collectionView.reloadData()
//                    self.tableView.reloadData()
//
//                    self.searchBar.text = Constants.CharacterConstants.SPACE
//                    self.searchBar.showsCancelButton = false
//
//                    self.searchBar.endEditing(true)
//
//                    refreshControl.endRefreshing()
//
//                }
//
//            }
//
//        }
//
//        //        self.tableView.reloadData()
//        //        refreshControl.endRefreshing()
//    }
    
}
