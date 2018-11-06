//
//  FinalSelectedImageCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 10/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalSelectedImageCollectionViewCell: UICollectionViewCell {
    
    lazy var selectedImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
//        temp.contentMode = .scaleAspectFit
        temp.contentMode = .scaleAspectFill
//        temp.contentMode = .scaleAspectFit
        
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FinalSelectedImageCollectionViewCell {
    
    func setupCellSettings(image : UIImage) {
        
        selectedImageView.image = image
 
        self.addSubview(selectedImageView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            selectedImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            selectedImageView.topAnchor.constraint(equalTo: safe.topAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
}
