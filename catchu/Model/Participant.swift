//
//  Participant.swift
//  catchu
//
//  Created by Erkut Baş on 8/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Participant {
    
    public static var shared = Participant()
    
    private var _participantDictionary : Dictionary<String, [User]>!
    
    init() {
        
        _participantDictionary = Dictionary<String, [User]>()
        
    }
    
    var participantDictionary: Dictionary<String, [User]> {
        get {
            return _participantDictionary
        }
        set {
            _participantDictionary = newValue
        }
    }
    
    
}
