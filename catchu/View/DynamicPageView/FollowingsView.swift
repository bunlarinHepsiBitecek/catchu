//
//  FollowingsView.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowingsView: UIView {
    
    var followingsViewModel: FollowingsViewModel!
    
    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var followingsTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
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
        
        temp.register(FollowingsTableViewCell.self, forCellReuseIdentifier: FollowingsTableViewCell.identifier)
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(FollowingsView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()
    
    init(frame: CGRect, user: User) {
        super.init(frame: frame)
        followingsViewModel = FollowingsViewModel(user: user)
        initializeViewSettings()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FollowingsView {
    
    private func initializeViewSettings() {
        addFollowingsViewModelListener()
        configureView()
        addViews()
        addHeaderViewToTableView()
        startGettingUserFollowings()
        getSearchHeaderListener()
        setTitleData()
        
    }
    
    private func configureView() {
        self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    private func addViews() {
        self.addSubview(followingsTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            followingsTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            followingsTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            followingsTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            followingsTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    private func addHeaderViewToTableView() {
        followingsTableView.tableHeaderView = searchBarHeaderView
    }
    
    private func startGettingUserFollowings() {
        followingsViewModel.state.value = .loading
    }
    
    private func addFollowingsViewModelListener() {
        // add data fetching listener
        followingsViewModel.state.bind { (state) in
            self.dataFethingStateManager(state: state)
        }
        
        followingsViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
        
        followingsViewModel.refreshProcessState.bind { (operationState) in
            self.handleRefreshControllState(state: operationState)
        }
    }
    
    private func handleRefreshControllState(state: CRUD_OperationStates) {
        switch state {
        case .processing:
            self.followingsViewModel.refreshProcess()
        case .done:
            self.refreshControllerActivationManager(active: false)
        }
    }
    
    private func dataFethingStateManager(state: TableViewState) {
        self.setLoadingAnimation(state)
        
        switch state {
        case .loading:
            print("loading")
            self.followingsViewModel.getUserFollowingsPageByPage()
        case .populate:
            print("populate")
            self.reloadFollowingsTableView()
        case .paging:
            print("paging")
            followingsViewModel.fetchMoreProcess(selectedProfileUserid: User.shared.userid!)
            
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
                self.followingsTableView.tableFooterView = nil
            default:
                self.followingsTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func reloadFollowingsTableView() {
        print("\(#function)")
        DispatchQueue.main.async {
            /*
            UIView.transition(with: self.followingsTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.followingsTableView.reloadData()
            })*/
            
            self.followingsTableView.reloadData()
        }
    }
    
    /// Description : Check if a cell is loading state or not
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: boolean
    private func cellIsLoading(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= followingsViewModel.currentFollowingsArrayCount
        
    }
    
    private func getSearchHeaderListener() {
        searchBarHeaderView.getSearchActions { (searchTool) in
            print("searchTool : \(searchTool)")
            self.followingsViewModel.searchTool.value = searchTool
        }
    }
    
    private func triggerSearchProcess(searchTool: SearchTools) {
        followingsViewModel.searchFollowingsInTableViewData(inputText: searchTool.searchText)
    }
    
    private func setTitleData() {
        if let followingCount = followingsViewModel.user.userFollowingCount {
            self.title = followingCount
        }
    }
    
    private func refreshControllerActivationManager(active: Bool) {
        
        DispatchQueue.main.async {
            guard let refreshControl = self.followingsTableView.refreshControl else { return }
            
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    func listenTotalNumberOfFollowingsChanges(completion : @escaping(_ count: Int) -> Void) {
        followingsViewModel.totalFollowingsCount.bind(completion)
    }
    
    @objc func triggerRefreshProcess(_ sender: UIRefreshControl) {
        followingsViewModel.refreshProcessState.value = .processing
    }
    
}

extension FollowingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingsViewModel.returnFollowingArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followingsTableView.dequeueReusableCell(withIdentifier: FollowingsTableViewCell.identifier, for: indexPath) as? FollowingsTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: followingsViewModel.returnFollowingArrayData(index: indexPath.row))
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate
extension FollowingsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeigth = scrollView.contentSize.height
        
        if offsetY > (contentHeigth - scrollView.frame.height) {
            followingsViewModel.state.value = .paging
        }
        
    }
}

// MARK: - MenuSlideItems
extension FollowingsView: PageItems {
    var title: String? {
        get {
            return followingsViewModel.user.userFollowingCount!
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return LocalizedConstants.TitleValues.LabelTitle.following
        }
        set {
            _ = newValue
        }
    }
    
}
