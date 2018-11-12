//
//  UIButtonExtensions.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

extension UIButton {
    
    func loadingIndicator(_ show: Bool, style: UIActivityIndicatorViewStyle? = nil) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: style ?? .white)
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
