//
//  UserProfileViewPostCollectionCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewPostCollectionCell: BaseCollectionCell, ConfigurableCell {
    
    var viewModel: FeedViewModelItemPost!
    
    private let dimension = 80
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = nil
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            imageView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            imageView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            imageView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            imageView.safeWidthAnchor.constraint(equalToConstant: contentView.frame.width),
            imageView.safeHeightAnchor.constraint(equalToConstant: contentView.frame.height),
            ])
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModel = viewModelItem as? FeedViewModelItemPost else { return }
        self.viewModel = viewModel
        
        guard let post = viewModel.post else { return }
//        guard let user = post.user else { return }
        
        if let attachements = post.attachments, let mediaFirst = attachements.first {
            if let url = mediaFirst.url {
                imageView.loadAndCacheImage(url: url)
            } else {
                // show text
            }
        }
    }
}

