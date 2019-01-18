//
//  FollowingsView.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowingsView: UIView {
    
    var followingsViewModel = FollowingsViewModel()
    
    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var followingsTableView: UITableView = {
        
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
        
        temp.register(FollowingsTableViewCell.self, forCellReuseIdentifier: FollowingsTableViewCell.identifier)
        
        return temp
        
    }()
    
    init(frame: CGRect, active: Bool) {
        super.init(frame: frame)
        self.active = active
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
        followingsViewModel.getUserFollowingsPageByPage(selectedProfileUserid: User.shared.userid!)
    }
    
    private func addFollowingsViewModelListener() {
        // add data fetching listener
        followingsViewModel.state.bind { (state) in
            self.dataFethingStateManager(state: state)
        }
        
        followingsViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
    }
    
    private func dataFethingStateManager(state: TableViewState) {
        self.setLoadingAnimation(state)
        
        switch state {
        case .populate:
            self.reloadFollowingsTableView()
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
                self.followingsTableView.tableFooterView = nil
            default:
                self.followingsTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func reloadFollowingsTableView() {
        print("\(#function)")
        DispatchQueue.main.async {
            //self.friendTableView.reloadData()
            UIView.transition(with: self.followingsTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.followingsTableView.reloadData()
            })
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
    
}

extension FollowingsView: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingsViewModel.returnFollowingArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followingsTableView.dequeueReusableCell(withIdentifier: FollowingsTableViewCell.identifier, for: indexPath) as? FollowingsTableViewCell else { return UITableViewCell() }
        
        if cellIsLoading(for: indexPath) {
            cell.initiateCellDesign(item: .none)
        } else {
            cell.initiateCellDesign(item: followingsViewModel.returnFollowingArrayData(index: indexPath.row))
            
            if indexPath.row % 2 == 0 {
                cell.followButton.setTitle("Follow", for: .normal)
            } else {
                cell.followButton.setTitle("Following", for: .normal)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: cellIsLoading) {
            followingsViewModel.getUserFollowingsPageByPage(selectedProfileUserid: User.shared.userid!)
        }
        
    }
    
}

// MARK: - MenuSlideItems
extension FollowingsView: PageItems {
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
            return "500"
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String {
        get {
            return LocalizedConstants.TitleValues.LabelTitle.following
        }
        set {
            _ = newValue
        }
    }
    
}
