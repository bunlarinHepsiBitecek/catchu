//
//  CommentViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    lazy var commentView: CommentView = {
        let view = CommentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizedConstants.Feed.Comments
        
        self.setupView()
        
        // load comment data
        self.commentView.dataSource.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.backgroundColor = .white

        self.view.addSubview(commentView)

        let safeLayout = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            commentView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            commentView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            ])
    }
    
}
