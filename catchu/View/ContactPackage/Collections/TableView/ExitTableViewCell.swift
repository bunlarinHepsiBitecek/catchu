//
//  ExitTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExitTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var exitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
