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
    var selectedFriendArray : Array<User>?
    var message: String?
    var privacyType: PrivacyType?
    var groupid: String?
    
    func clearPostItemsObjects() {
        
        PostItems.shared.selectedImageDictionary?.removeAll()
        PostItems.shared.selectedVideoUrl?.removeAll()
        PostItems.shared.selectedFriendArray?.removeAll()
        PostItems.shared.message = Constants.CharacterConstants.EMPTY
        PostItems.shared.groupid = Constants.CharacterConstants.EMPTY
        PostItems.shared.privacyType = PrivacyType.allFollowers
        
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
    
}
