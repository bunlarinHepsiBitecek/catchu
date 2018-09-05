//
//  ShareDataViewController.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareDataViewController: UIViewController {

    @IBOutlet var shareDataView: ShareDataView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        setupShareDataView()
        
    }

}

extension ShareDataViewController {
    
    func setupShareDataView() {
        
        shareDataView.translatesAutoresizingMaskIntoConstraints = false
        
        shareDataView.delegate = self
        shareDataView.initialize()
        self.view.addSubview(shareDataView)
        
        let safeAreaLayout = self.view.safeAreaLayoutGuide
        
        shareDataView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareDataView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareDataView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareDataView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
        
    }
    
}

extension ShareDataViewController: ShareDataProtocols {
    func dismisViewController() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
