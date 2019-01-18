//
//  UserProfileViewCaughtCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewCaughtCell: BaseTableCellRightDetail, ConfigurableCell {
    
    var viewModelItem: UserProfileViewModelItemCaught!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        selectionStyle = .none
        accessoryType = .none
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemCaught else { return }
        self.viewModelItem = viewModelItem
        textLabel?.text = viewModelItem.title
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        self.detailTextLabel?.text = "\(viewModelItem.caughtCount)"
    }
    
    @objc func caughtPosts() {
        print("\(#function) run")
        
    }
}
