//
//  FinalShareInfoViewController.swift
//  catchu
//
//  Created by Erkut Baş on 10/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalShareInfoViewController: UIViewController {

    @IBOutlet var mainContainerView: UIView!
    
    private var finalPageView : FinalSharePageView?
//    private var transition : CATransition?
    
    lazy var viewControllerLoadingScene: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        temp.alpha = 0
        
        return temp
        
    }()
    
    private var activityIndicator: UIActivityIndicatorView!
    private var tempView : UIView!
    
    weak var delegateForViewController : ShareDataProtocols!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

// MARK: - major functions
extension FinalShareInfoViewController {
    
    func setupViews() {
        
        addFinalPageView()
        addViewControllerLoadingScene()
        addTransition()
        
    }
    
    func addFinalPageView() {
        
        finalPageView = FinalSharePageView()
        
        finalPageView!.setDelegates(delegate: self, delegateForShareMenuViews: delegateForViewController)
        finalPageView!.translatesAutoresizingMaskIntoConstraints = false
        finalPageView!.isUserInteractionEnabled = true
        
        self.view.addSubview(finalPageView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            finalPageView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            finalPageView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            finalPageView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor
            ),
            finalPageView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func addViewControllerLoadingScene() {
        
        self.view.addSubview(viewControllerLoadingScene)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            viewControllerLoadingScene.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            viewControllerLoadingScene.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            viewControllerLoadingScene.bottomAnchor.constraint(equalTo: safe.bottomAnchor
            ),
            viewControllerLoadingScene.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func addActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = viewControllerLoadingScene.center
        
        viewControllerLoadingScene.addSubview(activityIndicator)
        
    }
    
    func activateLoadingScene(active : Bool, completion : @escaping (_ result : Bool) -> Void) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
            
            if active {
                self.viewControllerLoadingScene.alpha = 1
                self.activityIndicator.startAnimating()
                
            } else {
                self.viewControllerLoadingScene.alpha = 0
                self.activityIndicator.stopAnimating()
                
            }
            
        }) { (result) in
            
            completion(true)
            
        }
        
    }
    
    func addTransition() {
        
        print("addTransition starts")
        print("view : \(view)")
        print("view.window : \(view.window)")
        
        let transition = CATransition()
        
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
    func addTransitionToNextPage() {
        
        let transition = CATransition()
        
        transition.duration = Constants.AnimationValues.aminationTime_03
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
    }
    
    func initiateFriendPresentation(completion : @escaping (_ result : Bool) -> Void) {
        
        if User.shared.userFriendList.count > 0 {
            
            self.presentContactViewController()
            
        } else {
            
            addActivityIndicator()
            activateLoadingScene(active: true) { (finish) in
                
                print("finishes")
                
            }
            
            if let userid = User.shared.userid {
                
                APIGatewayManager.shared.getUserFriendList(userid: userid) { (friendList, completed) in
                    
                    if completed {
                        
                        if let businessError = friendList.error {
                            
                            if businessError.code != 1 {
                                print("something goes wrong : \(businessError.code)")
                            } else {
                                
                                User.shared.appendElementIntoFriendListAWS(httpResult: friendList)
                                
                            }
                            
                        }
                        
                    }
                    
                    completion(true)
                    
                }
                
            }
            
        }
        
    }
    
    func presentContactViewController() {
        
        if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ContactViewController) as? ContactViewController {
            
            destinationController.delegateShareDataProtocols = self
            destinationController.delegateContactProtocol = self
            
            addTransitionToNextPage()
            
            self.present(destinationController, animated: false, completion: nil)
            
        }
        
    }
    
    func resetFinalPageViewSettings() {
        
        if finalPageView != nil {
            finalPageView!.resetPostAttachmentViews()
        }
        
    }
    
    
}

// MARK: - ShareDataProtocols
extension FinalShareInfoViewController : ShareDataProtocols {
    
    func resetViewSettings() {
        resetFinalPageViewSettings()
    }
    
}

// MARK: - ViewPresentationProtocols
extension FinalShareInfoViewController : ViewPresentationProtocols {
    
    func dismissViewController() {
        
        addTransition()
        //        manageTransitionOfViewController(direction: .left)
        //        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func directToSaySometingPages() {
        
        addTransitionToNextPage()
//        manageTransitionOfViewController(direction: .rigth)
        
        if let destination = UIStoryboard.init(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.FinalNoteViewController) as? FinalNoteViewController {
            
            destination.delegateForViewController = self.delegateForViewController
            
            self.present(destination, animated: false, completion: nil)
            
        }
        
    }
    
    func directToContactsViewController(inputPostType: PostAttachmentTypes) {
        
        switch inputPostType {
        case .friends:
            print("friends selected")
        case .group:
            print("group selected")
        default:
            return
        }
        
//        self.addTransitionToNextPage()
        
        initiateFriendPresentation { (finish) in
            
            if finish {
                
                DispatchQueue.main.async {
                    
                    self.activateLoadingScene(active: false, completion: { (result) in
                        
                        if result {
                            self.presentContactViewController()
                            
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
}

extension FinalShareInfoViewController : ContactsProtocols {
    
    func returnSelectedContactProcess(selectedChoise: SegmentedButtonChoise) {
        
        guard let finalPageView = finalPageView else { return }
        
        switch selectedChoise {
        case .friends:
            finalPageView.setInformationLabel(inputPostType: .friends)
            PostItems.shared.createSelectedAllowList(inputPostType: .friends)
        case .groups:
            finalPageView.setInformationLabel(inputPostType: .group)
            PostItems.shared.createSelectedAllowList(inputPostType: .group)
        default:
            break
        }
        
    }
    
}
