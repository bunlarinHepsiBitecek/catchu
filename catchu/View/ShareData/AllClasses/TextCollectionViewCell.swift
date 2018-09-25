//
//  TextCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("TextCollectionViewCell starts")
        
        let customColorPalette = ColorPaletteView()
        
        self.addSubview(customColorPalette)
        
        customColorPalette.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customColorPalette.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customColorPalette.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customColorPalette.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            customColorPalette.heightAnchor.constraint(equalToConstant: 50)
            
            ])
        
        
    }
    
    
}

