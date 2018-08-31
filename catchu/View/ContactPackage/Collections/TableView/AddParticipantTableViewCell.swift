//
//  AddParticipantTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AddParticipantTableViewCell: UITableViewCell {

    @IBOutlet var addParticipantLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        addParticipantLabel.text = "Add Participants"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
