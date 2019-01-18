//
//  FollowersView.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowersView: UIView {
    
    var followersViewModel = FollowersViewModel()
    
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
        temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.none
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(FollowersTableViewCell.self, forCellReuseIdentifier: FollowersTableViewCell.identifier)
        
        return temp
        
    }()

    init(frame: CGRect, active: Bool) {
        super.init(frame: frame)
        self.active = active
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
        followersViewModel.totalFollowersCount.unbind()
        followersViewModel.searchTool.unbind()
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
        followersViewModel.getUserFollowersPageByPage(selectedProfileUserid: User.shared.userid!)
    }
    
    private func addFriendViewModelListener() {
        // add data fetching listener
        followersViewModel.state.bind { (state) in
            self.dataFethingStateManager(state: state)
        }
        
        followersViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
    }
    
    private func dataFethingStateManager(state: TableViewState) {
        self.setLoadingAnimation(state)
        
        switch state {
        case .populate:
            self.reloadFollowersTableView()
        default:
            return
        }
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state)
            
            switch state {
            case .populate:
                self.followersTableView.tableFooterView = nil
            default:
                self.followersTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func reloadFollowersTableView() {
        print("\(#function)")
        DispatchQueue.main.async {
            //self.friendTableView.reloadData()
            UIView.transition(with: self.followersTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.followersTableView.reloadData()
            })
        }
    }
    
    /// Description : Check if a cell is loading state or not
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: boolean
    private func cellIsLoading(for indexPath: IndexPath) -> Bool {
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
    
    private func listenButtonProcessInCell(buttonProcessData: FollowerCellButtonProcessData) {
        
        if buttonProcessData.buttonOperation == .more {
            switch buttonProcessData.state {
            case .done:
                // remove cell from followers list
                print("takasi more a bastı")
                return
            default:
                return
            }
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching
extension FollowersView: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersViewModel.returnFollowerArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followersTableView.dequeueReusableCell(withIdentifier: FollowersTableViewCell.identifier, for: indexPath) as? FollowersTableViewCell else { return UITableViewCell() }
        
        if cellIsLoading(for: indexPath) {
            cell.initiateCellDesign(item: .none)
        } else {
            cell.initiateCellDesign(item: followersViewModel.returnFollowerArrayData(index: indexPath.row))
        }
        
        cell.listenButtonOperations { (buttonProcessData) in
            self.listenButtonProcessInCell(buttonProcessData: buttonProcessData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: cellIsLoading) {
            followersViewModel.getUserFollowersPageByPage(selectedProfileUserid: User.shared.userid!)
        }
        
    }
    
}

// MARK: - MenuSlideItems
extension FollowersView: PageItems {
    var active: Bool {
        get {
            return false
        }
        set {
            _ = newValue
        }
    }
    
    var title: String {
        get {
            return "300"
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String {
        get {
            return LocalizedConstants.TitleValues.LabelTitle.followers
        }
        set {
            _ = newValue
        }
    }
}
