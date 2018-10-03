//
//  TemporaryViewController.swift
//  catchu
//
//  Created by Erkut Baş on 6/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import UserNotifications

class TemporaryViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var testImage: UIImageView!
    
    var testBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func logoutButtonClick(_ sender: UIButton) {
        FirebaseManager.shared.logout()
    }
    
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("GGGGGG")
        
        completionHandler([.alert, .sound, .badge])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goFriendView(_ sender: Any) {

        startFriendViewPresentation()
//        presentFriendViewController()
        
    }
    
    func presentFriendViewController() {
        
        if let destinationViewController = UIStoryboard(name: Constants.StoryBoardID.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ContactViewController) as? ContactViewController {

            present(destinationViewController, animated: true, completion: nil)
            
        }
        
    }
    
    func getUserFriendList(completion : @escaping (_ result : Bool) -> Void) {
        
        let client = RECatchUMobileAPIClient.default()
        
        let userid = User.shared.userID
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                client.friendsGet(userid: userid, authorization: tokenResult.token).continueWith { (taskFriendList) -> Any? in
                    
                    if taskFriendList.error != nil {
                        
                        print("getting friend list failed")
                        print("result : \(taskFriendList.error)")
                        print("result : \(taskFriendList.result)")
                        completion(false)
                        
                    } else {
                        
                        print("getting friend list ok")
                        
                        User.shared.appendElementIntoFriendListAWS(httpResult: taskFriendList.result!)
                        
                    }
                    
                    completion(true)
                    
                    return nil
                    
                }
            
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                
                if finished {
                    
                    let input = REGroupRequest()
                    
                    input?.requestType = RequestType.get_group_participant_list.rawValue
                    input?.groupid = "group1"
                    
                    client.groupsPost(authorization: tokenResult.token, body: input!).continueWith(block: { (task) -> Any? in
                        
                        print("yarrrroooooo")
                        
                        if task.error != nil {
                            
                            print("Error : \(task.error)")
                            
                        } else {
                            
                            print("task result : \(task.result?.error)")
                            
                            completion(true)
                            
                            
                        }
                        
                        return nil
                        
                    })
                    
                }
                
            })
            
            
            
        }
        
//        // gecici silinecek
//        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
//
//            if finished {
//
//
//
//
//            }
//
//        }

    }
    
    func startFriendViewPresentation() {
        
        print("userFriendList count : \(User.shared.userFriendList.count)")
        
        if User.shared.userFriendList.count > 0 {
            
            self.presentFriendViewController()
            
        } else {
            
            LoaderController.shared.showLoader()
            
            getUserFriendList { (result) in
                
                if result {
                    LoaderController.shared.removeLoader()
                    
                    /*
                     eger viewControlleri async olarak present etmessen asagidaki gibi bir warning aliyorsun. Bunun nedeni, sen ayns olarak amazondan data cekiyorsun ve bunu bir completion handler a bagliyorsun ve main thread dispatch acmadan main thread icerisinde view controller present etmeye calisiyorsun. Bu noktada segmented button labellari sonradan geliyor, asyn transaction main thread e yetisemiyor. O yuzden viewcontroller i asagidaki gibi asyn olarak call edeceksin.
                     
                     Warningn : This application is modifying the autolayout engine from a background thread after the engine was accessed from the main thread. This can lead to engine corruption and weird crashes
                     */
                    DispatchQueue.main.async {
                        
                        self.presentFriendViewController()
                        
                    }
                    
                }
                
            }
            
            print("erkut")
            
        }
        
    }
    
    
    @IBAction func printData(_ sender: Any) {
    
        SectionBasedFriend.shared.createInitialLetterBasedFriendDictionary()
        
        for item in SectionBasedFriend.shared.friendUsernameInitialBasedDictionary {
            
            for item2 in item.value as [User] {

                print("isUserSelected :\(item2.isUserSelected)")
                
            }
            
        }
        
        
        NotificationManager2.shared.registerForNotification()
        
    }
    
    @IBAction func sendImage(_ sender: Any) {
        
//        let function = Functions.functions()
//        
//        let uploadData = UIImagePNGRepresentation(testImage.image!)
//        
//        let data = ["yarro" : uploadData]
//        
//        function.httpsCallable("uploadImage").call(data) { (httpResult, error) in
//            
//            if error != nil {
//                
//                if let errorCode = error as NSError? {
//                    
//                    print("errorCode : \(errorCode.localizedDescription)")
//                    print("errorCode : \(errorCode.userInfo)")
//                    
//                }
//                
//            } else {
//                
//                if let data = httpResult?.data {
//                    
//                    print("data : \(data)")
//                    
//                }
//                
//            }
//            
//        }
            
    }
    
    @IBAction func getFriendsData(_ sender: Any) {
        
        getUserFriendList { (result) in
            
            print("result : \(result)")
            
        }
        
        
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        let client = RECatchUMobileAPIClient.default()
        
//        client.usersGet(userid: User.shared.userID).continueWith { (taskUserProfile) -> Any? in
//
//            print("error : \(taskUserProfile.error)")
//            print("result : \(taskUserProfile.result)")
//
//            taskUserProfile.result?.resultArray
//            return nil
//        }
        
        
    }
    
    @IBOutlet var fiki: UILabel!
    @IBAction func bk(_ sender: Any) {
        
        let client = RECatchUMobileAPIClient.default()
        
        guard let friendRequest = REFriendRequest() else { return }
        
        friendRequest.requesterUserid = User.shared.userID
        friendRequest.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.requestingFollowList
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            if finished {
                client.followRequestPost(authorization: tokenResult.token, body: friendRequest).continueWith { (task) -> Any? in
                    print("task : \(task.result)")
                    
                    
                    DispatchQueue.main.async {
                        
                        self.fiki.text = String(describing: task.result?.resultArray?.count)
                        
                    }
                    
                    User.shared.addRequestingFollow(httpResult: task.result!)
                    
                    
                    return nil
                }
            }
        }
    }
}
