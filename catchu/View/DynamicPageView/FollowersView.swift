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
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(FriendRelationTableViewCell.self, forCellReuseIdentifier: FriendRelationTableViewCell.identifier)
        
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
extension FollowersView {
    
    private func initializeViewSettings() {
        configureView()
        addViews()
        addHeaderViewToTableView()
        
    }
    
    private func configureView() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func addViews() {
        self.addSubview(followersTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            followersTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            followersTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            followersTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            followersTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    private func addHeaderViewToTableView() {
        followersTableView.tableHeaderView = searchBarHeaderView
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension FollowersView: UIGestureRecognizerDelegate {
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching
extension FollowersView: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("\(#function)")
    }
    
}

// MARK: - UISearchBarDelegate
extension FollowersView: UISearchBarDelegate {
    
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
