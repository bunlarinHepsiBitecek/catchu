        //
//  ExtensionContainerFriendController.swift
//  catchu
//
//  Created by Erkut Baş on 6/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

// viewController override functions
extension ContainerFriendViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("VIEWWILLDISAPPEAR STARTS")
        print("friendUsernameInitialBasedDictionary count : \(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
        // container lar arasında geçiş yaparken view resetlemek için kullanılır
//        SectionBasedFriend.shared.emptySectionBasedDictioanry()
//        SectionBasedFriend.shared.emptyIfUserSelectedDictionary()
        
    }
    
    func prepareViewDidLoadProcess() {
        
        print("PREPAREVIEWDIDLOADPROCESS STARTS")
        print("friendUsernameInitialBasedDictionary count : \(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
        SectionBasedFriend.shared.createInitialLetterBasedFriendDictionary()
        print("friendUsernameInitialBasedDictionary count : \(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
        self.isCollectionViewOpen = false
        SectionBasedFriend.shared.emptyIfUserSelectedDictionary()
        
    }
    
    func collectionViewAnimationManagement() {
        
        if isCollectionViewOpen {
            
            if SectionBasedFriend.shared.selectedUserArray.isEmpty {
                
                closeCollectionViewSmootly()
                
            }
            
        } else {
            
            if !SectionBasedFriend.shared.selectedUserArray.isEmpty {
                
                openCollectionViewSmootly()
                
            }
            
        }
        
    }
    
    func openCollectionViewSmootly() {
        
        animateCollectionView(duration: 0.3, constantHeight: 90.0)
        isCollectionViewOpen = true
        
    }
    
    func closeCollectionViewSmootly() {
        
        animateCollectionView(duration: 0.3, constantHeight: 0)
        isCollectionViewOpen = false
    }
    
    func animateCollectionView(duration : TimeInterval, constantHeight : CGFloat) {
        
        self.collectionViewHeightConstraint.constant = constantHeight
        
        UIView.transition(with: collectionView, duration: duration, options: .transitionCrossDissolve, animations: {
            
            self.view.layoutIfNeeded()
            
        })
        
    }
    
}

// tableView management
extension ContainerFriendViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("FRIEND FRIEND FRIEND")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.tableViewCellFriend, for: indexPath) as? FriendsTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        /* the code below supplies data for table view - begin */
        
        //cell.userFriend = SectionBasedFriend.shared.returnUserFromSectionBasedDictionary(indexPath: indexPath)
        cell.userFriend = returnUser(indexPath: indexPath)
        /* the code below supplies data for table view - end */
        
        cell.friendName.text = cell.userFriend.userName
        cell.friendUserNameDetail.text = cell.userFriend.name
        cell.friendImage.setImagesFromCacheOrFirebaseForFriend(cell.userFriend.profilePictureUrl)
        
        if SectionBasedFriend.shared.ifUserSelectedDictionary[cell.userFriend.userID]! {
            
            cell.friendSelectedIcon.image = #imageLiteral(resourceName: "check-mark.png")
            
            // after reloading tableview selected rows will be gone, that's why we need to implement code below
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
        } else {
            
            cell.friendSelectedIcon.image = nil
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return SectionBasedFriend.shared.returnSectionNumber(index: section)
        return returnRowCount(section: section)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //return SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.keys.count
        return returnSectionCount()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return SectionBasedFriend.shared.friendSectionKeyData[section]
        return returnSectionHeader(section: section)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.NumericValues.rowHeight50
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return SectionBasedFriend.shared.friendSectionKeyData
        
    }
    
    // select tableView row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        
        /*
            userID is marked as selected
            user is added into selected user array
        */
        SectionBasedFriend.shared.ifUserSelectedDictionary[cell.userFriend.userID] = true
        //cell.userFriend.indexPathTableView = indexPath
        cell.userFriend.indexPathTableView = indexPath
        cell.userFriend.indexPathTableViewOfSearchMode = indexPath
        
        SectionBasedFriend.shared.addElementIntoSelectedUsers(user: cell.userFriend)
        
        cell.userFriend.isUserSelected = true
        
        print("selected user indexPath : \(cell.userFriend.indexPathTableView)")
        print("selected user indexPathSearchMode : \(cell.userFriend.indexPathTableViewOfSearchMode)")
        
        /*
            check image is activated
         */
        cellSelectedIconManagement(indexPath: indexPath, iconManagement: .selected, userId: cell.userFriend.userID)
        
        collectionViewAnimationManagement()
        
        let selectedItemIndexPath = IndexPath(item: SectionBasedFriend.shared.selectedUserArray.count - 1, section: 0)
        collectionView.performBatchUpdates({
            
            collectionView.insertItems(at: [selectedItemIndexPath])
            
        })
        
        parentReferenceContactViewController?.contactView.setSelectedUserCounterLabel()
        
    }
    
    // deselect tableView row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        
        /*  userID is marked as deselected
         user is removed from selected user array
         */
        SectionBasedFriend.shared.ifUserSelectedDictionary[cell.userFriend.userID] = false
        
        if let i = SectionBasedFriend.shared.selectedUserArray.index(where: { $0.userID == cell.userFriend.userID}) {
            
            SectionBasedFriend.shared.selectedUserArray.remove(at: i)
        }
        
        /*
         uncheck image is activated
         */
        
        cellSelectedIconManagement(indexPath: indexPath, iconManagement: .deselected, userId: cell.userFriend.userID)
        
        print("cell.userFriend.indexPathCollectionView :\(cell.userFriend.indexPathCollectionView)")
        //collectionView.deleteItems(at: [cell.userFriend.indexPathCollectionView])
        
        collectionView.reloadData()
        collectionViewAnimationManagement()
        
        parentReferenceContactViewController?.contactView.setSelectedUserCounterLabel()
        
    }
    
    // the functions below decides return values for tableview row, section management according to search mode
    // return user object according to search mode process, if search is activated, retrieves data from search array. Otherwise, returns data from main collection data retrieved from firabase friends model
    func returnUser(indexPath : IndexPath) -> User {
        
        if SectionBasedFriend.shared.isSearchModeActivated {
            
            return SectionBasedFriend.shared.searchResult[indexPath.row]
            
        } else {
            
            return SectionBasedFriend.shared.returnUserFromSectionBasedDictionary(indexPath: indexPath)
            
        }
        
    }
    
    func returnRowCount(section : Int) -> Int {
        
        if SectionBasedFriend.shared.isSearchModeActivated {
            return SectionBasedFriend.shared.searchResult.count
        } else {
            return SectionBasedFriend.shared.returnSectionNumber(index: section)
        }
        
    }
    
    func returnSectionCount() -> Int {
        
        if SectionBasedFriend.shared.isSearchModeActivated {
            return Constants.NumericConstants.INTEGER_ONE
        } else {
            return SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.keys.count
        }
        
    }
    
    func returnSectionHeader(section : Int) -> String {
        
        if SectionBasedFriend.shared.isSearchModeActivated {
            return LocalizedConstants.SearchBar.searchResult
        } else {
            return SectionBasedFriend.shared.friendSectionKeyData[section]
        }
    }
    
}

// collectionView management
extension ContainerFriendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.collectionViewCellFriend, for: indexPath) as? FriendCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }
        
        if SectionBasedFriend.shared.selectedUserArray.count > 0 {
            
            UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                cell.selectedFriendImage.setImagesFromCacheOrFirebaseForFriend(SectionBasedFriend.shared.selectedUserArray[indexPath.row].profilePictureUrl)
                cell.selectedFriendName.text = SectionBasedFriend.shared.selectedUserArray[indexPath.row].name
                cell.selectedUser = SectionBasedFriend.shared.selectedUserArray[indexPath.row]
                
            })
            
        }
        
        if SectionBasedFriend.shared.selectedUserArray.count > 0 {
        
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return SectionBasedFriend.shared.selectedUserArray.count
        
    }
    
    // select collectionView item (to delete selected user array)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        
        if let i = SectionBasedFriend.shared.selectedUserArray.index(where: { $0.userID == cell.selectedUser.userID}) {
            
            SectionBasedFriend.shared.selectedUserArray.remove(at: i)
        }
        
        collectionView.deleteItems(at: [indexPath])
        
        SectionBasedFriend.shared.ifUserSelectedDictionary[cell.selectedUser.userID] = false
        
        /* if collection view is reload, the user interface changes sharply, not smoothly */
        //collectionView.reloadData()
        collectionViewAnimationManagement()
        
        /*
            while deleting from collectionView, the same user selected in tableView
            must be deselected as well
         */
        
        print("cell.selectedUser indexParh : \(cell.selectedUser.indexPathTableView)")
        print("cell.selectedUser indexParhSearch : \(cell.selectedUser.indexPathTableViewOfSearchMode)")
        
        if SectionBasedFriend.shared.isSearchModeActivated {
            tableView.deselectRow(at: cell.selectedUser.indexPathTableViewOfSearchMode, animated: true)
            cellSelectedIconManagement(indexPath: cell.selectedUser.indexPathTableViewOfSearchMode, iconManagement: .deselected, userId: cell.selectedUser.userID)
        } else {
            tableView.deselectRow(at: cell.selectedUser.indexPathTableView, animated: true)
            cellSelectedIconManagement(indexPath: cell.selectedUser.indexPathTableView, iconManagement: .deselected, userId: cell.selectedUser.userID)
        }
        
        //tableView.deselectRow(at: cell.selectedUser.indexPathTableView, animated: true)
        
        //cellSelectedIconManagement(indexPath: cell.selectedUser.indexPathTableView, iconManagement: .deselected)
        
        parentReferenceContactViewController?.contactView.setSelectedUserCounterLabel()
        
    }

    // to select or deselect check icon inside each row of tableview
    func cellSelectedIconManagement(indexPath : IndexPath, iconManagement : IconManagement, userId : String) {
        
        print("cellSelectedIconManagement starts")
        print("indexPath :\(indexPath)")
        print("userID : \(userId)")
        
        switch iconManagement {
        case .selected:
            selectCellIcon(indexPath: indexPath)
        case .deselected:
            //deselectCellIcon(inputIndexPath: indexPath, userId: userId)
            deselectCellIconForWithUserID(userId: userId)
            //tableView.reloadData()
        default:
            return
        }
        
    }
    
    func selectCellIcon(indexPath : IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        
        UIView.transition(with: cell.friendSelectedIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            cell.friendSelectedIcon.image = #imageLiteral(resourceName: "check-mark.png")
            
        })
        
    }
    
    func deselectCellIcon(inputIndexPath : IndexPath, userId : String) {
        
        print("deselectCellIcon starts")
        print("inputIndexPath :\(inputIndexPath)")
        
        let tempIndexArray : [IndexPath] = self.tableView.indexPathsForVisibleRows!
        
        for item in tempIndexArray {
            
            if inputIndexPath == item {
                
                let cell = tableView.cellForRow(at: inputIndexPath) as! FriendsTableViewCell
                
                UIView.transition(with: cell.friendSelectedIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    
                    cell.friendSelectedIcon.image = nil
                    
                })
                
                break
                
            }
            
        }
        
    }
    
    func deselectCellIconForWithUserID(userId : String) {
        
        print("deselectCellIconForWithUserID starts")
        print("userId :\(userId)")
        
        let tempCellArray : [UITableViewCell] = self.tableView.visibleCells
        
        for item in tempCellArray {
            
            let cell = item as! FriendsTableViewCell
            
            if cell.userFriend.userID == userId {
                
                UIView.transition(with: cell.friendSelectedIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    
                    cell.friendSelectedIcon.image = nil
                    
                })
                
                break
                
            }
            
            
        }
        
    }
    
}

