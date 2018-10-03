//
//  CustomProgressBar.swift
//  catchu
//
//  Created by Erkut Baş on 9/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomProgressBar: UIView {

    var bezierPath : UIBezierPath!
    var shapeLayer : CAShapeLayer!
    var progressBarLayer : CAShapeLayer!
    
    var progress: Float = 0 {
        willSet(newValue)
        {
            progressBarLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        bezierPath = UIBezierPath()
        self.createShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func createCirclePath() {
        
        let x = self.frame.width / 2
        let y = self.frame.height / 2
        
        let center = CGPoint(x: x, y: y)
        
        bezierPath.addArc(withCenter: center, radius: x / CGFloat(2), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        bezierPath.close()
    }
    
    func createShape() {
        
        createCirclePath()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        progressBarLayer = CAShapeLayer()
        progressBarLayer.path = bezierPath.cgPath
        progressBarLayer.lineWidth = 10
        progressBarLayer.lineCap = kCALineCapRound
        progressBarLayer.fillColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        progressBarLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressBarLayer)
        
    }
    
}

