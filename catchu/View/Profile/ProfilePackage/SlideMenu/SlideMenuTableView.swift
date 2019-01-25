//
//  SlideMenuTableView.swift
//  catchu
//
//  Created by Erkut Baş on 1/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SlideMenuTableView: UIView {

    var slideMenuTableViewModel = SlideMenuTableViewModel()
    
    lazy var slideMenuTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()

        // cell registration
        temp.register(ExplorePeopleSlideMenuTableViewCell.self, forCellReuseIdentifier: ExplorePeopleSlideMenuTableViewCell.identifier)
        temp.register(PendingRequestSlideMenuTableViewCell.self, forCellReuseIdentifier: PendingRequestSlideMenuTableViewCell.identifier)
        temp.register(ManageGroupsSlideMenuTableViewCell.self, forCellReuseIdentifier: ManageGroupsSlideMenuTableViewCell.identifier)
        temp.register(SettingsSlideMenuTableViewCell.self, forCellReuseIdentifier: SettingsSlideMenuTableViewCell.identifier)
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(SlideMenuTableView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        slideMenuTableViewModel.refreshProcessState.unbind()
    }
    
}

// MARK: - major functions
extension SlideMenuTableView {
    
    private func initializeViews() {
        addViews()
        creataCells()
    }
    
    private func addViews() {
        self.addSubview(slideMenuTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            slideMenuTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            slideMenuTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            slideMenuTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            slideMenuTableView.heightAnchor.constraint(equalToConstant: frame.height)
            
            ])
    }
    
    private func creataCells() {
        slideMenuTableViewModel.createSlideMenuCellArray()
    }
    
    private func addTransitionToPresentationOfFriendRelationViewController() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
    private func gotoFriendRelationViewController() {
        
        addTransitionToPresentationOfFriendRelationViewController()
        
        let friendRelationViewController = FriendRelationViewController()
        
        friendRelationViewController.friendRelationChoise = FriendRelationViewChoise.group
        friendRelationViewController.friendRelationViewPurpose = FriendRelationViewPurpose.groupManagement
        
        if let currentViewController = LoaderController.currentViewController() {
            currentViewController.present(friendRelationViewController, animated: false, completion: nil)
        }

    }
    
    private func gotoExplorePeopleViewController() {
        
        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Profile, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ExplorePeopleViewController) as? ExplorePeopleViewController {
            
            if let currentViewController = LoaderController.currentViewController() {
                if let navigationController = currentViewController.navigationController {
                    navigationController.pushViewController(destination, animated: true)
                } else {
                    currentViewController.present(destination, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    private func gotoExploreViewContoller() {
        let exploreViewController = ExploreViewController()
        
        if let currentViewController = LoaderController.currentViewController() {
            if let navigationController = currentViewController.navigationController {
                navigationController.pushViewController(exploreViewController, animated: true)
            } else {
                currentViewController.present(exploreViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func gotoPendingRequestViewController() {
        let pendingRequestController = PendingRequestTableViewController()
        
        print("slideMenuTableViewModel.followRequesterArray : \(slideMenuTableViewModel.followRequesterArray)")
        
        pendingRequestController.pendingRequestTableViewModel.followRequesterArray = slideMenuTableViewModel.followRequesterArray
        
        if let currentViewController = LoaderController.currentViewController() {
            if let navigationController = currentViewController.navigationController {
                navigationController.pushViewController(pendingRequestController, animated: true)
            } else {
                currentViewController.present(pendingRequestController, animated: true, completion: nil)
            }
        }
        
        pendingRequestController.slideMenuPendingRequestCount { (updatedFollowRequestArray) in
            print("COUNT : \(updatedFollowRequestArray.count)")
            self.updateBadgeDataFromPendingRequestViewController(count: self.slideMenuTableViewModel.returnUpdatedFollowRequestArrayCount(array: updatedFollowRequestArray))
        }
        
    }
    
    private func updateBadgeDataFromPendingRequestViewController(count: Int) {
        DispatchQueue.main.async {
            for item in self.slideMenuTableView.visibleCells {
                if let cell = item as? PendingRequestSlideMenuTableViewCell {
                    cell.setBadgeDataFromOutside(value: "\(count)")
                }
            }
        }
    }
    
    private func pushViewControllers(slideMenuType: SlideMenuViewTags) {
        
        SlideMenuLoader.shared.animateSlideMenu(active: false)
        
        switch slideMenuType {
        case .explore:
            //gotoExplorePeopleViewController()
            gotoExploreViewContoller()
        case .viewPendingFriendRequests:
            gotoPendingRequestViewController()
        case .manageGroupOperations:
            gotoFriendRelationViewController()
        case .settings:
            return
        }
        
    }
    
    private func refreshControllerActivationManager(active: Bool) {
        guard let refreshControl = slideMenuTableView.refreshControl else { return }
        
        if active {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    func activatePendingRequestBadgeData(value: String) {
        DispatchQueue.main.async {
            for item in self.slideMenuTableView.visibleCells {
                if let cell = item as? PendingRequestSlideMenuTableViewCell {
                    cell.setBadgeDataFromOutside(value: value)
                    cell.cellEnableManager(active: true)
                    self.refreshControllerActivationManager(active: false)
                }
            }
            
        }
    }
    
    func setFollowerRequestArray(followRequesterArray: Array<CommonViewModelItem>) {
        self.slideMenuTableViewModel.followRequesterArray = followRequesterArray
    }
    
    func refreshControlListener(completion: @escaping (_ refreshState: CRUD_OperationStates) -> Void) {
        slideMenuTableViewModel.refreshProcessState.bind { (operationState) in
            completion(operationState)
        }
    }
    
    @objc func triggerRefreshProcess(_ sender: UIRefreshControl) {
        slideMenuTableViewModel.refreshProcessState.value = .processing
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SlideMenuTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slideMenuTableViewModel.returnSlideMenuCellArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let slideMenuType = slideMenuTableViewModel.returnViewModel(index: indexPath.row)
        
        switch slideMenuType.type {
        case .explore:
            guard let cell = slideMenuTableView.dequeueReusableCell(withIdentifier: ExplorePeopleSlideMenuTableViewCell.identifier, for: indexPath) as? ExplorePeopleSlideMenuTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: slideMenuType)
            
            return cell
            
        case .viewPendingFriendRequests:
            guard let cell = slideMenuTableView.dequeueReusableCell(withIdentifier: PendingRequestSlideMenuTableViewCell.identifier, for: indexPath) as? PendingRequestSlideMenuTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: slideMenuType)
            
            return cell
            
        case .manageGroupOperations:
            guard let cell = slideMenuTableView.dequeueReusableCell(withIdentifier: ManageGroupsSlideMenuTableViewCell.identifier, for: indexPath) as? ManageGroupsSlideMenuTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: slideMenuType)
            
            return cell
            
        case .settings:
            guard let cell = slideMenuTableView.dequeueReusableCell(withIdentifier: SettingsSlideMenuTableViewCell.identifier, for: indexPath) as? SettingsSlideMenuTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: slideMenuType)
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slideMenuItem = slideMenuTableViewModel.returnViewModel(index: indexPath.row)
        self.pushViewControllers(slideMenuType: slideMenuItem.type)
        
        slideMenuTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
