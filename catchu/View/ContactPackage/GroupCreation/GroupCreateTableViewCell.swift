//
//  GroupCreateTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupCreateTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var referenceOfGroupCreateView = GroupCreateView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        contentSize.contentSizeOfCell = contentSize.calculateContentSizeForTableRowHeight(inputItemCount: returnSelectedFriendCount())
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GroupCreateTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnSelectedFriendCount()
    }
    
    func returnSelectedFriendCount() -> Int {
        return SectionBasedFriend.shared.selectedUserArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.groupCreateSelectedParticipantCell, for: indexPath) as? GroupCreateCollectionViewCell else { return UICollectionViewCell() }
        
        cell.participant = SectionBasedFriend.shared.selectedUserArray[indexPath.row]
        if let profilePictureUrl = cell.participant.profilePictureUrl {
            cell.participantImage.setImagesFromCacheOrFirebaseForFriend(profilePictureUrl)
        }
        
        if let username = cell.participant.username {
            cell.participantName.text = username
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? GroupCreateCollectionViewCell
        
        if let i = SectionBasedFriend.shared.selectedUserArray.index(where: { $0.userid == cell?.participant.userid}) {
            
            SectionBasedFriend.shared.selectedUserArray.remove(at: i)
            SectionBasedFriend.shared.ifUserSelectedDictionary[(cell?.participant.userid)!] = false
            
        }
        
        collectionView.deleteItems(at: [indexPath])
        
//        collectionView.layoutIfNeeded()
//        
//        self.referenceOfGroupCreateView.tableView.reloadData()
        self.referenceOfGroupCreateView.referenceOfGroupCreateViewController.referenceOfContactViewController.childReferenceFriendContainerFriendController?.tableView.reloadData()
        self.referenceOfGroupCreateView.referenceOfGroupCreateViewController.referenceOfContactViewController.childReferenceFriendContainerFriendController?.collectionView.reloadData()
        
    }
    
    
    
}
