//
//  UserProfileEditViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let cancelAction = #selector(UserProfileEditViewController.cancel)
    static let saveAction = #selector(UserProfileEditViewController.save)
}

class UserProfileEditViewController: BaseTableViewController {
    
    var viewModel: UserProfileEditViewModel!
    
    private var expandedIndexPath: IndexPath?
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    lazy var cancelLeftBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelAction)
        return barButton
    }()
    
    lazy var doneRightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .saveAction)
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavigation()
        setupHeaderView()
        setupTableView()
    }
    
    func setup() {
        self.view.backgroundColor = .white
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = cancelLeftBarButton
        navigationItem.rightBarButtonItem = doneRightBarButton
    }
    
    func setupHeaderView() {
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .interactive
        
        // at cell, 2 times left padding from
        let leftPadding: CGFloat = 7 * 20
        tableView.separatorStyle = .singleLine
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: leftPadding , bottom: 0, right: 0)
        
        tableView.register(UserProfileEditViewCell.self, forCellReuseIdentifier: UserProfileEditViewCell.identifier)
        
        let headerView = UserProfileEditHeaderView()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        tableView.tableHeaderView = headerView
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        if let rightBarButtonView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
            activityIndicatorView.frame = rightBarButtonView.frame
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.activityIndicatorView.stopAnimating()
            
            self.navigationItem.rightBarButtonItem = self.doneRightBarButton
        })
        
    }

}

extension UserProfileEditViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileEditViewCell.identifier, for: indexPath) as? UserProfileEditViewCell {
            cell.configure(viewModelItem: item)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    /*
    1. There is no date picker shown, we tap a row, then a date picker is shown just under it
    2. A date picker is shown, we tap the same row , then the date picker is hidden
    3. A date picker is shown, we tap a differen row, then the date picker is hidden and another date picker under the tapped row is shown
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
//        tableView.visibleCells
//            .compactMap { $0 as? UserProfileEditViewCell}
//            .forEach { $0.isExpanded = false}
        
        tableView.beginUpdates()
        
        if let expandedIndexPath = self.expandedIndexPath {
            if expandedIndexPath == indexPath { // case 2
                expandRow(indexPath: indexPath, isExpand: false)
            } else { // case 3
                expandRow(indexPath: expandedIndexPath, isExpand: false)
                expandRow(indexPath: indexPath, isExpand: true)
            }
        } else { // case 1
            expandRow(indexPath: indexPath, isExpand: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
    
    func expandRow(indexPath: IndexPath, isExpand: Bool) {
        if let previousCell = tableView.cellForRow(at: indexPath) as? UserProfileEditViewCell {
            previousCell.isExpanded = isExpand
            self.expandedIndexPath = isExpand ? indexPath : nil
        }
    }
    
//    func findExpandedIndexpath() -> IndexPath? {
//        let aaa = tableView.visibleCells
//            .compactMap { $0 as? UserProfileEditViewCell}
//            .filter { $0.isExpanded == true }.first
//    }
}

