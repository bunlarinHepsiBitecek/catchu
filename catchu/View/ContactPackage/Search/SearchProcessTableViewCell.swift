//
//  SearchProcessTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchProcessTableViewCell: UITableViewCell {

    @IBOutlet var viewForActivityIndicator: UIView!
    @IBOutlet var searchProcessInformation: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
