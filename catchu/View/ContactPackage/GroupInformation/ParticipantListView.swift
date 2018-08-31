//
//  ParticipantListView.swift
//  catchu
//
//  Created by Erkut Baş on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ParticipantListView: UIView {

    @IBOutlet var topView: UIViewDesign!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var selectedParticipantCount: UILabel!
    @IBOutlet var totalFriendCount: UILabel!
    
    @IBOutlet var collectionViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var isCollectionViewOpen : Bool!
    var isCollectionViewShouldMove : Bool!
    
    var group = Group()
    
    var activityIndicator: UIActivityIndicatorView!
    var tempView : UIView!
    
    var referenceOfParticipantListViewController = ParticipantListViewController()
    
    /// refresh control for tableView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ParticipantListView.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        APIGatewayManager.shared.getUserFriendList(userid: User.shared.userID) { (friendList, response) in
            
            if response {
                
                User.shared.userFriendList.removeAll()
                
                User.shared.appendElementIntoFriendListAWS(httpResult: friendList)
                
                SectionBasedParticipant.sharedParticipant = SectionBasedParticipant()
                
                SectionBasedParticipant.sharedParticipant.emptyIfUserSelectedDictionary()
                SectionBasedParticipant.sharedParticipant.createInitialLetterBasedFriendDictionary()
                
                DispatchQueue.main.async {
                    
                    self.setCollectionViewProperties()
                    self.setSelectedParticipantLabel()
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                    
                    self.searchBar.text = Constants.CharacterConstants.SPACE
                    self.searchBar.showsCancelButton = false
                    
                    self.searchBar.endEditing(true)
                    
                    refreshControl.endRefreshing()
                    
                }
                
            }
            
        }
        
//        self.tableView.reloadData()
//        refreshControl.endRefreshing()
    }
    
    
    func initialize() {
        
        setDelegatesForCollections()
        setCollectionSettings()
        setTopViewProperties()
        createNecessaryObjects()
        setCollectionViewProperties()
        searchBarPropertyManagement()
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        emptyNecessaryObjects()
        SectionBasedParticipant.sharedParticipant = SectionBasedParticipant()
        
        referenceOfParticipantListViewController.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        startAddParticipantProcess()
        
    }
    
}

// MARK: - major functions
extension ParticipantListView {
    
    func setDelegatesForCollections() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
    func setCollectionSettings() {
        
        self.tableView.sectionIndexMinimumDisplayRowCount = 5
        self.tableView.addSubview(refreshControl)
        
    }
    
    func setTopViewProperties() {
        
        let bottomBorder = CALayer()
        
        bottomBorder.frame = CGRect(x: 0, y: topView.frame.height - 0.3, width: topView.frame.width, height: 0.3)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        topView.layer.addSublayer(bottomBorder)
        
        cancelButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        addButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.add, for: .normal)
        topicLabel.text = LocalizedConstants.TitleValues.LabelTitle.addParticipant
        
        
        totalFriendCount.text = "\(User.shared.userFriendList.count)"
        
    }
    
    func createNecessaryObjects() {
        
        print("createNecessaryObjects starts")
        print("count : \(SectionBasedParticipant.sharedParticipant.friendUsernameInitialBasedDictionary.count)")
        
        SectionBasedParticipant.sharedParticipant.createInitialLetterBasedFriendDictionary()
        SectionBasedParticipant.sharedParticipant.emptyIfUserSelectedDictionary()
        
        print("count : \(SectionBasedParticipant.sharedParticipant.friendUsernameInitialBasedDictionary.count)")

    }
    
    func emptyNecessaryObjects() {
        
        print("emptyNecessaryObjects starts")
        print("count : \(SectionBasedParticipant.sharedParticipant.friendUsernameInitialBasedDictionary.count)")
        
        SectionBasedParticipant.sharedParticipant.emptySectionBasedDictioanry()
        SectionBasedParticipant.sharedParticipant.emptyIfUserSelectedDictionary()
        SectionBasedParticipant.sharedParticipant.emptySelectedUserArray()

        print("count : \(SectionBasedParticipant.sharedParticipant.friendUsernameInitialBasedDictionary.count)")
    }
    
    func setCollectionViewProperties() {
        
        self.isCollectionViewOpen = false
        self.isCollectionViewShouldMove = false
        
        collectionViewHeightConstraints.constant = 0
        
    }
    
    func setSelectedParticipantLabel() {
        
        UIView.transition(with: selectedParticipantCount, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.selectedParticipantCount.text = self.returnSelectedUserFriendCount()
        })
        
    }
    
    func returnSelectedUserFriendCount() -> String{
        
        let tempCount = SectionBasedParticipant.sharedParticipant.selectedUserArray.count
        
        let countStringValue : String = String(tempCount)
        
//        if tempCount <= Constants.NumericConstants.INTEGER_ZERO {
//
//            //            makeDisableCounterLabels()
//            //            boolenValueForCountColorManagement = true
//
//        } else {
//
//            if boolenValueForCountColorManagement {
//
//                //                makeEnableCounterLabels()
//                //                boolenValueForCountColorManagement = false
//
//            }
//
//        }
        
        return countStringValue
        
    }
    
    func startAddParticipantProcess() {
        
        var title = "Add "
        var count = 0
        
        if SectionBasedParticipant.sharedParticipant.selectedUserArray.count > Constants.NumericConstants.INTEGER_FOUR {
            
            for item in SectionBasedParticipant.sharedParticipant.selectedUserArray {
                
                title = title + item.name
                
                print("SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex : \(SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex)")
                
                count += 1

                if SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex < Constants.NumericConstants.INTEGER_FOUR {
                    title = title + ", "
                }
                
                
                if count > 4 {
                    
                    break
                    
                }
                
            }
            
            title = title + " and " + "\(SectionBasedParticipant.sharedParticipant.selectedUserArray.count - Constants.NumericConstants.INTEGER_FOUR)" + " to " +  "\"" + group.groupName + "\"" + " group."
            
            
        } else {
            
            for item in SectionBasedParticipant.sharedParticipant.selectedUserArray {
                
                print("index(ofAccessibilityElement: item) : \(index(ofAccessibilityElement: item))")
                
                title = title + item.name
                
                print("SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex : \(SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex)")
                
                count += 1

                if SectionBasedParticipant.sharedParticipant.selectedUserArray.endIndex != count {
                    title = title + ", "
                }
                

            }
            
            title =  title + " to " + "\"" + group.groupName + "\"" + " group."
            
        }
        
        let actionController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let addButton = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.add, style: .default) { (alertAction) in
            
            print("do something")
            self.addParticipantToGroup()
            
        }
        
        let cancelButton = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel) { (alertAction) in
            
        }
        
        actionController.view.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        actionController.addAction(addButton)
        actionController.addAction(cancelButton)
        
        referenceOfParticipantListViewController.present(actionController, animated: true, completion: nil)
        
    }
    
    func addParticipantToGroup() {
        
        showSpinning()
        
        var inputRequest = REGroupRequest()
        inputRequest?.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
        
        inputRequest = SectionBasedParticipant.sharedParticipant.returnREGroupRequestFromGroup(inputGroup: group, inputParticipantArray: SectionBasedParticipant.sharedParticipant.selectedUserArray)
        
        inputRequest?.requestType = RequestType.add_participant_into_group.rawValue

        APIGatewayManager.shared.addNewParticipantsToExistingGroup(groupBody: inputRequest!) { (groupRequestResult, response) in
            
            if response {
                
                print("request is successfull")
                
                for item in SectionBasedParticipant.sharedParticipant.selectedUserArray {
                    
                    Participant.shared.participantDictionary[self.group.groupID]?.append(item)
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.stopSpinning()
                    self.emptyNecessaryObjects()
                    //self.referenceOfParticipantListViewController.referenceOfGroupInformationView.setFooterViewHeight()
                    self.referenceOfParticipantListViewController.referenceOfGroupInformationView.setParticipantCount()
                    self.referenceOfParticipantListViewController.referenceOfGroupInformationView.tableView.reloadData()
                    self.referenceOfParticipantListViewController.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    func showSpinning() {
        
        tempView = UIView()
        
        tempView.frame = CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height)
        
        tempView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addButton.addSubview(tempView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = tempView.center
        
        activityIndicator.startAnimating()
        
        tempView.addSubview(activityIndicator)
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tempView.removeFromSuperview()
            self.addButton.isEnabled = false
        }
        
        
    }
    
}


// MARK: - searchbar process
extension ParticipantListView: UISearchBarDelegate {
    
    // to make searchBar textField background invisible
    func searchBarPropertyManagement() {
        
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchBarProperties.searchField) as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        searchBar.searchBarStyle = .minimal
        
        searchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = Constants.CharacterConstants.SPACE
        self.searchBar.endEditing(true)
        
        SectionBasedParticipant.sharedParticipant.isSearchModeActivated = false
        tableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // empty searchResult array
        SectionBasedParticipant.sharedParticipant.emptySearchResult()
        
        if !searchText.isEmpty {
            
            print("searchBar userFriendList count : \(User.shared.userFriendList.count)")
            
            for item in User.shared.userFriendList {
                
                print("item key : \(item.key)")
                print("item val : \(item.value)")
                
                if let user = item.value as User? {
                    
                    print("name : \(user.name)")
                    
                    var arraySplit = [Substring]()
                    
                    arraySplit = item.value.name.split(separator: " ")
                    
                    for item in arraySplit {
                        
                        if item.lowercased().hasPrefix((searchBar.text?.lowercased())!) {
                            
                            SectionBasedParticipant.sharedParticipant.searchResult.append(user)
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            
            searchBar.setShowsCancelButton(true, animated: true)
            
            SectionBasedParticipant.sharedParticipant.isSearchModeActivated = true
            
        } else {
            
            print("search text field is empty")
            SectionBasedParticipant.sharedParticipant.isSearchModeActivated = false
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.endEditing(true)
            
        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: - collectionView process
extension ParticipantListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantSelectedCell", for: indexPath) as? ParticipantSelectedCollectionViewCell else { return UICollectionViewCell() }
        
        if SectionBasedParticipant.sharedParticipant.selectedUserArray.count > 0 {
            
            UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                cell.selectedParticipantImage.setImagesFromCacheOrFirebaseForFriend(SectionBasedParticipant.sharedParticipant.selectedUserArray[indexPath.row].profilePictureUrl)
                cell.selectedParticipantName.text = SectionBasedParticipant.sharedParticipant.selectedUserArray[indexPath.row].name
                cell.participant = SectionBasedParticipant.sharedParticipant.selectedUserArray[indexPath.row]
                
            })
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return SectionBasedParticipant.sharedParticipant.selectedUserArray.count
        
    }
    
    // select collectionView item (to delete selected user array)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ParticipantSelectedCollectionViewCell
        
        if let i = SectionBasedParticipant.sharedParticipant.selectedUserArray.index(where: { $0.userID == cell.participant.userID}) {
            
            SectionBasedParticipant.sharedParticipant.selectedUserArray.remove(at: i)
        }
        
        collectionView.deleteItems(at: [indexPath])
        
        SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary[cell.participant.userID] = false
        
        /* if collection view is reload, the user interface changes sharply, not smoothly */
        //collectionView.reloadData()
        collectionViewAnimationManagement()
        
        /*
         while deleting from collectionView, the same user selected in tableView
         must be deselected as well
         */
        
        print("cell.selectedUser indexParh : \(cell.participant.indexPathTableView)")
        print("cell.selectedUser indexParhSearch : \(cell.participant.indexPathTableViewOfSearchMode)")
        
        if SectionBasedParticipant.sharedParticipant.isSearchModeActivated {
            tableView.deselectRow(at: cell.participant.indexPathTableViewOfSearchMode, animated: true)
            cellSelectedIconManagement(indexPath: cell.participant.indexPathTableViewOfSearchMode, iconManagement: .deselected, userId: cell.participant.userID)
        } else {
            tableView.deselectRow(at: cell.participant.indexPathTableView, animated: true)
            cellSelectedIconManagement(indexPath: cell.participant.indexPathTableView, iconManagement: .deselected, userId: cell.participant.userID)
        }
        
        //tableView.deselectRow(at: cell.selectedUser.indexPathTableView, animated: true)
        
        //cellSelectedIconManagement(indexPath: cell.selectedUser.indexPathTableView, iconManagement: .deselected)
        
        setSelectedParticipantLabel()
        
    }

    
    func collectionViewAnimationManagement() {
        
        if isCollectionViewOpen {
            
            if SectionBasedParticipant.sharedParticipant.selectedUserArray.isEmpty {
                
                closeCollectionViewSmootly()
                
            }
            
        } else {
            
            if !SectionBasedParticipant.sharedParticipant.selectedUserArray.isEmpty {
                
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
        
        self.collectionViewHeightConstraints.constant = constantHeight
        
        UIView.transition(with: collectionView, duration: duration, options: .transitionCrossDissolve, animations: {
            
            self.layoutIfNeeded()
            
        })
        
    }
    
    
}


// MARK: - tableView process
extension ParticipantListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return returnRowCount(section: section)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return returnSectionCount()
        
    }
    
    // the functions below decides return values for tableview row, section management according to search mode
    // return user object according to search mode process, if search is activated, retrieves data from search array. Otherwise, returns data from main collection data retrieved from firabase friends model
    func returnUser(indexPath : IndexPath) -> User {
        
        if SectionBasedParticipant.sharedParticipant.isSearchModeActivated {
            
            return SectionBasedParticipant.sharedParticipant.searchResult[indexPath.row]
            
        } else {
            
            return SectionBasedParticipant.sharedParticipant.returnUserFromSectionBasedDictionary(indexPath: indexPath)
            
        }
        
    }
    
    func returnRowCount(section : Int) -> Int {
        
        if SectionBasedParticipant.sharedParticipant.isSearchModeActivated {
            return SectionBasedParticipant.sharedParticipant.searchResult.count
        } else {
            return SectionBasedParticipant.sharedParticipant.returnSectionNumber(index: section)
        }
        
    }
    
    func returnSectionCount() -> Int {
        
        if SectionBasedParticipant.sharedParticipant.isSearchModeActivated {
            return Constants.NumericConstants.INTEGER_ONE
        } else {
            return SectionBasedParticipant.sharedParticipant.friendUsernameInitialBasedDictionary.keys.count
        }
        
    }
    
    func returnSectionHeader(section : Int) -> String {
        
        if SectionBasedParticipant.sharedParticipant.isSearchModeActivated {
            return LocalizedConstants.SearchBar.searchResult
        } else {
            return SectionBasedParticipant.sharedParticipant.friendSectionKeyData[section]
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return SectionBasedParticipant.sharedParticipant.friendSectionKeyData[section]
        return returnSectionHeader(section: section)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.NumericValues.rowHeight50
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return SectionBasedParticipant.sharedParticipant.friendSectionKeyData
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("ZALIM ZALIM")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.participantListCell, for: indexPath) as? ParticipantListTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        print("ZALIM ZALIM 2")

        cell.resetLabelProperties()
        
        /* the code below supplies data for table view - begin */
        
        //cell.participant = SectionBasedParticipant.sharedParticipant.returnUserFromSectionBasedDictionary(indexPath: indexPath)
        cell.participant = returnUser(indexPath: indexPath)
        
        cell.participant.displayProperties()
        
        /* the code below supplies data for table view - end */
        
        cell.participantName.text = cell.participant.userName
        cell.participantDetailInformation.text = cell.participant.name
        cell.participantImage.setImagesFromCacheOrFirebaseForFriend(cell.participant.profilePictureUrl)
        
//        for (key, value) in SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary {
//            
//            print("key : \(key)")
//            print("value : \(value)")
//            
//        }
        
        print("cell.participant.userID : \(cell.participant.userID)")
        
        if SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary[cell.participant.userID]! {
            
            cell.participantSelectedIcon.image = #imageLiteral(resourceName: "check-mark.png")
            
            // after reloading tableview selected rows will be gone, that's why we need to implement code below
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
        } else {
            
            cell.participantSelectedIcon.image = nil
            
        }
        
        if let userList = Participant.shared.participantDictionary[group.groupID] {
            
            for item in userList {
                
                if item.userID == cell.participant.userID {
                    
                    cell.setParticipantAlreadyInGroup()
                    
                }
                
            }
            
        }
        
        print("ZALIM ZALIM 3")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ParticipantListTableViewCell
        
        /*
         userID is marked as selected
         user is added into selected user array
         */
        SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary[cell.participant.userID] = true
        //cell.participant.indexPathTableView = indexPath
        cell.participant.indexPathTableView = indexPath
        cell.participant.indexPathTableViewOfSearchMode = indexPath
        
        SectionBasedParticipant.sharedParticipant.addElementIntoSelectedUsers(user: cell.participant)
        
        cell.participant.isUserSelected = true
        
        print("selected user indexPath : \(cell.participant.indexPathTableView)")
        print("selected user indexPathSearchMode : \(cell.participant.indexPathTableViewOfSearchMode)")
        
        resultTest()
        
        /*
         check image is activated
         */
        cellSelectedIconManagement(indexPath: indexPath, iconManagement: .selected, userId: cell.participant.userID)
        
        collectionViewAnimationManagement()
        
        let selectedItemIndexPath = IndexPath(item: SectionBasedParticipant.sharedParticipant.selectedUserArray.count - 1, section: 0)
        
        print("selectedItemIndexPath : \(selectedItemIndexPath)")
        print("collectionFrame width : \(collectionView.frame.width)")
        print("contentSize : \(collectionView.contentSize.width)")
        
//        collectionView.insertItems(at: [selectedItemIndexPath])
        
//        collectionView.performBatchUpdates({
//
//            collectionView.insertItems(at: [selectedItemIndexPath])
//            print("collectionView visible item count : \(collectionView.visibleCells.count)")
//            print("collectionView  item count : \(collectionView.numberOfItems(inSection: 0))")
//
////            collectionView.scrollToItem(at: selectedItemIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//
//        })
        
        setSelectedParticipantLabel()
        
        print("jj : \(self.collectionViewFlowLayout.collectionViewContentSize)")

        collectionView.performBatchUpdates({
            
            collectionView.insertItems(at: [selectedItemIndexPath])
            
        }) { (result) in
            
            if result {
                
                print("contentSize : \(self.collectionView.contentSize.width)")
                print("item count : \(self.collectionView.numberOfItems(inSection: 0))")
                print("spacing : \(self.collectionViewFlowLayout.minimumLineSpacing)")
                print("jj : \(self.collectionViewFlowLayout.collectionViewContentSize.width)")
                print("kk : \(self.collectionViewFlowLayout.minimumLineSpacing)")
                
                if self.collectionViewFlowLayout.collectionViewContentSize.width > self.collectionView.frame.width {
                    
                    self.collectionView.scrollToItem(at: selectedItemIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally , animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    // deselect tableView row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ParticipantListTableViewCell
        
        /*  userID is marked as deselected
         user is removed from selected user array
         */
        SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary[cell.participant.userID] = false
        
        if let i = SectionBasedParticipant.sharedParticipant.selectedUserArray.index(where: { $0.userID == cell.participant.userID}) {
            
            SectionBasedParticipant.sharedParticipant.selectedUserArray.remove(at: i)
        }
        
        /*
         uncheck image is activated
         */
        
        cellSelectedIconManagement(indexPath: indexPath, iconManagement: .deselected, userId: cell.participant.userID)
        
        print("cell.userFriend.indexPathCollectionView :\(cell.participant.indexPathCollectionView)")
        //collectionView.deleteItems(at: [cell.userFriend.indexPathCollectionView])
        
        collectionView.reloadData()
        collectionViewAnimationManagement()
//
        setSelectedParticipantLabel()
        
    }
    
    func resultTest() {
        
        print("sectionFriend selectedDictionaryCount : \(SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary)")
        print("SectionBasedParticipant selectedDictionaryCount : \(SectionBasedParticipant.sharedParticipant.ifUserSelectedDictionary)")
    
    }
    
    // to select or deselect check icon inside each row of tableview
    func cellSelectedIconManagement(indexPath : IndexPath, iconManagement : IconManagement, userId : String) {
        
        switch iconManagement {
        case .selected:
            selectCellIcon(indexPath: indexPath)
        case .deselected:
            deselectCellIconForWithUserID(userId: userId)
        default:
            return
        }
        
    }
    
    func selectCellIcon(indexPath : IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ParticipantListTableViewCell
        
        UIView.transition(with: cell.participantSelectedIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            cell.participantSelectedIcon.image = #imageLiteral(resourceName: "check-mark.png")
            
        })
        
    }
    
    func deselectCellIconForWithUserID(userId : String) {
        
        print("deselectCellIconForWithUserID starts")
        print("userId :\(userId)")
        
        let tempCellArray : [UITableViewCell] = self.tableView.visibleCells
        
        for item in tempCellArray {
            
            let cell = item as! ParticipantListTableViewCell
            
            if cell.participant.userID == userId {
                
                UIView.transition(with: cell.participantSelectedIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    
                    cell.participantSelectedIcon.image = nil
                    
                })
                
                break
                
            }
            
        }
        
    }
    
}
