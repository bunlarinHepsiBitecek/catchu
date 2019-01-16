//
//  SearchBarHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 1/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UIView {

    lazy var searchBar: UISearchBar = {
        let temp = UISearchBar()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.placeholder = LocalizedConstants.SearchBar.searchFollower
        temp.delegate = self
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension SearchBarHeaderView {
    
    private func initializeViewSettings() {
        self.addView()
        self.setupSearchBarSettings()
    }
    
    private func addView() {
        self.addSubview(searchBar)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            searchBar.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: safe.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    private func setupSearchBarSettings() {
        searchBar.configureSearchBarSettings()
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchBarHeaderView: UISearchBarDelegate {
    
}

