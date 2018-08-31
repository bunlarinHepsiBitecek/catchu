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
            progressView.setProgress(progress, animated: progressCounter != 0)
        }
    }
    
    //MARK: - Private Methods -
    private func setupLoader() {
        removeLoader()
        
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.activityIndicatorViewStyle = .gray
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
    
    func startProgressView(progressViewStyle: UIProgressViewStyle) {
        removeProgressView()
        print("startProgressView")
        
        self.progressView.progressViewStyle = progressViewStyle
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
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func currentViewController() -> UIViewController {
        return appDelegate().window!.rootViewController!
    }
    
    func currentView() -> UIView {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        return appDel.window!.rootViewController!.view!
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
    
    func goToLoginViewController() {
        LoaderController.shared.appDelegate().window?.rootViewController = UIStoryboard(name: Constants.Storyboard.Name.Login, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.ID.LoginViewController)
        LoaderController.shared.appDelegate().window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func goToFeedViewController() {
        LoaderController.shared.appDelegate().window?.rootViewController = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.ID.FeedViewController)
        LoaderController.shared.appDelegate().window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func gotoConfirmationViewController() {
        LoaderController.shared.appDelegate().window?.rootViewController = UIStoryboard(name: Constants.Storyboard.Name.Login, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.ID.ConfirmationViewController)
        LoaderController.shared.appDelegate().window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func goToMainViewController() {
        LoaderController.shared.appDelegate().window?.rootViewController = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.ID.MainTabBarViewController)
        LoaderController.shared.appDelegate().window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

