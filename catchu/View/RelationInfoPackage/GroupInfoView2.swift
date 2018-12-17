//
//  GroupInfoView2.swift
//  catchu
//
//  Created by Erkut Baş on 12/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoView2: UIView {

    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private let groupImageContainerViewHeight : CGFloat = 150
    private let groupImageContainerVisibleHeight : CGFloat = 50
    
    private var groupImageContainerView : GroupImageContainerView!
    
    private let groupDetailViewModel = GroupDetailViewModel()
    
    var group: Group?
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
        temp.rowHeight = UITableViewAutomaticDimension
        
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
    
    init(frame: CGRect, group: Group, groupViewModel: CommonGroupViewModel) {
        super.init(frame: frame)
        self.group = group
        self.groupDetailViewModel.group = self.group
        self.groupViewModel = groupViewModel
        self.groupDetailViewModel.groupViewModel = self.groupViewModel
        
        self.groupViewModel?.groupNameChanged.value = "zalala"
        print("popo : group : \(self.group?.groupID)")
        
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        groupDetailViewModel.groupParticipantCount.unbind()
        groupDetailViewModel.isAuthenticatedUserAdmin.unbind()
        groupDetailViewModel.state.unbind()
    }
}

// MARK: - major functions
extension GroupInfoView2 {
    
    private func initializeView() {
        
        addViews()
        addGroupImageContainer()
        addGroupDetailViewModelListeners()
        startGettingGroupDetailData()
        //addGroupInfoImageView()
        
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
    
    private func addGroupImageContainer() {
        groupImageContainerView = GroupImageContainerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: groupImageContainerViewHeight + statusBarHeight))
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
        
    }
    
    // observe view controller dismiss operation
    func addObserverForGroupInfoDismiss(completion : @escaping (_ state : GroupImageProcess) -> Void) {
        groupImageContainerView.startCancelButtonObserver(completion: completion)
    }
    
    private func addGroupDetailViewModelListeners() {
        
        groupDetailViewModel.state.bind { (state) in
            
            self.setLoadingAnimation(state)
            
            switch state {
            case .populate:
                self.reloadGroupDetailTableView()
                return
            default:
                return
            }
        }
        
        groupDetailViewModel.groupParticipantCount.bind { (totalCount) in
            DispatchQueue.main.async {
                self.groupImageContainerView.setParticipantCount(participantCount: totalCount)
            }
        }
        
        
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state, inputInformationText: LocalizedConstants.PostAttachmentInformation.gettingGroupDetail)
            
            switch state {
            case .populate:
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
            
            self.groupDetailTableView.reloadData()

        }
        
    }
    
    private func directGroupInfoEditViewController(groupViewModel: CommonGroupViewModel) {
        print("\(#function)")
        
        if let currentViewController = LoaderController.currentViewController() {
            
            let groupInfoEditViewController = GroupInfoEditTableViewController()
            groupInfoEditViewController.groupViewModel = groupViewModel
            
            let groupInfoEditNavigationController = UINavigationController(rootViewController: groupInfoEditViewController)
            
            currentViewController.present(groupInfoEditNavigationController, animated: true, completion: nil)
        }
        
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupInfoView2 : UITableViewDelegate, UITableViewDataSource {
    
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
                
                let object = participantObject.participantList[indexPath.row]
                
                cell.initiateCellDesign(item: participantObject.participantList[indexPath.row])
                
                return cell
            }
            
        case .exit:
            print("exit cell loaded")
            
            guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupExitTableViewCell.identifier, for: indexPath) as? GroupExitTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: groupDetailObject)
            
            return cell
        }
        
        /*
        guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupInfoParticipantTableViewCell.identifier, for: indexPath) as? GroupInfoParticipantTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(indexPath.row) + takasi bom bom"
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.imageView?.image = UIImage(named: "8771.jpg")
        cell.imageView?.clipsToBounds = true
        
        cell.accessoryType = .detailButton
        
        
        return cell*/
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupDetailObject = groupDetailViewModel.returnGroupDetailSectionItems(section: indexPath.section)
        
        switch groupDetailObject.type {
        case .name:
            // to do
            if let groupNameViewModel = groupDetailObject as? GroupNameViewModel {
                if let groupViewModel = groupNameViewModel.groupViewModel {
                    groupViewModel.groupNameChanged.value = "koko"
                    self.directGroupInfoEditViewController(groupViewModel: groupViewModel)
                }
            }
        default:
            return
        }
        
    }
    
}

// MARK: - scroll override functions
extension GroupInfoView2 {
    
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
            
            // when pulling down there is no need to show blur view on group image
            /*
            if (height <= groupImageContainerVisibleHeight) || (height > (groupImageContainerViewHeight + statusBarHeight + Constants.StaticViewSize.ConstraintValues.constraint_70)) {
                groupImageContainerView.activationManagerOfMaxSizeContainerView(active: true)
            } else {
                groupImageContainerView.activationManagerOfMaxSizeContainerView(active: false)
                groupImageContainerView.activationManagerOfStackViewGroupInfo(active: false)
            }*/

        }
        
    }
    
}
