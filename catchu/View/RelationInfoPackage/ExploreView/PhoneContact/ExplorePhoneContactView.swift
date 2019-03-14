//
//  ExplorePhoneContactView.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MessageUI

class ExplorePhoneContactView: UIView {

    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var facebookTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        // delegations
        temp.delegate = self
        temp.dataSource = self
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.none
        temp.rowHeight = UITableView.automaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(ExploreFacebookContactTableViewCell.self, forCellReuseIdentifier: ExploreFacebookContactTableViewCell.identifier)
        
        //temp.backgroundView = requestView
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(ExplorePhoneContactView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - major functions
extension ExplorePhoneContactView {
    
    private func initializeViewSettings() {
        
    }
    
    @objc private func triggerRefreshProcess(_ sender: UIRefreshControl) {
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ExplorePhoneContactView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
