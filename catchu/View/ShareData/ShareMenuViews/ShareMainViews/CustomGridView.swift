//
//  CustomGridView.swift
//  catchu
//
//  Created by Erkut Baş on 10/19/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomGridView: UIView {

    private var lineCount : Int?
    private var viewAdded : Bool = false
    
    init(frame: CGRect, inputLineCount : Int) {
        super.init(frame: frame)
        
        lineCount = inputLineCount
        
        initiateViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("BABABABABABABABABAB")
        
        print("self.frame.height : \(self.frame.height)")
        
        if !viewAdded {
            
            if self.frame.height > 0{
                addGridViews()
                
                print("kokokokokokokoko")
                
                viewAdded = true
            }
            
        }
        
    }
    
}

// MARK: - major functions
extension CustomGridView {
    
    func initiateViewSettings() {
        
        self.isUserInteractionEnabled = true
        
        activationManager(hidden: true)
        
    }
    
    func addGridViews() {
        
        let gridLength = self.frame.size.height
        let gridRange = gridLength / 5
        
        guard let lineCount = lineCount else { return }
        
        var count = 0
        var range : CGFloat = 0
        
        while (count < lineCount) {
            
            range += gridRange
            
            let tempView = UIView(frame: CGRect(x: range, y: 0, width: 1, height: gridLength))
            tempView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.addSubview(tempView)
            
            count += 1
            
        }
        
        count = 0
        range = 0
        
        while (count < lineCount) {
            
            range += gridRange
            
            let tempView = UIView(frame: CGRect(x: 0, y: range, width: gridLength, height: 1))
            tempView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.addSubview(tempView)
            
            count += 1
            
        }
        
    }
    
    func activationManager(hidden : Bool) {
        self.isHidden = hidden
    }
    
}
