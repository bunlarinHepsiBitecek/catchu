//
//  FeedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let pullToRefresh = #selector(FeedViewController.refreshData(_:))
}

class FeedViewController: BaseTableViewController {
    
    // MARK: Variable
    private let viewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizedConstants.Feed.CatchU
        
        guard checkLoginAuth() else { return }
        
        setupTableView()
        barButtonTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLoginAuth() -> Bool {
        if !FirebaseManager.shared.checkUserLoggedIn() {
            FirebaseManager.shared.redirectSignin()
            return false
        }
        
        return true
    }
    
    private func setupTableView() {
        
        viewModel.delegate = self
        
        tableView.dataSource = viewModel
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
//        tableView.estimatedRowHeight = 500
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = .none
        
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
        
        tableView.backgroundView = ConstanstViews.Labels.NoDataFoundLabel
        tableView.backgroundView?.isHidden = true
        
        setupRefreshControl()
    }
    
    // MARK : Sil
    func barButtonTest() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonActionRight))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(buttonActionLeft))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func buttonActionRight() {
        let phoneViewController = PhoneViewController()
        LoaderController.presentViewController(controller: phoneViewController)
    }
    
    @objc func buttonActionLeft() {
//        let feedMapView = FeedMapView()
//        feedMapView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(feedMapView)
//
//        NSLayoutConstraint.activate([
//            feedMapView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
//            feedMapView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//            feedMapView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//            feedMapView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
//            ])
        
        AlertViewManager.show(type: .error, body: "Ugur totosu buna bakiyor simdi")
        
    }
}

extension FeedViewController {
    
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

extension FeedViewController: FeedViewCellDelegate {
    
    func updateTableView(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        if let item = viewModel.items[indexPath.row] as? FeedViewModelPostItem {
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

extension FeedViewController: FeedViewModelDelegete {
    func apply(changes: CellChanges) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: changes.reloads, with: .fade)
            self.tableView.insertRows(at: changes.inserts, with: .fade)
            self.tableView.deleteRows(at: changes.deletes, with: .fade)
            self.tableView.endUpdates()
            
            self.tableView.backgroundView?.isHidden = self.viewModel.items.count > 0
        }
        
    }
    
}


