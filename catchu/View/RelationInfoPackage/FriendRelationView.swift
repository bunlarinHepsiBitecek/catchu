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
    
    private var participantArray: Array<User>?
    private var friendRelationPurpose: FriendRelationViewPurpose?
    
    lazy var friendTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.rowHeight = UITableView.automaticDimension
        temp.tableFooterView = UIView()
        
//        temp.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_80, bottom: 0, right: 0)
        //temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(FriendRelationTableViewCell.self, forCellReuseIdentifier: FriendRelationTableViewCell.identifier)
        
        return temp
        
    }()
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }*/
    
    init(frame: CGRect, participantArray: Array<User>?, friendRelationPurpose: FriendRelationViewPurpose?) {
        super.init(frame: frame)
        
        if let participantArray = participantArray {
            self.participantArray = participantArray
        }
        
        if let friendRelationPurpose = friendRelationPurpose {
            self.friendRelationPurpose = friendRelationPurpose
        }
        
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
        friendsViewModel.searchTool.unbind()
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
        addFriendViewModelListener()
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
    
    private func addFriendViewModelListener() {
        
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
        
        friendsViewModel.searchTool.bind { (searchTools) in
            self.searchProcessManager(searchTool: searchTools)
        }
        
    }
    
    private func searchProcessManager(searchTool: SearchTools) {
        if searchTool.searchIsProgress {
            if !searchTool.searchText.isEmpty {
                self.searchProcess(inputText: searchTool.searchText)
            }
        } else {
            friendsViewModel.triggerSectionTitleChange()
            self.reloadFriendTableView()
        }
    }
    
    private func searchProcess(inputText : String) {
        print("\(#function) starts")
        friendsViewModel.searchFriendInTableViewData(inputText: inputText)
        friendsViewModel.triggerSectionTitleChange()
    }
    
    private func startGettingUserFriends() {
        
        //friendsViewModel.getUserFollowers(page: 1)
        friendsViewModel.getUserFollowersPageByPage()
        
    }
    
    private func reloadFriendTableView() {
        print("\(#function) TAKAKAKAKAKAKA")
        DispatchQueue.main.async {
            
            //self.friendTableView.reloadData()
            UIView.transition(with: self.friendTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.friendTableView.reloadData()
                
            })
            
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
        
        switch activation {
        case .enable:
            self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_100
        case .disable:
            self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_0
        }
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            self.layoutIfNeeded()
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
    
    func selectedFriendListAnimationManagement2(_ userViewModel: CommonUserViewModel) {
        if friendsViewModel.returnSelectedFriendCount() == 1 {
            print("PASS 1")
            friendsViewModel.checkIfSelectedFriendExist()
            friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
            
        } else if friendsViewModel.returnSelectedFriendCount() == 0 {
            print("PASS 2")
            friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
            friendsViewModel.checkIfSelectedFriendExist()
            
        } else {
            print("PASS 3")
            friendSelectionView.informSelectedFriendCollectionView(selectedItem: userViewModel)
        }
    }
    
    
    // check if a cell is loading state or not
    private func cellIsLoading(for indexPath : IndexPath) -> Bool {
        return indexPath.row >= friendsViewModel.currentFriendCount
    }
    
    private func checkIfParticipantUserExist(commonViewModelItem: CommonViewModelItem) -> Bool {
        
        guard let friendRelationPurpose = friendRelationPurpose else { return false }
        guard let participantArray = participantArray else { return false }
        
        guard let commonUserViewModel = commonViewModelItem as? CommonUserViewModel else { return false }
        guard let user = commonUserViewModel.user else { return false }
        
        if friendRelationPurpose == .participant {
            for item in participantArray {
                if user.userid == item.userid {
                    commonUserViewModel.userSelected.value = .alreadyGroupParticipant
                    return true
                }
            }
        }
        
        return false
        
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
    
    func startObserverForSelectedCommonUserViewModelList(completion : @escaping (_ commonUserViewModelList: [CommonUserViewModel]) -> Void) {
        
        friendsViewModel.selectedCommonUserViewModel.bind { (commonUserViewModelList) in
            completion(commonUserViewModelList)
        }
        
    }
    
    func callTriggerCollectionClear(active : Bool) {
        friendSelectionView.triggerCollectionClear(active: active)
    }
    
    func closeFriendSelectionCollectionView(activation : CollectionViewActivation) {
        friendsViewModel.selectedListActivationState.value = activation
    }
    
}

// MARK: - functions called outside
extension FriendRelationView {
    
    func triggerSearchProcess(searchTool: SearchTools) {
        friendsViewModel.searchTool.value = searchTool
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
        return friendsViewModel.returnFriendArrayCount()
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
            //checkIfParticipantUserExist(commonViewModelItem: friendsViewModel.returnFriendArrayData(index: indexPath.row))
            
            cell.initiateCellDesign(item: friendsViewModel.returnFriendArrayData(index: indexPath.row))
            
            if checkIfParticipantUserExist(commonViewModelItem: friendsViewModel.returnFriendArrayData(index: indexPath.row)) {
                cell.disableCell()
            }
            
            /*
             bu fonksiyonu kapattık, cunku initiateCellDesign icerisindeki bindAndFire tableviewstate deselect select komutlarını main thread icerisinde queue alıyor. burada biz ana akısta cell icerisindeki datayı hızlı bir sekilde set ediyoruz. Fakat queue daki data daha sonra kumule calısınca bizim gri check isaretimizi nil yapıyor.
            if checkIfParticipantUserExist(commonViewModelItem: friendsViewModel.returnFriendArrayData(index: indexPath.row)) {
                cell.disableCell()
            }*/
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = friendTableView.cellForRow(at: indexPath) as? FriendRelationTableViewCell
        
        guard let cell = friendTableView.cellForRow(at: indexPath) as? FriendRelationTableViewCell else { return }
        
        cell.setUserSelectionState(state: .selected)
        
        print("cell friend userid : \(cell.userViewModel?.user?.userid)")
        
        //selectedFriendListAnimationManagement(cell)
        selectedFriendListAnimationManagement2(cell.userViewModel!)
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

