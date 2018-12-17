//
//  GroupRelationView.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupRelationView: UIView {
    
    // view model
    private let groupRelationViewModel = GroupRelationViewModel()
    
    lazy var groupTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        //temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        //temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(GroupRelationTableViewCell.self, forCellReuseIdentifier: GroupRelationTableViewCell.identifier)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        groupRelationViewModel.state.unbind()
        groupRelationViewModel.sectionTitle.unbind()
        groupRelationViewModel.selectedGroupList.unbind()
    }
    
}

// MARK: - major functions
extension GroupRelationView {

    private func initializeView() {
        
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        viewActivationManager(active: true, animated: false)
        
        addViews()
        setupGroupRelationViewModelListeners()
        startGettingUserGroups()
        
    }
    
    private func addViews() {
        addGroupTableView()
    }
    
    private func addGroupTableView() {
        print("\(#function)")
        
        self.addSubview(groupTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            groupTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func setupGroupRelationViewModelListeners() {
        // add listener for tableview state
        groupRelationViewModel.state.bind { (state) in
            
            self.setLoadingAnimation(state)
            
            switch state {
            case .populate:
                self.reloadGroupTableView()
            default:
                return
            }
            
        }
        
    }
    
    private func startGettingUserGroups() {
        groupRelationViewModel.getGroups()
    }
    
    private func reloadGroupTableView() {
        
        DispatchQueue.main.async {
            UIView.transition(with: self.groupTableView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                self.groupTableView.reloadData()
             
             })
        }
        
    }
    
    private func setLoadingAnimation(_ state : TableViewState) {
        
        DispatchQueue.main.async {
            let loadingView = RelationCollectionLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Height.height_50))
            loadingView.setInformation(state)
            
            switch state {
            case .populate:
                self.groupTableView.tableFooterView = nil
            default:
                self.groupTableView.tableFooterView = loadingView
            }
        }
        
    }
    
    /// Description : used to manage visibility of view itself. It's public function, because it can be call outside of the class as well.
    ///
    /// - Parameter active: boolean value to make view visible or invisible
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
    
    func startObservingForSelectedGroup(completion: @escaping (_ groupList : [Group]) -> Void) {
        groupRelationViewModel.selectedGroupList.bind { (groupList) in
            completion(groupList)
        }
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
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupRelationView : UITableViewDelegate, UITableViewDataSource {
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.StaticViewSize.ConstraintValues.constraint_60
    }*/
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupRelationViewModel.sectionTitle.value.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupRelationViewModel.groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: GroupRelationTableViewCell.identifier, for: indexPath) as? GroupRelationTableViewCell else { return UITableViewCell() }
    
        cell.initiateCellDesign(item: groupRelationViewModel.groupArray[indexPath.row])

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell else { return }
        cell.setGroupSelectionState(state: .selected)
        
        groupRelationViewModel.convertSelectedGroupViewModelToGroupList()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell else { return }
        cell.setGroupSelectionState(state: .deSelected)
        
        groupRelationViewModel.convertSelectedGroupViewModelToGroupList()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: LocalizedConstants.TableViewRowActionTitles.delete) { (action, indexPath) in
            print("action : \(action)")
            print("indexPath : \(indexPath)")
        }
        
        let moreInformationAction = UITableViewRowAction(style: .normal, title: LocalizedConstants.TableViewRowActionTitles.more) { (action, indexPath) in
            print("action : \(action)")
            print("indexPath : \(indexPath)")
            
            self.groupRelationViewModel.infoRequestedGroup = cell?.returnCellGroupViewModel()
            
            /*
            if let cell = cell {
                if let group = cell.returnCellRelatedGroup() {
                    self.groupRelationViewModel.infoRequestedGroup = group
                }
            }*/
            
            AlertControllerManager.shared.startActionSheetManager(type: ActionControllerType.groupInformation, operationType: nil, delegate: self)
        }
        
        return [deleteAction, moreInformationAction]
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: GroupRelationTableViewCell.identifier, for: indexPath) as? GroupRelationTableViewCell else { return }
//
//    }
    
    
}

// MARK: - ActionSheetProtocols
extension GroupRelationView : ActionSheetProtocols {
    func presentViewController() {
        
        groupRelationViewModel.infoRequestedGroup?.groupNameChanged.value = "erkut"
        
        if let currentViewController = LoaderController.currentViewController() {
            
            addTransitionToPresentationOfFriendRelationViewController()
            
            let groupInfoViewController = GroupInfoViewController()
            groupInfoViewController.groupViewModel = groupRelationViewModel.infoRequestedGroup
            
            if let groupViewModel = groupRelationViewModel.infoRequestedGroup {
                if let group = groupViewModel.group {
                    groupInfoViewController.group = group
                }
            }
            
            currentViewController.present(groupInfoViewController, animated: false, completion: nil)
            
        }
        
    }
}
