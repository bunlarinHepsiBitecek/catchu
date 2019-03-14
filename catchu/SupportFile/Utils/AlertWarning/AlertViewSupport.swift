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
    
    static let shared = AlertViewManager()
    
    private var alertControls = [AlertControllerInfo]()
    
    func createAlert(title: String, message: String, preferredStyle: UIAlertController.Style, actionTitle: String, actionStyle: UIAlertAction.Style, completionHandler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: completionHandler)
        
        alertController.addAction(alertAction)
        
        guard let currentViewController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        currentViewController.present(alertController, animated: true, completion: nil)
    }
    
    func createAlert_2(title: String, message: String, preferredStyle: UIAlertController.Style, actionTitle: String, actionStyle: UIAlertAction.Style, selfDismiss: Bool, seconds: Int, completionHandler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: completionHandler)
        
        alertController.addAction(alertAction)
        
        if selfDismiss {
            
            let when = DispatchTime.now() + Double(Int64(seconds))
            
            DispatchQueue.main.asyncAfter(deadline: when){
                alertController.dismiss(animated: true, completion: nil)
            }
        
        }
    
    }
    
    func createAlert(title: String, message: String, preferredStyle: UIAlertController.Style, actionTitleLeft: String, actionTitleRight: String, actionStyle: UIAlertAction.Style, completionHandlerLeft: ((UIAlertAction) -> Void)?, completionHandlerRight: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let alertActionLeft = UIAlertAction(title: actionTitleLeft, style: actionStyle, handler: completionHandlerLeft)
        let alertActionRight = UIAlertAction(title: actionTitleRight, style: actionStyle, handler: completionHandlerRight)
        
        alertController.addAction(alertActionLeft)
        alertController.addAction(alertActionRight)
        
        guard let currentViewController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        currentViewController.present(alertController, animated: true, completion: nil)
    }
    
    
    public func showOkAlert(_ title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let okAction = UIAlertAction.init(title: LocalizedConstants.Ok, style: UIAlertAction.Style.cancel, handler: handler)
        
        self.showAlert(title, message: message, actions: [okAction], style: UIAlertController.Style.alert, view: nil)
        
    }
    
    private func showAlert(_ title: String?, message: String?, actions: [UIAlertAction], style: UIAlertController.Style, view: AnyObject?) {
        
        let alertController = UIAlertController.init(title: title, message: message == "" ? nil : message, preferredStyle: style) as UIAlertController
        
        for action: UIAlertAction in actions {
            alertController.addAction(action)
        }
        
        guard let currentViewController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        currentViewController.present(alertController, animated: true, completion: nil)
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
    
    
    class func show(targetView: UIView? = nil, type: ErrorType, placement: Placement? = nil, title: String? = nil, body: String? = nil) {
        let errorView = ErrorView()
        errorView.configureTheme(type, placement)
        errorView.configureContent(title: title, body: body)
        errorView.show(targetView: targetView)
    }
    
}
