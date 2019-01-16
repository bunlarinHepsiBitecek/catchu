//
//  UserProfileViewGroupCollectionCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewGroupCollectionCell: BaseCollectionCell {
    
    private let dimension = 80
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = nil
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        profileImageView.backgroundColor = UIColor.lightGray
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            profileImageView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            profileImageView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            profileImageView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            profileImageView.safeWidthAnchor.constraint(equalToConstant: contentView.frame.width),
            profileImageView.safeHeightAnchor.constraint(equalToConstant: contentView.frame.height),
            ])
    }
    
    func configure(item: Group) {
        if let groupPictureUrl = item.groupPictureUrl {
            profileImageView.loadAndCacheImage(url: groupPictureUrl)
        } else {
            if let name = item.groupName {
                profileImageView.setImageInitialPlaceholder(name, circular: false)
            }
        }
    }
}
