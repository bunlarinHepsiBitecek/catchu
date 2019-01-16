//
//  LikeViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LikeViewController: BaseTableViewController, ConfigurableController {
    // MARK: Variable
    private var viewModel: LikeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedConstants.Like.Likes
        
        setupTableView()
        setupViewModel()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // at cell, 2 times left padding from imageview
        let leftPadding = Constants.Feed.ImageWidthHeight + 2 * Constants.Feed.Padding
        let seperatorInset = UIEdgeInsets(top: 0, left: leftPadding , bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = seperatorInset
        
        tableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.identifier)
        
        setupRefreshControl()
    }
    
    func setupViewModel() {
        viewModel.loadData()
        
        viewModel.reloadTableView.bind { [unowned self](_) in
            self.reloadTableView()
        }
    }
    
    deinit {
        viewModel.reloadTableView.unbind()
    }
    
    func configure(viewModel: ViewModel) {
        guard let viewModel = viewModel as? LikeViewModel else { return }
        self.viewModel = viewModel
    }
    
}

extension LikeViewController {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: .pullToRefresh, for: .valueChanged)
        refreshControl!.attributedTitle = NSAttributedString(string: LocalizedConstants.Feed.Loading)
    }
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.viewModel.refreshData()
            self.refreshControl!.endRefreshing()
        })
    }
}

extension LikeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier, for: indexPath) as? UserViewCell {
            
            cell.configure(viewModelItem: item)
            
            return cell
        }
        return UITableViewCell()
        
    }
    
}


fileprivate extension Selector {
    static let pullToRefresh = #selector(LikeViewController.refreshData(_:))
}
