//
//  UserProfileViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let openSliderMenuAction = #selector(UserProfileViewController.openSliderMenu)
    static let presentEditProfileAction = #selector(UserProfileViewController.presentEditProfile)
    static let pullToRefresh = #selector(UserProfileViewController.refreshData)
}

class UserProfileViewController: BaseTableViewController {
    // MARK: - Variables
    var viewModel = UserProfileViewModel()
    var isBarButtonItems = true
    
    // MARK: - Views
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    lazy var footerActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }()
    
    lazy var profileHeaderView: UserProfileHeaderView = {
        let view = UserProfileHeaderView()
        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        print("profileHeaderView: \(view.frame.size)")
        return view
    }()
    
    // MARK: - View
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1).cgColor]
        gradient.frame = self.view.bounds
        return gradient
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupHeaderView()
        setupNavigation()
        setupViewModel()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(UserProfileViewFollowCell.self, forCellReuseIdentifier: UserProfileViewFollowCell.identifier)
        tableView.register(UserProfileViewPostCell.self, forCellReuseIdentifier: UserProfileViewPostCell.identifier)
        tableView.register(UserProfileViewCaughtCell.self, forCellReuseIdentifier: UserProfileViewCaughtCell.identifier)
        tableView.register(UserProfileViewGroupsCell.self, forCellReuseIdentifier: UserProfileViewGroupsCell.identifier)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: .pullToRefresh, for: .valueChanged)
    }
    
    func setupHeaderView() {
        self.tableView.tableHeaderView = profileHeaderView
        self.tableView.tableFooterView = UIView()
    }
    
    private func setupNavigation() {
        if isBarButtonItems {
            let sliderMenuLeftBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: .openSliderMenuAction)
            navigationItem.leftBarButtonItem = sliderMenuLeftBarButton
            
            let editProfileRightBarButton = UIBarButtonItem(image: UIImage(named: "user_white"), style: .plain, target: self, action: .presentEditProfileAction)
            navigationItem.rightBarButtonItem = editProfileRightBarButton
        }
    }
    
    @objc func openSliderMenu() {
        print("slider menu")
        SlideMenuLoader.shared.animateSlideMenu(active: true)
    }
    
    @objc func presentEditProfile() {
        print("presentEditProfile menu")
        let userProfileEditViewModel = UserProfileEditViewModel(user: viewModel.user)
        let userProfileEditVC = UserProfileEditViewController()
        userProfileEditVC.viewModel = userProfileEditViewModel
        let userProfileEditNC = UINavigationController(rootViewController: userProfileEditVC)
        self.present(userProfileEditNC, animated: true, completion: nil)
        
    }
    
    private func setupViewModel() {
        viewModel.getUserInfo()
        viewModel.getUserGroups()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
        viewModel.changes.bind { [unowned self] in
            self.reloadTableView($0)
        }
    }
    
    deinit {
        viewModel.state.unbind()
        viewModel.changes.unbind()
    }
    
    private func stateAnimate(_ state: TableViewState) {
        switch state {
        case .loading:
            showLoadingIndicator()
            reloadTableView()
        case .populate:
            headerViewConfig()
            stopLoadingIndicator()
            reloadTableView()
        case .error:
            stopLoadingIndicator()
        default:
            return
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView(_ changes: CellChanges) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: changes.reloads, with: .fade)
            self.tableView.insertRows(at: changes.inserts, with: .fade)
            self.tableView.deleteRows(at: changes.deletes, with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    func headerViewConfig() {
        DispatchQueue.main.async {
            self.profileHeaderView.configure(viewModel: self.viewModel)
            self.profileHeaderView.frame.size = self.profileHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            print("profileHeaderViewConfig: \(self.profileHeaderView.frame.size)")
        }
    }
}

extension UserProfileViewController {
    func showLoadingIndicator() {
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            ])
    }
    func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
        }
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.viewModel.getUserInfo()
            self.viewModel.getUserGroups()
            self.refreshControl!.endRefreshing()
        })
    }
    
}


extension UserProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath: \(indexPath)")
        
        let item = viewModel.items[indexPath.section].rowViewModels[indexPath.row]
        
        switch (item as! UserProfileViewModelItem).type {
        case .follow:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileViewFollowCell.identifier, for: indexPath) as? UserProfileViewFollowCell {
                cell.configure(viewModelItem: item)
                return cell
            }
        case .post:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileViewPostCell.identifier, for: indexPath) as? UserProfileViewPostCell {
                cell.configure(viewModelItem: item)
                return cell
            }
        case .caught:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileViewCaughtCell.identifier, for: indexPath) as? UserProfileViewCaughtCell {
                cell.configure(viewModelItem: item)
                return cell
            }
        case .groups:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileViewGroupsCell.identifier, for: indexPath) as? UserProfileViewGroupsCell {
                cell.configure(viewModelItem: item)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    /// CollectionView into TableView
    /// Collectionview's sizeForItem function is working after TableViewCell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.items[indexPath.section].rowViewModels[indexPath.row]
        switch (item as! UserProfileViewModelItem).type {
        case .groups:
            return Constants.Profile.GroupTableHeight
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.items[section].headerTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow: \(indexPath)")
        
        let item = viewModel.items[indexPath.section].rowViewModels[indexPath.row]
        switch (item as! UserProfileViewModelItem).type {
        case .post:
            let userPostsViewModel = UserPostsViewModel()
            let userPostsViewController = UserPostsViewController()
            userPostsViewController.viewModel = userPostsViewModel
            self.navigationController?.pushViewController(userPostsViewController, animated: true)
        case .caught:
            let userPostsViewModel = UserPostsViewModel()
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            layout.estimatedItemSize = CGSize(width: 1, height: 1)

            let userPostsViewCollectionController = UserPostsViewCollectionController(collectionViewLayout: layout)
            userPostsViewCollectionController.viewModel = userPostsViewModel
            self.navigationController?.pushViewController(userPostsViewCollectionController, animated: true)
        default:
            return
        }
    }
    
}
