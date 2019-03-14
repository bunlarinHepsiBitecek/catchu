//
//  UserProfilePostsViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfilePostsViewController: BaseTableViewController, ConfigurableController {
    
    var viewModel: UserProfilePostsViewModel!
    
    override func setupViews() {
        super.setupViews()
        
        setupTableView()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
    }
    
    func setupViewModel() {
        
    }
    
    deinit {
//        viewModel.state.unbind()
//        viewModel.changes.unbind()
    }
    
    func configure(viewModel: ViewModel) {
        guard let viewModel = viewModel as? UserProfilePostsViewModel else { return }
        self.viewModel = viewModel
    }
}

extension UserProfilePostsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.identifier, for: indexPath) as? FeedViewCell {
            
            cell.configure(viewModel: item, indexPath: indexPath)
            
            // MARK: bind the cell
            cell.readMore?.bind({ [unowned self] (indexPath) in
                self.reloadTableCell(at: indexPath)
            })
            
        }
        return UITableViewCell()
    }
}

extension UserProfilePostsViewController {
    
    func reloadTableCell(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        if let item = viewModel.items[indexPath.row] as? FeedViewModelItemPost {
            item.expanded = true
            
            guard let post = item.post else { return }
            guard let message = post.message else { return }
            
            self.tableView.beginUpdates()
            if let cell = tableView.cellForRow(at: indexPath) as? FeedViewCell {
                cell.statusTextViewReadMore(expanded: true, text: message)
            }
            self.tableView.endUpdates()
        }
    }
}
