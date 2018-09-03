//
//  GroupCreateHeaderTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupCreateHeaderTableViewCell: UITableViewCell {

    @IBOutlet var participantTag: UILabel!
    @IBOutlet var selectedCount: UILabel!
    @IBOutlet var totalCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
