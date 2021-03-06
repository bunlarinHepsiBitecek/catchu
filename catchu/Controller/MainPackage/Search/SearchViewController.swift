//
//  SearcViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchViewController: BaseTableViewController {
    
    let viewModel = SearchViewModel()
    
    lazy var activityIndicatorView: UIView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = LocalizedConstants.SearchBar.searching
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicatorView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20),
            stackView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 20),
            ])
        return view
    }()
    
    let noResultFoundView: TableViewStateResultView = {
        let view = TableViewStateResultView()
        view.setup(imageName: nil, title: nil, subtitle: LocalizedConstants.Feed.NoResultFound)
        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return view
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.showsCancelButton = true
        searchController.definesPresentationContext = true
        
//        searchController.searchBar.tintColor = .white
//        searchController.searchBar.barTintColor = .white
//
//        let whiteTitleAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
//        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
//        textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupNavigation()
        setupTableView()
        setupViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarBecomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarBecomeFirstResponder() {
        DispatchQueue.main.async { [unowned self] in
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func setupNavigation() {
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    func setupTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.identifier)
    }
    
    func setupViewModel() {
        viewModel.state.bindAndFire { [unowned self](state) in
            self.setFooterView(state)
            self.reloadTableView()
        }
    }
    
    func setFooterView(_ state: TableViewState) {
        let footerView: UIView?
        switch state {
        case .suggest:
            footerView = nil
        case .loading:
            footerView = activityIndicatorView
        case .paging:
            footerView = nil
        case .populate:
            footerView = nil
        case .empty:
            footerView = noResultFoundView
        case .error:
            footerView = noResultFoundView
        default:
            footerView = nil
        }
        DispatchQueue.main.async {
            self.tableView.tableFooterView = footerView
        }
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    deinit {
        viewModel.state.unbind()
    }
    
}

extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.filteredItems[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier, for: indexPath) as? UserViewCell {
            cell.configure(viewModelItem: item)
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.filteredItems[indexPath.row] as? ViewModelUser else { return }
        
        let userProfileViewController = LoaderController.profileViewController(item.user)
        
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
        
//        let otherViewModel = OtherUserProfileViewModel(user: item.user)
//
//        let otherProfileVC = OtherUserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        otherProfileVC.viewModel = otherViewModel
//
//        self.navigationController?.pushViewController(otherProfileVC, animated: true)
        
    }
    
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    
    // cancel performation
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self,
//                                               selector: #selector(loadRecordings),
//                                               object: nil)
//
//        perform(#selector(loadRecordings), with: nil, afterDelay: 0.5)
//    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        viewModel.search(text: searchString)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
}

class TableViewStateResultView: BaseView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }()
    
    let stateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(named: "no-internet")
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Connection Error"
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Please check your internet connection"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityIndicatorView, stateImageView, titleStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    
    
    override func setupView() {
        super.setupView()
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
//            stackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
//            stackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
//            stackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
//            stackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor)
            stackView.safeCenterXAnchor.constraint(equalTo: safeCenterXAnchor),
            stackView.safeCenterYAnchor.constraint(equalTo: safeCenterYAnchor),
            ])
    }
    
    func setup(imageName: String?, title: String?, subtitle: String?) {
        activityIndicatorView.stopAnimating()
        
        if let imageName = imageName {
            stateImageView.image = UIImage(named: imageName)
            stateImageView.isHidden = false
        } else {
            stateImageView.isHidden = true
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        
        titleStackView.isHidden = titleLabel.isHidden && subtitleLabel.isHidden
    }
}
