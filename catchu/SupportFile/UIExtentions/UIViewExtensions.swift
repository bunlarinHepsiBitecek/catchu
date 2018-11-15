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


extension UIViewController {
    
    /// An extension add child view controller and move parent
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    /// An extension remove from parent view and viewcontroller
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
    
    /// An extension add child view controller to containerview
    /// - Returns: void
    /// - Author: Remzi Yildirim
    func addChild(to containerView: UIView, _ child: UIViewController) {
        /// view controller view to containerview
        addChildViewController(child)
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
}
