//
//  CustomActivityIndicator.swift
//  catchu
//
//  Created by Erkut Baş on 11/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {

    private let indicator = CAShapeLayer()
    private let animator = CustomIndicatorAnimator()
    
    private var isAnimating = false
    
    
    
    
    
    /*
     
     private let indicator = CAShapeLayer()
     private let animator = MaterialActivityIndicatorAnimator()
     
     private var isAnimating = false
     
     convenience init() {
     self.init(frame: .zero)
     self.setup()
     }
     
     override public init(frame: CGRect) {
     super.init(frame: frame)
     self.setup()
     }
     
     public required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     self.setup()
     }
     
     
     */

}
