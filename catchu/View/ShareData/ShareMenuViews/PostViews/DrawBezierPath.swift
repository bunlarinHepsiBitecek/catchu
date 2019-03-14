//
//  DrawBezierPath.swift
//  catchu
//
//  Created by Erkut Baş on 3/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class DrawBezierPath: UIBezierPath {
    
    private static let maxPointCount:Int = 5
    
    private var points = [CGPoint](repeating: CGPoint.zero, count: 5)
    private var pointCount : Int = 0
    
    private var startPoint : CGPoint = CGPoint.zero
    
    private var isBegin = false
    
    func burshBegin(at point:CGPoint) {
        self.move(to: point)
        startPoint = point
        points[0] = point
        pointCount = 1
    }
    
    func appendPoint(point:CGPoint) -> Bool {
        points[pointCount] = point
        pointCount += 1
        if pointCount == DrawBezierPath.maxPointCount {
            
            isBegin = true
            
            points[3] = CGPoint.init(x: (points[2].x + points[4].x) / 2, y: (points[2].y + points[4].y) / 2)
            
            self.move(to: points[0])
            self.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            
            points[0] = points[3]
            points[1] = points[4]
            pointCount = 2
            
            return true
        }
        return false
    }
    
    func end() {
        switch pointCount {
        case 1:
            if !self.isBegin {
                self.addArc(withCenter: self.startPoint, radius: self.lineWidth / 2, startAngle: 0, endAngle: CGFloat(Float.pi * 2.0), clockwise: false)
            }
            break
        case 2:
            self.addLine(to: points[1])
            break
        case 3:
            self.addQuadCurve(to: points[2], controlPoint: points[1])
            break
        case 4:
            self.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            break
        default:
            break
            
        }
    }
    
}
