//
//  ExplorePeopleViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDynamicLinks

class ExplorePeopleViewController: UIViewController {

    private var searchController = UISearchController(searchResultsController: nil)
    private var exploreView : ExploreView?
    private var messageController : MFMessageComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ExplorePeopleViewController starts")
        
        prepareViewDidLoadOperations()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
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
        
        print("takasi")
        print("self.view.frame : \(self.view.frame)")
        
//        exploreView = ExploreView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 200))
        exploreView = ExploreView(frame: .zero, delegate: self)
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
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        // bunu yazmassak navigation bar içerisinde gelmiyor
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = false
        
    }
    
    func setViewControllerSettings() {
        
//        let navigationBar = navigationController!.navigationBar
//        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationBar.shadowImage = UIImage()
//
//        navigationBar.clipsToBounds = true
        
        self.title = LocalizedConstants.SlideMenu.explorePeople
        
    }
    
}

// MARK: - UISearchResultsUpdating
extension ExplorePeopleViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults starts")
    }
    
}

// MARK: - UserProfileViewProtocols
extension ExplorePeopleViewController : UserProfileViewProtocols {
    
    func presentMessageController(phoneNumber: String) {
        
        print("MFMessageComposeViewController.canSendText() : \(MFMessageComposeViewController.canSendText())")
        
        if MFMessageComposeViewController.canSendText() {
            
            messageController = MFMessageComposeViewController()
            messageController!.body = "https://f2wrp.app.goo.gl/ZEcd"
            messageController!.recipients = [phoneNumber]
            messageController!.delegate = self
            messageController!.messageComposeDelegate = self
            
            self.present(messageController!, animated: true, completion: nil)
        }
        
    }
    
    func showAlertAction(alertController: UIAlertController) {
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

// MARK: - UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate
extension ExplorePeopleViewController : UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print("messageComposeViewController didFinishWith starts")
        
        switch result {
        case .cancelled:
            messageController?.dismiss(animated: true, completion: nil)
            
        case .failed:
            messageController?.dismiss(animated: true, completion: nil)
            
        case .sent:
            messageController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

