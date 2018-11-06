//
//  FriendsTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 6/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet var friendImage: UIImageViewDesign!
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendSelectedIcon: UIImageViewDesign!
    @IBOutlet var friendUserNameDetail: UILabel!
    
    var userFriend = User()
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        setupCellViewSettings()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - major functions
extension FriendsTableViewCell {
    
    func setupCellViewSettings() {
        
        self.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 10
        
    }
    
}
