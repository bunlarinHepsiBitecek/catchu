//
//  PageSliderView.swift
//  catchu
//
//  Created by Erkut Baş on 1/12/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PageSliderView: UIView {
    
    private var pageCount: Int = 0
    private var activePage: Int = 0
    
    lazy var sliderContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return temp
    }()
    
    lazy var slider: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    var sliderLeadingConstraint = NSLayoutConstraint()
    
    init(frame: CGRect, pageCount: Int, activePage: Int? = nil) {
        super.init(frame: frame)
        self.pageCount = pageCount
        if let activePage = activePage {
            self.activePage = activePage
        }
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension PageSliderView {
    
    private func initializeViewSettings() {
        self.addViews()
    }
    
    private func addViews() {
        self.addSubview(sliderContainer)
        self.sliderContainer.addSubview(slider)
        
        let safe = self.safeAreaLayoutGuide
        let safeSliderContainer = self.sliderContainer.safeAreaLayoutGuide
        
        print("self.frame.width / CGFloat(self.pageCount) : \(self.frame.width / CGFloat(self.pageCount))")
        
        sliderLeadingConstraint = slider.leadingAnchor.constraint(equalTo: safeSliderContainer.leadingAnchor, constant: CGFloat(activePage) * (self.frame.width / CGFloat(self.pageCount)))
        
        NSLayoutConstraint.activate([
            
            sliderContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            sliderContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            sliderContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            sliderContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            sliderLeadingConstraint,
            slider.widthAnchor.constraint(equalToConstant: self.frame.width / CGFloat(self.pageCount)),
            slider.heightAnchor.constraint(equalToConstant: self.frame.height),
            slider.bottomAnchor.constraint(equalTo: safeSliderContainer.bottomAnchor)
            
            ])
        
    }
    
    func animateSlider(inputConstant: CGFloat) {
        print("\(#function)")
        sliderLeadingConstraint.constant = inputConstant / CGFloat(pageCount)
    }
    
}
