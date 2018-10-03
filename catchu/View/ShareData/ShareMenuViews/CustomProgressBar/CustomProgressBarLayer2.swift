//
//  CustomProgressBarLayer2.swift
//  catchu
//
//  Created by Erkut Baş on 9/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomProgressBarLayer2: CALayer {
    
    private var circularPath : UIBezierPath!
    private var innerShapeLayer : CAShapeLayer!
    private var outerShapeLayer : CAShapeLayer!
    private var rotateTransformation = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)

    private var completedLabel : UILabel!
    private var progressLabel : UILabel!
    
    public var isUsingAnimation : Bool!
    
    var progress : CGFloat = 0 {
        didSet {
            
            DispatchQueue.main.async {
                self.progressLabel.text = "\(self.progress)%"
            }
            
            innerShapeLayer.strokeEnd = progress / 100
            
            if progress > 100 {
                
                progressLabel.text = "100%"
                
            }
            
        }
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(radius : CGFloat, position : CGPoint, innerColor : UIColor, outerColor : UIColor, lineWidth : CGFloat) {
        
        super.init()
        
        circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        outerShapeLayer = CAShapeLayer()
        outerShapeLayer.path = circularPath.cgPath
        outerShapeLayer.position = position
        outerShapeLayer.strokeColor = outerColor.cgColor
        outerShapeLayer.fillColor = UIColor.clear.cgColor
        outerShapeLayer.lineWidth = lineWidth
        outerShapeLayer.strokeEnd = 1
        outerShapeLayer.lineCap = kCALineCapRound
        outerShapeLayer.transform = rotateTransformation
        
        addSublayer(outerShapeLayer)
        
        innerShapeLayer = CAShapeLayer()
        innerShapeLayer.path = circularPath.cgPath
        innerShapeLayer.strokeColor = innerColor.cgColor
        innerShapeLayer.position = position
        innerShapeLayer.strokeEnd = progress
        innerShapeLayer.lineWidth = lineWidth
        innerShapeLayer.lineCap = kCALineCapRound
        innerShapeLayer.fillColor = UIColor.clear.cgColor
        innerShapeLayer.transform = rotateTransformation
        
        addSublayer(innerShapeLayer)
        
        progressLabel = UILabel()
        
        let size = CGSize(width: radius, height: radius)
        let origin = CGPoint(x: position.x, y: position.y)
        
        progressLabel.frame = CGRect(origin: origin, size: size)
        progressLabel.center = position
        progressLabel.center.y = position.y
        progressLabel.font = UIFont.boldSystemFont(ofSize: radius * 0.2)
        progressLabel.text = "0%"
        progressLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        progressLabel.textAlignment = .center
        
        insertSublayer(progressLabel.layer, at: 0)
        
        completedLabel = UILabel()
        
//        let completedLabelOrigin = CGPoint(x: position.x , y: position.y)
//
//        completedLabel.frame = CGRect(origin: completedLabelOrigin, size: CGSize.init(width: radius, height: radius * 0.6))
//        completedLabel.font = UIFont.systemFont(ofSize: radius * 0.2, weight: UIFont.Weight.light)
//        completedLabel.textAlignment = .center
//        completedLabel.center = position
//        completedLabel.center.y = position.y + 20
//        completedLabel.textColor = .white
//        completedLabel.text = "Completed"
//
//        insertSublayer(completedLabel.layer, at: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
