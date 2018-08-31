//
//  ExtensionUIImageView.swift
//  catchu
//
//  Created by Erkut Baş on 6/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Firebase

extension UIImageView {
    
    func setImagesFromCacheOrFirebaseForFriend(_ urlString: String) {
        
        self.image = nil
        
        if let tempImage = SectionBasedFriend.shared.cachedFriendProfileImages.object(forKey: urlString as NSString) {
            
            image = tempImage
            
        } else {
            
            if !urlString.isEmpty {
                
                let url = URL(string: urlString)
                
                let request = URLRequest(url: url!)
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                    
                    if error != nil {
                        
                        if let errorMessage = error as NSError? {
                            
                            print("errorMessage : \(errorMessage.localizedDescription)")
                            
                        }
                        
                    } else {
                        
                        if let image = UIImage(data: data!) {
                            
                            DispatchQueue.main.async(execute: {

                                SectionBasedFriend.shared.cachedFriendProfileImages.setObject(image, forKey: urlString as NSString)

                                self.image = image

                            })
                        }
                    }
                })
                
                task.resume()
            }
        }
    }
    
}
