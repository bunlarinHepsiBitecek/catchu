//
//  UserProfileViewController.swift
//  catchu
//
//  Created by Erkut Baş on 11/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    private var leftItem = UIImageView(image: UIImage(named: "menu"))
    private var rigthItem = UIImageView(image: UIImage(named: "user_black"))
    
    private var userProfileMainView : UserProfileMainView?
    private var userProfileTopView : UserProfileTopView?
    
    private var containerView : UIView? = nil
    private let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    // userProfileView pullToDown animation
    private var heightConstraintsOfUserProfileTopView = NSLayoutConstraint()
    private var verticalLimit : CGFloat = Constants.StaticViewSize.ViewSize.Height.height_180
    private var totalTranslation : CGFloat = Constants.StaticViewSize.ViewSize.Height.height_180
    
    /* main pan up - down operation properties */
    // subviews constraint properties
    private var userProfileTopViewTopConstraint: NSLayoutConstraint!
    private var containerViewHeightConstraint: NSLayoutConstraint!
    
    // main pan gesture control properties
    private let userProfileTopViewOriginalTopConstraint: CGFloat = 0
    //private let userProfileTopViewMinimalVisibleHeight: CGFloat  = 54
    private let userProfileTopViewMinimalVisibleHeight: CGFloat  = 0
    private let userProfileTopViewMaximumVisibleHeightReverse: CGFloat  = -180
    private var imaginaryContainerViewOffsetStartPositionY: CGFloat = 0.0
    
    private var containerViewOriginalHeight: CGFloat = 0.0
    
    private var userProfileTopViewBottomY: CGFloat  = 0.0
    private var dragStartPos: CGPoint = CGPoint.zero
    private let dragDifference: CGFloat = 0
    
    private var contentOffset: CGFloat = 0.0
    
    // Variables for calculating the position
    enum Direction {
        case SCROLL
        case STOP
        case UP
        case DOWN
    }
    
    var dragDirection = Direction.UP
    
    /* main pan up - down operation properties */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViewController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setContainerViewHeightConstraint()
        
    }
    
}

// MARK: - major functions
extension UserProfileViewController {
    
    // we need to calculate after viewDidLoad, because pan gesture recognizer need that value
    func setContainerViewHeightConstraint() {
        print("setContainerViewHeightConstraint starts")
        
        guard let containerView = containerView else { return }
        
        print("containerView.frame : \(containerView.frame)")
        
        containerViewHeightConstraint =  self.containerView!.heightAnchor.constraint(equalToConstant: containerView.frame.height)
        
    }
    
    func prepareViewController() {
        
        print("prepareViewController starts")
        print("UIScreen bounds :\(UIScreen.main.bounds.size)")
        print("self.view.frame : \(self.view.frame)")
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        
        print("topPadding : \(topPadding)")
        print("bottomPadding : \(bottomPadding)")
        print("navigationBar : \(self.navigationController?.navigationBar.frame)")
        
        print("container result height : \(UIScreen.main.bounds.size.height - (topPadding! + bottomPadding! + (self.navigationController?.navigationBar.frame.height)! + 180 + 50))")
        
        
        addBarButtons()
        addUserProfileTopView()
        addSwipeGestureRecognizer()
        addPanGestureToTopView()
        addContainerView()
        setDelegateToSlideMenuLoader(delegate: self)
        
    }
    
    func addBarButtons() {
        
        addGestureRecognizersToTopBarItems()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthItem)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func startAnimationForLeftItem() {
        
        leftItem.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.leftItem.transform = CGAffineTransform.identity
                
                
        })
        self.leftItem.layoutIfNeeded()
        
    }
    
    func startAnimationForRigthItem() {
        
        rigthItem.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.rigthItem.transform = CGAffineTransform.identity
                
                
        })
        self.rigthItem.layoutIfNeeded()
        
    }
    
    func addUserProfileTopView() {
        
        userProfileTopView = UserProfileTopView(frame: .zero, delegate: self, delegateOfUserProfile: self)
        userProfileTopView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userProfileTopView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        heightConstraintsOfUserProfileTopView = userProfileTopView!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_180)
        
        userProfileTopViewTopConstraint = userProfileTopView!.topAnchor.constraint(equalTo: safe.topAnchor)
        
        NSLayoutConstraint.activate([
            
            userProfileTopView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            userProfileTopView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            userProfileTopViewTopConstraint,
            heightConstraintsOfUserProfileTopView
            //userProfileTopView!.topAnchor.constraint(equalTo: safe.topAnchor),
            //userProfileTopView!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_180)
            
            ])
        
    }
    
    func addUserProfileMainView() {
        
        userProfileMainView = UserProfileMainView(frame: .zero, delegate: self)
        userProfileMainView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userProfileMainView!)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userProfileMainView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            userProfileMainView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            userProfileMainView!.topAnchor.constraint(equalTo: safe.topAnchor),
            userProfileMainView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func setDelegateToSlideMenuLoader(delegate : ViewPresentationProtocols) {
        
        SlideMenuLoader.shared.setSlideMenuDelegation(delegate: delegate)
        
    }
    
    func addContainerView() {
        
        //let pageViewController = TabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let feedVC1 = FeedViewController()
//        feedVC1.view.backgroundColor = .red
        feedVC1.title = "Feed First"
        
        let catchVC1 = CatchViewController()
//        catchVC1.view.backgroundColor = .yellow
        catchVC1.title = "Catch Second"
        
        var items = [UIViewController]()
        items.append(feedVC1)
        items.append(catchVC1)
        
        pageViewController.items = items
        
        let menuTabView = pageViewController.menuTabView
        //menuTabView.backgroundColor = .clear
        menuTabView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menuTabView.layer.borderWidth = 1
        menuTabView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //let containerView = pageViewController.containerView
        containerView = pageViewController.containerView
        
        view.addSubview(containerView!)
        view.addSubview(menuTabView)
        
        addChild(to: containerView!, pageViewController)
        
        addMainPanGesture(inputView: containerView!)
        
        NSLayoutConstraint.activate([
            menuTabView.safeTopAnchor.constraint(equalTo: (self.userProfileTopView?.safeBottomAnchor)!),
//            menuTabView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 200),
            menuTabView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            menuTabView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            menuTabView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView!.safeTopAnchor.constraint(equalTo: menuTabView.safeBottomAnchor),
            containerView!.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView!.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView!.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    func activityIndicatorManager(active : Bool) {
        if userProfileTopView != nil {
            userProfileTopView?.activityManager(active: active)
        }
    }
    
    func refreshUserProfileInformation() {
        
        print("refreshUserProfileInformation starts")
        
        if userProfileTopView != nil {
            userProfileTopView?.getUserProfileInformation(completion: { (finish) in
                if finish {
                    self.userProfileTopView?.checkFollower_Following_Counts()
                }
            })
        }
    }
    
    func refreshUserProfileInformation(completion : @escaping (_ finish : Bool) -> Void) {
        
        print("refreshUserProfileInformation starts")
        
        if userProfileTopView != nil {
            
            userProfileTopView?.getUserProfileInformation(completion: completion)
            
//            userProfileTopView?.getUserProfileInformation(completion: { (finish) in
//                if finish {
//                    self.userProfileTopView?.checkFollower_Following_Counts()
//                }
//
//            })
        }
    }
    
    func findSelectedPageView() {
        
        print("findSelectedPageView starts")
        
        let activePage = pageViewController.selectedIndex
        
        print("activePage : \(activePage)")
        
        if activePage == 0 {
            if let feedViewContoller = pageViewController.items[activePage] as? FeedViewController {
                print("FeedViewController is active")
                
                print("feedViewContoller.tableView.contentOffset : \(feedViewContoller.tableView.contentOffset)")
                
                if feedViewContoller.tableView.contentOffset.y < 0 {
                    print("KAKAKAKAKAKAKAKAKAKAKAKAK")
                }
                
                self.contentOffset = feedViewContoller.tableView.contentOffset.y
                
            }
        } else if activePage == 1 {
            if let catchViewController = pageViewController.items[activePage] as? CatchViewController {
                print("CatchViewController is active")
                
            }
        }
        
    }
    
}

// MARK: - UIGestureRecognizer
extension UserProfileViewController : UIGestureRecognizerDelegate {
    
    func addGestureRecognizersToTopBarItems() {
        
        let tapGestureRecognizerLeftBarItem = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.leftBarItemPressed(_:)))
        tapGestureRecognizerLeftBarItem.delegate = self
        leftItem.addGestureRecognizer(tapGestureRecognizerLeftBarItem)
        
        let tapGestureRecognizerRigthBarItem = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.rightBarItemPressed(_:)))
        tapGestureRecognizerRigthBarItem.delegate = self
        rigthItem.addGestureRecognizer(tapGestureRecognizerRigthBarItem)
        
    }
    
    @objc func rightBarItemPressed(_ sender : UITapGestureRecognizer) {
        
        print("rightBarItemPressed pressed")
        
        startAnimationForRigthItem()
        
    }
    
    @objc func leftBarItemPressed(_ sender : UITapGestureRecognizer) {
        
        print("leftBarItemPressed pressed")
        
        startAnimationForLeftItem()
        
        print("self.navigationController?.viewControllers.count :\(self.navigationController?.viewControllers.count)")
        print("self.navigationController?.viewControllers :\(self.navigationController?.view)")
        print("self.navigationController?.viewControllers.count :\(self.navigationController?.view)")
        
        SlideMenuLoader.shared.animateSlideMenu(active: true)
        
    }
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UserProfileViewController.swipeToClose(_:)))
        swipeGesture.direction = .right
        swipeGesture.delegate = self
        // if you add slide gesture to main view, it conflicts pageviewcontroller scroll functions
        //self.view.addGestureRecognizer(swipeGesture)
        self.userProfileTopView?.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeToClose(_ sender : UISwipeGestureRecognizer) {
        
        print("swipeToClose starts")
        
        switch sender.direction {
        case .right:
            SlideMenuLoader.shared.animateSlideMenu(active: true)
            return
        default:
            break
        }
        
    }
    
    func gotoContactViewController() {
        
        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ContactViewController) as? ContactViewController {
            
            self.navigationController?.pushViewController(destination, animated: true)
            
        }
        
    }
    
    func gotoExplorePeopleViewController() {
        
        print("gotoExplorePeopleViewController starts")
        
        if let destination = UIStoryboard(name: Constants.Storyboard.Name.Profile, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ExplorePeopleViewController) as? ExplorePeopleViewController {
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
    }
    
    // to make multi gesture recognizer runs at the same time
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /* TopView pull to refresh */
    // to pull down topView
    func addPanGestureToTopView() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pullToDown(_:)))
        panGesture.delegate = self
        userProfileTopView!.addGestureRecognizer(panGesture)
        
    }
    
    @objc func pullToDown(_ sender : UIPanGestureRecognizer) {
        
        let velocity = sender.velocity(in: userProfileTopView)
        
        switch returnVerticalDirection(velocity: velocity) {
        case .down:
            
            let yCoordinateTranslation = sender.translation(in: userProfileTopView).y
            
            if (heightConstraintsOfUserProfileTopView.hasExceeded(verticalLimit: verticalLimit)){
                totalTranslation += yCoordinateTranslation
                heightConstraintsOfUserProfileTopView.constant = logConstraintValueForYPosition(yPosition: totalTranslation)
                
                if sender.state == .began || sender.state == .changed {
                    activityIndicatorManager(active: true)
                } else if sender.state == .ended {
//                    animateViewBackToLimit2()
                    animateViewBackToLimit()
                }
                
            } else {
                heightConstraintsOfUserProfileTopView.constant += yCoordinateTranslation
            }
            
            sender.setTranslation(.zero, in: view)
            
        default:
            break
        }
        
    }
    
    func logConstraintValueForYPosition(yPosition : CGFloat) -> CGFloat {
        return verticalLimit * (1 + log10(yPosition/verticalLimit))
    }
    
    func animateViewBackToLimit() {
       
        print("animateViewBackToLimit starts")
        
        activityIndicatorManager(active: false)
        self.heightConstraintsOfUserProfileTopView.constant = self.verticalLimit
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = Constants.StaticViewSize.ViewSize.Height.height_180

        }, completion: { (finish) in
            
            self.refreshUserProfileInformation()
            
        })
        
    }
    
    func animateViewBackToLimit2() {
        
        print("animateViewBackToLimit starts")
        
        activityIndicatorManager(active: false)
        /*
        self.heightConstraintsOfUserProfileTopView.constant = self.verticalLimit
        */
        self.refreshUserProfileInformation { (finish) in
            if finish {
                
                self.heightConstraintsOfUserProfileTopView.constant = self.verticalLimit
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                        self.totalTranslation = Constants.StaticViewSize.ViewSize.Height.height_180
                        
                    }, completion: { (finish) in
                        
                        self.userProfileTopView?.checkFollower_Following_Counts()
                        
                    })
                }
                
            }
        }
        
        
        
        
    }
    
    func returnVerticalDirection(velocity : CGPoint) -> PanDirections {
        
        if velocity.y > 0 {
            print("down")
            return .down
        } else {
            print("up")
            return .up
        }
        
    }
    /* TopView pull to refresh */
    
    /* View pan up and down animations */
    func addMainPanGesture(inputView : UIView) {
        
        let mainPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.mainPanOperationsManagement(_:)))
        mainPanGesture.delegate = self
        inputView.addGestureRecognizer(mainPanGesture)

    }
    
    @objc func mainPanOperationsManagement(_ sender : UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            panBeganProcess(sender)
            break
            
        case .changed:
            panChangedProcess(sender)
            break
            
        default:
            otherPanProcess(sender)
        }
        
        findSelectedPageView()
        
    }
    
    func panBeganProcess(_ sender : UIPanGestureRecognizer) {
        
        print("panBeganProcess starts")
        
        guard let view = sender.view else { return }
        
        let location = sender.location(in: view)
        let subview = view.hitTest(location, with: nil)
        
        if subview == userProfileTopView && userProfileTopViewTopConstraint.constant == userProfileTopViewOriginalTopConstraint {
            
            return
        }
        
        dragStartPos = sender.location(in: self.view)
        
        print("self.userProfileTopView!.frame.origin.y : \(self.userProfileTopView!.frame.origin.y)")
        print("self.userProfileTopView!.frame.height : \(self.userProfileTopView!.frame.height)")
//        userProfileTopViewBottomY = self.userProfileTopView!.frame.origin.y + self.userProfileTopView!.frame.height
        userProfileTopViewBottomY = self.userProfileTopView!.frame.height + 50
        
        // Move
        if dragDirection == Direction.STOP {
            
            dragDirection = (userProfileTopViewTopConstraint.constant == userProfileTopViewOriginalTopConstraint) ? Direction.UP : Direction.DOWN
        }
        
        // Scroll event of CollectionView is preferred.
        if (dragDirection == Direction.UP   && dragStartPos.y < userProfileTopViewBottomY + dragDifference) ||
            (dragDirection == Direction.DOWN && dragStartPos.y > userProfileTopViewBottomY) {
            
            dragDirection = Direction.STOP
            
        }
        
    }
    
    func panChangedProcess(_ sender : UIPanGestureRecognizer) {
        
        print("panChangedProcess starts")
        print("dragDirection : \(dragDirection)")
        print("contentOffset : \(contentOffset)")
        
        let currentPosition = sender.location(in: self.view)
        print("currentPosition.y : \(currentPosition.y)")
        print("userProfileTopViewBottomY : \(userProfileTopViewBottomY)")
        print("self.userProfileTopView!.frame.height : \(self.userProfileTopView!.frame.height)")
        
        if dragDirection == Direction.UP && currentPosition.y < userProfileTopViewBottomY - dragDifference {
            
            userProfileTopViewTopConstraint.constant = max(userProfileTopViewMinimalVisibleHeight - self.userProfileTopView!.frame.height, currentPosition.y + dragDifference - (userProfileTopView!.frame.height + 50))
            
            containerViewHeightConstraint.constant = min(self.view.frame.height - userProfileTopViewMinimalVisibleHeight, self.view.frame.height - userProfileTopViewTopConstraint.constant - userProfileTopView!.frame.height)
            
            print("1 userProfileTopViewTopConstraint.constant : \(userProfileTopViewTopConstraint.constant)")
            print("userProfileTopViewMinimalVisibleHeight - self.userProfileTopView!.frame.height : \(userProfileTopViewMinimalVisibleHeight - self.userProfileTopView!.frame.height)")
            print("currentPosition.y + dragDifference - userProfileTopView!.frame.height : \(currentPosition.y + dragDifference - userProfileTopView!.frame.height)")
            
            
        } else if dragDirection == Direction.DOWN && currentPosition.y > userProfileTopViewBottomY {
            userProfileTopViewTopConstraint.constant = min(userProfileTopViewOriginalTopConstraint, currentPosition.y - userProfileTopView!.frame.height)
            
            containerViewHeightConstraint.constant = max(self.view.frame.height - userProfileTopViewOriginalTopConstraint - userProfileTopView!.frame.height, self.view.frame.height - userProfileTopViewTopConstraint.constant - userProfileTopView!.frame.height)
            
            print("2 userProfileTopViewTopConstraint.constant : \(userProfileTopViewTopConstraint.constant)")
            
        } else if dragDirection == Direction.STOP && contentOffset < 0{
            dragDirection = Direction.SCROLL
            imaginaryContainerViewOffsetStartPositionY = currentPosition.y
            
        } else if dragDirection == Direction.SCROLL {
            
            if userProfileTopViewTopConstraint.constant < 0 {
                
                userProfileTopViewTopConstraint.constant = userProfileTopViewMinimalVisibleHeight - self.userProfileTopView!.frame.height + currentPosition.y - imaginaryContainerViewOffsetStartPositionY
                
                print("3 userProfileTopViewTopConstraint.constant : \(userProfileTopViewTopConstraint.constant)")
                
            }
            
            if containerViewHeightConstraint.constant < self.view.frame.height {
                
                containerViewHeightConstraint.constant = max(self.view.frame.height - userProfileTopViewOriginalTopConstraint - userProfileTopView!.frame.height, self.view.frame.height - userProfileTopViewTopConstraint.constant - userProfileTopView!.frame.height)
                
            }
            
        }
        print("panChangedProcess ends")
        
        findSelectedPageView()

    }
    
    func otherPanProcess(_ sender : UIPanGestureRecognizer) {
        
        imaginaryContainerViewOffsetStartPositionY = 0.0
        
        if sender.state == UIGestureRecognizerState.ended &&
            dragDirection == Direction.STOP {
            
            return
        }
        
        let currentPosition = sender.location(in: self.view)
        
        if currentPosition.y < userProfileTopViewBottomY - dragDifference &&
            userProfileTopViewTopConstraint.constant != userProfileTopViewOriginalTopConstraint {
            
            userProfileTopViewTopConstraint.constant = userProfileTopViewMinimalVisibleHeight - self.userProfileTopView!.frame.height
            
            print("4 userProfileTopViewTopConstraint.constant : \(userProfileTopViewTopConstraint.constant)")
            
            containerViewHeightConstraint.constant = self.view.frame.height - userProfileTopViewMinimalVisibleHeight
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            
                            self.view.layoutIfNeeded()
                            
            }, completion: nil)
            
            dragDirection = Direction.DOWN
            
            //arrangeViewControllerTitle(inputDirection: .UP)
            
        } else {
            
            userProfileTopViewTopConstraint.constant = userProfileTopViewOriginalTopConstraint
            containerViewHeightConstraint.constant = self.view.frame.height - userProfileTopViewOriginalTopConstraint - userProfileTopView!.frame.height
            
            print("5 userProfileTopViewTopConstraint.constant : \(userProfileTopViewTopConstraint.constant)")
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            
                            self.view.layoutIfNeeded()
                            
            }, completion: nil)
            
            dragDirection = Direction.UP
            
            //arrangeViewControllerTitle(inputDirection: .DOWN)
            
        }
        
        findSelectedPageView()
        
    }
    
    func arrangeViewControllerTitle(inputDirection : Direction) {
        
        switch inputDirection {
        case .UP:
            print("up")
            if let name = User.shared.username {
                setTitle(inputTitle: name)
            }
        case .DOWN:
            print("down")
            setTitle(inputTitle: Constants.CharacterConstants.SPACE)
            
        default:
            return
        }
        
        
    }
    
    func setTitle(inputTitle : String) {
        
        UIView.animate(withDuration: 0.5) {
//            self.title = inputTitle
            self.navigationItem.title = inputTitle
        }
        
    }
    /* View pan up and down animations */
}

// MARK: - NavigationControllerProtocols
extension UserProfileViewController : NavigationControllerProtocols {
    
    func setNavigationTitle(input: String) {
        self.title = input
    }
    
}

// MARK: - ViewPresentationProtocols
extension UserProfileViewController : ViewPresentationProtocols {
    
    func directFromSlideMenu(inputSlideMenuType: SlideMenuViewTags) {
        
        SlideMenuLoader.shared.animateSlideMenu(active: false)
        
        switch inputSlideMenuType {
        case .manageGroupOperations:
            gotoContactViewController()
        case .explore:
            gotoExplorePeopleViewController()
            return
        case .settings:
            return
        case .viewPendingFriendRequests:
            return
        }
        
    }
    
}

// MARK: - UserProfileViewProtocols
extension UserProfileViewController : UserProfileViewProtocols {
    
    func pullToViewDown() {
        
    }
    
}

// MARK: - layoutConstraint extension specific to this class
private extension NSLayoutConstraint {
    func hasExceeded(verticalLimit: CGFloat) -> Bool {
        return self.constant > verticalLimit
    }
}


