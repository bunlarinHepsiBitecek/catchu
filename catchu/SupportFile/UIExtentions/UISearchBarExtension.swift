//
//  UISearchBarExtension.swift
//  catchu
//
//  Created by Erkut Baş on 1/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

extension UISearchBar {
    
    func configureSearchBarSettings() {
        
        let textFieldInsideSearchBar = self.value(forKey: Constants.searchBarProperties.searchField) as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        self.searchBarStyle = .minimal
    }
    
}
