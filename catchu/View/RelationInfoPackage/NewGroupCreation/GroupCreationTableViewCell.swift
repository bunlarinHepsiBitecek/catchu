//
//  GroupCreationTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupCreationTableViewCell: CommonTableCell {
    
    //var groupParticipantArray = [CommonViewModelItem]()
    private var tableViewCellViewModel = GroupCreationTableViewCellViewModel()
    
    // to sync participant count with tableView sectionHeader
    private var sectionHeaderViewModel: SectionHeaderViewModel?
    
    // to sync removed item with previous friend relation view
    private var friendGroupRelationViewModel: FriendGroupRelationViewModel?
    
    lazy var participantcollection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.Cell.minimumLineSpacing_10
        layout.minimumInteritemSpacing = Constants.Cell.minimumLineSpacing_10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        
        collectionView.contentInset = UIEdgeInsets(top: Constants.StaticViewSize.ConstraintValues.constraint_15, left: Constants.StaticViewSize.ConstraintValues.constraint_5, bottom: Constants.StaticViewSize.ConstraintValues.constraint_15, right: Constants.StaticViewSize.ConstraintValues.constraint_5)
        
        collectionView.register(GroupCreationParticipantCollectionViewCell.self, forCellWithReuseIdentifier: GroupCreationParticipantCollectionViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
        
    }()
    
    
    override func initializeCellSettings() {
        print("\(#function)")
        print("YARRO")
    }
    

}

// MARK: - major functions
extension GroupCreationTableViewCell {
    
    private func addViews() {
        self.contentView.addSubview(participantcollection)
        
        let safe = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            participantcollection.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            participantcollection.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            participantcollection.topAnchor.constraint(equalTo: safe.topAnchor),
            participantcollection.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    func startCreationOfCollectionView(groupParticipantArray: Array<CommonUserViewModel>, sectionHeaderViewModel: SectionHeaderViewModel, friendGroupRelationViewModel: FriendGroupRelationViewModel) {
        
        //self.groupParticipantArray = groupParticipantArray
        self.tableViewCellViewModel.groupParticipantArray = groupParticipantArray
        self.friendGroupRelationViewModel = friendGroupRelationViewModel
        self.sectionHeaderViewModel = sectionHeaderViewModel
        
        addViews()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
extension GroupCreationTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableViewCellViewModel.returnGroupParticipantArrayCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = participantcollection.dequeueReusableCell(withReuseIdentifier: GroupCreationParticipantCollectionViewCell.identifier, for: indexPath) as? GroupCreationParticipantCollectionViewCell else { return UICollectionViewCell() }
        
        cell.initiateCellDesign(item: tableViewCellViewModel.returnParticipant(index: indexPath.row))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: GroupCreationCellSizeCalculator.itemHeight, height: GroupCreationCellSizeCalculator.itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = participantcollection.cellForItem(at: indexPath) as? GroupCreationParticipantCollectionViewCell else { return }
        
        cell.setUserSelectionState(state: .deSelected)
        if let userViewModel = cell.userViewModel {
            
            if let friendGroupRelationViewModel = friendGroupRelationViewModel {
                friendGroupRelationViewModel.groupCreationRemovedParticipant.value = userViewModel
            }
            
            tableViewCellViewModel.removeItemFromGroupParticipantArray(removedItem: userViewModel)
            
            participantcollection.performBatchUpdates({
                participantcollection.deleteItems(at: [indexPath])
            }) { (finish) in
                self.sectionHeaderViewModel?.participantCount.value = self.tableViewCellViewModel.returnGroupParticipantArrayCount()
            }
        }
        
        
        /*
        if let userViewModel = cell.userViewModel {
            selectedFriendsViewModel.removeItemFromFriendArray(friend: userViewModel)
            selectedFriendCollectionView.performBatchUpdates({
                selectedFriendCollectionView.deleteItems(at: [indexPath])
            })
            
            if selectedFriendsViewModel.friendArray.count <= 0 {
                selectedFriendsViewModel.selectedFriendListEmpty.value = .disable
            }
            
        }*/
        
        
    }
    
    
}
