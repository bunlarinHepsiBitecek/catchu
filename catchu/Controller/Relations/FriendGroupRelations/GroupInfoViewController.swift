//
//  GroupInfoViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoViewController: UIViewController {

    private var groupInfoView : GroupInfoView2!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

// MARK: - major fucntions
extension GroupInfoViewController {
    
    private func prepareViewController() {
        
        configureViewControllerSettings()
        addViews()
        
    }
    
    private func configureViewControllerSettings() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func addViews() {
        
        addGroupInfoView()
        
    }
    
    private func addGroupInfoView() {
        print("\(#function) starts")
        
        groupInfoView = GroupInfoView2()
        groupInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(groupInfoView)
        
        let safe = self.view.safeAreaLayoutGuide
        
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            
            groupInfoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupInfoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupInfoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            //groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor, constant: -statusBarHeight),
            groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
}
