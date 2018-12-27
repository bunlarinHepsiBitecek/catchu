//
//  ImageCacheManager.swift
//  catchu
//
//  Created by Erkut Baş on 12/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    
    var cachedGroupImages = NSCache<NSString, UIImage>()
    
    func eraseImageFromCache(_ urlString: String) {
        ImageCacheManager.shared.cachedGroupImages.removeObject(forKey: urlString as NSString)
        
        let thumbnailsUrl = urlString.replacingOccurrences(of: ImageSizeTypes.originals.rawValue, with: ImageSizeTypes.thumbnails.rawValue)
        
        ImageCacheManager.shared.cachedGroupImages.removeObject(forKey: thumbnailsUrl as NSString)
    }
    
    func saveImageToCache(_ urlString: String, image: UIImage) {
        ImageCacheManager.shared.cachedGroupImages.setObject(image, forKey: urlString as NSString)
        
        let thumbnailsUrl = urlString.replacingOccurrences(of: ImageSizeTypes.originals.rawValue, with: ImageSizeTypes.thumbnails.rawValue)
        
        ImageCacheManager.shared.cachedGroupImages.setObject(image, forKey: thumbnailsUrl as NSString)
        
    }
    
}

extension UIImageView {
    
    /// Description : set image from cache or download from server
    ///
    /// - Parameters:
    ///   - urlString: related url string
    ///   - type: originals or thumbnails
    func setImagesFromCacheOrDownloadWithTypes(_ urlString: String, type: ImageSizeTypes) {
        print("\(#function)")
        
        var urlString = urlString
        
        if type == .thumbnails {
            urlString = urlString.replacingOccurrences(of: ImageSizeTypes.originals.rawValue, with: type.rawValue)
        }
        
        self.image = nil
        
        if let tempImage = ImageCacheManager.shared.cachedGroupImages.object(forKey: urlString as NSString) {
            image = tempImage
        } else {
            if !urlString.isEmpty {
                if let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                        if error != nil {
                            if let errorMessage = error as NSError? {
                                print("errorMessage : \(errorMessage.localizedDescription)")
                            }
                        } else {
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async(execute: {
                                    ImageCacheManager.shared.cachedGroupImages.setObject(image, forKey: urlString as NSString)
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
