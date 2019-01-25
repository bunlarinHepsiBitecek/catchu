//
//  UserPostsPageViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 1/24/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

class UserPostsPageViewController: BaseViewController {
    
    // MARK: - Variables
//    var viewModel:
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        setupContainer()
        
    }
    
    func setupContainer() {
        
        let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let userPostsViewModel = UserPostsViewModel()
        let userPostsViewController = UserPostsViewController()
        userPostsViewController.configure(viewModel: userPostsViewModel)
        
        let userPostsViewCollectionController = UserPostsViewCollectionController()
        
        
        let feedViewModel = FeedViewModel()
        let feedVC1 = FeedViewController()
        feedVC1.configure(viewModel: feedViewModel)
        let catchVC1 = CatchViewController()
        catchVC1.view.backgroundColor = .yellow
        
        var items: [(viewController: UIViewController, title: String, icon: UIImage?)] = []
        items.append((viewController: feedVC1, title: LocalizedConstants.Feed.Public, icon: UIImage(named: "earth")))
        items.append((viewController: catchVC1, title: LocalizedConstants.Feed.Catch, icon: UIImage(named: "Catchu.png")))
        
        pageViewController.items = items
        
        let menuTabView = pageViewController.menuTabView
        menuTabView.backgroundColor = .clear
        
        let containerView = pageViewController.containerView
        
        self.view.addSubview(containerView)
        self.view.addSubview(menuTabView)
        
        addChild(to: containerView, pageViewController)
        NSLayoutConstraint.activate([
            menuTabView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
            menuTabView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            menuTabView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            menuTabView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.safeTopAnchor.constraint(equalTo: menuTabView.safeBottomAnchor),
            containerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    
    
    
    
}
