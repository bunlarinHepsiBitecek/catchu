//
//  FriendRelationView.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationView: UIView {

    private var tempFlag = true
    // view model
    private let friendsViewModel = FriendsViewModel()
    
    // views
    private var friendSelectionView: FriendRelationSelectionView!
    private var friendSelectionViewHeightConstraint = NSLayoutConstraint()
    
    lazy var friendTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        //temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(FriendRelationTableViewCell.self, forCellReuseIdentifier: FriendRelationTableViewCell.identifier)
        
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
        friendsViewModel.state.unbind()
        friendsViewModel.selectedListActivationState.unbind()
        friendsViewModel.selectedFrientCount.unbind()
        friendsViewModel.totalFriendCount.unbind()
        friendsViewModel.selectedUserList.unbind()
    }
}

// MARK: - major functions
extension FriendRelationView {
    
    // to manage visibilty of view
    func viewActivationManager(active : Bool, animated: Bool) {
        
        if animated {
            UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                if active {
                    self.alpha = 1
                } else {
                    self.alpha = 0
                }
            })
        } else {
            
            if active {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
            
        }
        
    }
    
    private func initializeViewSettings() {
    
        addViews()
        setupViewSettings()
        startGettingUserFriends()
        addSelectedFriendListObservers()
        viewActivationManager(active: false, animated: false)
        
    }
    
    private func addViews() {
        addFriendSelectionView()
        addFriendTableView()
    }
    
    private func addFriendTableView() {
        
        self.addSubview(friendTableView)
        
        let safe = self.safeAreaLayoutGuide
        let safeFriendSelection = self.friendSelectionView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            friendTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendTableView.topAnchor.constraint(equalTo: safeFriendSelection.bottomAnchor),
            friendTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addFriendSelectionView() {
        
        friendSelectionView = FriendRelationSelectionView()
        friendSelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(friendSelectionView)
        
        let safe = self.safeAreaLayoutGuide
        
        friendSelectionViewHeightConstraint = friendSelectionView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_0)
        
        NSLayoutConstraint.activate([
            
            friendSelectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            friendSelectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendSelectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendSelectionViewHeightConstraint,
            
            ])
    }
    
    private func addSelectedFriendListObservers() {
        friendSelectionView.startObservingSelectedFriendList { (activationInfo) in
            self.friendsViewModel.selectedListActivationState.value = activationInfo
        }
        
    }
    
    // listens selected friend collection view
    func addSelectedFriendCountObserver(completion : @escaping (_ counter : Int) -> Void) {
        friendSelectionView.startObservingSelectedFriendListCount { (counter) in
            // this method listens friendrelationselectionview collectionview selected friend count.Thats why when we return selected count, we can ask total userlist from this view - friendrelationview -, and this view listener return friendgrouprelationview updated user list
            self.friendsViewModel.convertSelectedFriendListToUserList()
            completion(counter)
        }
    }
    
    private func setupViewSettings() {
        
        print("\(#function) starts")
        
        // there is not need to to get fire listener
        friendsViewModel.state.bind { (state) in
            
            self.setLoadingAnimation(state)
            
            switch state {
            case .populate:
                print("tableView is ready to load")
                self.reloadFriendTableView()
            default:
                //self.setLoadingAnimation(state)
                break
            }
            
        }
        
        // bind selected friend collection animation
        friendsViewModel.selectedListActivationState.bind { (animation) in
            self.friendSelectionCollectionAnimation(activation: animation)
        }
        
        friendsViewModel.sectionTitle.bindAndFire { (sectionTitle) in
            print("sectionTitle :\(sectionTitle.rawValue)")
            
        }
        
        
    }
    
    private func startGettingUserFriends() {
        
        //friendsViewModel.getUserFollowers(page: 1)
        friendsViewModel.getUserFollowersPageByPage()
        
    }
    
    private func reloadFriendTableView() {
        
        DispatchQueue.main.async {
            
            self.friendTableView.reloadData()
            /*
            UIView.transition(with: self.friendTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.friendTableView.reloadData()
                
            })*/
        }
        
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state)
            
            switch state {
            case .populate:
                self.friendTableView.tableFooterView = nil
            default:
                self.friendTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    private func friendSelectionCollectionAnimation(activation: CollectionViewActivation) {
        
        print("\(#function) starts")
        print("activation : \(activation)")
        print("KAKAKAKAKAKA")
        switch activation {
        case .enable:
            self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_100
        case .disable:
            self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_0
        }
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            self.layoutIfNeeded()
        }
        
        /*
        UIView.transition(with: friendSelectionView, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
            
            self.layoutIfNeeded()
            
        })*/
        
    }
    
    func startObserverForSelectedFriendCount(completion : @escaping (_ counter : Int) -> Void) {
        
        friendsViewModel.selectedFrientCount.bind { (counter) in
            completion(counter)
        }
        
    }
    
    func startObserverForTotalFriendCount(completion : @escaping (_ counter : Int) -> Void) {
        
        friendsViewModel.totalFriendCount.bind { (totalCount) in
            completion(totalCount)
        }
        
    }
    
    func startObserverForSelectedUserList(completion : @escaping (_ userList : [User]) -> Void) {
        
        friendsViewModel.selectedUserList.bind { (userList) in
            completion(userList)
        }
        
    }
    
    private func selectedFriendListAnimationManagement(_ cell: FriendRelationTableViewCell) {
        if friendsViewModel.returnSelectedFriendCount() == 1 {
            
            friendsViewModel.checkIfSelectedFriendExist()
            if let userViewModel = cell.userViewModel {
                friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
            }
            
        } else if friendsViewModel.returnSelectedFriendCount() == 0 {
            if let userViewModel = cell.userViewModel {
                friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
            }
            friendsViewModel.checkIfSelectedFriendExist()
            
        } else {
            
            if let userViewModel = cell.userViewModel {
                friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
            }
        }
    }
    
    func searchTrigger(inputText : String) {
        print("\(#function) starts")
        
        friendsViewModel.searchFriendInTableViewData(inputText: inputText)
        
        
    }
    
    // check if a cell is loading state or not
    private func cellIsLoading(for indexPath : IndexPath) -> Bool {
        return indexPath.row >= friendsViewModel.currentFriendCount
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FriendRelationView: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {

    // section title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsViewModel.sectionTitle.value.rawValue
    }
    
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.StaticViewSize.ConstraintValues.constraint_60
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returning the total number of friends directly getting from the server
        return friendsViewModel.totalNumberOfFriends
    }
    
    // cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        print("\(#function)")
        print("indexPath : \(indexPath)")
        
        guard let cell = friendTableView.dequeueReusableCell(withIdentifier: FriendRelationTableViewCell.identifier, for: indexPath) as? FriendRelationTableViewCell else { return UITableViewCell() }
        
        if cellIsLoading(for: indexPath) {
            print("cell is loading process")
            cell.initiateCellDesign(item: .none)
        } else {
            cell.initiateCellDesign(item: friendsViewModel.friendArray[indexPath.row])
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = friendTableView.cellForRow(at: indexPath) as? FriendRelationTableViewCell
        
        guard let cell = friendTableView.cellForRow(at: indexPath) as? FriendRelationTableViewCell else { return }
        
        cell.setUserSelectionState(state: .selected)
        selectedFriendListAnimationManagement(cell)
        friendsViewModel.findSelectedFriendCount()
        friendsViewModel.convertSelectedFriendListToUserList()
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("\(#function)")
        print("indexPaths : \(indexPaths)")
        if indexPaths.contains(where: cellIsLoading) {
            friendsViewModel.getUserFollowersPageByPage()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("\(#function)")
        print("indexPath : \(indexPaths)")
    }
    
}

