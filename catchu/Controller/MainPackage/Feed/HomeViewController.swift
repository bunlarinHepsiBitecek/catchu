//
//  HomeViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let padding: CGFloat = 10
    
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
        
        let feedViewModel = FeedViewModel()
        let feedVC1 = FeedViewController()
        feedVC1.title = "Public"
        feedVC1.configure(viewModel: feedViewModel)
        let catchVC1 = CatchViewController()
        catchVC1.view.backgroundColor = .yellow
        catchVC1.title = "Catch"
        
        var items: [(viewController: UIViewController, title: String, icon: UIImage?)] = []
        items.append((viewController: feedVC1, title: "Public", icon: UIImage(named: "earth")))
        items.append((viewController: catchVC1, title: "Catch", icon: UIImage(named: "Catchu.png")))
        
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
    
    func setupSearchViewBar() {
        self.navigationItem.titleView = searchBar
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonActionRight))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    let mapView = FeedMapView()
    var isShowen = false
    @objc func buttonActionRight() {
        
//        if isShowen {
//            mapView.removeFromSuperview()
//        } else {
//            mapView.translatesAutoresizingMaskIntoConstraints = false
//            self.view.addSubview(mapView)
//
//            NSLayoutConstraint.activate([
//                mapView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
//                mapView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//                mapView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//                mapView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
//                ])
//        }
//        isShowen = !isShowen
        
//        let likeVC = LikeViewController()
//        likeVC.configure(viewModel: LikeViewModel())
//        self.navigationController?.pushViewController(likeVC, animated: true)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
//        let profileVC = UserProfileCollectionViewController(collectionViewLayout: layout)
//        self.navigationController?.pushViewController(profileVC, animated: true)
        
//        let denemeCollectionView = DenemeCollectionViewController(collectionViewLayout: layout)
//        self.navigationController?.pushViewController(denemeCollectionView, animated: true)
        
        
        let dummyUser = User()
        dummyUser.profilePictureUrl = "https://picsum.photos/100/100/?random"
        dummyUser.userid = "userid"
        dummyUser.name = "Ilk Remzi Yildirim"
        dummyUser.username = "remziyildirim"
        
        
        let otherViewModel = OtherUserProfileViewModel(user: dummyUser)
        
        let otherProfileVC = OtherUserProfileViewController(collectionViewLayout: layout)
        otherProfileVC.viewModel = otherViewModel
        
        self.navigationController?.pushViewController(otherProfileVC, animated: true)
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
        
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController())
        self.present(searchNavigationController, animated: true, completion: nil)
        return false
    }
}
