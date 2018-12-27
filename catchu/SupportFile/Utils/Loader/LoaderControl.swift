//
//  LoaderControl.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//
import UIKit

class LoaderController: NSObject {
    
    static let shared = LoaderController()
    private let activityIndicator = UIActivityIndicatorView()
    private let progressView = UIProgressView()
    
    // MARK: between 0.0 - 1.0
    var progressCounter: Double = 0 {
        didSet {
            let progress = Float(progressCounter) / 100
            DispatchQueue.main.async {
                self.progressView.setProgress(progress, animated: self.progressCounter != 0)
            }
        }
    }
    
    //MARK: - Private Methods -
    private func setupLoader() {
        removeLoader()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
    }
    
    func showLoader() {
        setupLoader()
        
        let currentView = self.currentView()
        
        DispatchQueue.main.async {
            self.activityIndicator.center = currentView.center
            self.activityIndicator.startAnimating()
            currentView.addSubview(self.activityIndicator)
            //            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            //            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func showLoader(style: UIActivityIndicatorView.Style) {
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = style
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        guard let currentVC = LoaderController.currentViewController() else {
            print("Current View controller can not be found for activity indicator")
            return
        }
        guard let mainView = currentVC.view else { return }
        
        mainView.addSubview(self.activityIndicator)
        let safeLayout = mainView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeLayout.centerYAnchor)
            ])
        
        self.activityIndicator.startAnimating()
    }
    
    func startProgressView(progressViewStyle: UIProgressViewStyle) {
        removeProgressView()
        print("startProgressView")
        
        //self.progressView.progressViewStyle = progressViewStyle
        let currentView = self.currentView()
        
        DispatchQueue.main.async {
            self.progressView.frame = currentView.frame
            currentView.addSubview(self.progressView)
            self.progressView.translatesAutoresizingMaskIntoConstraints = false
            
            let margins = self.currentViewController().view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                self.progressView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                self.progressView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                self.progressView.topAnchor.constraint(equalTo: margins.topAnchor)
                ])
        }
    }
    
    func removeProgressView() {
        self.progressView.removeFromSuperview()
    }
    
    func currentView() -> UIView {
        let appDel = appDelegate()
        return appDel.window!.rootViewController!.view!
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func currentViewController() -> UIViewController {
        return appDelegate().window!.rootViewController!
    }
    
    class func currentViewController(rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController?.presentedViewController {
            return currentViewController(rootViewController: presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return currentViewController(rootViewController: navigationController.visibleViewController)
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return currentViewController(rootViewController: selectedViewController)
            }
        }
        
        return rootViewController
    }
    
    
    /// Find current navigation controller
    ///
    /// - Returns: current navigation controller
    class func currentNavigationController() -> UINavigationController? {
        return LoaderController.currentViewController()?.navigationController
    }
    

    /// If exist find navigation controller and push to stack given view controller
    ///
    /// - Parameter controller: The view controller to present on current view controller
    class func presentViewController(controller: UIViewController?) {
        guard let controller = controller else { return }
        guard let currentViewController = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        let navigationController = UINavigationController(rootViewController: controller)
        
        currentViewController.present(navigationController, animated: true, completion: nil)
    }
    
    /// If exist find navigation controller and pushes given view controller
    ///
    /// - Parameter controller: The view controller to push onto the stack
    class func pushViewController(controller: UIViewController?){
        guard let controller = controller else { return }
        guard let navigationController = LoaderController.currentNavigationController() else { return }
        navigationController.pushViewController(controller, animated: true)
    }
    
    
    class func setRootViewController(controller: UIViewController?, transition: LoaderTransition) {
        DispatchQueue.main.async {
            guard let controller = controller else { return }
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.popToRootViewController(animated: true)
            guard let appDel = UIApplication.shared.delegate as? AppDelegate, let window = appDel.window else { return }
            window.layer.add(transition.animation, forKey: transition.forKey)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    class func setRootViewControllerForStoryboard(name: String, identifier: String, transition: LoaderTransition) {
        DispatchQueue.main.async {
            let storyboardController = UIStoryboard(name: name, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
            guard let appDel = UIApplication.shared.delegate as? AppDelegate, let window = appDel.window else { return }
            window.layer.add(transition.animation, forKey: transition.forKey)
            window.rootViewController = storyboardController
            window.makeKeyAndVisible()
        }
    }
    
    
    class func getSafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11, *) {
            let window = UIApplication.shared.windows[0]
            let insets:UIEdgeInsets = window.safeAreaInsets
            return insets
        } else {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    func goToSettings() {
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(settingsUrl!)  {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                })
            }
            else  {
                let url = URL(string : "prefs:root=")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }
        }
    }
    
    class func transitionAnimation() -> CATransition {
        let transition = CATransition()
        /// Second, we define the duration for the transition to get COMPLETED
        transition.duration = 0.20
        /// Here, you define the animation pacing (whether it starts slowly, ends faster OR starts faster, ends slowly... etc)
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        return transition
    }
    
}
