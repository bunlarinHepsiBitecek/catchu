//
//  DropPinViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DropPinViewController: UIViewController {
    // MARK: outlets
    @IBOutlet var mapShareView: MapShareView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customization() {
        self.view.addSubview(self.mapShareView)
        self.mapShareView.translatesAutoresizingMaskIntoConstraints = false
        let margins = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapShareView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mapShareView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mapShareView.topAnchor.constraint(equalTo: margins.topAnchor),
            mapShareView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
    }
    
}
