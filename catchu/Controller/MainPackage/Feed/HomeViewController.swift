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
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        searchBar.barStyle = .blackTranslucent
        searchBar.placeholder = LocalizedConstants.Feed.Search
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
            menuTabView.heightAnchor.constraint(equalToConstant: 40),

            containerView.safeTopAnchor.constraint(equalTo: menuTabView.safeBottomAnchor),
            containerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    func setupSearchViewBar() {
//        self.navigationItem.titleView = searchBar
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "icon_search"), style: .plain, target: self, action: .searchAction)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .messageAction)
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
//    let mapView = FeedMapView()
//    var isShowen = false
    @objc func messages() {
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
        
        
        // MARK: - Other User Profile
        let dummyUser = User()
        dummyUser.userid = "VVkIWB15bdcrEli4kSD4uv8gPIl1"
        dummyUser.name = "Ilk Erkut Bas"
        dummyUser.username = "erkutbas"
        dummyUser.followStatus = User.FollowStatus.pending

        let otherViewModel = OtherUserProfileViewModel(user: dummyUser)
        
        let otherProfileVC = OtherUserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        otherProfileVC.viewModel = otherViewModel

        self.navigationController?.pushViewController(otherProfileVC, animated: true)
        
        // MARK: - Collection and Feed Design
//        let userPostsPageViewController = UserPostsPageViewController()
//        self.navigationController?.pushViewController(userPostsPageViewController, animated: true)
    }
    
    @objc func presentSearchNavigation() {
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController())
        self.present(searchNavigationController, animated: true, completion: nil)
    }
    
    func containerAddChildViewController(_ childViewController: UIViewController, containerView: UIView) {
        self.addChild(childViewController)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
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


fileprivate extension Selector {
    static let searchAction = #selector(HomeViewController.presentSearchNavigation)
    static let messageAction = #selector(HomeViewController.messages)
}
