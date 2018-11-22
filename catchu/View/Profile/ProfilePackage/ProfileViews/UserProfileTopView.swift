//
//  UserProfileTopView.swift
//  catchu
//
//  Created by Erkut Baş on 11/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfileTopView: UIView {
    
    weak var delegateNavigation : NavigationControllerProtocols!
    weak var delegateUserProfileOperations : UserProfileViewProtocols!
    
    private var activityIndicator : UIActivityIndicatorView?
    
    private var previousFollowerCount : String = "0"
    private var previousFollowingCount : String = "0"
    
    lazy var topView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
        
    }()
    
    lazy var profileImageContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_51
        return temp
        
    }()
    
    lazy var profileImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "user.png")
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        
        return temp
    }()
    
    lazy var changeIconContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
        
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "deneme"
        
        return temp
        
    }()
    
    lazy var changeIconImageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "plus")
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        
        return temp
    }()
    
    lazy var stackContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    lazy var stackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [stackViewFollowings, stackViewFollowers])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    lazy var stackViewFollowers: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [followerCount, followerLabel])
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    lazy var stackViewFollowings: UIStackView = {
        
        
        let temp = UIStackView(arrangedSubviews: [followingCount, followingLabel])
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    var followerLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.followers
        
        return temp
        
    }()
    
    var followingLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.following
        
        return temp
        
    }()
    
    var followerCount: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "\(Constants.NumericConstants.INTEGER_ZERO)"
        
        return temp
        
    }()
    
    var followingCount: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "\(Constants.NumericConstants.INTEGER_ZERO)"
        
        return temp
        
    }()
    
    lazy var followRequestButton: UIButton = {
        
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: #selector(self.followButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        temp.setTitle(LocalizedConstants.Like.Follow, for: UIControlState.normal)
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        temp.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        temp.layer.cornerRadius = 5
        
        return temp
        
    }()
    
    
    init(frame: CGRect, delegate : NavigationControllerProtocols, delegateOfUserProfile : UserProfileViewProtocols) {
        super.init(frame: frame)
        
        self.delegateNavigation = delegate
        self.delegateUserProfileOperations = delegateOfUserProfile
        
        initializeViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - major functions
extension UserProfileTopView {
    
    func initializeViews() {
        
        addViews()
        addActivityIndicator()
        getUserProfileInformation { (finish) in
            if finish {
                self.setPreviousValues()
            }
        }
        
    }
    
    func addViews() {
        
        self.addSubview(topView)
        self.topView.addSubview(profileImageContainer)
        self.profileImageContainer.addSubview(profileImageView)
        self.topView.addSubview(userNameLabel)
        self.topView.addSubview(changeIconContainer)
        self.changeIconContainer.addSubview(changeIconImageView)
        self.topView.addSubview(stackContainer)
        self.stackContainer.addSubview(stackView)
        self.stackContainer.addSubview(followRequestButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeTopView = self.topView.safeAreaLayoutGuide
        let safeProfileImageContainer = self.profileImageContainer.safeAreaLayoutGuide
        let safeChangeIconContainer = self.changeIconContainer.safeAreaLayoutGuide
        let safeUserNameLabel = self.userNameLabel.safeAreaLayoutGuide
        let safeStackView = self.stackView.safeAreaLayoutGuide
        let safeStackContainerView = self.stackContainer.safeAreaLayoutGuide
        let safeFollowRequestButton = self.followRequestButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            topView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            topView.topAnchor.constraint(equalTo: safe.topAnchor),
            topView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            //topView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_180),
            
            profileImageContainer.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            profileImageContainer.bottomAnchor.constraint(equalTo: safeUserNameLabel.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            profileImageContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_102),
            profileImageContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_102),
            
            profileImageView.centerXAnchor.constraint(equalTo: safeProfileImageContainer.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: safeProfileImageContainer.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100),
            profileImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            changeIconContainer.trailingAnchor.constraint(equalTo: safeProfileImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            changeIconContainer.bottomAnchor.constraint(equalTo: safeProfileImageContainer.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            changeIconContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24),
            changeIconContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_24),
            
            userNameLabel.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            userNameLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            userNameLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            userNameLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            changeIconImageView.centerXAnchor.constraint(equalTo: safeChangeIconContainer.centerXAnchor),
            changeIconImageView.centerYAnchor.constraint(equalTo: safeChangeIconContainer.centerYAnchor),
            changeIconImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            changeIconImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            stackContainer.bottomAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            stackContainer.topAnchor.constraint(equalTo: safeTopView.topAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: safeTopView.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackContainer.leadingAnchor.constraint(equalTo: safeProfileImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            
            stackView.bottomAnchor.constraint(equalTo: safeFollowRequestButton.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            stackView.trailingAnchor.constraint(equalTo: safeStackContainerView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeStackContainerView.leadingAnchor),

            followRequestButton.bottomAnchor.constraint(equalTo: safeStackContainerView.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_40),
            followRequestButton.centerXAnchor.constraint(equalTo: safeStackContainerView.centerXAnchor),
            followRequestButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            followRequestButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            
            ])
        
    }
    
    func addActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator!.hidesWhenStopped = true
        
        self.topView.addSubview(activityIndicator!)
        
        let safeTopView = self.topView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            activityIndicator!.centerXAnchor.constraint(equalTo: safeTopView.centerXAnchor),
            activityIndicator!.topAnchor.constraint(equalTo: safeTopView.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            
            ])
        
    }
    
    func activityManager(active : Bool) {
        
        guard activityIndicator != nil else {
            return
        }
        
        if active {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
        
    }
    
    func setUserDataToViews() {
        
        print("self.userNameLabel : \(self.userNameLabel)")
        
        DispatchQueue.main.async {
            
            if let name = User.shared.name {
                self.userNameLabel.text = name
            }
            if let profilePictureURL = User.shared.profilePictureUrl {
                self.profileImageView.setImagesFromCacheOrFirebaseForFriend(profilePictureURL)
            }
            if let followerCount = User.shared.userFollowerCount {
                self.followerCount.text = followerCount
            }
            if let followingCount = User.shared.userFollowingCount {
                self.followingCount.text = followingCount
            }
            
            /*
             UIView.transition(with: self.userNameLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
             if let name = User.shared.name {
             self.userNameLabel.text = name
             }
             })
             
             UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
             if let profilePictureURL = User.shared.profilePictureUrl {
             self.profileImageView.setImagesFromCacheOrFirebaseForFriend(profilePictureURL)
             }
             })
             
             UIView.transition(with: self.followerCount, duration: 0.5, options: .transitionCrossDissolve, animations: {
             if let followerCount = User.shared.userFollowerCount {
             self.followerCount.text = followerCount
             }
             })
             
             UIView.transition(with: self.followingCount, duration: 0.5, options: .transitionCrossDissolve, animations: {
             if let followingCount = User.shared.userFollowingCount {
             self.followingCount.text = followingCount
             }
             })*/
            
            if let userName = User.shared.username {
                self.delegateNavigation.setNavigationTitle(input: userName)
            }
            
        }
        
    }
    
    func getUserProfileInformation(completion : @escaping (_ finish : Bool) -> Void) {
        
        if let userid = User.shared.userid {
            APIGatewayManager.shared.getUserProfileInfo(userid: userid, requestedUserid: userid) { (reUserProfileResult, finish) in
                if finish {
                    User.shared.convertReUserDataToUserObject(httpRequest: reUserProfileResult)
                    self.setUserDataToViews()
                }
                
                completion(true)
            }
        }
        
    }
    
    func triggerAnimationForFollowersCount() {
        
        followerCount.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.followerCount.transform = CGAffineTransform.identity
                
                
        })
        self.followerCount.layoutIfNeeded()
        
    }
    
    func triggerAnimationForFollowingCount() {
        
        followingCount.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.followingCount.transform = CGAffineTransform.identity
                
                
        })
        self.followingCount.layoutIfNeeded()
        
    }
    
    func setPreviousValues() {
        print("setPreviousValues starts")

        if let followerCount = User.shared.userFollowerCount {
            self.previousFollowerCount = followerCount
        }
        
        if let followingCount = User.shared.userFollowingCount {
            self.previousFollowingCount = followingCount
        }
        
        print("previousFollowerCount : \(previousFollowerCount)")
        print("previousFollowingCount : \(previousFollowingCount)")
        
    }
    
    func checkFollower_Following_Counts() {
        print("checkFollower_Following_Counts starts")
        print("previousFollowerCount : \(previousFollowerCount)")
        print("previousFollowingCount : \(previousFollowingCount)")
        
        if let followerCount = User.shared.userFollowerCount {
            if followerCount != previousFollowerCount {
                DispatchQueue.main.async {
                    self.triggerAnimationForFollowersCount()
                }
                self.previousFollowerCount = followerCount
            }
        }
        
        if let followingCount = User.shared.userFollowingCount {
            if followingCount != previousFollowingCount {
                
                DispatchQueue.main.async {
                    self.triggerAnimationForFollowingCount()
                }
                
                self.previousFollowingCount = followingCount
            }
        }
    }
    
    @objc func followButtonTapped(_ sender : UIButton) {
        print("followButtonTapped start")
    }
    
}

