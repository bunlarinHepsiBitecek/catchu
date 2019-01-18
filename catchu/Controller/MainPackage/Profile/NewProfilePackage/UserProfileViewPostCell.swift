//
//  UserProfileViewPostCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewPostCell: BaseTableCellRightDetail, ConfigurableCell {
    
    var viewModelItem: UserProfileViewModelItemPost!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        selectionStyle = .none
        accessoryType = .none
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemPost else { return }
        self.viewModelItem = viewModelItem
        
        textLabel?.text = viewModelItem.title
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        self.detailTextLabel?.text = "\(viewModelItem.postCount)"
    }
    
    @objc func posts() {
        print("\(#function) run")
        
    }
}
