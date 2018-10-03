//
//  FinalShareInfoViewController.swift
//  catchu
//
//  Created by Erkut Baş on 10/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalShareInfoViewController: UIViewController {

    @IBOutlet var mainContainerView: UIView!
    
    private var finalPageView : FinalSharePageView?
    
    weak var delegateForViewController : ShareDataProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

// MARK: - major functions
extension FinalShareInfoViewController {
    
    func setupViews() {
        
        addFinalPageView()
        
    }
    
    func addFinalPageView() {
        
        finalPageView = FinalSharePageView()
        
        finalPageView!.setDelegates(delegate: self, delegateForShareMenuViews: delegateForViewController)
        finalPageView!.translatesAutoresizingMaskIntoConstraints = false
        finalPageView!.isUserInteractionEnabled = true
        
        self.view.addSubview(finalPageView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            finalPageView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            finalPageView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            finalPageView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor
            ),
            finalPageView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func addTranstion() {
        
        let transition = CATransition()
        
        transition.duration = Constants.AnimationValues.aminationTime_05
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
}

extension FinalShareInfoViewController : ViewPresentationProtocols {
    
    func dismissFinalShareViewController() {
        
        addTranstion()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
