//
//  AccountPrivacyTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AccountPrivacyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        prepareViewController()
    }
    
}

// MARK: - major functions
extension AccountPrivacyTableViewController {
    
    private func prepareViewController() {
        print("\(#function)")
        setupViewSettings()
    }
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.privacySecurityTitle
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.register(AccountPrivacyTableViewCell.self, forCellReuseIdentifier: AccountPrivacyTableViewCell.identifier)
    }
    
}

// MARK: - Table view data source
extension AccountPrivacyTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountPrivacyTableViewCell.identifier, for: indexPath) as? AccountPrivacyTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
}
