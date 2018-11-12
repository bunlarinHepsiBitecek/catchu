//
//  PhoneViewConfirmationController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class PhoneViewConfirmationController: BaseTableViewController {
    
    var viewModel: PhoneViewModel!
    
    
    lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(complateConfirmation(_:)))
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavigation() {
        navigationItem.title = LocalizedConstants.EditableProfileView.Confirm
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func setupTableView() {
        // MARK: must initialize at viewDidLoad
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = viewModel
        tableView.delegate = self
        
        // Setup dynamic auto-resizing for comment cells
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .singleLine
        
        tableView.register(PhoneViewConfirmationCell.self, forCellReuseIdentifier: PhoneViewConfirmationCell.identifier)
    }
    
    private func setupViewModel() {
        viewModel.loadConfirmation()
        
        viewModel.confirmationItem.isValidConfirmation.bindAndFire {[unowned self] in
            print("isValidConfirmation: \($0)-\(self.viewModel.confirmationItem.confirmationCode)")
            self.doneBarButton.isEnabled = $0
        }
    }
    
    deinit {
        viewModel.confirmationItem.isValidConfirmation.unbind()
    }
    
    @objc func complateConfirmation(_ sender: UIBarButtonItem) {
        viewModel.smsConfirmation()
//        self.dismiss(animated: true, completion: nil)
    }
}
