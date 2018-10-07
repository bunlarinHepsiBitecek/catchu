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


extension UIImageView {
    
    public func setImageInitialPlaceholder(_ string: String, backgroundColor: UIColor? = nil, circular: Bool, textAttributes: [NSAttributedStringKey: AnyObject]? = nil) {
        
        let initials: String = initialsFromString(string: string)
        let color = backgroundColor ?? UIColor.gray
        let attributes: [NSAttributedStringKey: AnyObject] = (textAttributes != nil) ? textAttributes! : [
            NSAttributedStringKey.font: self.fontForFontName(name: nil),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        self.image = imageSnapshot(text: initials, backgroundColor: color, circular: circular, textAttributes: attributes)
    }
    
    private func fontForFontName(name: String?) -> UIFont {
        let kFontResizingProportion: CGFloat = 0.4
        
        let fontSize = self.bounds.width * kFontResizingProportion;
        if name != nil {
            return UIFont(name: name!, size: fontSize)!
        }
        else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    private func imageSnapshot(text imageText: String, backgroundColor: UIColor, circular: Bool, textAttributes: [NSAttributedStringKey : AnyObject]) -> UIImage {
        
        let scale: CGFloat = UIScreen.main.scale
        
        var size: CGSize = self.bounds.size
        if (self.contentMode == .scaleToFill ||
            self.contentMode == .scaleAspectFill ||
            self.contentMode == .scaleAspectFit ||
            self.contentMode == .redraw) {
            
            size.width = (size.width * scale) / scale
            size.height = (size.height * scale) / scale
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        if circular {
            // Clip context to a circle
            let path: CGPath = CGPath(ellipseIn: self.bounds, transform: nil)
            context.addPath(path)
            context.clip()
        }
        
        // Fill background of context
        context.setFillColor(backgroundColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Draw text in the context
        let textSize: CGSize = imageText.size(withAttributes: textAttributes)
        let bounds: CGRect = self.bounds
        
        imageText.draw(in: CGRect(x: bounds.midX - textSize.width / 2,
                                  y: bounds.midY - textSize.height / 2,
                                  width: textSize.width,
                                  height: textSize.height),
                       withAttributes: textAttributes)
        
        let snapshot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return snapshot;
    }
    
    private func initialsFromString(string: String) -> String {
        return string.components(separatedBy: .whitespacesAndNewlines).reduce("") {
            ($0.isEmpty ? "" : "\($0.uppercased().first!)") + ($1.isEmpty ? "" : "\($1.uppercased().first!)")
        }
    }
    
}
