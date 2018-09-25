//
//  RadialGradientView.swift
//  catchu
//
//  Created by Erkut Baş on 9/14/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {
    
    var startColor:UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    var endColor:UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        let gradLocationsNum = 2
        let gradLocations:[CGFloat] = [0.0, 1.0]
        
        var gradColors = [CGFloat](repeating: 0.0, count: 8)
        
        var red:CGFloat = 0.0, green:CGFloat = 0.0, blue:CGFloat = 0.0, alpha:CGFloat = 0.0
        startColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        gradColors[0] = red
        gradColors[1] = green
        gradColors[2] = blue
        gradColors[3] = alpha
        
        endColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        gradColors[4] = red
        gradColors[5] = green
        gradColors[6] = blue
        gradColors[7] = alpha
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: gradColors, locations: gradLocations, count: gradLocationsNum)
        
        let gradCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        let gradRadius = min(bounds.size.width, bounds.size.height) / (2)
        
        ctx.drawRadialGradient(gradient!, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: .drawsAfterEndLocation)
    }
    
}
