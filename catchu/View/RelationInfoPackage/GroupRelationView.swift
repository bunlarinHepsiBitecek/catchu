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
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        //temp.prefetchDataSource = self
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.rowHeight = UITableView.automaticDimension
        temp.tableFooterView = UIView()
        
        //temp.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_80, bottom: 0, right: 0)
        
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
        groupRelationViewModel.groupRelationOperationStates.unbind()
        groupRelationViewModel.newGroupAdded.unbind()
        groupRelationViewModel.searchTool.unbind()
    }
    
}

// MARK: - major functions
extension GroupRelationView {

    private func initializeView() {
        
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
        
        groupRelationViewModel.groupRelationOperationStates.bind { (operatinState) in
            switch operatinState {
            case .processing:
                print("processing....")
            case .done:
                DispatchQueue.main.async {
                    self.deleteSelectedRow()
                }
                print("done...")
            }
        }
        
        groupRelationViewModel.newGroupAdded.bind { (newCommonGroupViewModel) in
            // then add new item, it's automatically selected
            self.addNewGroupToArray(newGroup: newCommonGroupViewModel)
        }
        
        groupRelationViewModel.searchTool.bind { (searchTool) in
            self.searchProcessManager(searchTool: searchTool)
        }
        
    }
    
    private func searchProcessManager(searchTool: SearchTools) {
        if searchTool.searchIsProgress {
            if !searchTool.searchText.isEmpty {
                self.searchProcess(inputText: searchTool.searchText)
            }
        } else {
            groupRelationViewModel.triggerSectionTitleChange()
            self.reloadGroupTableView()
        }
    }
    
    private func searchProcess(inputText : String) {
        print("\(#function) starts")
        groupRelationViewModel.searchGroupInTableViewData(inputText: inputText)
        groupRelationViewModel.triggerSectionTitleChange()
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
            loadingView.setInformation(state, inputInformationText: LocalizedConstants.PostAttachmentInformation.gettingGroup)
            
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
    
    func getNewGroupOutside(newGroup: CommonGroupViewModel) {
        groupRelationViewModel.newGroupAdded.value = newGroup
    }
    
    private func addTransitionToPresentationOfFriendRelationViewController() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        if let window = self.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
    private func deleteSelectedRow() {
        
        guard let selectedGroupIndexPath = groupRelationViewModel.selectedGroupData.selectedGroupIndexPath else { return }
        
        print("selectedGroupIndexPath : \(selectedGroupIndexPath)")
        
        self.groupTableView.beginUpdates()
        self.groupTableView.deleteRows(at: [selectedGroupIndexPath], with: UITableView.RowAnimation.middle)
        self.groupTableView.endUpdates()
        
    }
    
    private func addNewGroupToArray(newGroup: CommonViewModelItem) {
        self.groupRelationViewModel.addNewGroup(newGroup: newGroup)
        
        guard let newGroupCommonGroupViewModel = newGroup as? CommonGroupViewModel else { return }
        
        let lastIndexPath = IndexPath(row: self.groupRelationViewModel.returnGroupArrayCount() - 1, section: 0)

        DispatchQueue.main.async {
            self.groupRelationViewModel.deselectAllGroup()
            self.groupTableView.reloadData()
            self.groupTableView.selectRow(at: lastIndexPath, animated: true, scrollPosition: .bottom)
            
            newGroupCommonGroupViewModel.groupSelected.value = .selected
            
            self.groupRelationViewModel.convertSelectedGroupViewModelToGroupList()
        }

    }
    
}

// MARK: - functions called outside
extension GroupRelationView {
    
    func triggerSearchProcess(searchTool: SearchTools) {
        groupRelationViewModel.searchTool.value = searchTool
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupRelationView : UITableViewDelegate, UITableViewDataSource {
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.StaticViewSize.ConstraintValues.constraint_60
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupRelationViewModel.sectionTitle.value.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupRelationViewModel.returnGroupArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: GroupRelationTableViewCell.identifier, for: indexPath) as? GroupRelationTableViewCell else { return UITableViewCell() }
    
        cell.initiateCellDesign(item: groupRelationViewModel.returnGroupArrayData(index: indexPath.row))

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell else { return }
        
        groupRelationViewModel.deselectAllGroup()
        
        cell.setGroupSelectionState(state: .selected)
        
        print("cell group id : \(cell.groupViewModel?.group?.groupID)")
        
        groupRelationViewModel.convertSelectedGroupViewModelToGroupList()
        
    }
    
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell else { return }
        cell.setGroupSelectionState(state: .deSelected)
        
        groupRelationViewModel.convertSelectedGroupViewModelToGroupList()
    }*/
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = groupTableView.cellForRow(at: indexPath) as? GroupRelationTableViewCell
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: LocalizedConstants.TableViewRowActionTitles.delete) { (action, indexPath) in
            print("action : \(action)")
            print("indexPath : \(indexPath)")
            
            //AlertControllerManager.shared.startActionSheetManager(type: ActionControllerType.groupInformation, operationType: nil, delegate: self)
            
        }
        
        let moreInformationAction = UITableViewRowAction(style: .normal, title: LocalizedConstants.TableViewRowActionTitles.more) { (action, indexPath) in
            print("action : \(action)")
            print("indexPath : \(indexPath)")
            
            //self.groupRelationViewModel.infoRequestedGroup = cell?.returnCellGroupViewModel()
            
            guard let groupViewModelRetrievedFromCell = cell?.returnCellGroupViewModel() else { return }
            
            self.groupRelationViewModel.setSelectedGroupData(groupViewModel: groupViewModelRetrievedFromCell, indexPath: indexPath)
            
            AlertControllerManager.shared.startActionSheetManager(type: ActionControllerType.groupInformation, operationType: nil, delegate: self, title: nil)
        }
        
        return [deleteAction, moreInformationAction]
        
    }
    
}

// MARK: - ActionSheetProtocols
extension GroupRelationView : ActionSheetProtocols {
    func presentViewController() {
        
        if let currentViewController = LoaderController.currentViewController() {
            
            addTransitionToPresentationOfFriendRelationViewController()
            
            let groupInfoViewController = GroupInfoViewController()
            //groupInfoViewController.groupViewModel = groupRelationViewModel.infoRequestedGroup
            groupInfoViewController.groupViewModel = groupRelationViewModel.selectedGroupData.selectedGroupViewModel
            
            currentViewController.present(groupInfoViewController, animated: false, completion: nil)
            
        }
        
    }
    
    func exitFromGroup() {
        
        groupRelationViewModel.exitGroup()
        
    }
}
