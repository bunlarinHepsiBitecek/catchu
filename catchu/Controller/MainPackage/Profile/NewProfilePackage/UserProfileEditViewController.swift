//
//  UserProfileEditViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let cancelAction = #selector(UserProfileEditViewController.cancel)
    static let saveAction = #selector(UserProfileEditViewController.save)
}

class UserProfileEditViewController: BaseTableViewController {
    
    var viewModel: UserProfileEditViewModel!
    
    private var expandedIndexPath: IndexPath?
    private var pickedImage: UIImage?
    private var pickedImageExtension: String?
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    lazy var cancelLeftBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelAction)
        return barButton
    }()
    
    lazy var doneRightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .saveAction)
        barButton.isEnabled = false
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavigation()
        setupHeaderView()
        setupTableView()
        setupViewModel()
    }
    
    func setup() {
        self.view.backgroundColor = .white
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = cancelLeftBarButton
        navigationItem.rightBarButtonItem = doneRightBarButton
    }
    
    func setupHeaderView() {
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        
        // at cell, 2 times left padding from
        let leftPadding: CGFloat = 7 * 20
        tableView.separatorStyle = .singleLine
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: leftPadding , bottom: 0, right: 0)
        
        tableView.register(UserProfileEditViewCell.self, forCellReuseIdentifier: UserProfileEditViewCell.identifier)
        
        tableView.tableFooterView = UIView()
//        let headerView = UserProfileHeaderView()
//        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        tableView.tableHeaderView = headerView
    }
    
    deinit {
        viewModel.state.unbind()
        viewModel.valueChanged.unbind()
    }
    
    func setupViewModel() {
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
        
        viewModel.valueChanged.bind { [unowned self] in
            self.enableDoneRightBarButton($0)
        }
    }
    
    private func stateAnimate(_ state: TableViewState) {
        switch state {
        case .loading:
            startActivityIndicatorBarButton()
        case .populate:
            stopActivityIndicatorBarButton()
            dismissViewController()
        default:
            print("Handle Error state: \(state)")
            return
        }
    }
    
    @objc func cancel() {
        dismissViewController()
    }
    
    @objc func save() {
        viewModel.updateUserInfo()
    }
    
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func startActivityIndicatorBarButton() {
        DispatchQueue.main.async {
            if let rightBarButtonView = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
                self.activityIndicatorView.frame = rightBarButtonView.frame
            }
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    private func stopActivityIndicatorBarButton() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.doneRightBarButton
            self.doneRightBarButton.isEnabled = false
        }
    }
    
    private func enableDoneRightBarButton(_ state: Bool) {
        DispatchQueue.main.async {
            self.doneRightBarButton.isEnabled = state
        }
    }
}

extension UserProfileEditViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileEditViewCell.identifier, for: indexPath) as? UserProfileEditViewCell {
            cell.configure(viewModelItem: item)
            
            cell.changePhotoActionBlock = { () in
                self.showChangePhotoActionSheet()
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    /*
    1. There is no date picker shown, we tap a row, then a date picker is shown just under it
    2. A date picker is shown, we tap the same row , then the date picker is hidden
    3. A date picker is shown, we tap a differen row, then the date picker is hidden and another date picker under the tapped row is shown
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
//        tableView.visibleCells
//            .compactMap { $0 as? UserProfileEditViewCell}
//            .forEach { $0.isExpanded = false}
        
        tableView.beginUpdates()
        
        if let expandedIndexPath = self.expandedIndexPath {
            if expandedIndexPath == indexPath { // case 2
                expandRow(indexPath: indexPath, isExpand: false)
            } else { // case 3
                expandRow(indexPath: expandedIndexPath, isExpand: false)
                expandRow(indexPath: indexPath, isExpand: true)
            }
        } else { // case 1
            expandRow(indexPath: indexPath, isExpand: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func expandRow(indexPath: IndexPath, isExpand: Bool) {
        if let previousCell = tableView.cellForRow(at: indexPath) as? UserProfileEditViewCell {
            previousCell.isExpanded = isExpand
            self.expandedIndexPath = isExpand ? indexPath : nil
        }
    }
}

extension UserProfileEditViewController {
    
    func showChangePhotoActionSheet() {
        let actionSheetController = UIAlertController(title: LocalizedConstants.Profile.ChangePhoto, message: nil, preferredStyle: .actionSheet)
        
        let actionRemoveCurrentPhoto = UIAlertAction(title: LocalizedConstants.EditableProfile.RemoveCurrentPhoto, style: .destructive) { (_) in
            self.removeProfilePhoto()
        }
        
        let actionTakePhoto = UIAlertAction(title: LocalizedConstants.EditableProfile.TakePhoto, style: .default) { (_) in
            ImagePickerManager.shared.accessCamera(vc: self)
        }
        
        let actionChooseFromLibrary = UIAlertAction(title: LocalizedConstants.EditableProfile.ChooseFromLibrary, style: .default) { (_) in
            ImagePickerManager.shared.accessPhotoLibrary(vc: self)
        }
        
        let actionCancel = UIAlertAction(title: LocalizedConstants.Cancel, style: .cancel, handler: nil)
        
        actionSheetController.addAction(actionRemoveCurrentPhoto)
        actionSheetController.addAction(actionTakePhoto)
        actionSheetController.addAction(actionChooseFromLibrary)
        actionSheetController.addAction(actionCancel)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
        ImagePickerManager.shared.imagePicked = { (image, pathExtension) in
            self.updateProfileImage(image: image, imageExtension: pathExtension)
        }
    }
    
    private func removeProfilePhoto() {
        viewModel.removeProfilePhoto()
        updateProfileImage(image: nil, imageExtension: nil)
    }
    
    private func updateProfileImage(image: UIImage?, imageExtension: String?) {
        pickedImage = image
        pickedImageExtension = imageExtension
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserProfileEditViewCell {
            cell.profileImageView.image = pickedImage
        }
    }
    
}

