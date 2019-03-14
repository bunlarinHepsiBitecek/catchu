//
//  InvitedContactTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/27/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import Contacts

class InvitedContactTableCellViewModel {

    var commonContactViewModel: CommonContactViewModel?
    var selectedPhone = CommonDynamic(String())
    
    init(commonContactViewModel: CommonContactViewModel) {
        self.commonContactViewModel = commonContactViewModel
    }
    
    func returnContactData() -> CNContact? {
        if let commonContactViewModel = commonContactViewModel {
            return commonContactViewModel.contact
        }
        
        return nil
    }
    
//    func returnUser() -> User? {
//        if let commonUserViewModel = commonUserViewModel {
//            if let user = commonUserViewModel.user {
//                return user
//            }
//        }
//        return nil
//    }
    
    
}

