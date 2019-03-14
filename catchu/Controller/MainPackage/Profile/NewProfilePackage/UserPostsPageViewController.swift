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
        
        view.backgroundColor = UIColor.white
        
        let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let userPostsViewModel = UserPostsViewModel()
        let userPostsViewController = UserPostsViewController()
        userPostsViewController.configure(viewModel: userPostsViewModel)
        
        let userPostsViewCollectionController = UserPostsViewCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        userPostsViewCollectionController.configure(viewModel: userPostsViewModel)
        
        var items: [(viewController: UIViewController, title: String, icon: UIImage?)] = []
        items.append((viewController: userPostsViewController, title: LocalizedConstants.Profile.Collection, icon: nil))
        items.append((viewController: userPostsViewCollectionController, title: LocalizedConstants.Profile.Table, icon: nil))
        
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
