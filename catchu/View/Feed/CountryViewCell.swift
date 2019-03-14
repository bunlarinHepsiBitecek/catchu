//
//  CountryViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class CountryViewCell: BaseTableCell {
    
    var country: Country?
    
    // style value1 is enabled detailTextLabel
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(country: Country) {
        self.country = country
        
        self.textLabel?.text = country.name
        self.detailTextLabel?.text = country.phoneExtension
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }
}
