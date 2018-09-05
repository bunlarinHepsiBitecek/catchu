//
//  ShareDataViewController.swift
//  catchu
//
//  Created by Erkut Baş on 9/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ShareDataViewController: UIViewController {

    @IBOutlet var shareDataView: ShareDataView!
    @IBOutlet var shareTypeSliderView: ShareTypeSliderView!
    @IBOutlet var shareFunctionSliderView: ShareFunctionSliderView!
    
    var priorActiveTab : Int!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("priorActiveTab : \(String(describing: priorActiveTab))")
        
        setupShareDataView()
        setupShareTypeSliderView()
        setupShareFunctionSliderView()
        
        shareTypeSliderView.didSelectFirstCellForInitial()
        
    }

}

extension ShareDataViewController {
    
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
        shareTypeSliderView.initialize()
        self.shareDataView.addSubview(shareTypeSliderView)
        
        let safeAreaLayout = self.shareDataView.typeSliderContainerView.safeAreaLayoutGuide
        
        shareTypeSliderView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareTypeSliderView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareTypeSliderView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareTypeSliderView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
    }
    
    private func setupShareFunctionSliderView() {
        
        shareFunctionSliderView.translatesAutoresizingMaskIntoConstraints = false
        
        shareFunctionSliderView.initialize()
        self.view.addSubview(shareFunctionSliderView)
        
        let safeAreaLayout = self.shareDataView.majorFunctionsContainerView.safeAreaLayoutGuide
        
        shareFunctionSliderView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor).isActive = true
        shareFunctionSliderView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor).isActive = true
        shareFunctionSliderView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor).isActive = true
        shareFunctionSliderView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor).isActive = true
        
        
    }
    
}

extension ShareDataViewController: ShareDataProtocols {
    func dismisViewController() {
        
        if let destionation = LoaderController.shared.currentViewController() as? MainTabBarViewController {
            
            destionation.selectedIndex = priorActiveTab
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
