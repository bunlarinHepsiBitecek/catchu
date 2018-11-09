//
//  SlideMenuLoader.swift
//  catchu
//
//  Created by Erkut Baş on 11/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

//protocol SlideMenuLoaderProtocols {
//    func animateSlideMenu(active : Bool)
//}

class SlideMenuLoader: NSObject {
    
    private var slideMenu : SlideMenu!
    private var shadowMenu : UIView!
    
    public static let shared = SlideMenuLoader()
    
    func createSlider(inputView : UIView) {
        
        let screen = UIScreen.main.bounds
        
        print("screen : \(screen)")
        print("UIScreen.main.bounds : \(UIScreen.main.bounds)")
        print("self.superview : \(inputView.superview)")
        
        addShadowView(inputFrame: screen, inputView: inputView)
        addSlideMenuView(inputFrame: screen, inputView: inputView)
        
        addGestureToShadowView()
        addSwipeGestureRecognizer()
        
    }
    
    func addShadowView(inputFrame : CGRect, inputView : UIView) {
        
        shadowMenu = UIView(frame: inputFrame)
        shadowMenu.backgroundColor = UIColor(white: 0, alpha: 0.5)
        shadowMenu.frame = inputFrame
        shadowMenu.alpha = 0
        
        inputView.addSubview(shadowMenu)
        
    }
    
    func addSlideMenuView(inputFrame : CGRect, inputView : UIView) {
        
        let width : CGFloat = Constants.StaticViewSize.ViewSize.Width.width_250
        slideMenu = SlideMenu(frame: CGRect(x: -width, y: 0, width: width, height: inputView.frame.height))
        inputView.addSubview(slideMenu)
        
        //animateSlideMenu(active: true)
        
    }
    
    /// - Parameter active: visible or not
    func animateSlideMenu(active: Bool) {
        print("animateSlideMenu starts")
        
        slideMenu.setUserInformationToViews()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if active {
                self.shadowMenu.alpha = 1
                
                self.slideMenu.frame = CGRect(x: 0, y: 0, width: self.slideMenu.frame.width, height: self.slideMenu.frame.height)
                
            } else {
                self.shadowMenu.alpha = 0
                
                self.slideMenu.frame = CGRect(x: -self.slideMenu.frame.width, y: 0, width: self.slideMenu.frame.width, height: self.slideMenu.frame.height)
            }
            
        }, completion: nil)
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension SlideMenuLoader : UIGestureRecognizerDelegate {
    
    func addGestureToShadowView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SlideMenuLoader.closeMenuView(_:)))
        tapGesture.delegate = self
        shadowMenu.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeMenuView(_ sender : UITapGestureRecognizer)  {
        
        animateSlideMenu(active: false)
        
    }
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SlideMenuLoader.swipeToClose(_:)))
        swipeGesture.direction = .left
        swipeGesture.delegate = self
        self.shadowMenu.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeToClose(_ sender : UISwipeGestureRecognizer) {
        
        print("swipeToClose starts")
        
        switch sender.direction {
        case .left:
            SlideMenuLoader.shared.animateSlideMenu(active: false)
            return
        default:
            break
        }
        
    }
    
}
