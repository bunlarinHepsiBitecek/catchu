//
//  AppDelegate.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import TwitterKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey: Constants.TWITTER_CUSTOMER_KEY, consumerSecret: Constants.TWITTER_CUSTOMER_SECRETKEY)
        
        //NotificationManager.shared.initializeRegisterForRemoteNotification()
        //application.registerForRemoteNotifications()
        //UIApplication.shared.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        //FirebaseManager.shared.checkUserLoggedIn()
        
//        let awsInstance = AWSMobileClient.sharedInstance().interceptApplication(
//            application, didFinishLaunchingWithOptions:
//            launchOptions)
        
        
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Twitter log-in - Completed sign-in but not being redirected to my app
    func application(_ application:UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
//        let directedByGGL =  GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        print("I have received a URL through custom url scheme : \(url.absoluteString)")
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            // handle twitter sign in
            let directedByTWTR =  TWTRTwitter.sharedInstance().application(application, open: url, options: options)
            return directedByTWTR
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("AppDelegate userNotificationCenter willPresent triggered")
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("AppDelegate userNotificationCenter didReceive triggered")
        
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        let token2 = deviceToken.map { String(format: "%02.2hhx", $0)}.joined()
        print("token2 = \(token2)")
        
        print("device token : \(token)")
        print("deviceToken : ", deviceToken)
        print("Userid : \(User.shared.userid)")
        
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        
//        APIGatewayManager.shared.createApplicationEndpoint(userid: User.shared.userid!, deviceToken: token2) { (result) in
//            
//            switch result {
//            case .failure(let error):
//                print("failure")
//            case .success(let data):
//                print("success")
//            }
//            
//        }
        
    }
    
    func handleIncomingDynamicLink(_ dynamicLink : DynamicLink) {
        
        guard let url = dynamicLink.url else {
            print("that's weird, my dynamicLink has no url!")
            return
        }
        
        print("Your incoming link paramater is : \(dynamicLink.url?.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
        
        for queryItem in queryItems {
            print("parameter : \(queryItem.name) has a value of : \(queryItem.value ?? "")")
            
        }
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if let incomingUrl = userActivity.webpageURL {
            print("incomingUrl is : \(incomingUrl)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                
                guard error == nil else {
                    
                    print("Found error : \(error?.localizedDescription)")
                    return
                    
                }
                
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
                
            }
            
            if linkHandled {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    

    
}

/*
 
 {
 "requestType": "CREATE_APPLICATION_ENDPOINT",
 "userid": "VVkIWB15bdcrEli4kSD4uv8gPIl1",
 "deviceToken": "81e45d1afbeafabe2dab7c3e6da88425c082e0b5e1113a7cf23cb29ccd303788"
 }
 
 https://stackoverflow.com/questions/11516782/how-to-get-registrationid-using-gcm-in-android
 
 */
