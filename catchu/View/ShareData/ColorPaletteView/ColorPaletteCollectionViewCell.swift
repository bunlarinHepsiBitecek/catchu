//
//  ColorPaletteCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ColorPaletteCollectionViewCell: UICollectionViewCell {
    
    var customColorContainerView : CustomColorContainerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ColorPaletteCollectionViewCell {

    func setupCell(inputColorArray : Array<UIColor>, delegate : ShareDataProtocols) {
        
        if customColorContainerView == nil {
        
            customColorContainerView = CustomColorContainerView(frame: .zero, inputColorArray: inputColorArray)
            customColorContainerView.delegate = delegate
            
            customColorContainerView.translatesAutoresizingMaskIntoConstraints = false

            self.contentView.addSubview(customColorContainerView)

            let safe = self.contentView.safeAreaLayoutGuide

            NSLayoutConstraint.activate([

                customColorContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                customColorContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                customColorContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
                customColorContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)

                ])
        }
        
    }
    
}

