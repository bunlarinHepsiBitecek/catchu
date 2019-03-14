//
//  GradientLabel.swift
//  catchu
//
//  Created by Erkut Baş on 12/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GradientLabel: UIView {

    init(frame: CGRect, text: String, fontSize: CGFloat, colorArray: [CGColor]) {
        super.init(frame: frame)
        
        // create a view with size 400 x 400
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        // Create a gradient layer
        let gradient = CAGradientLayer()
        
        // gradient colors in order which they will visually appear
        //gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = colorArray
        
        // Gradient from left to right
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // set the gradient layer to the same size as the view
        gradient.frame = view.bounds
        // add the gradient layer to the views layer for rendering
        view.layer.addSublayer(gradient)
        
        self.addSubview(view)
        
        // Create a label and add it as a subview
        let label = UILabel(frame: view.bounds)
        label.text = text
        label.contentMode = .center
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        view.addSubview(label)
        
        // Tha magic! Set the label as the views mask
        view.mask = label
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewActivationManager(active : Bool, animated : Bool) {
        if animated {
            UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_03, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                if active {
                    self.alpha = 1
                } else {
                    self.alpha = 0
                }
            })
        } else {
            if active {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
        }
    }
    
}

