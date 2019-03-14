
//
//  CommonContactViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/26/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import Contacts

class CommonContactViewModel: CommonViewModelItem {
 
    var contact: CNContact?
    
    init(contact: CNContact) {
        self.contact = contact
    }
    
}
