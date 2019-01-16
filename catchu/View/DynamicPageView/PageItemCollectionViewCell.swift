//
//  PageItemCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/12/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PageItemCollectionViewCell: CommonPageItemCell {
    
    override func initializeView() {
        self.addViews()
    }
    
}

// MARK: - major functions
extension PageItemCollectionViewCell {
    
    private func addViews() {
        self.contentView.addSubview(pageItemStackView)
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            pageItemStackView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            pageItemStackView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
    }
    
    func configureCell(pageItem: PageItems) {
        
        self.pageTitle.text = pageItem.title
        self.pageSubTitle.text = pageItem.subTitle
        
    }
    
}
