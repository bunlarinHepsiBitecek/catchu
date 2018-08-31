//
//  CloudFunctionsManager.swift
//  catchu
//
//  Created by Erkut Baş on 6/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import FirebaseFunctions

class CloudFunctionsManager {
    
    public static let shared = CloudFunctionsManager()
    lazy var functions = Functions.functions()
    
    func getSharedDataByUserNameAndShareId(inputKey : String, completion : @escaping (_ result : Bool) -> Void) {
        
        print("getSharedDataByUserNameAndShareId starts")
        print("inputKey : \(inputKey)")
        
        let data = ["shareId" : inputKey]
        
        functions.httpsCallable(Constants.FirebaseCallableFunctions.getShareDataByShareID).call(data) { (httpResult, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let data = httpResult?.data {
                
                    print("data : \(data)")
                    
                    let tempShareObject = Share()
                    
                    tempShareObject.shareId = inputKey
                    tempShareObject.parseShareData(dataDictionary: data as! [String : AnyObject])
                    
                    Share.shared.appendElementIntoShareQueryResultDictionary(key: inputKey, value: tempShareObject)
                    
                }
                
            }
            
            completion(true)
        }
        
    }
    
    func createSharedModel() {
        
        let data = Share.shared.createSharedDataDictionary()
        
        functions.httpsCallable(Constants.FirebaseCallableFunctions.setNewShareData).call(data) { (httpResult, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let data = httpResult?.data {
                    
                    print("data : \(data)")
                }
                
            }
            
        }
        
        print("data :\(data)")
        
    }
    
    func createUserProfileModel() {
        
        let data = User.shared.createUserDataDictionary()
        
        functions.httpsCallable(Constants.FirebaseCallableFunctions.createUserProfile).call(data) { (httpResult, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let data = httpResult?.data {
                    
                    print("data : \(data)")
                    
                }
                
            }
            
        }
        
        print("data :\(data)")
    }
    
    // function below uses singleton user object
    func updateUserProfileModel() {
        
        User.shared.toString()
        
        let data = User.shared.createUserDataDictionary()
        
        functions.httpsCallable(Constants.FirebaseCallableFunctions.updateUserProfile).call(data) { (httpResult, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let data = httpResult?.data {
                    
                    print("data : \(data)")
                    
                }
                
            }
            
        }
        
        print("data :\(data)")
    }
    
    // function below updates specific childs of Profile unique nodes according to data 
    func updateUserProfileModelWithData(data: NSDictionary) {
        
        User.shared.toString()
        functions.httpsCallable(Constants.FirebaseCallableFunctions.updateUserProfile).call(data) { (httpResult, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let data = httpResult?.data {
                    
                    print("data : \(data)")
                    
                }
                
            }
            
        }
        
        print("data :\(data)")
    }
    
    func getFriends() {
        
        User.shared.toString()
        
        functions.httpsCallable(Constants.FirebaseCallableFunctions.getFriends).call { (httpResult, error) in
           
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.localizedDescription)")
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                User.shared.appendElementIntoFriendList(httpResult: httpResult!)
                
            }
        }
    }
    
}
