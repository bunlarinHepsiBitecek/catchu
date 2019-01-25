//
//  FollowersView.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowersView: UIView {
    
    var followersViewModel: FollowersViewModel!
    
    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var followersTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        // delegations
        temp.delegate = self
        temp.dataSource = self
//        temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.none
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(FollowersTableViewCell.self, forCellReuseIdentifier: FollowersTableViewCell.identifier)
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(FollowersView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()

    init(frame: CGRect, user: User) {
        super.init(frame: frame)
        followersViewModel = FollowersViewModel(user: user)
        initializeViewSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("frame: \(frame)")
        
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        followersViewModel.state.unbind()
        followersViewModel.searchTool.unbind()
        followersViewModel.refreshProcessState.unbind()
    }
    
}

// MARK: - major functions
extension FollowersView {
    
    private func initializeViewSettings() {
        addFriendViewModelListener()
        configureView()
        addViews()
        addHeaderViewToTableView()
        startGettingUserFriends()
        getSearchHeaderListener()
        setTitleData()
        
    }
    
    private func configureView() {
        self.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    }
    
    private func addViews() {
        self.addSubview(followersTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            followersTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            followersTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            followersTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            followersTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//            followersTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -100),
            
            ])
    }
    
    private func addHeaderViewToTableView() {
        followersTableView.tableHeaderView = searchBarHeaderView
    }
    
    private func startGettingUserFriends() {
        followersViewModel.state.value = .loading
        
    }
    
    private func addFriendViewModelListener() {
        // add data fetching listener
        followersViewModel.state.bind { (state) in
            self.dataFethingStateManager(state: state)
        }
        
        followersViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
        
        followersViewModel.refreshProcessState.bind { (operationState) in
            self.handleRefreshControllState(state: operationState)
        }
    }
    
    private func handleRefreshControllState(state: CRUD_OperationStates) {
        switch state {
        case .processing:
            self.followersViewModel.refreshProcess()
        case .done:
            self.refreshControllerActivationManager(active: false)
        }
    }
    
    private func dataFethingStateManager(state: TableViewState) {
        self.setLoadingAnimation(state)
        
        switch state {
        case .loading:
            print("loading")
            self.followersViewModel.getUserFollowersPageByPage2()
        case .populate:
            print("populate")
            self.reloadFollowersTableView()
        case .paging:
            print("paging")
            followersViewModel.fetchMoreProcess()
        default:
            return
        }
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state)
            
            switch state {
            case .populate, .paging:
                self.followersTableView.tableFooterView = nil
            default:
                self.followersTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func reloadFollowersTableView() {
        print("\(#function)")
        DispatchQueue.main.async {

            /*
            UIView.transition(with: self.followersTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.followersTableView.reloadData()
            })*/
            
            self.followersTableView.reloadData()
            
        }
    }
    
    /// Description : Check if a cell is loading state or not
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: boolean
    private func cellIsLoading(for indexPath: IndexPath) -> Bool {
        print("indexPath.row >= followersViewModel.currentFollowersArrayCount : \(indexPath.row >= followersViewModel.currentFollowersArrayCount)")
        print("indexPath.row : \(indexPath.row)")
        print("followersViewModel.currentFollowersArrayCount : \(followersViewModel.currentFollowersArrayCount)")
        return indexPath.row >= followersViewModel.currentFollowersArrayCount
        
    }
    
    private func getSearchHeaderListener() {
        searchBarHeaderView.getSearchActions { (searchTool) in
            print("searchTool : \(searchTool)")
            self.followersViewModel.searchTool.value = searchTool
        }
    }
    
    private func triggerSearchProcess(searchTool: SearchTools) {
        followersViewModel.searchFollowersInTableViewData(inputText: searchTool.searchText)
    }
    
    private func listenButtonProcessInCell(buttonProcessData: FollowRequestOperationData) {
        
        if buttonProcessData.buttonOperation == .more {
            switch buttonProcessData.operationState {
            case .done:
                DispatchQueue.main.async {
                    self.followersViewModel.removeFollowerFromFollowersArray(userid: buttonProcessData.requesterUserid)
                    
                    if let indexPath = self.findItemIndexPathInVisibleCell(followerUserid: buttonProcessData.requesterUserid) {
                        
                        self.followersTableView.beginUpdates()
                        
                        if buttonProcessData.buttonOperation == .more {
                            self.followersTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
                        }
                        
                        self.manageTableViewScrollProperty(active: true)
                        self.followersTableView.endUpdates()
                    }
                    
                }
            case .processing:
                self.manageTableViewScrollProperty(active: false)
            }
        }
    }
    
    private func findItemIndexPathInVisibleCell(followerUserid: String) -> IndexPath? {
        if let visibleIndexPath = followersTableView.indexPathsForVisibleRows {
            for item in visibleIndexPath {
                if let cell = followersTableView.cellForRow(at: item) as? FollowersTableViewCell {
                    if followerUserid == cell.returnCellUserid() {
                        return item
                    }
                }
            }
        }
        return nil
    }
    
    private func manageTableViewScrollProperty(active: Bool) {
        followersTableView.isScrollEnabled = active
    }
    
    private func setTitleData() {
        if let followerCount = followersViewModel.user.userFollowerCount {
            self.title = followerCount
        }
    }
    
    private func refreshControllerActivationManager(active: Bool) {
        
        DispatchQueue.main.async {
            guard let refreshControl = self.followersTableView.refreshControl else { return }
            
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    func listenTotalNumberOfFollowersChanges(completion : @escaping(_ count: Int) -> Void) {
        followersViewModel.totalNumberOfFollowers.bind(completion)
    }
    
    @objc func triggerRefreshProcess(_ sender: UIRefreshControl) {
        followersViewModel.refreshProcessState.value = .processing
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching
extension FollowersView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersViewModel.returnFollowerArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followersTableView.dequeueReusableCell(withIdentifier: FollowersTableViewCell.identifier, for: indexPath) as? FollowersTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: followersViewModel.returnFollowerArrayData(index: indexPath.row))
        
        cell.listenButtonOperations { (buttonProcessData) in
            self.listenButtonProcessInCell(buttonProcessData: buttonProcessData)
        }
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate
extension FollowersView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeigth = scrollView.contentSize.height
        
        if offsetY > (contentHeigth - scrollView.frame.height) {
            followersViewModel.state.value = .paging
        }
        
    }
}

// MARK: - MenuSlideItems
extension FollowersView: PageItems {
    var title: String? {
        get {
            return followersViewModel.user.userFollowerCount!
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return LocalizedConstants.TitleValues.LabelTitle.followers
        }
        set {
            _ = newValue
        }
    }
    
}
