//
//  UIViewExtensions.swift
//  catchu
//
//  Created by Erkut Baş on 8/12/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format : String, views : UIView...) {
        
        var viewsDictionary = [String : UIView]()
        
        for (index, view) in views.enumerated() {
            
            let key = "v\(index)"
            viewsDictionary[key] = view
            
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}
