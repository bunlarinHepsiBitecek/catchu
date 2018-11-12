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
        searchBar.searchBarStyle = .prominent
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainer()
        setupSearchView()
    }

    func setupContainer() {
        
        let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let feedVC1 = FeedViewController()
        feedVC1.title = "Public"
        let catchVC1 = CatchViewController()
        catchVC1.view.backgroundColor = .yellow
        catchVC1.title = "Catch"
        let catchVC2 = CatchViewController()
        catchVC2.view.backgroundColor = .red
        catchVC2.title = "Catch 2"
        let catchVC3 = CatchViewController()
        catchVC3.view.backgroundColor = .green
        catchVC3.title = "Catch 3"
        
        var items = [UIViewController]()
        items.append(feedVC1)
        items.append(catchVC1)
//        items.append(catchVC2)
//        items.append(catchVC3)
        
        pageViewController.items = items
        
        let menuTabView = pageViewController.menuTabView
        menuTabView.translatesAutoresizingMaskIntoConstraints = false
        menuTabView.backgroundColor = .clear

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(containerView)
        self.view.addSubview(menuTabView)

        addChildViewController(to: containerView, pageViewController)


        NSLayoutConstraint.activate([
            menuTabView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
            menuTabView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            menuTabView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            menuTabView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            menuTabView.heightAnchor.constraint(equalToConstant: 30),

            containerView.safeTopAnchor.constraint(equalTo: menuTabView.safeBottomAnchor),
            containerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    func setupSearchView() {
        self.navigationItem.titleView = searchBar
    }
    
    
    func frameForContentController() -> CGRect {
        return self.view.bounds
    }
    
    func containerAddChildViewController(_ childViewController: UIViewController, containerView: UIView) {
        self.addChildViewController(childViewController)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: \(searchText)")
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
        return false
    }
}
