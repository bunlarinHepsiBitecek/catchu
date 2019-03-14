//
//  GroupInfoViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoViewController: UIViewController {

    var groupViewModel: CommonGroupViewModel?

    private var groupInfoView : GroupInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

// MARK: - major fucntions
extension GroupInfoViewController {
    
    private func prepareViewController() {
        
        configureViewControllerSettings()
        
        do {
            try addViews()
            
        }
        catch let error as ClientPresentErrors {
            if error == .missingGroupObject {
                print("Without Group data, groupInfoView can not be presented")
            }
        }
        catch {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    private func configureViewControllerSettings() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func addViews() throws {
        print("\(#function)")
        guard let groupViewModel = self.groupViewModel else { throw ClientPresentErrors.missingGroupObject }
        
        addGroupInfoView(groupViewModel: groupViewModel)
        addGroupInfoDismissListener()
    }
    
    private func addGroupInfoView(groupViewModel: CommonGroupViewModel) {
        print("\(#function) starts")
        
        //groupInfoView = GroupInfoView2(frame: .zero, group: group)
        groupInfoView = GroupInfoView(frame: .zero, groupViewModel: groupViewModel)
        //groupInfoView = GroupInfoView(frame: .zero, groupViewModel: groupViewModel, delegate: self)
        groupInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(groupInfoView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupInfoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupInfoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupInfoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    private func addTransitionToPresentationOfFriendRelationViewController() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
    private func addGroupInfoDismissListener() {
        groupInfoView.addObserverForGroupInfoDismiss { (state) in
            switch state {
            case .exit:
                self.addTransitionToPresentationOfFriendRelationViewController()
                self.dismiss(animated: false, completion: nil)
            case .start:
                return
            }
            
        }
        
    }
    
    // function is used from outside of the controller
    func addGroupLeavingProcessListener(completion: @escaping(_ groupOperationType: GroupOperationTypes) -> Void) {
        groupInfoView.addObserverForLeavingGroupProcess(completion: completion)
    }
}

