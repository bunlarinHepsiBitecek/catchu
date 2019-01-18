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
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
    
    lazy var noResultFoundView: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = LocalizedConstants.Feed.NoResultFound
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20),
            label.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 10),
            label.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
        return view
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
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
        
        setupTableView()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarBecomeFirstResponder()
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
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.identifier)
        
        tableView.keyboardDismissMode = .interactive
        
//        tableView.tableHeaderView = searchController.searchBar
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController

            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func setupViewModel() {
        viewModel.state.bindAndFire { [unowned self](state) in
            print("state fire: \(state.rawValue)")
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
//        return viewModel.items.count
        return viewModel.filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let item = viewModel.items[indexPath.row]
        let item = viewModel.filteredItems[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier, for: indexPath) as? UserViewCell {
            cell.configure(viewModelItem: item)
            return cell
        }
        
        return UITableViewCell()
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
        self.dismiss(animated: true, completion: nil)
        viewModel.removeAll()
    }
}


class TableViewStateStack: BaseView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        activityIndicatorView.backgroundColor = .green
        
        return activityIndicatorView
    }()
    
    
    let stateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage(named: "no-internet")
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "Connection Error"
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.text = "Please check your internet connection"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
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
        return stackView
    }()
    
    
    
    override func setupView() {
        super.setupView()
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            stackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            stackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            stackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])
    }
    
    func setup(imageName: String?, title: String?, subtitle: String?) {
        activityIndicatorView.isHidden = true
        
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
