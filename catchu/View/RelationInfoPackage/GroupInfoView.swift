//
//  GroupInfoView.swift
//  catchu
//
//  Created by Erkut Baş on 12/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoView: UIView {
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private let groupImageContainerViewHeight : CGFloat = 150
    private let groupImageContainerVisibleHeight : CGFloat = 50
    
    private var groupImageContainerView : GroupImageContainerView!
    
    private let groupDetailViewModel = GroupDetailViewModel()
    
    // getting from caller viewController to pass and listen changes
    var groupViewModel : CommonGroupViewModel?
    
    lazy var groupDetailTableView: UITableView = {
        
        let temp = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.grouped)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        //temp.backgroundColor = UIColor.clear
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.contentInset = UIEdgeInsets(top: groupImageContainerViewHeight + statusBarHeight, left: 0, bottom: 0, right: 0)
        temp.contentInsetAdjustmentBehavior = .automatic
        temp.rowHeight = UITableView.automaticDimension
        
        //temp.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_85, bottom: 0, right: 0)
        //temp.separatorColor = UIColor.groupTableViewBackground
        
        // cell registrations
        temp.register(GroupNameTableViewCell.self, forCellReuseIdentifier: GroupNameTableViewCell.identifier)
        temp.register(GroupAdminPanelTableViewCell.self, forCellReuseIdentifier: GroupAdminPanelTableViewCell.identifier)
        temp.register(GroupExitTableViewCell.self, forCellReuseIdentifier: GroupExitTableViewCell.identifier)
        temp.register(GroupParticipantTableViewCell.self, forCellReuseIdentifier: GroupParticipantTableViewCell.identifier)
        
        return temp
        
    }()
    
    lazy var groupImageContainer: UIView = {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: groupImageContainerViewHeight))
        //temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return temp
    }()
    
    /*
     override init(frame: CGRect) {
     super.init(frame: frame)
     
     self.initializeView()
     }*/
    
    init(frame: CGRect, groupViewModel: CommonGroupViewModel) {
        super.init(frame: frame)
        // to sync groupRelationView data
        self.groupViewModel = groupViewModel
        self.groupDetailViewModel.groupViewModel = self.groupViewModel
        
        self.initializeView()
        // after adding groupImageContainerView, let's get it's viewModel to sync groupImageContainerView data
        self.groupDetailViewModel.groupImageViewModel = groupImageContainerView.groupImageViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        groupDetailViewModel.groupParticipantCount.unbind()
        groupDetailViewModel.state.unbind()
    }
}

// MARK: - major functions
extension GroupInfoView {
    
    private func initializeView() {
        
        addViews()
        
        do {
            try addGroupImageContainer()
        }
        catch let error as ClientPresentErrors {
            if error == .missingGroupViewModel {
                print("CommonGroupViewModel is required!")
            }
        }
        catch {
            print("Something terribly goes wrong")
        }
        
        addGroupDetailViewModelListeners()
        startGettingGroupDetailData()
        
    }
    
    private func addViews() {
        
        self.addSubview(groupDetailTableView)
        self.addSubview(groupImageContainer)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupDetailTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupDetailTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupDetailTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            groupDetailTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            groupImageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupImageContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupImageContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    private func addGroupImageContainer() throws {
        
        guard let groupViewModel = groupViewModel else { throw ClientPresentErrors.missingGroupViewModel }
        
        groupImageContainerView = GroupImageContainerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: groupImageContainerViewHeight + statusBarHeight), groupViewModel: groupViewModel, callerView: self)
        
        groupImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        groupImageContainerView.layer.shadowOpacity = 0.6
        groupImageContainerView.layer.shadowRadius = 5.0
        groupImageContainerView.layer.shadowColor = UIColor.black.cgColor
        
        self.groupImageContainer.addSubview(groupImageContainerView)
        
        let safeGroupImageContainer = self.groupImageContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupImageContainerView.leadingAnchor.constraint(equalTo: safeGroupImageContainer.leadingAnchor),
            groupImageContainerView.trailingAnchor.constraint(equalTo: safeGroupImageContainer.trailingAnchor),
            groupImageContainerView.topAnchor.constraint(equalTo: safeGroupImageContainer.topAnchor, constant: -statusBarHeight),
            groupImageContainerView.bottomAnchor.constraint(equalTo: safeGroupImageContainer.bottomAnchor),
            
            ])
        
        groupImageContainerView.startListenStackViewGroupTitleTapped { (tapped) in
            // to do
        }
        
    }
    
    private func addGroupDetailViewModelListeners() {
        
        groupDetailViewModel.state.bind { (state) in
            
            self.setLoadingAnimation(state)
            
            switch state {
            case .populate:
                self.reloadGroupDetailTableView()
                return
                
            case .sectionReload:
                self.reloadParticipantSection()
                return
            default:
                return
            }
        }
        
        groupDetailViewModel.groupParticipantCount.bind { (totalCount) in
            
            self.groupImageContainerView.groupImageViewModel.groupParticipantCount.value = totalCount
            
        }
        
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state, inputInformationText: LocalizedConstants.PostAttachmentInformation.gettingGroupDetail)
            
            switch state {
            case .populate, .sectionReload:
                self.groupDetailTableView.tableFooterView = nil
            default:
                self.groupDetailTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func startGettingGroupDetailData() {
        groupDetailViewModel.getGroupDetails()
    }
    
    private func reloadGroupDetailTableView() {
        
        DispatchQueue.main.async {
            
            UIView.transition(with: self.groupDetailTableView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.groupDetailTableView.reloadData()
            
            })
            
        }
        
    }
    
    private func reloadParticipantSection() {
        DispatchQueue.main.async {
            self.groupDetailTableView.reloadSections([self.groupDetailViewModel.participantSectionNumber], with: .middle)
            
        }
    }
    
    /// Description : it's used to go group name edit view process
    ///
    /// - Parameter groupNameViewModel: groupNameViewModel object taken from this view
    private func directGroupInfoEditViewController(groupNameViewModel: GroupNameViewModel) {
        print("\(#function)")
        
        if let currentViewController = LoaderController.currentViewController() {
            
            let groupInfoEditViewController = GroupInfoEditTableViewController()
            groupInfoEditViewController.groupNameViewModel = groupNameViewModel
            
            let groupInfoEditNavigationController = UINavigationController(rootViewController: groupInfoEditViewController)
            
            currentViewController.present(groupInfoEditNavigationController, animated: true, completion: nil)
        }
        
    }
    
    private func directParticipantViewController() {
        let friendRelationViewController = FriendRelationViewController()
        let currentViewController = LoaderController.currentViewController()
        
        // used to return selected friend, friendList or group information
        //friendRelationViewController.delegate = delegate
        friendRelationViewController.friendRelationViewPurpose = FriendRelationViewPurpose.participant
        friendRelationViewController.friendRelationChoise = FriendRelationViewChoise.friend
        friendRelationViewController.delegate = self
        friendRelationViewController.participantArray = groupDetailViewModel.participantArray
        friendRelationViewController.selectedGroup = groupDetailViewModel.groupViewModel?.group
        
        currentViewController?.present(friendRelationViewController, animated: true, completion: {
            print("presented")
        })
    }
    
    private func startActionSheet(title: String) {
        
        var operationType = ActionControllerOperationType.select
        
        if groupDetailViewModel.returnAuthenticatedUserIsAdmin() {
            operationType = ActionControllerOperationType.admin
        }
        
        AlertControllerManager.shared.startActionSheetManager(type: ActionControllerType.userInformation, operationType: operationType, delegate: self, title: title)
        
    }
    
    // observe view controller dismiss operation
    func addObserverForGroupInfoDismiss(completion : @escaping (_ state : GroupInfoLifeProcess) -> Void) {
        groupImageContainerView.startCancelButtonObserver(completion: completion)
        
        groupDetailViewModel.groupInfoViewExit.bind(completion)
    }
    
    func addObserverForLeavingGroupProcess(completion: @escaping (_ groupOperationType: GroupOperationTypes) -> Void) {
        groupDetailViewModel.leavingGroupProcessTriggered.bind(completion)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupInfoView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupDetailViewModel.returnSectionCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let groupDetailObject = groupDetailViewModel.returnGroupDetailSectionItems(section: section)
        
        switch groupDetailObject.type {
        case .participant:
            if let participantsObject = groupDetailObject as? GroupParticipantsViewModel {
                return "\(participantsObject.participantList.count)" + " " + participantsObject.sectionTitle
            }
            return groupDetailObject.sectionTitle
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupDetailViewModel.returnRowCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupDetailObject = groupDetailViewModel.returnGroupDetailSectionItems(section: indexPath.section)
        
        switch groupDetailObject.type {
        case .name:
            print("name cell loaded")
            
            guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupNameTableViewCell.identifier, for: indexPath) as? GroupNameTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: groupDetailObject)
            
            return cell
            
        case .admin:
            print("admin cell loaded")
            
            guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupAdminPanelTableViewCell.identifier, for: indexPath) as? GroupAdminPanelTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: groupDetailObject)
            
            return cell
            
        case .participant:
            print("participant cell loaded")
            
            if let participantObject = groupDetailObject as? GroupParticipantsViewModel {
                guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupParticipantTableViewCell.identifier, for: indexPath) as? GroupParticipantTableViewCell else { return UITableViewCell() }
                
                cell.initiateCellDesign(item: participantObject.participantList[indexPath.row])
                
                return cell
            }
            
        case .exit:
            print("exit cell loaded")
            
            guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupExitTableViewCell.identifier, for: indexPath) as? GroupExitTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: groupDetailObject)
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupDetailObject = groupDetailViewModel.returnGroupDetailSectionItems(section: indexPath.section)
        
        switch groupDetailObject.type {
        case .name:
            // to do
            if let groupNameViewModel = groupDetailObject as? GroupNameViewModel {
                self.directGroupInfoEditViewController(groupNameViewModel: groupNameViewModel)
                
            }
            
        case .admin:
            self.directParticipantViewController()
            
        case .participant:
            
            guard let cell = groupDetailTableView.cellForRow(at: indexPath) as? GroupParticipantTableViewCell else { return }
            
            print("userid : \(String(describing: cell.groupParticipantViewModel?.user?.userid))")
            
            if let groupParticipantViewModel = cell.groupParticipantViewModel {
                if let user = groupParticipantViewModel.user {
                    groupDetailViewModel.selectedUser = user
                    if let name = user.name {
                        self.startActionSheet(title: name)
                    }
                }
            }
            
        case .exit:
            // this section is used to leave group for authenticated user
            AlertControllerManager.shared.startActionSheetManager(type: .exitWarning, operationType: nil, delegate: self, title: nil)
        default:
            return
        }
        
    }
    
}

// MARK: - scroll override functions
extension GroupInfoView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("yarro scroll")
        let y = (groupImageContainerViewHeight) - (scrollView.contentOffset.y + groupImageContainerViewHeight)
        let height = min(max(y, groupImageContainerVisibleHeight), UIScreen.main.bounds.height)
        print("scrollView.contentOffset.y : \(scrollView.contentOffset.y)")
        print("y : \(y)")
        print("height : \(height)")
        groupImageContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
        if groupImageContainerView != nil {
            
            if (height <= groupImageContainerVisibleHeight) {
                print("bitirim")
                groupImageContainerView.activationManagerOfStackViewGroupInfo(active: true)
            }
            
            if (height <= groupImageContainerVisibleHeight) {
                groupImageContainerView.activationManagerOfMaxSizeContainerView(active: true)
            } else {
                groupImageContainerView.activationManagerOfMaxSizeContainerView(active: false)
                groupImageContainerView.activationManagerOfStackViewGroupInfo(active: false)
            }
            
        }
        
    }
    
}

// MARK: - PostViewProtocols
extension GroupInfoView : PostViewProtocols {
    
    func returnAddedParticipants(participantArray: Array<User>) {
        print("\(#function)")
        print("participantArray count : \(participantArray.count)")
        
        groupDetailViewModel.addNewParticipantsToGroup(newParticipantArray: participantArray)
        
    }
    
}

// MARK: - ActionSheetProtocols
extension GroupInfoView: ActionSheetProtocols {
    
    func returnOperations(selectedProcessType: ActionButtonOperation) {
        switch selectedProcessType {
        case .exitGroup:
            if let user = groupDetailViewModel.selectedUser {
                groupDetailViewModel.exitGroup(selectedUser: user)
            }
        case .gotoUserInfo:
            return
        case .makeGroupAdmin:
            if let user = groupDetailViewModel.selectedUser {
                if let userid = User.shared.userid, let newAdminUserid = user.userid {
                    groupDetailViewModel.changeGroupAdmin(adminUserid: userid, newAdminUserid: newAdminUserid)
                }
            }
        case .leaveGroup:
            print("leave group is triggered")
            groupDetailViewModel.groupInfoViewExit.value = .exit
            groupDetailViewModel.leavingGroupProcessTriggered.value = .leaveGroup
        default:
            return
        }
    }
}
