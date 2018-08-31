//
//  AlertViewSupport.swift
//  catchu
//
//  Created by Erkut Baş on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import UIKit

struct AlertControllerInfo {
    
    var presentingViewController : UIViewController
    var alertController : UIAlertController
    
}

class AlertViewManager : NSObject {
    
    public class var shared : AlertViewManager {
        struct Static {
            static let instance : AlertViewManager = AlertViewManager()
        }
        return Static.instance
    }
    
    private var alertControls = [AlertControllerInfo]()
    
    
    func createAlert(title: String, message: String, preferredStyle: UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle, completionHandler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: completionHandler)
        
        alertController.addAction(alertAction)
        
        if let app = UIApplication.shared.delegate, let window = app.window, let presentingViewController = window?.rootViewController {
            
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
        }
    }
    
    func createAlert_2(title: String, message: String, preferredStyle: UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle, selfDismiss: Bool, seconds: Int, completionHandler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: completionHandler)
        
        alertController.addAction(alertAction)
        
        if let app = UIApplication.shared.delegate, let window = app.window, let presentingViewController = window?.rootViewController {
            
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
            
        }
        
        if selfDismiss {
            
            let when = DispatchTime.now() + Double(Int64(seconds))
            
            DispatchQueue.main.asyncAfter(deadline: when){
                alertController.dismiss(animated: true, completion: nil)
            }
        
        }
    
    }
    
    func createAlert(title: String, message: String, preferredStyle: UIAlertControllerStyle, actionTitleLeft: String, actionTitleRight: String, actionStyle: UIAlertActionStyle, completionHandlerLeft: ((UIAlertAction) -> Void)?, completionHandlerRight: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertActionLeft = UIAlertAction(title: actionTitleLeft, style: actionStyle, handler: completionHandlerLeft)
        let alertActionRight = UIAlertAction(title: actionTitleRight, style: actionStyle, handler: completionHandlerRight)
        
        alertController.addAction(alertActionLeft)
        alertController.addAction(alertActionRight)
        
        if let app = UIApplication.shared.delegate, let window = app.window, let presentingViewController = window?.rootViewController {
            
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
        }
    }
    
    
    public func showOkAlert(_ title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let okAction = UIAlertAction.init(title: LocalizedConstants.Ok, style: UIAlertActionStyle.cancel, handler: handler)
        
        self.showAlert(title, message: message, actions: [okAction], style: UIAlertControllerStyle.alert, view: nil)
        
    }
    
    private func showAlert(_ title: String?, message: String?, actions: [UIAlertAction], style: UIAlertControllerStyle, view: AnyObject?) {
        
        let alertController = UIAlertController.init(title: title, message: message == "" ? nil : message, preferredStyle: style) as UIAlertController
        
        for action: UIAlertAction in actions {
            alertController.addAction(action)
        }
        
        if let app = UIApplication.shared.delegate, let window = app.window, let presentingViewController = window?.rootViewController {
            
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
            
        }
    }
    
    private func presentAlertController(_ alertController : UIAlertController, presentingViewController : UIViewController) {
        DispatchQueue.main.async { () -> Void in
            
            if let presentedModalVC = presentingViewController.presentedViewController {
                presentedModalVC.present(alertController, animated: true, completion: nil)
            }
            else {
                presentingViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
