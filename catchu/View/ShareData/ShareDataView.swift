//
//  ShareDataView.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareDataView: UIView {

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var topBarView: UIView!
    
    weak var delegate : ShareDataProtocols!
    
    func initialize() {
        
        setupTopBarSettings()
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        delegate.dismisViewController()
        
    }
}

extension ShareDataView {
    
    func setupTopBarSettings() {
        
        topBarView.layer.cornerRadius = 10
        
        setupTopBarObjectSettings()
        
    }
    
    func setupTopBarObjectSettings() {
        
        cancelButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        
    }
    
}
