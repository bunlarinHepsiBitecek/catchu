//
//  PostContentCheckView.swift
//  catchu
//
//  Created by Erkut Baş on 11/21/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostContentCheckView: UIView {

    lazy var iconContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
        
    }()
    
    lazy var iconImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "icon_checked")
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        
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
extension PostContentCheckView {
    
    private func initializeView() {
        
        addViews()
        // without animation, set alpha directly 0
        self.alpha = 0
        
    }
    
    private func addViews() {
        
        self.addSubview(iconContainer)
        self.iconContainer.addSubview(iconImageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeIconContainer = self.iconContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            iconContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            iconContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            iconContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            iconContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: safeIconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: safeIconContainer.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            ])
        
    }
    
    func activationManager(active : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if active {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
        }
        
    }
    
}
