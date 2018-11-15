//
//  SearcViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearcViewControllerNew: BaseTableViewController {
    
    let viewModel = SearchViewModel()
    
    var searchTimer: Timer?
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupTableView()
        setupViewModel()
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.identifier)
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func setupViewModel() {
        viewModel.isLoading.bindAndFire { [unowned self] (isLoading) in
            print("isLoading: \(isLoading)")
            if isLoading {
                self.reloadTableView()
            }
        }
        
        viewModel.reloadTableView.bindAndFire { [unowned self] (isReload) in
            print("reloadTableView: \(isReload)")
            if isReload {
                self.reloadTableView()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    deinit {
        viewModel.isLoading.unbind()
        viewModel.reloadTableView.unbind()
    }
    
}

extension SearcViewControllerNew {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel.isLoading.value {
//            return 1
//        }
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if viewModel.isLoading.value {
//            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//            activityIndicatorView.hidesWhenStopped = true
//            activityIndicatorView.startAnimating()
//
//            let cell = UITableViewCell()
//            cell.contentView.addSubview(activityIndicatorView)
//            return cell
//        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier, for: indexPath) as? UserViewCell {
            cell.configure(item: viewModel.items[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.isLoading.value {
            return "Searching..."
        }

//        return viewModel.items.count > 0 ? "Search result" : nil
        return "Search result"
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.isLoading.value {
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.startAnimating()

            return activityIndicatorView
        }
        return nil
    }
}

extension SearcViewControllerNew: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        
        searchTimer?.invalidate()
        print("timer basladi")
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            print("tetiklendi")
            self.viewModel.searchUsers(text: searchString)
        })
        
//        if searchString.isEmpty {
//            return
//        }
//
//        viewModel.isLoading.value = true
//        searchTimer?.invalidate()
//        print("timer basladi")
//        searchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
//            print("tetiklendi")
//            // Put your code which should be executed with a delay here
//            self.viewModel.isLoading.value = false
//            self.viewModel.reloadTableView.value = true
//        })
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.removeAll()
    }
    
}
