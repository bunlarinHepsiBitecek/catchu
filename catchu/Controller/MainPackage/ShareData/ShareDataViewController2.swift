//
//  ShareDataViewController2.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareDataViewController2: UIViewController {
    
    @IBOutlet var shareDataView: ShareDataView!
    @IBOutlet var shareTypeSliderView: ShareTypeSliderView!
    @IBOutlet var shareMenuView: ShareMenuViews!
    
    weak var delegate : TabBarControlProtocols!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var priorActiveTab : Int!
    
    //    var shareMenuView : ShareMenuViews!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("priorActiveTab : \(String(describing: priorActiveTab))")
        
        setupShareDataView()
        setupShareTypeSliderView()
        setupDelegationForSliderTypeView()
        setupShareMenuViews()
        
        shareTypeSliderView.didSelectFirstCellForInitial()
        
    }
    
}

extension ShareDataViewController2 {
    
    private func setupShareDataView() {
        
        shareDataView.translatesAutoresizingMaskIntoConstraints = false
        
        shareDataView.delegate = self
        shareDataView.initialize()
        self.view.addSubview(shareDataView)
        
        let safeAreaLayout = self.view.safeAreaLayoutGuide
        
        shareDataView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareDataView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareDataView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareDataView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
    }
    
    private func setupShareTypeSliderView() {
        
        shareTypeSliderView.translatesAutoresizingMaskIntoConstraints = false
        shareTypeSliderView.delegate = shareDataView
        shareTypeSliderView.delegateForViewController = self
        shareTypeSliderView.initialize()
        self.shareDataView.addSubview(shareTypeSliderView)
        
        let safeAreaLayout = self.shareDataView.typeSliderContainerView.safeAreaLayoutGuide
        
        shareTypeSliderView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareTypeSliderView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareTypeSliderView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareTypeSliderView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
    }
    
    private func setupShareMenuViews() {
        
        shareMenuView.delegate = shareTypeSliderView
        shareMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        self.shareDataView.majorFunctionsContainerView.addSubview(shareMenuView)
        
        let safeAreaLayout = self.shareDataView.majorFunctionsContainerView.safeAreaLayoutGuide
        
        shareMenuView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareMenuView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareMenuView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareMenuView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
        print("------> : \(shareMenuView.frame.height)")
        print("------> : \(shareMenuView.bounds.height)")
        
        shareMenuView.initialize()
        
    }
    
    /// set delegate after shareMenuView is loaded
    private func setupDelegationForSliderTypeView() {
        
        shareTypeSliderView.delegateForFunction = shareMenuView
        
    }
    
}

// MARK: - ShareDataProtocols
extension ShareDataViewController2: ShareDataProtocols {
    
    func dismisViewController() {
        
        if let destionation = LoaderController.shared.currentViewController() as? MainTabBarViewController {
            
            destionation.selectedIndex = priorActiveTab
            
        }
        
        guard delegate != nil else {
            return
        }
        
        delegate.tabBarHiddenManagement(hidden: false)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func nextToFinalSharePage() {
        
        print("nextToFinalSharePage start")
        
        if let destination = UIStoryboard.init(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.FinalShareInfoViewController) as? FinalShareInfoViewController {
            
            addTransition()
            
            destination.delegateForViewController = self
//            self.present(destination, animated: true, completion: nil)
            self.present(destination, animated: false, completion: nil)
            
        }
        
    }
    
    func addTransition() {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
    }
    
}

