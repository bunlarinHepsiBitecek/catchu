//
//  FeedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet var feedView: FeedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // yeniden Firebase authentication için kapattık
//        AWSManager.shared.startUserAuthenticationProcess(navigationController: self.navigationController!)
        
        //AWSManager.shared.showSignInView(navigationController: self.navigationController!)
        
//        self.getData()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !FirebaseManager.shared.checkUserLoggedIn() {
            
            if let destination = UIStoryboard.init(name: Constants.Storyboard.Name.Login, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.ID.LoginViewController) as? LoginViewController {
                
                self.present(destination, animated: true, completion: nil)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.view.addSubview(self.feedView)

        self.feedView.translatesAutoresizingMaskIntoConstraints = false
        let safeLayout = self.view.safeAreaLayoutGuide
        
//        let barHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            self.feedView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.feedView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            self.feedView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            self.feedView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor)
            ])
        
    }
    
    func getData() {
        LocationManager.shared.delegete = self
        LocationManager.shared.startUpdateLocation()
    }
    
}

extension FeedViewController: LocationManagerDelegate {
    func didUpdateLocation() {
//        FeedDataSource.shared.loadData()
    }
}


