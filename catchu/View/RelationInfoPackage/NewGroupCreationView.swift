//
//  NewGroupCreationView.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class NewGroupCreationView: UIView {
    
    private var groupCreationViewModel = GroupCreationViewModel()

    private var headerView = NewGroupCreationHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.StaticViewSize.ViewSize.Height.height_150), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    
    private var sectionView = GroupCreationSectionHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.StaticViewSize.ViewSize.Height.height_40))
    
    lazy var addedParticipantTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.rowHeight = UITableView.automaticDimension
        temp.tableHeaderView = headerView
        temp.tableFooterView = UIView()
        temp.separatorStyle = .none
        
        temp.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_80, bottom: 0, right: 0)
        //temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(GroupCreationTableViewCell.self, forCellReuseIdentifier: GroupCreationTableViewCell.identifier)
        
        return temp
        
    }()
    
    init(frame: CGRect, selectedCommonUserViewModelList: Array<CommonUserViewModel>, friendGroupRelationViewModel: FriendGroupRelationViewModel) {
        super.init(frame: frame)
        
        // sync group creation view model with friend relation views (selected users to create new group) selected new participant objects
        groupCreationViewModel.selectedCommonUserViewModelList = selectedCommonUserViewModelList
        groupCreationViewModel.friendGroupRelationViewModel = friendGroupRelationViewModel
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension NewGroupCreationView {
    
    private func initializeView() {
        addViews()
        setTotalParticipantCountToSectionHeader()
        addInputViewToHeaderView()
    }
    
    private func addViews() {
        
        self.addSubview(addedParticipantTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            addedParticipantTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            addedParticipantTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            addedParticipantTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            addedParticipantTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func setTotalParticipantCountToSectionHeader() {
        sectionView.giveSelectedParticipantCount(count: groupCreationViewModel.returnNumberOfSelectedCommonUserViewModelList())
    }
    
    func addTotalParticipantCountListener(completion : @escaping (_ count : Int) -> Void) {
        groupCreationViewModel.totalParticipantCount.bind { (count) in
            completion(count)
        }
    }
    
    func addHeaderViewListeners(completion : @escaping (_ filled : Bool) -> Void) {
        headerView.addGroupNameTextFieldFilledListener(completion: completion)
    }
    
    func addGroupNameListener(completion: @escaping (_ groupName: String) -> Void) {
        headerView.addGroupNameListener(completion: completion)
    }
    
    func addGroupImageListener(completion: @escaping (_ groupImage: UIImage) -> Void) {
        headerView.addGroupImageListener(completion: completion)
    }
    
    func addGroupImagePickerListener(completion: @escaping (_ imagePickerData: ImagePickerData) -> Void) {
        headerView.addGroupImagePickerListener(completion: completion)
    }
    
    private func addInputViewToHeaderView() {
        headerView.setInputView(inputView: self)
    }
    
}

extension NewGroupCreationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.NumericConstants.INTEGER_ONE
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.NumericConstants.INTEGER_ONE
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return GroupCreationCellSizeCalculator.shared.calculateContentSizeForTableRowHeight(inputItemCount: groupCreationViewModel.returnNumberOfSelectedCommonUserViewModelList())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = addedParticipantTableView.dequeueReusableCell(withIdentifier: GroupCreationTableViewCell.identifier, for: indexPath) as? GroupCreationTableViewCell else { return UITableViewCell() }
        
        cell.startCreationOfCollectionView(groupParticipantArray: groupCreationViewModel.selectedCommonUserViewModelList, sectionHeaderViewModel: sectionView.sectionHeaderViewModel, friendGroupRelationViewModel: groupCreationViewModel.friendGroupRelationViewModel!, groupCreationViewModel : groupCreationViewModel)
        
        return cell
        
    }
    
    
    
}
