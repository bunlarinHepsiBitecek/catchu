//
//  MenuTabViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//


class MenuTabViewCell: BaseCollectionCell {
    
    var item: MenuTabViewModelItem?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ConstanstViews.PageView.TabView.Font
        label.textColor = ConstanstViews.PageView.TabView.DefaultColor
        label.numberOfLines = 1
        label.textAlignment = .center

        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? ConstanstViews.PageView.TabView.CurrentColor : ConstanstViews.PageView.TabView.DefaultColor
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        let cellStackView = UIStackView(arrangedSubviews: [titleLabel])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor)
            ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = ConstanstViews.PageView.TabView.DefaultColor
    }
    
    func configure(item: MenuTabViewModelItem) {
        self.item = item
        self.titleLabel.text = item.title
    }
    
}
