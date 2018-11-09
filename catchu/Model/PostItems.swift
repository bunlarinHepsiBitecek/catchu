//
//  PostItems.swift
//  catchu
//
//  Created by Erkut Baş on 10/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostItems {

    public static var shared = PostItems()
    
    var selectedImageDictionary : Array<UIImage>?
    var selectedVideoUrl : Array<URL>?
    var selectedVideoScreenShoot : Dictionary<URL, UIImage>?
    var selectedVideoScreenShootWithPlayButton : Dictionary<URL, UIImage>?
    var selectedFriendArray : Array<User>?
    var message: String?
    var messageScreenShot : UIImage?
    var privacyType: PrivacyType?
    var groupid: String?
    
    func clearPostItemsObjects() {
        
        PostItems.shared.selectedImageDictionary?.removeAll()
        PostItems.shared.selectedVideoUrl?.removeAll()
        PostItems.shared.selectedVideoScreenShoot?.removeAll()
        selectedVideoScreenShootWithPlayButton?.removeAll()
        PostItems.shared.selectedFriendArray?.removeAll()
        PostItems.shared.messageScreenShot = UIImage()
        PostItems.shared.message = Constants.CharacterConstants.EMPTY
        PostItems.shared.groupid = Constants.CharacterConstants.EMPTY
        PostItems.shared.privacyType = PrivacyType.allFollowers
        
    }
    
    func setSnapShotOfMessage(inputImage : UIImage) {
        PostItems.shared.messageScreenShot = inputImage
    }
    
    func appendVideoScreenShot(inputURL: URL, inputImage: UIImage) {
        
        if PostItems.shared.selectedVideoScreenShoot == nil {
            PostItems.shared.selectedVideoScreenShoot = Dictionary<URL, UIImage>()
        }
        
        PostItems.shared.selectedVideoScreenShoot![inputURL] = inputImage
        addPlayButtonToScreenShot(inputURL: inputURL)
    }
    
    func deleteVideoScreenShot(inputUrl : URL) {
        
        if PostItems.shared.selectedVideoScreenShoot != nil {
            PostItems.shared.selectedVideoScreenShoot?.removeValue(forKey: inputUrl)
        }
        
        if PostItems.shared.selectedVideoScreenShootWithPlayButton != nil {
           PostItems.shared.selectedVideoScreenShootWithPlayButton?.removeValue(forKey: inputUrl)
        }
        
    }
    
    func returnImage(index : Int) -> UIImage {
        
        if PostItems.shared.selectedImageDictionary != nil {
            if let image = PostItems.shared.selectedImageDictionary?[index] {
                return image
            }
        }
        
        return UIImage()
        
    }
    
    func returnVideoUrl(index : Int) -> URL {
        
        if PostItems.shared.selectedVideoUrl != nil {
            if let url = PostItems.shared.selectedVideoUrl?[index] {
                return url
            }
        }
        
        return URL(string: Constants.CharacterConstants.SPACE)!
        
    }
    
    func emptySelectedImageArray() {
        
        if PostItems.shared.selectedImageDictionary != nil {
            PostItems.shared.selectedImageDictionary!.removeAll()
        }
        
    }
    
    func emptySelectedVideoArrays() {
        
        if PostItems.shared.selectedVideoUrl != nil {
            PostItems.shared.selectedVideoUrl!.removeAll()
        }
        
    }
    
    func returnTotalPostItems() -> Int {
        
        var count = 0
        
        if PostItems.shared.selectedImageDictionary != nil {
            count += PostItems.shared.selectedImageDictionary!.count
        }
        
        if PostItems.shared.selectedVideoUrl != nil {
            count += PostItems.shared.selectedVideoUrl!.count
        }
        
        return count
        
    }
    
    func setNote(inputString : String) {
        PostItems.shared.message = inputString
    }
    
    func createSelectedAllowList(inputPostType : PostAttachmentTypes) {
        
        switch inputPostType {
        case .friends:
            
            if SectionBasedFriend.shared.selectedUserArray.count > 0 {
                if PostItems.shared.selectedFriendArray == nil {
                    PostItems.shared.selectedFriendArray = Array<User>()
                } else {
                    PostItems.shared.selectedFriendArray?.removeAll()
                }
                
                for item in SectionBasedFriend.shared.selectedUserArray {
                    PostItems.shared.selectedFriendArray?.append(item)
                }
            }
            
        case .group:
            
            if SectionBasedGroup.shared.selectedGroupList.count > 0 {
                
                if let group = SectionBasedGroup.shared.selectedGroupList.first {
                    if let groupid = group.groupID {
                        PostItems.shared.groupid = groupid
                    }
                }

            }
            
        default:
            break
        }
        
    }
    
    func addPlayButtonToScreenShot(inputURL : URL) {
        
        let image = PostItems.shared.selectedVideoScreenShoot![inputURL]
        let playButton = UIImage(named: "play-button-colored.png")
        
        let xPoint = image!.size.width / 2 - 100
        let yPoint = image!.size.height / 2 - 100
        
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 0.0)
        
        image!.draw(in: CGRect(origin: .zero, size: image!.size))
        playButton!.draw(in: CGRect(origin: CGPoint(x: xPoint, y: yPoint), size: CGSize(width: 200, height: 200)))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if PostItems.shared.selectedVideoScreenShootWithPlayButton == nil {
            PostItems.shared.selectedVideoScreenShootWithPlayButton = Dictionary<URL, UIImage>()
        }
        
        PostItems.shared.selectedVideoScreenShootWithPlayButton![inputURL] = newImage
        
    }
    
}
