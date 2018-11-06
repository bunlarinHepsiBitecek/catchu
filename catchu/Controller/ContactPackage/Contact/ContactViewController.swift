 //
//  ContactViewController.swift
//  catchu
//
//  Created by Erkut Baş on 6/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet var contactView: ContactView!
    
    // let's create a child view controller of container view controller get data from container view controller to main controller view controller
    var childReferenceFriendContainerFriendController : ContainerFriendViewController?
    var childReferenceGroupContainerGroupController : ContainerGroupViewController?
    
    weak var delegateShareDataProtocols : ShareDataProtocols!
    weak var delegateContactProtocol : ContactsProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactView.referenceMasterViewController = self
        
        prepareViewLoadProcess()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTranstionToDismiss() {
        
        let transition = CATransition()
        
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
 }
 
 extension ContactViewController : ViewPresentationProtocols {
    
    func dismissViewController() {
        
        addTranstionToDismiss()
        self.dismiss(animated: false, completion: nil)
        
    }
    
 }

