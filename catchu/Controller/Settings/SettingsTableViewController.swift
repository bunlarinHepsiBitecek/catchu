//
//  SettingsTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    private var settingControllerViewModel = SettingsControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        prepareViewController()
        
    }

}

// MARK: - major functions
extension SettingsTableViewController {
    
    private func prepareViewController() {
        print("\(#function)")
        
        setupViewSettings()
        addTableViewListeners()
        //addSearchController()
        //addSearchControllerListeners()
        createRows()
        
    }
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.settingsTitle
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsSelection = true
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(SettingsBaseTableViewCell.self, forCellReuseIdentifier: SettingsBaseTableViewCell.identifier)
    }
    
    private func addTableViewListeners() {
        settingControllerViewModel.state.bind { (state) in
            self.handleTableViewState(state: state)
        }
    }
    
    private func handleTableViewState(state: TableViewState) {
        switch state {
        case .populate:
            tableView.reloadData()
        default:
            return
        }
    }
    
    private func createRows() {
        settingControllerViewModel.createSections()
    }
    
    private func rowSelectOperations(type: SettingsRowType) {
        switch type {
        case .addFacebookFriends:
            self.triggerExploreViewController(pageType: .facebook)
        case .addContacts:
            self.triggerExploreViewController(pageType: .contact)
        case .invitePeople:
            self.triggerInvitePeopleProcess()
        case .accountPrivacyChange:
            self.triggerPrivacyController()
        case .accountLogout:
            FirebaseManager.shared.logout()
        }
    }
    
    private func triggerExploreViewController(pageType: ExploreType) {
        let exploreViewController = ExploreViewController()
        exploreViewController.exploreType = pageType
        
        if let currentViewController = LoaderController.currentViewController() {
            if let navigationController = currentViewController.navigationController {
                navigationController.pushViewController(exploreViewController, animated: true)
            } else {
                currentViewController.present(exploreViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    private func triggerPrivacyController() {
        let accountPrivacyTableViewController = AccountPrivacyTableViewController()
        
        if let currentViewController = LoaderController.currentViewController() {
            if let navigationController = currentViewController.navigationController {
                navigationController.pushViewController(accountPrivacyTableViewController, animated: true)
            } else {
                currentViewController.present(accountPrivacyTableViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    private func triggerInvitePeopleProcess() {
        
        let inviteActivityViewController = UIActivityViewController(activityItems: [URL(string: "https://f2wrp.app.goo.gl/ZEcd")], applicationActivities: nil)
        
        if let popoverPresentationController = inviteActivityViewController.popoverPresentationController {
            //popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        
        if let currentViewController = LoaderController.currentViewController() {
            currentViewController.present(inviteActivityViewController, animated: true, completion: nil)
        }
        
    }
}

// MARK: - Table view data source
extension SettingsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settingControllerViewModel.returnSectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingControllerViewModel.returnNumberOfRowsInSections(section: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingControllerViewModel.returnGroupSectionTitles(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupType = settingControllerViewModel.groupSectionArray[indexPath.section]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsBaseTableViewCell.identifier, for: indexPath) as? SettingsBaseTableViewCell else { return UITableViewCell() }

        
        switch groupType.type {
        case .addFriends:
            if let settingsAddFriendsViewModel = groupType as? SettingsAddFriendsViewModel {
                cell.initiateCellDesign(item: settingsAddFriendsViewModel.processType[indexPath.row])
            }
            
        case .inviteFriends:
            if let settingsInviteFriendsViewModel = groupType as? SettingsInviteFriendsViewModel {
                cell.initiateCellDesign(item: settingsInviteFriendsViewModel.processType[indexPath.row])
            }
        case .account:
            if let settingsAccountViewModel = groupType as? SettingsAccountViewModel {
                cell.initiateCellDesign(item: settingsAccountViewModel.processType[indexPath.row])
            }
        case .authentication:
            if let settingsAuthenticationViewModel = groupType as? SettingsAuthenticationViewModel {
                cell.initiateCellDesign(item: settingsAuthenticationViewModel.processType[indexPath.row])
            }
        default:
            return UITableViewCell()
        }

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsBaseTableViewCell else { return }
        
        if let type = cell.returnCellRowType() {
            self.rowSelectOperations(type: type)
        }
        
    }

}
