//
//  FriendRelationViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendRelationViewController: UIViewController {
    
    private var friendRelationView : FriendGroupRelationView!
    var friendRelationChoise : FriendRelationViewChoise?
    var friendRelationViewPurpose : FriendRelationViewPurpose?
    
    var participantArray: Array<User>?
    var selectedGroup: Group?
    // used to return selected friend, friendList, or group information
    weak var delegate : PostViewProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        
        
    }
    
    
    
}

// MARK: - major functions
extension FriendRelationViewController {
    
    private func setupViews() {
        viewConfiguration()
        addViews()
    }
    
    private func viewConfiguration() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func addViews() {
        
        do {
            try addFriendRelationView()
            
        } catch let error as ClientPresentErrors {
            print("ALERT ALERT ALERT")
            if error == .missingViewControllerChoise {
                print("FriendRelationViewController awaits choise value - calling for friends or groups")
            } else if error == .missingViewControllerPurpose {
                print("FriendRelationViewController awaits purpose value - calling for post operation or group management")
            } else if error == .missingDelegation {
                print("Delegation is required")
            }
        }
        
        catch {
            print("\(Constants.CRASH_WARNING)")
        }
        
        //addFriendRelationView()
    }
    
    private func addFriendRelationView() throws {
        
        guard let friendRelationChoise = friendRelationChoise else { throw ClientPresentErrors.missingViewControllerChoise }
        guard let friendRelationViewPurpose = friendRelationViewPurpose else { throw ClientPresentErrors.missingViewControllerPurpose }
        //guard let delegate = delegate else { throw ClientPresentErrors.missingDelegation }
        
        if friendRelationViewPurpose == .participant || friendRelationViewPurpose == .post {
            if delegate == nil {
                throw ClientPresentErrors.missingDelegation
            }
        }
        
        friendRelationView = FriendGroupRelationView(frame: .zero, delegate: self, delegatePostView: delegate, friendRelationChoise: friendRelationChoise, friendRelationPurpose: friendRelationViewPurpose, participantArray: participantArray, selectedGroup: selectedGroup)
        
        friendRelationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(friendRelationView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            friendRelationView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendRelationView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendRelationView.topAnchor.constraint(equalTo: safe.topAnchor),
            friendRelationView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addTransitionToPresentationOfFriendRelationViewController() {
        
        let transition = CATransition()
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
}

// MARK: - ViewPresentationProtocols
extension FriendRelationViewController: ViewPresentationProtocols {

    func dismissViewController() {
        addTransitionToPresentationOfFriendRelationViewController()
        self.dismiss(animated: false) {
            print("controller dismissed")
        }
    }
    
}

