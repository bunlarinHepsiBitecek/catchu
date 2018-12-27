//
//  ImageSizeManager.swift
//  catchu
//
//  Created by Erkut Baş on 12/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

extension UIImage {
    
    // image resize, especially reduce the size of the content
    func reSizeImage(orientation: ImageOrientation) -> UIImage? {
        
        // This is the rect that we've calculated out and this is what is actually used below
        guard let rect = returnRectangles(imageOrientation: orientation) else { return nil }
        guard let size = returnSize(imageOrientation: orientation) else { return nil }
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
    func returnRectangles(imageOrientation: ImageOrientation) -> CGRect? {
        
        // first check orientation of image
        switch imageOrientation {
        case .portrait:
            return CGRect(x: 0, y: 0, width: Constants.ImageResizeValues.Width.width_1080, height: Constants.ImageResizeValues.Height.height_1440)
        case .landScape:
            return CGRect(x: 0, y: 0, width: Constants.ImageResizeValues.Width.width_1440, height: Constants.ImageResizeValues.Height.height_1080)
        case .square:
            return CGRect(x: 0, y: 0, width: Constants.ImageResizeValues.Width.width_1080, height: Constants.ImageResizeValues.Height.height_1080)
        case .other:
            return nil
        }
        
    }
    
    func returnSize(imageOrientation: ImageOrientation) -> CGSize? {
        // first check orientation of image
        switch imageOrientation {
        case .portrait:
            return CGSize(width: Constants.ImageResizeValues.Width.width_1080, height: Constants.ImageResizeValues.Height.height_1440)
        case .landScape:
            return CGSize(width: Constants.ImageResizeValues.Width.width_1440, height: Constants.ImageResizeValues.Height.height_1080)
        case .square:
            return CGSize(width: Constants.ImageResizeValues.Width.width_1080, height: Constants.ImageResizeValues.Height.height_1080)
        case .other:
            return nil
        }
    }

    
}
