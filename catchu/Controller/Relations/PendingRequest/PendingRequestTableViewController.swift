//
//  PendingRequestTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/2/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PendingRequestTableViewController: UITableViewController {

    var pendingRequestTableViewModel = PendingRequestTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    deinit {
        pendingRequestTableViewModel.searchTools.unbind()
    }
}

// MARK: - major functions
extension PendingRequestTableViewController {
    
    private func prepareViewController() {
        print("\(#function)")
        
        setupViewSettings()
        addTableViewListeners()
        addSearchController()
        addSearchControllerListeners()
        
    }
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.groupInfoEdit
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        self.tableView.register(PendingRequestTableViewCell.self, forCellReuseIdentifier: PendingRequestTableViewCell.identifier)
    }
    
    private func addTableViewListeners() {
        pendingRequestTableViewModel.state.bind { (state) in
            switch state {
            case .populate:
                self.tableViewReload()
            default:
                return
            }
        }
        
    }
    
    private func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedConstants.SearchBar.searching
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    private func addSearchControllerListeners() {
        pendingRequestTableViewModel.searchTools.bind { (searchTool) in
            self.searchToolOperations(searchTool: searchTool)
        }
        
        
    }
    
    private func searchToolOperations(searchTool: SearchTools) {
        if !searchTool.searchIsProgress {
            self.tableViewReload()
        }
    }
    
    private func tableViewReload() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: Constants.AnimationValues.aminationTime_03, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }
    
    func listenButtonOperation(cellResult: FollowRequestOperationCellResult) {
        print("\(#function)")
        
        switch cellResult.state {
        case .done:
            print("cell item : \(cellResult.state)")
            print("cell userid : \(cellResult.requesterUserid)")
            
            DispatchQueue.main.async {
                
                if let indexPath = self.findItemIndexPathInVisibleCell(requesterUserid: cellResult.requesterUserid) {
                    self.pendingRequestTableViewModel.removeFollowRequestFromArray(userid: cellResult.requesterUserid)
                    
                    self.tableView.beginUpdates()
                    
                    if cellResult.buttonOperation == .confirm {
                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    } else if cellResult.buttonOperation == .delete {
                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
                    }
                    
                    self.tableView.endUpdates()
                    
                    self.manageTableViewScrollProperty(active: true)
                }

            }

        case .processing:
            self.manageTableViewScrollProperty(active: false)
            return
        }
        
    }
    
    func slideMenuPendingRequestCount(completion: @escaping (_ followRequestArray: [CommonViewModelItem]) -> Void) {
        pendingRequestTableViewModel.slideMenuPendingRequestCounterListener.bind { (updatedFollowRequestArray) in
            completion(updatedFollowRequestArray)
        }
    }
    
    private func findItemIndexPathInVisibleCell(requesterUserid: String) -> IndexPath? {
        if let visibleIndexPath = tableView.indexPathsForVisibleRows {
            for item in visibleIndexPath {
                if let cell = tableView.cellForRow(at: item) as? PendingRequestTableViewCell {
                    if requesterUserid == cell.returnCellUserid() {
                        return item
                    }
                }
            }
        }
        return nil
    }
    
    private func manageTableViewScrollProperty(active: Bool) {
        tableView.isScrollEnabled = active
    }
    
}

// MARK: - tableViewDelegates
extension PendingRequestTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pendingRequestTableViewModel.returnFollowRequestArrayCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PendingRequestTableViewCell.identifier, for: indexPath) as? PendingRequestTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: pendingRequestTableViewModel.returnCommonViewItem(index: indexPath.row))
        cell.setItemTagToButtons(item: indexPath.item)
        cell.listenButtonOperations { (cellResult) in
            self.listenButtonOperation(cellResult: cellResult)
        }
        
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating
extension PendingRequestTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("\(#function)")
        
        if let text = searchController.searchBar.text {
            if !text.isEmpty {
                pendingRequestTableViewModel.searchFollowRequesterInTableViewData(inputText: searchController.searchBar.text!)
            } else {
                pendingRequestTableViewModel.searchTools.value.searchIsProgress = false
            }
        }
        
        
    }
}
