//
//  NewGroupCreationViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class NewGroupCreationViewController: UIViewController {

    private var newGroupCreationView: NewGroupCreationView!
    var selectedCommonUserViewModelList = Array<CommonUserViewModel>()
    
    // to sync group creation participant count and friend group relation view count
    var friendGroupRelationViewModel: FriendGroupRelationViewModel?
    
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

        setupViews()
        
    }
    
}

// MARK: - major functions
extension NewGroupCreationViewController {
    
    private func setupViews() {
        
        viewConfiguration()
        
        do {
            try addViews()
        } catch let error as ClientPresentErrors {
            if error == .missingFriendGroupRelationViewModel {
                print("\(Constants.ALERT)friendGroupRelationViewModel is required to sync total selected participant count with group creation view")
            }
        }
        catch  {
            print("\(Constants.CRASH_WARNING)")
        }
        
        addBarButtons()
        
    }
    
    private func viewConfiguration() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.groupCreate
        
    }
    
    private func addViews() throws {
        
        guard let friendGroupRelationViewModel = friendGroupRelationViewModel else { throw ClientPresentErrors.missingFriendGroupRelationViewModel}
        
        newGroupCreationView = NewGroupCreationView(frame: .zero, selectedCommonUserViewModelList: selectedCommonUserViewModelList, friendGroupRelationViewModel: friendGroupRelationViewModel)
        
        newGroupCreationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(newGroupCreationView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            newGroupCreationView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            newGroupCreationView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            newGroupCreationView.topAnchor.constraint(equalTo: safe.topAnchor),
            newGroupCreationView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    private func addBarButtons() {
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        //self.navigationItem.rightBarButtonItem = rigthBarButton
        
        self.addRigthBarButton { (finish) in
            print("right bat button is added")
        }
        
    }
    
    private func addRigthBarButton(completion : @escaping (_ finish : Bool) -> Void) {
        self.navigationItem.rightBarButtonItem = self.rigthBarButton
        completion(true)
    }
    
    @objc func dismissViewController(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChanges(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
