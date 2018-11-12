//
//  LikeView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LikeView: BaseView {
    
    // MARK: Variable
    let dataSource = LikeViewModel()
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        // Setup dynamic auto-resizing for comment cells
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // at cell, 2 times left padding from imageview
        let leftPadding = Constants.Feed.ImageWidthHeight + 2 * Constants.Feed.Padding
        let seperatorInset = UIEdgeInsets(top: 0, left: leftPadding , bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = seperatorInset
        
        tableView.register(LikeViewCell.self, forCellReuseIdentifier: LikeViewCell.identifier)
        
        return tableView
    }()
    
    override func setupView() {
        super.setupView()
        
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeTopAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
        
        self.dataSource.delegate = self
    }
    
    func configure(post: Post, comment: Comment? = nil) {
        self.dataSource.post = post
        self.dataSource.comment = comment
    }
    
}

extension LikeView {
    func setupRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.Feed.Loading)
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
//            self.dataSource.refreshData()
            self.refreshControl.endRefreshing()
        })
    }
}

extension LikeView: LikeViewModelDelegete {
    func updateTableView() {
        self.tableView.reloadData()
    }
}
