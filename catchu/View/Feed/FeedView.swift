//
//  FeedView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
}

class FeedView: BaseView {
    
    // MARK: Variable
    private let dataSource = FeedViewModel()
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.frame)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
        
        return tableView
    }()
    
    
    override func setupView() {
        print("FeedView setupView")
        
        self.dataSource.delegate = self
        
        self.addSubview(tableView)
        let safeLayout = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.dataSource.refreshData()
            self.refreshControl.endRefreshing()
        })
    }
}

extension FeedView: UITableViewDelegate {

}

extension FeedView: FeedViewCellDelegate {
    
    func updateTableView(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }

        if let item = self.dataSource.items[indexPath.row] as? FeedViewModelPostItem {
            item.expanded = true

            guard let post = item.post else { return }
            guard let message = post.message else { return }
            
            if let cell = tableView.cellForRow(at: indexPath) as? FeedViewCell {
                cell.statusTextViewReadMore(expanded: true, text: message)
            }
        }
        
//        if let item = self.dataSource.items[indexPath.row] as? FeedViewModelPostItem {
//            item.expanded = true
//        }
        
        // MARK: Disabling animations gives us our desired behaviour
//        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
//        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        // MARK: Enable animations
//        UIView.setAnimationsEnabled(true)
    }
}

extension FeedView: FeedViewModelDelegete {
    func apply(changes: CellChanges) {
        print("tableview reloaded")
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: changes.reloads, with: .fade)
            self.tableView.insertRows(at: changes.inserts, with: .fade)
            self.tableView.deleteRows(at: changes.deletes, with: .fade)
            self.tableView.endUpdates()
        }
    }
    
}

