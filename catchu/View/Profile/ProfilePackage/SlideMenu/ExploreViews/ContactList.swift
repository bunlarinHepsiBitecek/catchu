//
//  ContactList.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ContactList: UIView {
    
    var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ContactList {
    
    func initializeView() {
        
        addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
}
