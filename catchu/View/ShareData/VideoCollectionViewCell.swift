//
//  VideoCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("VideoCollectionViewCell starts")
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        initializeCustomVideoView()
        
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
    
}
