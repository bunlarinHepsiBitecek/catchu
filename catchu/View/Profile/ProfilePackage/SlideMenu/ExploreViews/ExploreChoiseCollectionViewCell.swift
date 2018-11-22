//
//  ExploreChoiseCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 11/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreChoiseCollectionViewCell: UICollectionViewCell {
    
    lazy var choiseLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.contentMode = .center
        temp.textAlignment = .center
        return temp
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeCellSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            choiseLabel.textColor = isHighlighted ? UIColor.black : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            choiseLabel.textColor = isSelected ? UIColor.black : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
}

// MARK: - major functions
extension ExploreChoiseCollectionViewCell {
    
    func initializeCellSettings() {
        
        addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(choiseLabel)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            choiseLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            choiseLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            choiseLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            choiseLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
            /*
            choiseLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            choiseLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),*/
            
            ])
    }
}
