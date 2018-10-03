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


// MARK: - Layout
extension UIView {
    
    open var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    open var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    open var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    open var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    open var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
    
    open var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
    
    open var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerXAnchor
        }
        return centerXAnchor
    }
    
    open var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerYAnchor
        }
        return centerYAnchor
    }
}
