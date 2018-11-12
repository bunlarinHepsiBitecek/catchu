//
//  CountryViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

protocol CountryViewControllerDelegate: class {
    func countryViewController(_ countryViewController: CountryViewController, didSelectCountry: Country)
}

class CountryViewController: BaseTableViewController {
    
    public var selectedCountry: Country?
    
    private let viewModel = CountryViewModel()
    
    weak var delegate: CountryViewControllerDelegate!
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = viewModel
        searchController.searchResultsUpdater = viewModel
        searchController.searchBar.delegate = viewModel
        searchController.searchBar.sizeToFit()
//        searchController.searchBar.searchBarStyle = .minimal
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        self.navigationItem.title = LocalizedConstants.EditableProfileView.SelectCountry
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
//        tableView.delegate = self
        tableView.dataSource = viewModel
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        
        tableView.register(CountryViewCell.self, forCellReuseIdentifier: CountryViewCell.identifier)
        tableView.tableHeaderView = searchController.searchBar
        
        viewModel.searchController = searchController
        viewModel.loadData(selectedCountry: selectedCountry)
        
        // bind observe
        viewModel.filteredCountries.bindAndFire { [unowned self] (_) in
            print("Reload")
            self.tableView.reloadData()
        }

        viewModel.selectedIndex?.bindAndFire({ [unowned self] in
            if self.viewModel.filteredCountries.value.count > 0 {
                self.view.layoutIfNeeded() // for section title color reloaded
                self.tableView.scrollToRow(at: $0, at: .middle, animated: true)
            }
        })
        
    }
    
    deinit {
        viewModel.filteredCountries.unbind()
        viewModel.selectedIndex?.unbind()
    }
}

extension CountryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: if not dismis searchController, currentViewController should find it
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: nil)
        }
        
        selectedCountry = viewModel.filteredCountries.value[indexPath.section][indexPath.row]
        guard let selectedCountry = selectedCountry else { return }
        delegate?.countryViewController(self, didSelectCountry: selectedCountry)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CountryViewController {
    /// when call from viewWilAppear then animate visible cell
    func animateTableView() {
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}
