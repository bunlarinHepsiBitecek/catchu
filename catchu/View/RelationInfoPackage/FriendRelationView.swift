//
//  FriendRelationView.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationView: UIView {

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
    }
}

// MARK: - major functions
extension FriendRelationView {
    
    private func initializeViewSettings() {
    
        alphaManager(active: true)
        addViews()
        setupViewSettings()
        startGettingUserFriends()
        
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
    
    private func activationManager(active : Bool) {
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            self.alphaManager(active: active)
            
        }
    }
    
    private func alphaManager(active : Bool) {
        if active {
            self.alpha = 1
        } else {
            self.alpha = 0
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
        
    }
    
    private func startGettingUserFriends() {
        
        friendsViewModel.getUserFollowers()
        
    }
    
    private func reloadFriendTableView() {
        
        DispatchQueue.main.async {
            
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
        
        print("\(#function) starts")
        print("activation : \(activation)")
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            switch activation {
            case .enable:
                self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_100
            case .disable:
                self.friendSelectionViewHeightConstraint.constant = Constants.StaticViewSize.ViewSize.Height.height_0
            }
            
            self.layoutIfNeeded()
        }
        
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FriendRelationView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsViewModel.sectionTitle.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.StaticViewSize.ConstraintValues.constraint_60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsViewModel.friendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = friendTableView.dequeueReusableCell(withIdentifier: FriendRelationTableViewCell.identifier, for: indexPath) as? FriendRelationTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: friendsViewModel.friendArray[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = friendTableView.cellForRow(at: indexPath) as? FriendRelationTableViewCell
        
        cell?.setUserSelectionState(state: .selected)
        friendsViewModel.checkIfSelectedFriendExist()
        
    }
    
}
