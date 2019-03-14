//
//  FeedViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedViewController: BaseTableViewController {
    
    // MARK: - Variable
    private var viewModel: FeedViewModel!
    
    // MARK: - Views
    lazy var activityIndicatorView: UIView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        
        return view
    }()
    
    let noResultFoundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = LocalizedConstants.Feed.NoPostFound
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard checkLoginAuth() else { return }
        
        setupTableView()
        setupViewModel()
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
        tableView.separatorStyle = .none
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
        tableView.backgroundView = noResultFoundLabel
        backgroungView(isHidden: true)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: .pullToRefresh, for: .valueChanged)
        refreshControl!.attributedTitle = NSAttributedString(string: LocalizedConstants.Feed.Loading)
    }
    
    private func setupViewModel() {
        viewModel.getData()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.state.bindAndFire { [unowned self] in
            print("state fired: \($0.rawValue)")
            self.setFooterView($0)
        }
        
        viewModel.changes.bindAndFire { [unowned self] in
            print("changes fired:")
            self.reloadTableView($0)
        }
    }
    
    deinit {
        viewModel.state.unbind()
        viewModel.changes.unbind()
    }
    
    func setFooterView(_ state: TableViewState) {
        backgroungView(isHidden: true)
        switch state {
        case .suggest:
            tableFooterView(view: nil)
        case .loading:
            tableFooterView(view: activityIndicatorView)
        case .paging:
            tableFooterView(view: nil)
        case .populate:
            tableFooterView(view: nil)
        case .empty:
            tableFooterView(view: nil)
            backgroungView(isHidden: false)
        case .error:
            tableFooterView(view: nil)
        default:
            tableFooterView(view: nil)
        }
    }
    
    func tableFooterView(view: UIView?) {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = view
        }
    }
    
    func backgroungView(isHidden: Bool) {
        DispatchQueue.main.async {
            self.tableView.backgroundView?.isHidden = isHidden
        }
    }
    
    func reloadTableView(_ changes: CellChanges) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: changes.reloads, with: .fade)
            self.tableView.insertRows(at: changes.inserts, with: .fade)
            self.tableView.deleteRows(at: changes.deletes, with: .fade)
            self.tableView.endUpdates()
//            self.tableView.backgroundView?.isHidden = self.viewModel.items.count > 0
        }
    }
    
    func configure(viewModel: ViewModel) {
        guard let viewModel = viewModel as? FeedViewModel else { return }
        self.viewModel = viewModel
    }
}

extension FeedViewController {
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.viewModel.refreshData()
            self.refreshControl!.endRefreshing()
        })
    }
    
}

extension FeedViewController {
    
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


extension FeedViewController {
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
            
            return cell
        }
        
        return UITableViewCell()
    }
}

fileprivate extension Selector {
    static let pullToRefresh = #selector(FeedViewController.refreshData(_:))
}



