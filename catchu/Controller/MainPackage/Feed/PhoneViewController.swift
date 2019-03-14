//
//  PhoneViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//


//        let phoneNumber = "+16505554567"
//        let testVerificationCode = "123456"

fileprivate extension Selector {
    static let sendSMS = #selector(PhoneViewController.sendSMS)
    static let cancel = #selector(PhoneViewController.dismissVC)
}

class PhoneViewController: BaseTableViewController {
    
    private let viewModel = PhoneViewModel()
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancel)
        return barButton
    }()
    
    lazy var nextBarButton: UIBarButtonItem = {
       let barButton = UIBarButtonItem(title: LocalizedConstants.EditableProfile.Next, style: .plain, target: self, action: .sendSMS)
        
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    func setupTableView() {
        // MARK: must initialize at viewDidLoad
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = viewModel
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        
        tableView.register(PhoneViewCountryCell.self, forCellReuseIdentifier: PhoneViewCountryCell.identifier)
        tableView.register(PhoneViewPhoneCell.self, forCellReuseIdentifier: PhoneViewPhoneCell.identifier)
    }
    
    private func setupNavigation() {
        navigationItem.title = LocalizedConstants.EditableProfile.Phone
        navigationItem.rightBarButtonItem = nextBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    func setupViewModel() {
        viewModel.loadData()
        viewModel.footerTitle = LocalizedConstants.EditableProfile.WillReceiveSMS
        
        viewModel.verificationId.bindAndFire { [unowned self] (verificationId) in
            if !verificationId.isEmpty {
                let confirmationViewController = PhoneViewConfirmationController()
                confirmationViewController.viewModel = self.viewModel
                self.navigationController?.pushViewController(confirmationViewController, animated: true)
            }
        }
        
        viewModel.isComplateVerify.bindAndFire { [unowned self] (isComplateVerify) in
            print("isEmpty bindAndFire: \(isComplateVerify)")
            if isComplateVerify {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        viewModel.verificationId.unbind()
        viewModel.isComplateVerify.unbind()
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    @objc func sendSMS() {
        viewModel.sendSMSVerificationCode()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func performConfirmationController() {
        let phoneViewConfirmationController = PhoneViewConfirmationController()
        LoaderController.pushViewController(controller: phoneViewConfirmationController)
    }
    
}

// tableview delegate
extension PhoneViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let _ = tableView.cellForRow(at: indexPath) as? PhoneViewCountryCell else { return }
        
        let countryViewController = CountryViewController()
        countryViewController.selectedCountry = viewModel.items[0].country
        countryViewController.delegate = self
        LoaderController.presentViewController(controller: countryViewController)
    }
}

extension PhoneViewController: CountryViewControllerDelegate {
    func countryViewController(_ countryViewController: CountryViewController, didSelectCountry: Country) {
        for item in viewModel.items {
            switch item.type {
            case .country:
                if let countryItem = item as? PhoneViewModelCountryItem {
                    countryItem.country = didSelectCountry
                }
            case .phone:
                if let phoneItem = item as? PhoneViewModelPhoneItem {
                    phoneItem.country = didSelectCountry
                }
            default: break
            }
        }
        reloadTableView()
    }
}
