//
//  Formatter.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

public class Formatter {
    class func roundedWithAbbreviations(_ count: Int) -> String {
        let number = Double(count)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(Int(number))"
        }
    }
    
    class func followAttributeString(title: String, subtitle: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let subtitleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline),
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        
        return attributedString
    }
    
    
    /// Filled button properties via following status
    ///
    /// - Parameters:
    ///   - followStatus: target user follow status
    ///   - button: the button which it's properties has filled by followStatus
    /// - Returns: void
    /// - Author: Remzi Yildirim
    class func configure(_ followStatus: User.FollowStatus, _ button: UIButton) {
        let facebookColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let title = followStatus.toString
        let titleColor: UIColor = followStatus == .none ? UIColor.white : UIColor.black
        let borderColor: UIColor = followStatus == .none ? facebookColor : UIColor.lightGray
        let backgroundColor: UIColor = followStatus == .none ? facebookColor : UIColor.white
        let alpha: CGFloat = followStatus == .own ? 0 : 1
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.alpha = alpha
        button.layer.borderColor = borderColor.cgColor
    }
    
}
