//
//  UserProfileEditHeaderView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

fileprivate extension Selector {
    static let changePhotoAction = #selector(UserProfileEditHeaderView.changePhoto)
}

class UserProfileEditHeaderView: BaseView {
    
    private let padding = Constants.Profile.Padding
    private let dimension = 80
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    
    lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedConstants.Profile.ChangePhoto, for: .normal)
        button.addTarget(self, action: .changePhotoAction, for: .touchUpInside)
        
        return button
    }()
    
    
    override func setupView() {
        super.setupView()
        
        let layoutMargin = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, changePhotoButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = padding
        stackView.layoutMargins = layoutMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            stackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            stackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            stackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            stackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
    }
    
    @objc func changePhoto() {
        print("change photo")
    }
    
}
