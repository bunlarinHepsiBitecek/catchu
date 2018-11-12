//
//  LikeViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController {
    
    lazy var likeView: LikeView = {
        let view = LikeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizedConstants.Like.Likes
        
        setupViews()
        
        // load likes data
        self.likeView.dataSource.loadData()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(likeView)
        
        NSLayoutConstraint.activate([
            likeView.safeTopAnchor.constraint(equalTo: self.view.safeTopAnchor),
            likeView.safeBottomAnchor.constraint(equalTo: self.view.safeBottomAnchor),
            likeView.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            likeView.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor)
            ])
    }

}
