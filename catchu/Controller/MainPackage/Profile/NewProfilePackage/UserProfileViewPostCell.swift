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
        viewModelItem.postCount.unbind()
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemPost else { return }
        self.viewModelItem = viewModelItem
        
        textLabel?.text = viewModelItem.title
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModelItem.postCount.bindAndFire { [unowned self] (count) in
            self.detailTextLabel?.text = "\(count)"
        }
    }
    
    @objc func posts() {
        print("\(#function) run")
        
    }
}
