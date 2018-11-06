//
//  CustomNotificationManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import UserNotifications

class CustomNotificationManager: NSObject {
    
    public static var shared = CustomNotificationManager()
    
    var title : String?
    var subTitle : String?
    var message : String?
    var categoryIdentifier : String?
    var processFailed : Bool?
    var attachmentImageArray : [UIImage]?
    
    var content = UNMutableNotificationContent()
    
    func sendNotification(inputTitle : String, inputSubTitle : String, inputMessage : String, inputIdentifier : String, operationResult : Bool, image: [UIImage], completion : @escaping(_ finish : Bool) -> Void) {
        
        self.title = inputTitle
        self.subTitle = inputSubTitle
        self.message = inputMessage
        self.categoryIdentifier = inputIdentifier
        self.processFailed = operationResult
        self.attachmentImageArray = image
        
        UNUserNotificationCenter.current().delegate = self
        print("UNUserNotificationCenter.current().delegate : \(UNUserNotificationCenter.current().delegate)")
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            
            let authorizationStatus = notificationSettings.authorizationStatus
            
            switch authorizationStatus {
            case .authorized:
                // send notification
                print("sending notification")
                self.initiateNotificationProcess(completion: { (finish) in
                    if finish {
                        completion(true)
                    }
                })
            case .notDetermined:
                // ask permission
                print("not determined ask it")
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
                    
                    if error != nil {
                        if let errorCode = error as NSError? {
                            print("error : \(errorCode.localizedDescription)")
                        }
                    } else {
                        if granted {
                            // send notification
                            print("sending notification")
                        }
                    }
                    
                })
            default:
                // show customAlertView
                break
            }
        }
        
    }
    
    private func initiateNotificationProcess(completion : @escaping(_ finish : Bool) -> Void) {
        
        if !processFailed! {
            UNUserNotificationCenter.current().setNotificationCategories([setNotificationCategories()])
        }
        
        UNUserNotificationCenter.current().add(createNotificationRequest()) { (error) in
            if error != nil {
                if let errorCode = error as NSError? {
                    print("error : \(errorCode.localizedDescription)")
                }
            } else {
                completion(true)
            }
        }
        
    }
    
    private func createNotificationRequest() -> UNNotificationRequest {
        
        let identifier = self.categoryIdentifier

        if let title = title {
            content.title = title
        }
        
        /*
        if let subTitle = subTitle {
            content.subtitle = subTitle
        }*/
        
        if let message = message {
            content.body = message
        }
        
        if let operationResult = self.processFailed {
            if !operationResult {
                
                if let imageArray = self.attachmentImageArray {
                    
                    for item in imageArray {
                        
                        let attachment = UNNotificationAttachment.create(identifier: identifier!, image: item.fixImageOrientation(), options: nil)
                        
                        if let attachment = attachment {
                            content.attachments = [attachment]
                            
                        }
                    }
                }
            }
        }
        
        // setup trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.AnimationValues.timeInterval_1, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier!, content: content, trigger: trigger)
        
        return request
        
    }
    
    private func setNotificationCategories() -> UNNotificationCategory {
        
        let identifier = self.categoryIdentifier
        
        // setting up actions
        let tryAgain = UNNotificationAction(identifier: NotificationIdentifiers.tryAgain.rawValue, title: LocalizedConstants.TitleValues.ButtonTitle.tryAgain, options: [])
        
        // category settings
        let category = UNNotificationCategory(identifier: identifier!, actions: [tryAgain], intentIdentifiers: [], options: [.customDismissAction])
        
        content.categoryIdentifier = identifier!
        
        return category
        
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension CustomNotificationManager : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // this class takes delegation from appdelegate
        print("CustomNotificationManager notificationCenter willPresent triggered")
        
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case NotificationIdentifiers.tryAgain.rawValue:
            print("Try Again Pressed")
            
            APIGatewayManager.shared.initiatePostOperations()
            
        default:
            break
        }
        
        completionHandler()
        
    }
    
}

