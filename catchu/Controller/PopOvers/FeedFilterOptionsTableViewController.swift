//
//  FeedFilterOptionsTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let dismissViewController = #selector(FeedFilterOptionsTableViewController.dismissViewController)
    static let saveNewFilter = #selector(FeedFilterOptionsTableViewController.saveNewFeedFilter)
}

class FeedFilterOptionsTableViewController: UITableViewController {
    
    private var feedFilterOptionsViewModel = FeedFilterOptionsViewModel()
    
    private var feedFilterChangeSectionHeaderView = FeedFilterRangeSectionHeaderView()
    private var feedFilterChangeSectionFooterView = FeedFilterRangeSectionFooterView()
    
    lazy var leftBarButton: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: UIBarButtonItemStyle.plain, target: self, action: .dismissViewController)
        
        temp.isEnabled = true
        return temp
    }()
    
    lazy var rightBarButton: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.save, style: UIBarButtonItemStyle.plain, target: self, action: .saveNewFilter)
        
        temp.isEnabled = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        addBarButtons()
        setupViewSettings()
        setupListeners()
        
    }
    
}

// MARK: - major functions
extension FeedFilterOptionsTableViewController {
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.filterSettings
        self.tableView.separatorStyle = .none
        self.tableView.register(FeedFilterSliderTableViewCell.self, forCellReuseIdentifier: FeedFilterSliderTableViewCell.identifier)
    }
    
    private func prepareData() {
        feedFilterOptionsViewModel.createFeedFilterRangeSections()
    }
    
    private func addBarButtons() {
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc fileprivate func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveNewFeedFilter(_ sender: UIButton) {
        // to do
    }
    
    private func setSliderChangeValueToSectionHeader(value: Int) {
        feedFilterChangeSectionHeaderView.setChangedFilterRange(value: value)
    }
    
    fileprivate func resetSliderValues(_ resetValue: (Int)) {
        self.setSliderChangeValueToSectionHeader(value: resetValue)
        self.resetSliderValue(resetValue: resetValue)
    }
    
    private func setupListeners() {
        feedFilterChangeSectionFooterView.listenResetButton { (resetValue) in
            self.resetSliderValues(resetValue)
        }
    }
    
    private func resetSliderValue(resetValue: Int) {
        DispatchQueue.main.async {
            for item in self.tableView.visibleCells {
                if let cell = item as? FeedFilterSliderTableViewCell {
                    cell.setSliderValue(value: resetValue)
                }
            }
        }
    }
    
}

// MARK: - tableviewdelegate functions
extension FeedFilterOptionsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return feedFilterOptionsViewModel.returnSectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedFilterOptionsViewModel.returnRowCount(section: section)
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return feedFilterOptionsViewModel.returnSectionTitle(section)
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return feedFilterChangeSectionHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.StaticViewSize.ViewSize.Height.height_50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return feedFilterChangeSectionFooterView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.StaticViewSize.ViewSize.Height.height_50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feedFilterOptions = feedFilterOptionsViewModel.returnFeedFilterRangeSectionsItems(section: indexPath.section)
        
        switch feedFilterOptions.type {
        case .filterRange:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedFilterSliderTableViewCell.identifier, for: indexPath) as? FeedFilterSliderTableViewCell else { return UITableViewCell() }
            
            cell.initiateCellDesign(item: feedFilterOptions)
            cell.addListenerForSliderValueChanged { (sliderValue) in
                self.setSliderChangeValueToSectionHeader(value: sliderValue)
            }
            
            return cell
            
        }
    }
    
}
