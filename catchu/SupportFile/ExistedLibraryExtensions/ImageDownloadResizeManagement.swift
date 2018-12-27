//
//  ImageDownloadResizeManagement.swift
//  catchu
//
//  Created by Erkut Baş on 6/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImagesFromCacheOrFirebaseForFriend(_ urlString: String) {
        print("setImagesFromCacheOrFirebaseForFriend starts")
        
        self.image = nil
        
        if let tempImage = SectionBasedFriend.shared.cachedFriendProfileImages.object(forKey: urlString as NSString) {
            
            image = tempImage
            
            print("CACHE YES")
            
        } else {
            
            print("CACHE NO")
            
            if !urlString.isEmpty {
                
//                let url = URL(string: urlString)
                if let url = URL(string: urlString) {
                    
                    print("url : \(url)")
                    
                    let request = URLRequest(url: url)
                    
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
    
    func setImagesFromCacheOrFirebaseForGroup(_ urlString: String) {
        print("setImagesFromCacheOrFirebaseForFriend starts")
        
        self.image = nil
        
        if let tempImage = SectionBasedGroup.shared.cachedGroupImages.object(forKey: urlString as NSString) {
            
            image = tempImage
            
            print("CACHE YES")
            
        } else {
            
            print("CACHE NO")
            
            if !urlString.isEmpty {
                
                if let url = URL(string: urlString) {
                    
                    print("url : \(url)")
                    
                    let request = URLRequest(url: url)
                    
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                        
                        if error != nil {
                            
                            if let errorMessage = error as NSError? {
                                
                                print("errorMessage : \(errorMessage.localizedDescription)")
                                
                            }
                            
                        } else {
                            
                            if let image = UIImage(data: data!) {
                                
                                DispatchQueue.main.async(execute: {

                                    SectionBasedGroup.shared.cachedGroupImages.setObject(image, forKey: urlString as NSString)
                                    
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
    
    func downloadImages(_ urlString: String, completin : @escaping (_ finish : Bool) -> Void) {
        print("downloadImages starts")
       
        self.image = nil
        
        if let tempImage = SectionBasedGroup.shared.cachedGroupImages.object(forKey: urlString as NSString) {
            
            image = tempImage
            
            print("CACHE YES")
            
        } else {
            
            print("CACHE NO")
            
            if !urlString.isEmpty {
                
                //                let url = URL(string: urlString)
                if let url = URL(string: urlString) {
                    
                    print("url : \(url)")
                    
                    let request = URLRequest(url: url)
                    
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                        
                        if error != nil {
                            
                            if let errorMessage = error as NSError? {
                                
                                print("errorMessage : \(errorMessage.localizedDescription)")
                                
                            }
                            
                        } else {
                            
                            if let image = UIImage(data: data!) {
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    SectionBasedGroup.shared.cachedGroupImages.setObject(image, forKey: urlString as NSString)
                                    
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
    
}
