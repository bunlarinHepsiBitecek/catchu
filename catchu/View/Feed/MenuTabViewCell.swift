//
//  MenuTabViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//


class MenuTabViewCell: BaseCollectionCell {
    
    var item: MenuTabViewModelItem?
    
    private let dimension = Constants.Feed.ImageWidthHeight
    
    let iconImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ConstanstViews.PageView.TabView.Font
        label.textColor = ConstanstViews.PageView.TabView.DefaultColor
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            changeColor()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        let cellStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .center
        cellStackView.distribution = .fill
        cellStackView.spacing = 5
        
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor)
            ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = ConstanstViews.PageView.TabView.DefaultColor
        iconImageView.image = nil
        iconImageView.isHidden = true
    }
    
    func configure(item: MenuTabViewModelItem) {
        self.item = item
        self.titleLabel.text = item.title
        self.iconImageView.image = item.icon //?.withRenderingMode(.alwaysTemplate)
        
        self.iconImageView.isHidden = item.icon == nil
        
        changeColor()
    }
    
    func changeColor() {
        titleLabel.textColor = isSelected ? ConstanstViews.PageView.TabView.CurrentColor : ConstanstViews.PageView.TabView.DefaultColor
        iconImageView.tintColor = isSelected ? ConstanstViews.PageView.TabView.CurrentColor : ConstanstViews.PageView.TabView.DefaultColor
    }
    
}
