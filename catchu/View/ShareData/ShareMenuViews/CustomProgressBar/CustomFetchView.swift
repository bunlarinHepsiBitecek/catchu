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
    private var layerAdded : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        initializeViewSettings()
        setupLayers()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        print("yarrooooo layoutSubviews starts")
//
//        if !layerAdded {
//            setupLayers()
//        }
//
//    }
    
}

// MARK: - major functions
extension CustomFetchView {
    
    func initializeViewSettings() {
        
        self.layer.cornerRadius = 10
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        
    }
    
    func setupLayers() {
        print("yarroooo setupViews starts")
        
        let xPosition = self.frame.height / 2
        let yPosition = self.frame.width / 2
        let position = CGPoint(x: xPosition, y: yPosition)

        print("xPosition : \(xPosition)")
        print("yPosition : \(yPosition)")
        print("position : \(position)")

        progressBar = CustomProgressBarLayer2(radius: 20, position: position, innerColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), outerColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), lineWidth: 10)
        layer.addSublayer(progressBar!)
        
//        if self.frame.height > 0 && self.frame.width > 0 {
//
//            let xPosition = self.frame.height / 2
//            let yPosition = self.frame.width / 2
//            let position = CGPoint(x: xPosition, y: yPosition)
//
//            print("xPosition : \(xPosition)")
//            print("yPosition : \(yPosition)")
//            print("position : \(position)")
//
//            progressBar = CustomProgressBarLayer2(radius: 20, position: position, innerColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), outerColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), lineWidth: 10)
////            layer.addSublayer(progressBar!)
//            layer.insertSublayer(progressBar!, at: 0)
//
//            layerAdded = true
//
//        }
        
    }
    
    func setProgress(progress : CGFloat) {
        
        guard progressBar != nil else {
            return
        }
        
        progressBar!.progress = progress
        
        print("progressBar!.progress :\(progressBar!.progress )")
        
    }
    
    func activationManagement(activate : Bool)  {
        if activate {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
    }
    
}


