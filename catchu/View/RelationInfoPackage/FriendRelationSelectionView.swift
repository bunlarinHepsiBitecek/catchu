//
//  FriendRelationSelectionView.swift
//  catchu
//
//  Created by Erkut Baş on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationSelectionView: UIView {

    private let selectedFriendsViewModel = FriendsViewModel()
    
    lazy var selectedFriendCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.minimumLineSpacing_Zero
        layout.minimumInteritemSpacing = Constants.Cell.minimumLineSpacing_Zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
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
        
        return CGSize(width: Constants.StaticViewSize.ViewSize.Width.width_80, height: Constants.StaticViewSize.ViewSize.Height.height_80)
        
    }
    
}
