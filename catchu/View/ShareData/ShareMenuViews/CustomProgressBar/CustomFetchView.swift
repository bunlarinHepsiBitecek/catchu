//
//  CustomFetchView.swift
//  catchu
//
//  Created by Erkut Baş on 10/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomFetchView: UIView {

    var progressBar : CustomProgressBarLayer2?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        
//    }
//    
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        
//        self.frame = self.bounds
//        
//        setupViews()
//        
//    }
    
    func setupViews() {
        
        let xPosition = self.center.x
        let yPosition = self.center.y
        let position = CGPoint(x: xPosition, y: yPosition)
        
        print("setupViews starts")
        print("xPosition : \(xPosition)")
        print("yPosition : \(yPosition)")
        print("position : \(position)")
        
        progressBar = CustomProgressBarLayer2(radius: 20, position: position, innerColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), outerColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), lineWidth: 10)
        layer.addSublayer(progressBar!)
        
    }
    
    func setProgress(progress : CGFloat) {
        
        guard progressBar != nil else {
            return
        }
        
        progressBar!.progress = progress
        
    }
    
}


