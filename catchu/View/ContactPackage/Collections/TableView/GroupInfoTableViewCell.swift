//
//  GroupInfoTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoTableViewCell: UITableViewCell {

    @IBOutlet var participantImage: UIImageViewDesign!
    @IBOutlet var participantUsername: UILabel!
    @IBOutlet var participantName: UILabel!
    @IBOutlet var adminLabel: UILabel!
    
    var participant = User()
    
    var isUserAdmin : Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adminLabel.text = Constants.CharacterConstants.SPACE
        isUserAdmin = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeProperties() {
        
        adminLabel.text = Constants.CharacterConstants.SPACE
        isUserAdmin = false
        
    }
    
}
