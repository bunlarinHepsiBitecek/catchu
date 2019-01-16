//
//  SlideMenu.swift
//  catchu
//
//  Created by Erkut Baş on 11/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SlideMenu: UIView {
    
    var slideMenuViewModel = SlideMenuViewModel()
    
    private var slideMenuTableView: SlideMenuTableView!

    private var userName : UILabel!
    private var userNameSurname : UILabel!
    private var profileViewLoaded : Bool = false
    private var topViewGradientColorAdded : Bool = false
    
    private var slideMenuViewTypeArray : [SlideMenuViewTags] = [.explore, .viewPendingFriendRequests, .manageGroupOperations, .settings]
    private var sliderMenuViewIcon : [UIImage] = [UIImage(named: "search")!, UIImage(named: "eye")!, UIImage(named: "group")!, UIImage(named: "settings")!]
    private  var sliderMenuViewLabel : [String] = ["Explore People", "View Pending Request", "Manage Groups", "Settings"]
    
    weak var delegate : ViewPresentationProtocols!
    
    lazy var mainView: UIView = {
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        return temp
    }()

    lazy var topView: UIView = {
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.layer.shadowOffset = CGSize(width: -3, height: 3)
        temp.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.shadowOpacity = 0.6
        temp.layer.shadowRadius = 4
        temp.layer.masksToBounds = false
        return temp
    }()
    
    lazy var profilePictureContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        return temp
    }()
    
    lazy var profilePictureView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
        temp.layer.borderWidth = 1
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        temp.clipsToBounds = true
        return temp
    }()
    
    lazy var stackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: returnUserInformationViews())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        return temp
    }()
    
    lazy var bodyView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initiateView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addShadowToProfileContainerView()
        addGradientColorToTopView()
    }
    
}

// MARK: - major functions
extension SlideMenu {
    
    private func initiateView() {
        
        addViews()
        addSlideMenuTableView()
        addSwipeGestureRecognizer()
        askingForFollowerRequest()
        addPendingRequestListeners()
        addRefreshRequestListener()
        
    }
    
    private func addViews() {
        
        print("self.frame : \(self.frame)")
        
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        topView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: Constants.StaticViewSize.ViewSize.Height.height_220)
        
        self.addSubview(mainView)
        self.mainView.addSubview(topView)
        
        self.mainView.addSubview(bodyView)
        
        self.topView.addSubview(profilePictureContainerView)
        self.profilePictureContainerView.addSubview(profilePictureView)
        self.topView.addSubview(stackView)
        
        self.mainView.bringSubview(toFront: topView)
        
        //self.bodyView.addSubview(menuTableView)
        
        let safe = self.safeAreaLayoutGuide
        let safeMain = self.mainView.safeAreaLayoutGuide
        let safeTopMain = self.topView.safeAreaLayoutGuide
        let safeBodyView = self.bodyView.safeAreaLayoutGuide
        let safeProfilePictureContainerView = self.profilePictureContainerView.safeAreaLayoutGuide
        
        print("superview : \(self.superview)")
        print("superview : \(self.superview)")
        
        NSLayoutConstraint.activate([
            
            profilePictureContainerView.bottomAnchor.constraint(equalTo: safeTopMain.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_50),
            profilePictureContainerView.centerXAnchor.constraint(equalTo: safeTopMain.centerXAnchor),
            profilePictureContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            profilePictureContainerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            
            profilePictureView.centerXAnchor.constraint(equalTo: safeProfilePictureContainerView.centerXAnchor),
            profilePictureView.centerYAnchor.constraint(equalTo: safeProfilePictureContainerView.centerYAnchor),
            profilePictureView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            profilePictureView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            
            stackView.leadingAnchor.constraint(equalTo: safeTopMain.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            stackView.bottomAnchor.constraint(equalTo: safeTopMain.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            bodyView.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: safeTopMain.bottomAnchor),
            //bodyView.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor),
            bodyView.heightAnchor.constraint(equalToConstant: self.frame.height - topView.frame.height),
            
            /*
            menuTableView.leadingAnchor.constraint(equalTo: safeBodyView.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: safeBodyView.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: safeBodyView.topAnchor),
            //menuTableView.bottomAnchor.constraint(equalTo: safeBodyView.bottomAnchor),
            menuTableView.heightAnchor.constraint(equalToConstant: self.frame.height - topView.frame.height)*/
            
            ])
        
    }
    
    private func addSlideMenuTableView() {
        
        let slideMenuHeight = self.frame.height - topView.frame.height
        
        slideMenuTableView = SlideMenuTableView(frame: CGRect(x: 0, y: 0, width: 0, height: slideMenuHeight))
        slideMenuTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bodyView.addSubview(slideMenuTableView)
        
        let safeBodyView = self.bodyView.safeAreaLayoutGuide
        
        print("self.frame.height : \(self.frame.height)")
        print("topView.frame.height : \(topView.frame.height)")
        
        NSLayoutConstraint.activate([
            
            slideMenuTableView.leadingAnchor.constraint(equalTo: safeBodyView.leadingAnchor),
            slideMenuTableView.trailingAnchor.constraint(equalTo: safeBodyView.trailingAnchor),
            slideMenuTableView.topAnchor.constraint(equalTo: safeBodyView.topAnchor),
            slideMenuTableView.heightAnchor.constraint(equalToConstant: self.frame.height - topView.frame.height)
            
            ])
    }
    
    private func returnUserInformationViews() -> [UIView] {
        
        var viewArray = [UIView]()
        
        userName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        userName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        userName.textAlignment = .left
        userName.contentMode = .center
        userName.text = "UserName"
        
        viewArray.append(userName)
        
        userNameSurname = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        userNameSurname.font = UIFont.systemFont(ofSize: 13, weight: .light)
        userNameSurname.textAlignment = .left
        userNameSurname.contentMode = .center
        userNameSurname.text = "Name_Surname"
        
        viewArray.append(userNameSurname)
        
        return viewArray
        
    }
    
    private func addShadowToProfileContainerView() {
        
        print("addShadowToProfileContainerView starts")
        print("profilePictureView.bounds : \(profilePictureView.bounds)")
        
        if profilePictureContainerView.bounds.height > 0 {
            
            if !profileViewLoaded {
                
                self.profilePictureContainerView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.profilePictureContainerView.layer.shadowOffset = .zero
                self.profilePictureContainerView.layer.shadowOpacity = 2;
                self.profilePictureContainerView.layer.shadowRadius = 5;
                self.profilePictureContainerView.layer.shadowPath = UIBezierPath(roundedRect: profilePictureContainerView.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_50).cgPath
                
                profileViewLoaded = true
                
            }
            
        }
    
    }
    
    private func addGradientColorToTopView() {
        
        if topView.bounds.height > 0 {
            if !topViewGradientColorAdded {
                
                let gradient = CAGradientLayer()
                gradient.frame = topView.bounds
                //gradient.colors = [#colorLiteral(red: 0.137254902, green: 0.02745098039, blue: 0.3019607843, alpha: 1).cgColor, #colorLiteral(red: 0.8, green: 0.3254901961, blue: 0.2, alpha: 1).cgColor]
                gradient.colors = [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1).cgColor]
                topView.layer.insertSublayer(gradient, at: 0)
                
                topViewGradientColorAdded = true
            }
        }
        
    }
    
    private func askingForFollowerRequest() {
        do {
            try slideMenuViewModel.getUserFollowerRequestList()
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(Constants.ALERT) userid is required.")
            }
        } catch {
            print("\(Constants.CRASH_WARNING)")
        }
    }
    
    private func addPendingRequestListeners() {
        slideMenuViewModel.state.bind { (fetchState) in
            self.pendingRequestStateHandler(fetchState: fetchState)
        }
    }
    
    private func pendingRequestStateHandler(fetchState: DataFetchingState) {
        switch fetchState {
        case .none:
            return
        case .fetching:
            return
        case .fetched:
            self.activatePendingRequestBadgeData()
            return
        }
    }
    
    private func activatePendingRequestBadgeData() {
        // this means followRequestArray has data now
        slideMenuTableView.activatePendingRequestBadgeData(value: "\(slideMenuViewModel.returnTotalRequestCount())")
        slideMenuTableView.setFollowerRequestArray(followRequesterArray: slideMenuViewModel.followRequesterArray)
    }
    
    private func addRefreshRequestListener() {
        slideMenuTableView.refreshControlListener { (operationState) in
            self.refreshProcessManagement(operationState: operationState)
        }
    }
    
    private func refreshProcessManagement(operationState: CRUD_OperationStates) {
        switch operationState {
        case .processing:
            self.askingForFollowerRequest()
        case .done:
            return
        }
    }
    
}

// MARK: - outside functions
extension SlideMenu {
    func setDelegate(delegate :ViewPresentationProtocols) {
        self.delegate = delegate
    }
    
    func setUserInformationToViews() {
        print("setUserInformationToViews starts")
        print("User.shared.name : \(User.shared.name)")
        
        if let name = User.shared.name {
            self.userNameSurname.text = name
        }
        
        if let userName = User.shared.username {
            self.userName.text = userName
        }
        
        if let profilePictureURL = User.shared.profilePictureUrl {
            self.profilePictureView.setImagesFromCacheOrFirebaseForFriend(profilePictureURL)
        }
    }
    
    private func presentViewControllers(inputSlideMenuType: SlideMenuViewTags) {
        
        SlideMenuLoader.shared.animateSlideMenu(active: false)
        
        switch inputSlideMenuType {
        case .manageGroupOperations:
            return
        case .explore:
            return
        case .settings:
            return
        case .viewPendingFriendRequests:
            self.presentFollowRequestTableViewControllers()
            return
        }
        
    }
    
    private func presentFollowRequestTableViewControllers() {
        let pendingRequestController = PendingRequestTableViewController()
        let navigationController = UINavigationController(rootViewController: pendingRequestController)
        
        if let currentViewController = LoaderController.currentViewController() {
            currentViewController.present(navigationController, animated: true, completion: nil)
        }
        
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SlideMenu : UIGestureRecognizerDelegate {
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SlideMenu.swipeToClose(_:)))
        swipeGesture.direction = .left
        swipeGesture.delegate = self
        mainView.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeToClose(_ sender : UISwipeGestureRecognizer) {
        
        print("swipeToClose starts")
        
        switch sender.direction {
        case .left:
            SlideMenuLoader.shared.animateSlideMenu(active: false)
            return
        default:
            break
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

