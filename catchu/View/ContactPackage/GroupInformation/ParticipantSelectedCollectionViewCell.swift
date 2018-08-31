//
//  ParticipantSelectedCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ParticipantSelectedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var selectedParticipantImage: UIImageViewDesign!
    @IBOutlet var selectedParticipantName: UILabel!
    
    var participant = User()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
}
