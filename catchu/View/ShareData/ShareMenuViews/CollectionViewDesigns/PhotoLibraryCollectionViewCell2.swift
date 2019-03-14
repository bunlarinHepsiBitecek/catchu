//
//  PhotoLibraryCollectionViewCell2.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell2: UICollectionViewCell {
    
    weak var delegate : ImageHandlerProtocol!
    
    lazy var containerView: UIView = {
        
        let temp = UIView()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        temp.layer.cornerRadius = 10
//        temp.layer.shadowOffset = CGSize(width: 0, height: 2)
//        temp.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        temp.layer.shadowRadius = 3
//        temp.layer.shadowOpacity = 0.6
        
        return temp
        
    }()
    
    lazy var imageView: UIImageView = {
        
        let temp = UIImageView()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
//        temp.layer.cornerRadius = 25
        temp.backgroundColor = UIColor.clear
        temp.contentMode = .scaleToFill
        temp.image = UIImage(named: "gallery")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupTapGestureRecognizer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension PhotoLibraryCollectionViewCell2 {
    
    func setupViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(imageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeContainerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            ])
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension PhotoLibraryCollectionViewCell2 : UIGestureRecognizerDelegate {
    
    func setupTapGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoLibraryCollectionViewCell2.openGallery(_:)))
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openGallery(_ sender : UITapGestureRecognizer) {
        
        selectionAnimation()
        
        ImageVideoPickerHandler.shared.delegate = delegate
        ImageVideoPickerHandler.shared.getPictureByGalery()
        
    }
    
    func selectionAnimation() {
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, delay: 0, usingSpringWithDamping: 0.20, initialSpringVelocity: 6.0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            
            self.transform = CGAffineTransform.identity
            
        })
        
        self.layoutIfNeeded()
        
    }
    
}
