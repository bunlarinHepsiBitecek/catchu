//
//  DrawLayer.swift
//  catchu
//
//  Created by Erkut Baş on 3/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DrawLayer: CAShapeLayer {
    private var currentPath = DrawBezierPath.init()
    
    override init() {
        super.init()
        
        self.lineCap = kCALineCapRound
        self.lineJoin = kCALineCapRound
        self.fillColor = UIColor.clear.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin(at point:CGPoint) {
        currentPath.burshBegin(at: point)
    }
    
    func move(at point:CGPoint) {
        if currentPath.appendPoint(point: point) {
            self.path = self.currentPath.cgPath
        }
    }
    
    func end() {
        currentPath.end()
        self.path = currentPath.cgPath
    }
    
    override func action(forKey event: String) -> CAAction? {
        if event == "path" || event == "contents" {
            return nil
        }
        return super.action(forKey: event);
    }
}
