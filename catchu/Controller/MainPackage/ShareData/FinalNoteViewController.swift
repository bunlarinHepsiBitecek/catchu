//
//  FinalNoteViewController.swift
//  catchu
//
//  Created by Erkut Baş on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalNoteViewController: UIViewController {

    private var saySomethingView : FinalShareSaySomethingView?
    
    weak var delegateForViewController : ShareDataProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMainView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if saySomethingView != nil {
            saySomethingView!.focusTextViewManagement(focus: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if saySomethingView != nil {
            saySomethingView!.focusTextViewManagement(focus: false)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - major functions
extension FinalNoteViewController {
    
    func addMainView() {
        
        saySomethingView = FinalShareSaySomethingView()
        
        saySomethingView!.setDelegations(delegate: self, delegateForViewController : delegateForViewController)
        saySomethingView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(saySomethingView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            saySomethingView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            saySomethingView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            saySomethingView!.topAnchor.constraint(equalTo: safe.topAnchor),
            saySomethingView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func addTranstionToDismiss() {
        
        let transition = CATransition()
        
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
}

// MARK: - ViewPresentationProtocols
extension FinalNoteViewController : ViewPresentationProtocols {
    
    func dismissViewController() {
        
        addTranstionToDismiss()

        self.dismiss(animated: false, completion: nil)
        
    }
    
}
