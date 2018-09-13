//
//  TextCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("TextCollectionViewCell starts")
        
       
//                initializeCustomVideoView()
        
    }
    
    func initializeCustomVideoView() {
        
        let customView = CustomVideoView()
        
        self.contentView.addSubview(customView)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customView.topAnchor.constraint(equalTo: safe.topAnchor),
            customView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
}

