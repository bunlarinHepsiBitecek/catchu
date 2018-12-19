//
//  GroupInfoEditTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoEditTableViewController: UITableViewController {
    
    // groupNameViewModel is getting outside
    var groupNameViewModel: GroupNameViewModel?
    
    // groupInfoEditViewModel is created self tableviewcontroller
    var groupInfoEditViewModel: GroupInfoEditViewModel?
    
    lazy var leftBarButton: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissViewController(_:)))
        temp.isEnabled = true
        return temp
    }()
    
    lazy var rigthBarButton: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.save, style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveChanges(_:)))
        temp.isEnabled = false
        return temp
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        temp.backgroundColor = UIColor.clear
        temp.hidesWhenStopped = true
        temp.startAnimating()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareViewController()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    deinit {
        groupInfoEditViewModel?.saveButtonActivation.unbind()
        groupInfoEditViewModel?.saveProcessState.unbind()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupInfoEditTableViewCell.identifier, for: indexPath) as? GroupInfoEditTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: groupInfoEditViewModel)
        
        return cell
    }
    
}

// MARK: - major functions
extension GroupInfoEditTableViewController {
    
    private func prepareViewController() {
        print("\(#function)")

        addBarButtons()
        setupViewSettings()
        
        do {
            try setupViewModelListeners()
            
        } catch let error as ClientPresentErrors {
            if error == .missingGroupNameViewModel {
                print("GroupNameViewModel is required")
            }
        }
        
        catch  {
            print("Something terribly goes wrong")
        }
        
    }
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.groupInfoEdit
        self.tableView.separatorStyle = .none
        self.tableView.register(GroupInfoEditTableViewCell.self, forCellReuseIdentifier: GroupInfoEditTableViewCell.identifier)
    }
    
    private func addBarButtons() {
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rigthBarButton
        
    }
    
    private func enableManagerOfSaveButton(active: Bool) {
        self.rigthBarButton.isEnabled = active
    }
    
    private func setupViewModelListeners() throws {
        
        guard let groupNameViewModel = self.groupNameViewModel else { throw ClientPresentErrors.missingGroupNameViewModel }
        
        groupInfoEditViewModel = GroupInfoEditViewModel(groupNameViewModel: groupNameViewModel)
        
        groupInfoEditViewModel?.saveButtonActivation.bind({ (active) in
            self.enableManagerOfSaveButton(active: active)
        })
        
        groupInfoEditViewModel?.saveProcessState.bind({ (operationState) in
            self.saveProcessOperationStateControl(operationState: operationState)
        })
        
    }
    
    private func saveProcessOperationStateControl(operationState: CRUD_OperationStates) {
        switch operationState {
        case .processing:
            if let rightBarButtonView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
                activityIndicatorView.frame = rightBarButtonView.frame
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
            }
            return
        case .done:
            self.navigationItem.rightBarButtonItem = rigthBarButton
            return
        }
    }
    
    @objc func dismissViewController(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChanges(_ sender : UIButton) {
        //self.dismiss(animated: true, completion: nil)
        
        groupInfoEditViewModel?.saveProcessState.value = .processing
        
        print("\(Constants.ALERT) nothing happens go ahead dont worry")
        
        do {
            try groupInfoEditViewModel?.updateGroupInformation()
        }
        catch let error as ClientPresentErrors {
            if error == .missingGroupInfoEditViewModel {
                print("\(Constants.ALERT)GroupInfoEditViewModel is required!")
            }
        }
        catch let error as CastingErrors {
            if error == .groupObjectCastFailed {
                print("\(Constants.ALERT)GroupObjectCasting failed")
            }
        }
        catch {
            print("Something goes terribly wrong")
        }
        
    }
    
    
    
}
