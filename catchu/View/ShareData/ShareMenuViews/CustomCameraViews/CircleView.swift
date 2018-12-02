//
//  CircleView.swift
//  catchu
//
//  Created by Erkut Baş on 9/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer: CAShapeLayer!
    
    private var second = 0
    private var timer = Timer()
    private var isTimerRunning : Bool = false
    
    private var animateBack : Bool = false

    private var postContentType: PostContentType?
    
    weak var delegate : PostViewProtocols!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        print("Double.pi : \(Double.pi)")
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 2)/2, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.lineCap = kCALineCapRound
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        circleLayer.lineWidth = 2;
//        circleLayer.contentsScale = UIScreen.main.scale
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(inputColor : CGColor) {
        circleLayer.strokeColor = inputColor
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func stop() {
        circleLayer.strokeEnd = 1.0
    }
    
    func stop(directionBack : Bool) {
        
        guard let postContentType = postContentType else { return }
        
        if directionBack {
            circleLayer.strokeEnd = 0.0
            delegate.triggerContentCheckAnimation(active : false, postContentType: postContentType)
        } else {
            circleLayer.strokeEnd = 1.0
            delegate.triggerContentCheckAnimation(active : true, postContentType: postContentType)
        }
        
        animateBack = false
        
    }
    
    func reset() {
        circleLayer.strokeStart = 0.0
    }
    
    func animateCircleWithDelegation(duration : TimeInterval, delegate: PostViewProtocols, postContentType : PostContentType) {
        
        self.delegate = delegate
        self.postContentType = postContentType
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        second = Int(duration)
        
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        
        circleLayer.add(animation, forKey: "animateCircle")
        
        runTimer()
        
    }
    
    func animateCircleWithDelegationToBack(duration : TimeInterval, delegate: PostViewProtocols) {
        
        animateBack = true
        
        self.delegate = delegate
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        second = Int(duration)
        
        animation.fromValue = 1
        animation.toValue = 0
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        
        circleLayer.add(animation, forKey: "animateCircle")
        
        runTimer()
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CircleView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        second -= 1
        
        if second <= 0 {
            timer.invalidate()
            stop(directionBack: animateBack)
            //delegate.triggerContentCheckAnimation()
            
        }
        
    }
    
    
}
