//
//  SearchBarHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 1/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UIView {

    private var searchHeaderViewModel = SearchHeaderViewModel()
    
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
    
    func getSearchActions(completion : @escaping (_ searchTool: SearchTools) -> Void) {
        searchHeaderViewModel.searchTool.bind(completion)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchBarHeaderView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(#function)")
        
        if let text = searchBar.text {
            if !text.isEmpty {
                searchHeaderViewModel.searchTool.value = SearchTools(searchText: text, searchIsProgress: true)
            } else {
                searchHeaderViewModel.searchTool.value = SearchTools(searchText: text, searchIsProgress: false)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("\(#function)")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("\(#function)")
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchHeaderViewModel.searchTool.value = SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false)
        
    }
    
}

