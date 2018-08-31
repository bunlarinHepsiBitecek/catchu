//
//  NotificationManager2.swift
//  catchu
//
//  Created by Erkut Baş on 6/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationActions: String {
    case HighFive = "highfiveidentifier"
}

class NotificationManager2 : NSObject, UNUserNotificationCenterDelegate {
    
    public static let shared = NotificationManager2()
    
    func registerForNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            
            if granted {
              
                self.sendLocalNotification()
                
            } else {
                
//                
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
                    if error == nil {
                        
                        self.sendLocalNotification()
                        
                    }
                })
                
            }
            
        }
        
    }
    
    func sendLocalNotification() {
        
        UNUserNotificationCenter.current().add(createRequestForLocalNotification()) { (error) in
            
            if error != nil {
                
                print("ooooooooo")
                
            } else {
                
                self.x()
                
            }
            
        }
        
        
    }
    
    func x() {
        
        let highFiveAction = UNNotificationAction(identifier: NotificationActions.HighFive.rawValue, title: "High Five", options: [])
        
        let category = UNNotificationCategory(identifier: "wassup", actions: [highFiveAction], intentIdentifiers: [], options: [.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(createRequestForLocalNotification()) { (error) in
            
            if error != nil {
                
                print("KKKKKKKKK")
                
            } else {
                
                print("LLLLLLLLL")
                
            }
            
        }
        
    }
    
    func createRequestForLocalNotification() -> UNNotificationRequest {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        return UNNotificationRequest(identifier: Constants.NotificationCenterConstants.refreshCounterValues, content: setContentOfLocalNotification(), trigger: trigger)
        
    }
    
    func setContentOfLocalNotification() -> UNMutableNotificationContent {
        
        print("setContentOfLocalNotification starts")
        
        print("share.shared.text : \(Share.shared.text)")
        
        let content = UNMutableNotificationContent()
        
        content.title = "CatchU"
        content.subtitle = LocalizedConstants.Notification.CatchSomething
        content.body = Share.shared.text
        
        //let url = Bundle.main.url(forResource: "8771", withExtension: "jpg")
        
        if let attachment = UNNotificationAttachment.create(identifier: "image", image: Share.shared.tempImageView.image!, options: nil) {
            
            content.attachments = [attachment] as! [UNNotificationAttachment]
            
        }
        
        return content
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        print("pppppppppp")
        
        // Response has actionIdentifier, userText, Notification (which has Request, which has Trigger and Content)
        switch response.actionIdentifier {
        case NotificationActions.HighFive.rawValue:
            print("High Five Delivered!")
        default: break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        print("qqqqqqqqqqq")
        // Delivers a notification to an app running in the foreground.
    }
    
}

extension UNNotificationAttachment {
    
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = UIImagePNGRepresentation(image) else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}
