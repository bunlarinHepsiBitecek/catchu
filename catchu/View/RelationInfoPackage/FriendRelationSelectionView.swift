//
//  FriendRelationSelectionView.swift
//  catchu
//
//  Created by Erkut Baş on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationSelectionView: UIView {

    private let selectedFriendsViewModel = SelectedFriendsViewModel()
    
    lazy var selectedFriendCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.minimumLineSpacing_Zero
        layout.minimumInteritemSpacing = Constants.Cell.minimumLineSpacing_Zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        
        collectionView.register(FriendRelationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: FriendRelationSelectionCollectionViewCell.identifier)

        return collectionView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        selectedFriendsViewModel.selectedFriendListEmpty.unbind()
        selectedFriendsViewModel.selectedFriendListCount.unbind()
        
    }
    
}

// MARK: - major functions
extension FriendRelationSelectionView {
    
    private func initiateView() {
        addViews()
        //setupViewSettings()
    }
    
    private func addViews() {
        
        addCollectionView()
        
    }
    
    private func addCollectionView() {
    
        self.addSubview(selectedFriendCollectionView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            selectedFriendCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            selectedFriendCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            selectedFriendCollectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            selectedFriendCollectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    /*
    private func setupViewSettings() {
        
        selectedFriendsViewModel.operation.bind { (operation) in
            self.collectionViewItemManager(operation: operation)
        }
        
    }
    
    private func collectionViewItemManager(operation : CollectionViewOperation) {
        print("\(#function) starts")
        
    }*/
    
    private func deSelectProcessOfItemInCollectionView(_ selectedItem: CommonUserViewModel) {
        selectedFriendsViewModel.removeItemFromFriendArray(friend: selectedItem)
        
        for indexPath in selectedFriendCollectionView.indexPathsForVisibleItems {
            
            guard let cell = selectedFriendCollectionView.cellForItem(at: indexPath) as? FriendRelationSelectionCollectionViewCell else { return }
            
            if let userViewModel = cell.userViewModel {
                if userViewModel.user?.userid == selectedItem.user?.userid {
                    selectedFriendCollectionView.performBatchUpdates({
                        selectedFriendCollectionView.deleteItems(at: [indexPath])
                    })
                    return
                }
                
            }
            
        }
        
        selectedFriendCollectionView.reloadData()
        selectedFriendCollectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    private func selectProcessOfItemInCollectionView(_ selectedItem: CommonUserViewModel) {
        
        selectedFriendCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: selectedFriendsViewModel.friendArray.count, section: 0)
            selectedFriendsViewModel.appendItemToFriendArray(friend: selectedItem)
            selectedFriendCollectionView.insertItems(at: [indexPath])
            
        })
        
    }
    
    func informSelectedFriendCollectionView(selectedItem : CommonUserViewModel) {

        switch selectedItem.userSelected.value {
        case .deSelected:
            deSelectProcessOfItemInCollectionView(selectedItem)
            
        case .selected:
            selectProcessOfItemInCollectionView(selectedItem)

        }
        
    }
    
    func startObservingSelectedFriendList(completion : @escaping (_ activationInfo : CollectionViewActivation) -> Void) {
        
        selectedFriendsViewModel.selectedFriendListEmpty.bind { (activationInfo) in
            completion(activationInfo)
        }
        
    }

    // listens selected friend collectionview
    func startObservingSelectedFriendListCount(completion : @escaping (_ counter : Int) -> Void) {
    
        selectedFriendsViewModel.selectedFriendListCount.bind { (counter) in
            completion(counter)
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FriendRelationSelectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedFriendsViewModel.friendArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = selectedFriendCollectionView.dequeueReusableCell(withReuseIdentifier: FriendRelationSelectionCollectionViewCell.identifier, for: indexPath) as? FriendRelationSelectionCollectionViewCell else { return UICollectionViewCell() }
        
        cell.initiateCellDesign(item: selectedFriendsViewModel.friendArray[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Constants.StaticViewSize.ViewSize.Width.width_90, height: Constants.StaticViewSize.ViewSize.Height.height_90)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = selectedFriendCollectionView.cellForItem(at: indexPath) as? FriendRelationSelectionCollectionViewCell else { return }
        
        cell.userViewModel?.userSelected.value = .deSelected
        
        if let userViewModel = cell.userViewModel {
            selectedFriendsViewModel.removeItemFromFriendArray(friend: userViewModel)
            selectedFriendCollectionView.performBatchUpdates({
                selectedFriendCollectionView.deleteItems(at: [indexPath])
            })
            
            if selectedFriendsViewModel.friendArray.count <= 0 {
                selectedFriendsViewModel.selectedFriendListEmpty.value = .disable
            }
            
        }
        
    }
    
}
