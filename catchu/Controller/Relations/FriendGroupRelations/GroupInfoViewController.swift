//
//  GroupInfoViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoViewController: UIViewController {

    private var groupInfoView : GroupInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
    }
    

}

// MARK: - major fucntions
extension GroupInfoViewController {
    
    private func prepareViewController() {
        
        addViews()
        
    }
    
    private func addViews() {
        
        addGroupInfoView()
        
    }
    
    private func addGroupInfoView() {
        print("\(#function) starts")
        
        groupInfoView = GroupInfoView()
        groupInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(groupInfoView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            
            groupInfoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupInfoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupInfoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor, constant: -statusBarHeight),
            
            ])
        
    }
}
