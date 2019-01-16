//
//  Share.swift
//  catchu
//
//  Created by Erkut Baş on 6/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

struct ShareMedia {
    let media: Media
    let type: MediaType
    let image: UIImage?
    let localUrl: URL?
    
    func toData() -> Data? {
        switch self.type {
        case .image:
            guard let image = self.image else { return nil }
            //return UIImageJPEGRepresentation(image, CGFloat(integerLiteral: Constants.NumericConstants.INTEGER_ONE))
            return UIImageJPEGRepresentation(image, 0.80)
        case .video:
            do {
                guard let localUrl = self.localUrl else { return nil }
                return try Data(contentsOf: localUrl)
            } catch {
                print("VideoShare object cann't convert video url to Data")
                return nil
            }
        }
    }
}

class Share {
    
    public static var shared = Share()
    // MARK: Remzi
    var images: [ShareMedia]?
    var videos: [ShareMedia]?
    var message: String?
    var privacyType: PrivacyType?
    var allowList: [User]?
    var groupid: String?
    // MARK:
    
    var tempImageView = UIImageView() // use for notification
    
    var image: UIImage?
    var imageSmall: UIImage?
    var textScreenShot: UIImage?
    var videoScreenShot: UIImage?
    var location: CLLocation?
    var shareid: String?
    var distance: Double?
    var user: User?
    
    
    init() {}
    
    
    func convertPostItemsToShare() {
        
        print("convertPostItemsToShare starts")
        
        // images
        if let imageArray = PostItems.shared.selectedImageArray {
            if let image = imageArray.first {

                var sharedImage = UIImage()
                
                if PostItems.shared.capturedImageEdited {
                    sharedImage = image
                } else {
                    if let resizedImage = image.reSizeImage(inputWidth: Constants.ImageResizeValues.Width.width_1080) {
                        print("resizedImage : \(resizedImage)")
                        sharedImage = resizedImage
                    }
                }
                
                let tempShareMedia = ShareMedia(media: Media(inputExtension: "jpeg"), type: .image, image: sharedImage, localUrl: nil)
                if Share.shared.images == nil {
                    Share.shared.images = [ShareMedia]()
                } else {
                    Share.shared.images?.removeAll()
                }
                Share.shared.images?.append(tempShareMedia)
                
            }
            print("imageArray.count : \(imageArray.count)")
        }
        
        // videos
        if let videoArray = PostItems.shared.selectedVideoUrl {
            
            if let videoUrl = videoArray.first {
                let tempShareMedia = ShareMedia(media: Media(inputExtension: videoUrl.pathExtension), type: .video, image: nil, localUrl: videoUrl)
                
                if Share.shared.videos == nil {
                    Share.shared.videos = [ShareMedia]()
                } else {
                    Share.shared.videos?.removeAll()
                }
                
                Share.shared.videos?.append(tempShareMedia)
                
                
            }
            
            print("videoArray.count : \(videoArray.count)")
            
        }
        
        // note
        if let note = PostItems.shared.message {
            Share.shared.message = note
        }
        
        // privacy & allowList
        if let privacy = PostItems.shared.privacyType {
            Share.shared.privacyType = privacy
            
            switch privacy {
            case .custom:
                
                print("PostItems.shared.selectedFriendArray.count : \(PostItems.shared.selectedFriendArray?.count)")
                if let selectedFriendArray = PostItems.shared.selectedFriendArray {
                    for item in selectedFriendArray {
                        if Share.shared.allowList == nil {
                            Share.shared.allowList = [User]()
                        }
                        
                        Share.shared.allowList?.append(item)
                        
                    }
                }
                
            case .everyone:
                break
                
            case .group:
                if let groupid = PostItems.shared.groupid {
                    Share.shared.groupid = groupid
                }
                
            case .myself:
                break
                
            default:
                break
            }
            
        }
        
        Share.shared.location = LocationManager.shared.currentLocation
        
    }
    
}
