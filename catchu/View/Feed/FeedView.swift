//
//  FeedView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    private let refreshControl = UIRefreshControl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
        self.backgroundColor = UIColor.green
    }
    
    private func customization() {
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupRefreshControl()
        
    }
}

extension FeedView {
    func setupRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.Feed.Loading)
    }
    
    @objc private func refreshData(_ sender: Any) {
        //        self.loadData()
        self.refreshControl.endRefreshing()
    }
}

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: section by per feed
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.identifier, for: indexPath) as? FeedViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
