//
//  DesignableUITextField.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            setBottomBorder()
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    // image start 5 pixel right
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var placeHolderColor: UIColor = Constants.UIDesignConstant.PlaceHolderColor {
        didSet {
            setPlaceHolderColor()
        }
    }
    
    func setBottomBorder()
    {
        borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = borderInactiveColor?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setPlaceHolderColor() {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor])
        
    }
    
    func placeHolderTitle(title: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  title : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor])
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    func updateView() {
        if let image = leftImage {
            //            leftViewMode = UITextFieldViewMode.always
            //            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            //            imageView.image = image
            //            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            //            imageView.tintColor = color
            //            leftView = imageView
            
            
            //MARK: Remzi textFieldPlace Holderin daha solda olabilmesi icin view ile ilerlendi
            leftViewMode = UITextFieldViewMode.always
            let svFrame = CGRect(x: 0, y: 0, width: 50, height: 20)
            let newView = UIView.init(frame: svFrame)
            imageView.image = image
            newView.addSubview(imageView)
            // constrainler ayarlanir
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: newView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: newView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: newView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: newView.bottomAnchor)
                ])
            leftView = newView
            //MARK: Remzi
            
            
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        //        // Placeholder text color
        //        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}
