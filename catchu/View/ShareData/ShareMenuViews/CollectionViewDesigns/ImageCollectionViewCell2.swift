//
//  ImageCollectionViewCell2.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewCell2: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let temp = UIView()
        
        /*
        temp.layer.borderWidth = 1
        temp.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.cornerRadius = 5
        temp.layer.shadowOffset = CGSize(width: 0, height: 2)
        temp.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.shadowRadius = 3
        temp.layer.shadowOpacity = 0.6
        temp.translatesAutoresizingMaskIntoConstraints = false*/
        
//        temp.layer.borderWidth = 1
        temp.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var imageView: UIImageView = {
        let temp = UIImageView()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.clipsToBounds = true
//        temp.layer.cornerRadius = 5
        temp.contentMode = .scaleAspectFill
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ImageCollectionViewCell2 {
    
    private func setupViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(imageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: safeContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),
            
            ])
    
    }
    
    func setImage(asset : PHAsset) {
        
        print("setImage starts")
        print("imageView.frame.size : \(imageView.frame.size)")
        
        MediaLibraryManager.shared.imageFrom(asset: asset, size: imageView.frame.size) { (image) in
            
            DispatchQueue.main.async {
                
                self.imageView.image = image
                
            }
            
        }
        
    }
    
}
