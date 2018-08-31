//
//  REAWSManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class REAWSManager {
    
    public static let shared = REAWSManager()
    
    
    /// is used to signed url to upload file on Amazon S3
    ///
    /// - Parameter completion: A RECommonS3BucketResult
    /// - Returns:
    /// - Author: Remzi Yildirim
    private func getSignedUpload(completion : @escaping (_ result : RECommonS3BucketResult) -> Void) {
        let extention = "jpg"
        
        RECatchUMobileAPIClient.default().commonSignedurlGet(_extension: extention).continueWith { (task) -> Any? in
            print("Task: \(task)")
            
            if let result = task.result {
                completion(result)
            }
            
            return nil
        }
    }
    
    /// Send text, image data to graph via AWS
    ///
    /// - Parameter imageExist: if image media data exist then set true
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func shareData(imageExist: Bool) {
        guard Reachability.networkConnectionCheck() else {return}
        
        if imageExist {
            self.getSignedUpload { (commonS3BucketResult) in
                print("Compilation signed: \(commonS3BucketResult)")
                self.uploadFileToS3(commonS3BucketResult: commonS3BucketResult, completion: { (result) in
                    print("Compilation S3: \(result)")
                    self.sharePostRequest()
                })
            }
        } else {
            self.sharePostRequest()
        }
    }
    
    
    /// Get shared items to nearby current location within specified range
    ///
    /// - Parameters:
    ///   - radius: search location range
    ///   - completion: A REShareListResponse
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func getGeolocationData(radius: Double, completion: @escaping (_ result : REShareListResponse) -> Void) {
        guard Reachability.networkConnectionCheck() else {return}
        
        print("getGeolocationData: \(LocationManager.shared.currentLocation.coordinate.latitude)")
        
        let share = REShare()
        share?.userid = User.shared.userID
        
        guard let shareDTO = share  else {return}
        
        let latitude = String(LocationManager.shared.currentLocation.coordinate.latitude)
        let longitude = String(LocationManager.shared.currentLocation.coordinate.longitude)
        let radius = String(radius)
        
        
        print("userid  : \(String(describing: shareDTO.userid))")
        print("latitude: \(latitude) - longitude: \(longitude) radius: \(radius)")
        
        RECatchUMobileAPIClient.default().sharesGeolocationPost(body: shareDTO, longitude: longitude, latitude: latitude, radius: radius).continueWith { (task) -> Any? in
            
            print("Result: \(task)")
            
            if let shareList = task.result {
                print("ShareList: \(shareList)")
                completion(shareList)
            }
            return nil
        }
        
        
    }
    
    
}


// private function
extension REAWSManager {
    
    private func uploadFileToS3(commonS3BucketResult: RECommonS3BucketResult, completion : @escaping (_ result : Bool) -> Void) -> Void {
        
        print("uploadFileToS3 started")
        
        guard let signedUrl = URL(string: commonS3BucketResult.signedUrl!) else {return}
        
        guard let imageData = UIImageJPEGRepresentation(Share.shared.image, CGFloat(integerLiteral: Constants.NumericConstants.INTEGER_ONE)) else {return}
        
        UploadManager.shared.uploadFile(signedUploadUrl: signedUrl, data: imageData) { (result) in
            Share.shared.imageUrl = commonS3BucketResult.downloadUrl!
            completion(true)
        }
    }
    
    private func sharePostRequest() {
        
        let location = RELocation()
        location?.latitude = NSNumber(value: Share.shared.location.coordinate.latitude)
        location?.longitude = NSNumber(value: Share.shared.location.coordinate.longitude)
        
        // create Share object
        let share = REShare()
        share?.userid = User.shared.userID
        share?.text = Share.shared.text
        share?.imageUrl = Share.shared.imageUrl
        share?.location = location
        share?.privacyType = PrivacyType.allFollowers.stringValue
//        share?.privacyType = PrivacyType.custom.stringValue
        share?.allowList = []

//        let user1 = REShare_allowList_item()
//        let user2 = REShare_allowList_item()
//        user1?.userid = "us-east-1:ea155b84-4f97-49f0-8559-5b20d507bdfa"
//        user2?.userid = "us-east-1:8a22a451-af0d-48cb-8e6b-f0ed3316449b"
//        share?.allowList?.append(user1!)
//        share?.allowList?.append(user2!)
        
        let shareRequest = REShareRequest()
        shareRequest?.share = share
        
        
        RECatchUMobileAPIClient.default().sharesShareidPost(shareid: Constants.CharacterConstants.SPACE, body: shareRequest!).continueWith { (task) -> Any? in
            
            print("Result: \(task)")
            
            if let result = task.result {
                print("result class: \(result)")
                print("result Error class: \(String(describing: result.error))")
                print("shareid: \(String(describing: result.share?.shareid))")
                print("imageurl: \(String(describing: result.share?.imageUrl))")
            }
            
            return nil
        }
        
    }
    
}
