//
//  GroupInfoImageView.swift
//  catchu
//
//  Created by Erkut Baş on 12/14/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoImageView: UIView {

    lazy var topContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    lazy var groupProfileImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "8771.jpg")
        temp.contentMode = .scaleAspectFill
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
extension GroupInfoImageView {
    
    private func initializeView() {
        addViews()
    }
    
    private func addViews() {
        
        self.addSubview(groupProfileImageView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupProfileImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupProfileImageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupProfileImageView.topAnchor.constraint(equalTo: safe.topAnchor),
            groupProfileImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
}
