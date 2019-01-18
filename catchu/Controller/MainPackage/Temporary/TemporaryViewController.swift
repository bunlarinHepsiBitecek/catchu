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
    private var customFetch : CustomFetchView?
    
    var timer: Timer!
    var progressCounter:Float = 0
    let duration:Float = 10.0
    var progressIncrement:Float = 0
    
    var takasi : CGFloat = 0.0
    
    var testBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        let button = UIButton(frame: CGRect(x: 50, y: 300, width: 100, height: 100))
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(TemporaryViewController.tktktk(_:)), for: .touchUpInside)
        button.setTitle("cancel", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(button)
        
        addCustomFetchTemporary()
        // Do any additional setup after loading the view.
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        customFetch!.setupViews()
//
//    }
    
    @objc func tktktk(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonClick(_ sender: UIButton) {
        FirebaseManager.shared.logout()
    }
    
    @IBAction func progressActivate(_ sender: Any) {
        
        takasi += 10
        
        customFetch!.setProgress(progress: takasi)
        
        InformerLoader.shared.animateInformerViews(postState: .success)
        
    }
    
    func addCustomFetchTemporary() {

        customFetch = CustomFetchView()
        
        customFetch!.translatesAutoresizingMaskIntoConstraints = false
        customFetch!.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        self.view.addSubview(customFetch!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customFetch!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 50),
            customFetch!.topAnchor.constraint(equalTo: safe.topAnchor, constant: 50),
            customFetch!.heightAnchor.constraint(equalToConstant: 100),
            customFetch!.widthAnchor.constraint(equalToConstant: 100),
            
            ])
        
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
        
        guard let userid = User.shared.userid else { return }
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                client.friendsGet(userid: userid, perPage: "30", page: "1", authorization: tokenResult.token).continueWith { (taskFriendList) -> Any? in
                    
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
        
        friendRequest.requesterUserid = User.shared.userid
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
    
    @IBAction func bas(_ sender: Any) {
        /*
        let groupInfoView = GroupInfoView2()
        groupInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(groupInfoView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        //        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            
            groupInfoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupInfoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupInfoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            //groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor, constant: -statusBarHeight),
            groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])*/
        
        InformerLoader.shared.animateInformerViews(postState: .failed)
        
    }
}
