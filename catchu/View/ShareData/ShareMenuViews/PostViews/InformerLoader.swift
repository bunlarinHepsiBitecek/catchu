//
//  InformerLoader.swift
//  catchu
//
//  Created by Erkut Baş on 1/6/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class InformerLoader: NSObject {
    
    public static let shared = InformerLoader()
    
    private var informerViewForSuccess: InformerView!
    private var informerViewForFail: InformerView!
    
    private var postState = PostState.success

    weak var delegate : ViewPresentationProtocols!
    
    private var totalHeight : CGFloat = 0
    
    func createPostResult(inputView : UIView) {
        
        let screen = UIScreen.main.bounds
        
        addInformerViews(inputFrame: screen, inputView: inputView)
        
    }
    
    private func calculateTotalHeight() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        totalHeight = statusBarHeight + Constants.StaticViewSize.ViewSize.Height.height_70
    }
    
    func addInformerViews(inputFrame : CGRect, inputView : UIView) {
        
        calculateTotalHeight()
        
        informerViewForFail = InformerView(frame: CGRect(x: 0, y: -totalHeight, width: UIScreen.main.bounds.width, height: totalHeight), postState: .failed)
        informerViewForSuccess = InformerView(frame: CGRect(x: 0, y: -totalHeight, width: UIScreen.main.bounds.width, height: totalHeight), postState: .success)
        
        inputView.addSubview(informerViewForFail)
        inputView.addSubview(informerViewForSuccess)
        
        addSuccessInformerListeners()
        addFailedInformerListeners()
        
    }
    
    func animateInformerViews(postState: PostState) {
        self.postState = postState
        
        DispatchQueue.main.async {
            switch postState {
            case .success:
                self.startAnimationForSuccessProcess()
            case .failed:
                self.startAnimationForFailedProcess()
            }
        }
        
    }
    
    private func addSuccessInformerListeners() {
        informerViewForSuccess.listenInformerGestureRecognizers { (state) in
            self.informerViewSuccessGestureProcess(state: state)
        }
    }
    
    private func addFailedInformerListeners() {
        informerViewForFail.listenInformerGestureRecognizers { (state) in
            self.informerViewFailedGestureProcess(state: state)
        }
    }
    
    private func informerViewFailedGestureProcess(state: InformerGestureStates) {
        switch state {
        case .swipped:
            print("swipped kokoko")
            stop(inputView: informerViewForFail)
        case .tapped:
            print("failed tapped")
            stop(inputView: informerViewForFail)
        case .none:
            return
        }
    }
    
    private func informerViewSuccessGestureProcess(state: InformerGestureStates) {
        switch state {
        case .swipped:
            print("swipped tapped")
            stop(inputView: informerViewForSuccess)
        default:
            return
        }
    }
    
    private func startAnimationForSuccessProcess() {
        
        startAnimation(inputView: informerViewForSuccess) { (finish) in
            self.stop(inputView: self.informerViewForSuccess)
        }
    }
    
    private func startAnimationForFailedProcess() {
        startAnimation(inputView: informerViewForFail) { (finish) in
            if finish {
                //self.stop(inputView: self.informerViewForFail)
            }
        }
    }
    
    private func startAnimation(inputView: UIView, completion: @escaping (_ finish : Bool) -> Void) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear], animations: {
            
            inputView.frame.origin.y = 0
            
        }, completion: { (finish) in
            completion(finish)
        })
        
    }
    
    private func stop(inputView: UIView) {
        
        UIView.animate(withDuration: 0.5, delay: 1, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            
            inputView.frame.origin.y = -self.totalHeight
            
        })
        
    }
    
}

