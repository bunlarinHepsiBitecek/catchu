//
//  GroupTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 8/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet var groupImage: UIImageViewDesign!
    @IBOutlet var groupName: UILabel!
    @IBOutlet var groupDescription: UILabel!
    @IBOutlet var groupSelectedIcon: UIImageViewDesign!
    
    var group = Group()
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                print("selected")
//            } else {
//                print("deselected")
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
