//
//  MenuTabViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//


class MenuTabViewCell: BaseCollectionCell {
    
    var item: MenuTabViewModelItem?
    
    private let dimension: CGFloat = 25
    
    lazy var iconImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        
        // MARK: When use with satackview
        let imageHeightConstraint = imageView.safeHeightAnchor.constraint(equalToConstant: dimension)
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        imageHeightConstraint.isActive = true
        
        let imageWidthConstraint = imageView.safeWidthAnchor.constraint(equalToConstant: dimension)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        imageWidthConstraint.isActive = true
        
        // aspect ratio
        imageView.safeWidthAnchor.constraint(equalTo: imageView.safeHeightAnchor, multiplier: 1).isActive = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ConstanstViews.PageView.TabView.Font
        label.textColor = ConstanstViews.PageView.TabView.DefaultColor
        label.numberOfLines = 1
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            changeColor()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = .clear
        
        let cellStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .center
        cellStackView.distribution = .fill
        cellStackView.spacing = 5
        
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.safeCenterXAnchor.constraint(equalTo: contentView.safeCenterXAnchor),
            cellStackView.safeCenterYAnchor.constraint(equalTo: contentView.safeCenterYAnchor),
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
