//
//  MoreOptionsTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MoreOptionsTableViewController: UITableViewController {

    private var moreOptionsViewModel = MoreOptionsViewModel()
    
    lazy var leftBarButton: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissViewController(_:)))
    
        temp.isEnabled = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareData()
        addBarButtons()
        setupViewSettings()
        
    }

}

// MARK: - major functions
extension MoreOptionsTableViewController {
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.advancedSettings
        self.tableView.separatorStyle = .none
        self.tableView.register(AllowCommentsTableViewCell.self, forCellReuseIdentifier: AllowCommentsTableViewCell.identifier)
        self.tableView.register(AllowLocationAppearTableViewCell.self, forCellReuseIdentifier: AllowLocationAppearTableViewCell.identifier)
    }
    
    private func prepareData() {
        moreOptionsViewModel.createMoreOptionsSections()
    }
    
    private func addBarButtons() {
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func dismissViewController(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - tableviewdelegate functions
extension MoreOptionsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return moreOptionsViewModel.returnSectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreOptionsViewModel.returnRowCount(section: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return moreOptionsViewModel.returnSectionTitle(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moreOptions = moreOptionsViewModel.returnMoreOptionsSectionItem(section: indexPath.section)
        
        switch moreOptions.type {
        case .allowComment:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AllowCommentsTableViewCell.identifier, for: indexPath) as? AllowCommentsTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: moreOptions)
            
            return cell
            
        case .allowLocationAppear:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AllowLocationAppearTableViewCell.identifier, for: indexPath) as? AllowLocationAppearTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: moreOptions)
            
            return cell
            
        }
    }
    
}
