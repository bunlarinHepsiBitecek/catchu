//
//  UIImageExtensions.swift
//  catchu
//
//  Created by Erkut Baş on 6/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func getImageFromFirebaseStorage(url : String, completion : @escaping (_ result : Bool) -> Void) {
        
        self.image = nil
        
        let url = URL(string: url)
        let urlRequest = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    print("errorCode : \(errorCode.userInfo)")
                    
                }
                
            } else {
                
                if let image = UIImage(data: data!) {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.image = image
                        
                        completion(true)
                        
                    })
                }
                
                
            }
            
        }
        
        task.resume()
        
        
    }
    
}
