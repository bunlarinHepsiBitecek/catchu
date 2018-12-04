//
//  HomeViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
//        searchBar.searchBarStyle = .default
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        searchBar.barStyle = .blackTranslucent
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainer()
        setupSearchViewBar()
    }

    func setupContainer() {
        
        let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let feedVC1 = FeedViewController()
        feedVC1.title = "Public"
        let catchVC1 = CatchViewController()
        catchVC1.view.backgroundColor = .yellow
        catchVC1.title = "Catch"
        
        var items = [UIViewController]()
        items.append(feedVC1)
        items.append(catchVC1)
        
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
            menuTabView.heightAnchor.constraint(equalToConstant: 30),

            containerView.safeTopAnchor.constraint(equalTo: menuTabView.safeBottomAnchor),
            containerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    func setupSearchViewBar() {
        self.navigationItem.titleView = searchBar
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonActionLeft))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func buttonActionLeft() {
        let likeVC = LikeViewController()
        self.navigationController?.pushViewController(likeVC, animated: true)
    }
    
    func containerAddChildViewController(_ childViewController: UIViewController, containerView: UIView) {
        self.addChildViewController(childViewController)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
        let searcVC = SearchViewController()
        self.navigationController?.pushViewController(searcVC, animated: true)
        return false
    }
}
