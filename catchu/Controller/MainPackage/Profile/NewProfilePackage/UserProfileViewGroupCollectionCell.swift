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
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        return imageView
    }()
    
    lazy var groupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Connection Error"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
//    lazy var blurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//
//        blurView.contentView.addSubview(groupTitleLabel)
//        NSLayoutConstraint.activate([
//            groupTitleLabel.safeTopAnchor.constraint(equalTo: blurView.contentView.safeTopAnchor),
//            groupTitleLabel.safeBottomAnchor.constraint(equalTo: blurView.contentView.safeBottomAnchor),
//            groupTitleLabel.safeLeadingAnchor.constraint(equalTo: blurView.contentView.safeLeadingAnchor),
//            groupTitleLabel.safeTrailingAnchor.constraint(equalTo: blurView.contentView.safeTrailingAnchor)
//            ])
//
//        return blurView
//    }()
    
    lazy var blurView: UIVisualEffectView = {
        // create blurView
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.contentView.addSubview(groupTitleLabel)
        NSLayoutConstraint.activate([
            groupTitleLabel.safeTopAnchor.constraint(equalTo: blurView.contentView.safeTopAnchor),
            groupTitleLabel.safeBottomAnchor.constraint(equalTo: blurView.contentView.safeBottomAnchor),
            groupTitleLabel.safeLeadingAnchor.constraint(equalTo: blurView.contentView.safeLeadingAnchor),
            groupTitleLabel.safeTrailingAnchor.constraint(equalTo: blurView.contentView.safeTrailingAnchor),
            ])
        
        return blurView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        profileImageView.backgroundColor = UIColor.lightGray
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(profileImageView)
        profileImageView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            profileImageView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            profileImageView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            profileImageView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            profileImageView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            profileImageView.safeWidthAnchor.constraint(equalToConstant: contentView.frame.width),
            profileImageView.safeHeightAnchor.constraint(equalToConstant: contentView.frame.height),
            
            
            blurView.safeBottomAnchor.constraint(equalTo: profileImageView.safeBottomAnchor),
            blurView.safeLeadingAnchor.constraint(equalTo: profileImageView.safeLeadingAnchor),
            blurView.safeTrailingAnchor.constraint(equalTo: profileImageView.safeTrailingAnchor),
            blurView.safeHeightAnchor.constraint(equalTo: profileImageView.safeHeightAnchor, multiplier: 0.2),
            ])
    }
    
    func configure(item: Group) {
        if let groupPictureUrl = item.groupPictureUrl, !groupPictureUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            profileImageView.loadAndCacheImage(url: groupPictureUrl)
        } else {
            if let name = item.groupName {
                profileImageView.setImageInitialPlaceholder(name, circular: false)
            }
        }
        groupTitleLabel.text = item.groupName
    }
}
