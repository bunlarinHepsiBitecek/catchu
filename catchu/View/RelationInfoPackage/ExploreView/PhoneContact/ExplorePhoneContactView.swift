//
//  ExplorePhoneContactView.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MessageUI

class ExplorePhoneContactView: UIView {
    
    // view model
    private var explorePhoneContactViewModel = ExplorePhoneContactViewModel()
    
    private var requestView = ContactRequestView(frame: .zero)
    private let messageController = MFMessageComposeViewController()
    
    private var sectionViewSyncedContact = DynamicSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.StaticViewSize.ViewSize.Height.height_40), infoLabel: LocalizedConstants.TitleValues.LabelTitle.userInCatchU)
    private var sectionViewInvitedContact = DynamicSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.StaticViewSize.ViewSize.Height.height_40), infoLabel: LocalizedConstants.TitleValues.LabelTitle.contactsInvited)

    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var phoneContactTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        // delegations
        temp.delegate = self
        temp.dataSource = self
        
        temp.keyboardDismissMode = .onDrag
        temp.separatorStyle = UITableViewCellSeparatorStyle.none
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(SyncedContactTableViewCell.self, forCellReuseIdentifier: SyncedContactTableViewCell.identifier)
        temp.register(InvitedContactTableViewCell.self, forCellReuseIdentifier: InvitedContactTableViewCell.identifier)
        
        temp.backgroundView = requestView
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(ExplorePhoneContactView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        explorePhoneContactViewModel.refreshProcessState.unbind()
        explorePhoneContactViewModel.state.unbind()
        explorePhoneContactViewModel.searchTool.unbind()
    }

}

// MARK: - major functions
extension ExplorePhoneContactView {
    
    private func initializeViewSettings() {
        addViews()
        addPhoneContactViewModelListeners()
        getPhoneContacts()
        getSearchHeaderListener()
    }
    
    private func addViews() {
        self.addSubview(phoneContactTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            phoneContactTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            phoneContactTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            phoneContactTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            phoneContactTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        tableViewActivationManager(active: false)
    }
    
    private func addPhoneContactViewModelListeners() {
        explorePhoneContactViewModel.state.bind { (state) in
            self.phoneContactTableViewStateManager(state: state)
        }
        
        explorePhoneContactViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
        
        explorePhoneContactViewModel.refreshProcessState.bind { (operationState) in
            self.handleRefreshControllState(state: operationState)
        }
        
        requestView.listenConnectButtonProcess { (triggered) in
            self.explorePhoneContactViewModel.triggerPermissionFlow()
        }
        
    }
    
    private func phoneContactTableViewStateManager(state: TableViewState) {
        // to do
        switch state {
        case .populate:
            self.reloadPhoneContactTableView()
            self.setContactCountsToSectionViews()
            self.tableViewActivationManager(active: true)
        default:
            return
        }
    }
    
    private func reloadPhoneContactTableView() {
        DispatchQueue.main.async {
            self.phoneContactTableView.reloadData()
        }
    }
    
    private func tableViewActivationManager(active: Bool) {
        DispatchQueue.main.async {
            self.phoneContactTableView.isScrollEnabled = active
            self.phoneContactTableView.backgroundView?.isHidden = active
            
            if active {
                self.phoneContactTableView.tableHeaderView = self.searchBarHeaderView
            } else {
                self.phoneContactTableView.tableHeaderView = nil
            }
        }
        
    }
    
    private func getPhoneContacts() {
        explorePhoneContactViewModel.startFetchingContactsFromDevice()
    }
    
    private func setContactCountsToSectionViews() {
        sectionViewSyncedContact.giveSelectedParticipantCount(count: explorePhoneContactViewModel.returnSyncedContactListCount())
        sectionViewInvitedContact.giveSelectedParticipantCount(count: explorePhoneContactViewModel.returnRawContactListCount())
    }
    
    @objc private func triggerRefreshProcess(_ sender: UIRefreshControl) {
        explorePhoneContactViewModel.refreshProcessState.value = .processing
    }
    
    private func presentMessageController(phoneNumber: String) {
        
        print("MFMessageComposeViewController.canSendText() : \(MFMessageComposeViewController.canSendText())")
        
        if MFMessageComposeViewController.canSendText() {
            
            messageController.body = "https://f2wrp.app.goo.gl/ZEcd"
            messageController.recipients = [phoneNumber]
            messageController.delegate = self
            messageController.messageComposeDelegate = self
            
            if let currentViewController = LoaderController.currentViewController() {
                currentViewController.present(messageController, animated: true, completion: nil)
            }

        }
        
    }
    
    private func refreshControllerActivationManager(active: Bool) {
        
        DispatchQueue.main.async {
            guard let refreshControl = self.phoneContactTableView.refreshControl else { return }
            
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    private func handleRefreshControllState(state: CRUD_OperationStates) {
        switch state {
        case .processing:
            self.explorePhoneContactViewModel.refreshProcess()
        case .done:
            self.refreshControllerActivationManager(active: false)
        }
    }
    
    private func triggerSearchProcess(searchTool: SearchTools) {
        explorePhoneContactViewModel.searchContactsInTableViewData(inputText: searchTool.searchText)
    }
    
    private func getSearchHeaderListener() {
        searchBarHeaderView.getSearchActions { (searchTool) in
            print("searchTool : \(searchTool)")
            self.explorePhoneContactViewModel.searchTool.value = searchTool
        }
    }
    
}

// MARK: - UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate
extension ExplorePhoneContactView : UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print("messageComposeViewController didFinishWith starts")
        
        switch result {
        case .cancelled:
            messageController.dismiss(animated: true, completion: nil)
            
        case .failed:
            messageController.dismiss(animated: true, completion: nil)
            
        case .sent:
            messageController.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ExplorePhoneContactView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellViewModel = explorePhoneContactViewModel.returnViewModel(index: section)
        
        switch cellViewModel.type {
        case .syncedContact:
            return sectionViewSyncedContact
        case .invitedContact:
            return sectionViewInvitedContact
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return explorePhoneContactViewModel.returnCommonExplorePhoneContactArray()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explorePhoneContactViewModel.returnNumberOfRowsInSections(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = explorePhoneContactViewModel.returnViewModel(index: indexPath.section)
        
        print("section info : \(indexPath.section)")
        print("celltype : \(cellViewModel.type)")
        
        switch cellViewModel.type {
        case .syncedContact:
            
            if let syncedCellViewModel = cellViewModel as? SyncedPhoneContactsViewModel {
                guard let cell = phoneContactTableView.dequeueReusableCell(withIdentifier: SyncedContactTableViewCell.identifier, for: indexPath) as? SyncedContactTableViewCell else { return UITableViewCell() }
                
                cell.initiateCellDesign(item: syncedCellViewModel.syncedPhoneContactsUserArray[indexPath.row])
                
                return cell
            }
            
        case .invitedContact:
            
            if let invitedCellViewModel = cellViewModel as? InvitedPhoneContactsViewModel {
                guard let cell = phoneContactTableView.dequeueReusableCell(withIdentifier: InvitedContactTableViewCell.identifier, for: indexPath) as? InvitedContactTableViewCell else { return UITableViewCell() }
                
                cell.initiateCellDesign(item: invitedCellViewModel.invitedPhoneContactsUserArray[indexPath.row])
                
                cell.listenSelectedPhoneNumber { (selectedPhone) in
                    self.presentMessageController(phoneNumber: selectedPhone)
                }
                
                return cell
            }

        }
        
        return UITableViewCell()
        
    }
    
}

// MARK: - PageItems
extension ExplorePhoneContactView: PageItems {
    var title: String? {
        get {
            return LocalizedConstants.SlideMenu.contacts
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return nil
        }
        set {
            _ = newValue
        }
    }
}
