//
//  GroupInfoView.swift
//  catchu
//
//  Created by Erkut Baş on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoView: UIView {

    lazy var groupDetailTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        //temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        //temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(GroupRelationTableViewCell.self, forCellReuseIdentifier: GroupRelationTableViewCell.identifier)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension GroupInfoView {
    
    private func initializeView() {
        self.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GroupInfoView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
