//
//  SectionBasedParticipant.swift
//  catchu
//
//  Created by Erkut Baş on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SectionBasedParticipant: SectionBasedFriend {
    
    public static var sharedParticipant = SectionBasedParticipant()
    
    func returnREGroupRequestFromGroup(inputGroup : Group, inputParticipantArray : [User]) -> REGroupRequest {
        
        let returnREGroup = REGroupRequest()
        returnREGroup?.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
        
        returnREGroup?.groupid = inputGroup.groupID
        
        for item in inputParticipantArray {
            
            let temp = REGroupRequest_groupParticipantArray_item()
            temp?.participantUserid = item.userID
            
            returnREGroup?.groupParticipantArray?.append(temp!)
            
        }
        
        return returnREGroup!
        
    }
    
    
}
