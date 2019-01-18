//
//  SearchHeaderViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/18/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SearchHeaderViewModel {
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
}
