//
//  PopOverControllerManager.swift
//  catchu
//
//  Created by Erkut Baş on 1/1/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PopOverControllerManager : NSObject, UIPopoverPresentationControllerDelegate {
    
    private static let shared = PopOverControllerManager()
    
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        
        controller.modalPresentationStyle = .popover
        
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        
        presentationController.delegate = PopOverControllerManager.shared
        
        return presentationController
    }
    
}
