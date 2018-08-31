//
//  ContactView.swift
//  catchu
//
//  Created by Erkut Baş on 6/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import UserNotifications

class ContactView: UIView, UNUserNotificationCenterDelegate {
    
    @IBOutlet var topView: UIViewDesign!
    @IBOutlet var containerViewFriend: UIView!
    @IBOutlet var containerGroup: UIView!
    
    @IBOutlet var confirmationButton: UIButton!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var segmentedButton: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var selectedRowCountLabel: UILabel!
    @IBOutlet var seperatorLable: UILabel!
    @IBOutlet var totalCountLabel: UILabel!
    
    // let's create a MasterController object
    var referenceMasterViewController : ContactViewController!
    
    var boolenValueForCountColorManagement : Bool!
    
    func initializeView() {
        
        // initialize SectionBasedFriend
        SectionBasedFriend.shared.emptySearchResult()
        SectionBasedFriend.shared.emptySelectedUserArray()
        
        self.topView.alpha = 0.0
        boolenValueForCountColorManagement = false
        
        UIView.animate(withDuration: 0.5) {
            self.topView.alpha = 1.0
        }
        
        self.containerViewFriend.alpha = 1.0
        self.containerGroup.alpha = 0.0
        
        //addBorderLineToTopView()
        setTitles()
        setCounterLabels()
        counterLabelsManagement()
        setSelectedUserCounterLabel()
        searchBarPropertyManagement()
        
        requestPermissionWithCompletionhandler { (granted) -> (Void) in
            
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        SectionBasedFriend.shared = SectionBasedFriend()
        referenceMasterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        showNotification(title: "yarro", message: "yarro messaje")
        
        switch returnSegment() {
        case .friends:
            
            
            if SectionBasedFriend.shared.selectedUserArray.count > 0 {
                
                referenceMasterViewController.dismiss(animated: true, completion: nil)
            }
            
        case .groups:
            
            print("groups")
            
        default:
            print("nothing")
        }
        
    }
    
    @IBAction func segmentedButtonChanged(_ sender: Any) {
        
        setInitialSegmentPropertiesForContainerViewPresentations()
        
    }
    
}

// view functions
extension ContactView {
    
    func requestPermissionWithCompletionhandler(completion: ((Bool) -> (Void))? ) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            
            if error != nil {
                if let errorMessage = error as NSError? {
                    print("errorMessage :\(errorMessage)")
                    print("errorMessage :\(errorMessage.localizedDescription)")
                    completion!(false)
                    return
                }
            } else {
                if granted {
                    UNUserNotificationCenter.current().delegate = self
                    self.setNotificationCategories()
                }
                completion!(true)
            }
        }
    }
    
    private func setNotificationCategories() {
        
        let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
        let replyAction = UNNotificationAction(identifier: "reply", title: "Reply", options: [])
        let archiveAction = UNNotificationAction(identifier: "archive", title: "Archive", options: [])
        let  ccommentAction = UNTextInputNotificationAction(identifier: "comment", title: "Comment", options: [])
        
        
        let localCat =  UNNotificationCategory(identifier: "local", actions: [likeAction], intentIdentifiers: [], options: [])
        
        let customCat =  UNNotificationCategory(identifier: "recipe", actions: [likeAction,ccommentAction], intentIdentifiers: [], options: [])
        
        let emailCat =  UNNotificationCategory(identifier: "email", actions: [replyAction, archiveAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([localCat, customCat, emailCat])
        
    }
    
    // MARK: Push Notification with Banner
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("TTTTTTTTTT")
        
        if response.notification.request.identifier == "notif" {
            
            completionHandler()
        }
        
    }
    
    func addBorderLineToTopView() {
        
        topView.addBottomBorderWithColor(color: .lightGray, width: 1.0)
        
    }
    
    func setCounterLabels() {
        
        totalCountLabel.text = returnTotalRowCountOfTableView()
        
    }
    
    func setSelectedUserCounterLabel() {
        
        UIView.transition(with: selectedRowCountLabel, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.selectedRowCountLabel.text = self.returnSelectedUserFriendCount()
        })
        
    }
    
    func setTitles() {
        
        setLabelTitle()
        setButtonTitles()
        
    }
    
    func setLabelTitle() {
        
        pageLabel.text = LocalizedConstants.TitleValues.LabelTitle.addParticipant
        
    }
    
    func setButtonTitles() {
        
        cancelButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        confirmationButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        segmentedButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.friend, forSegmentAt: 0)
        segmentedButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.group, forSegmentAt: 1)
        segmentedButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.newGroup, forSegmentAt: 2)
        
    }
    
    func returnTotalRowCountOfTableView() -> String {
        
        print("SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count : \(SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count)")
        
        //let tempCount = SectionBasedFriend.shared.friendUsernameInitialBasedDictionary.count
        let tempCount = User.shared.userFriendList.count
        let countStringValue : String = String(tempCount)
        
        return countStringValue
        
    }
    
    func makeDisableCounterLabels() {
        
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
            
            self.totalCountLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.selectedRowCountLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.seperatorLable.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        })
        
    }
    
    func makeEnableCounterLabels() {
        
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
            
            self.totalCountLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.selectedRowCountLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.seperatorLable.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        })
        
    }
    
    func counterLabelsManagement() {
        
        if SectionBasedFriend.shared.selectedUserArray.count > 0 {
            
            makeEnableCounterLabels()
            
        } else {
            
            makeDisableCounterLabels()
        }
        
    }
    
    func returnSelectedUserFriendCount() -> String{
        
        let tempCount = SectionBasedFriend.shared.selectedUserArray.count
        
        let countStringValue : String = String(tempCount)
        
        if tempCount <= Constants.NumericConstants.INTEGER_ZERO {
            
            makeDisableCounterLabels()
            boolenValueForCountColorManagement = true
            
        } else {
            
            if boolenValueForCountColorManagement {
                
                makeEnableCounterLabels()
                boolenValueForCountColorManagement = false
                
            }
            
        }
        
        return countStringValue
        
    }
    
}

// segmented button functions
extension ContactView {
    
    func setInitialSegmentPropertiesForContainerViewPresentations() {
        
        switch returnSegment() {
        case .friends, .groupCreation:
            
            startAnimationOfContainerViews(inputContainerViewChoise: .containerViewFriend)
            
        case .groups:
            
            if SectionBasedGroup.shared.groupNameInitialBasedDictionary.count > 0 {
                
                print("group okumasına gerek yok :)")
                startAnimationOfContainerViews(inputContainerViewChoise: .containerViewGroup)
                
            } else {
                
                print("group okumasına gerek var :)")
                getUserGroupList { (result) in
                    
                    if result {
                        
                        print("result basarili")
                        print("SAYILAR : \(Group.shared.groupList.count)")
                        
                        DispatchQueue.main.async {
                            SectionBasedGroup.shared.createInitialLetterBasedGroupDictionary()
                            self.startAnimationOfContainerViews(inputContainerViewChoise: .containerViewGroup)
                            self.referenceMasterViewController.childReferenceGroupContainerGroupController?.tableView.reloadData()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        case .nothing:
            
            print("There is nothing to do")
            
        }
        
    }
    
    func getUserGroupList(completion : @escaping (_ result : Bool) -> Void) {
    
        print("getUserGroupList starts")
        
        let client = RECatchUMobileAPIClient.default()
        
        let inputBody = REGroupRequest()
        
        inputBody?.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Groups.GET_AUTHENTICATED_USER_GROUP_LIST
        
        inputBody?.userid = User.shared.userID
        
        client.groupsPost(body: inputBody!).continueWith { (taskGroupRequestResult) -> Any? in
            
            print("taskGroupRequestResult.result : \(taskGroupRequestResult.result)")
            
            if taskGroupRequestResult.error != nil {
                
                print("taskGroupRequestResult.error : \(taskGroupRequestResult.error)")
                
            } else {
                
                //Group.shared.createGroupDictionary(httpRequest: taskGroupRequestResult.result!)
                print("Group count : \(taskGroupRequestResult.result?.resultArray?.count)")
                Group.shared.createGroupList(httpRequest: taskGroupRequestResult.result!)
                
                completion(true)
                
            }
            
            //completion(true)
            
            return nil
            
        }
    
    }
    
    
    func startAnimationOfContainerViews(inputContainerViewChoise : EnumContainerView) {
        
        switch inputContainerViewChoise {
        case .containerViewFriend:
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.containerViewFriend.alpha = 1.0
                self.containerGroup.alpha = 0.0
                
            })
            
        case .containerViewGroup:
            
            DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                
                
                    self.containerViewFriend.alpha = 0.0
                    self.containerGroup.alpha = 1.0
                    
                })
                
            }
                
        }
        
    }
    
    func returnSegment() -> SegmentedButtonChoise {
        
        if segmentedButton.selectedSegmentIndex == Constants.NumericConstants.INTEGER_ZERO {
            
            return .friends
            
        } else if segmentedButton.selectedSegmentIndex == Constants.NumericConstants.INTEGER_ONE {
            
            return .groups
            
        } else if segmentedButton.selectedSegmentIndex == Constants.NumericConstants.INTEGER_TWO {
            
            return .groupCreation
            
        } else {
            
            return .nothing
            
        }
        
    }
    
}

// extension for searchBar
extension ContactView : UISearchBarDelegate {
    
    // to make searchBar textField background invisible
    func searchBarPropertyManagement() {
        
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchBarProperties.searchField) as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        searchBar.searchBarStyle = .minimal
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // empty searchResult array
        SectionBasedFriend.shared.emptySearchResult()
        
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
                            
                            SectionBasedFriend.shared.searchResult.append(user)
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            
            searchBar.setShowsCancelButton(true, animated: true)
            
            SectionBasedFriend.shared.isSearchModeActivated = true
            
        } else {
            
            print("search text field is empty")
            SectionBasedFriend.shared.isSearchModeActivated = false
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.endEditing(true)
            
        }
        
        referenceMasterViewController.childReferenceFriendContainerFriendController?.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = Constants.CharacterConstants.SPACE
        self.searchBar.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
        
    }
    
    
}
