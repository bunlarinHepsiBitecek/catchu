//
//  MutualFollowViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/12/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MutualFollowViewController: UIViewController {
  
    var activePageType: FollowPageIndex?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareControllerSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}

// MARK: - major functions
extension MutualFollowViewController {
    
    private func prepareControllerSettings() {
        addViews()
    }
    
    private func addViews() {
        addDynamicPageView()
    }
    
    private func configureViewSettings() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.title = "Follow Info"
    }
    
    private func addDynamicPageView() {
        
        let followersView = FollowersView()
        let followingsView = FollowingsView()
        var activePage = 0
        
        if let activePageType = activePageType {
            switch activePageType{
            case .followers:
                activePage = 0
            case .followings:
                activePage = 1
            }
        }
        
        let viewArray : [UIView] = [followersView, followingsView]
        
        let dynamicPageView = DynamicPageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewArray: viewArray, activePage: activePage)
        
        dynamicPageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(dynamicPageView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            dynamicPageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            dynamicPageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            dynamicPageView.topAnchor.constraint(equalTo: safe.topAnchor),
            dynamicPageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
}
