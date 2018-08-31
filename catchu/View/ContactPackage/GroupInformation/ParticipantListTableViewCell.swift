//
//  ParticipantListTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ParticipantListTableViewCell: UITableViewCell {

    @IBOutlet var participantImage: UIImageViewDesign!
    @IBOutlet var participantName: UILabel!
    @IBOutlet var participantSelectedIcon: UIImageViewDesign!
    @IBOutlet var participantDetailInformation: UILabel!
    
    var participant = User()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetLabelProperties() {
        
        participantName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        participantDetailInformation.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        participantName.text = Constants.CharacterConstants.SPACE
        participantDetailInformation.text = Constants.CharacterConstants.SPACE
        participantSelectedIcon.image = UIImage()
        isUserInteractionEnabled = true
        
    }
    
    func setParticipantAlreadyInGroup() {
        
        participantName.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        participantDetailInformation.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        participantDetailInformation.text = "User is already in group!"
        participantSelectedIcon.image = UIImage(named: "check_mark_grey.png")
        
        isUserInteractionEnabled = false
        
    }

}
