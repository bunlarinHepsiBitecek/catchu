//
//  UserProfileMainView.swift
//  catchu
//
//  Created by Erkut Baş on 11/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UserProfileMainView: UIView {

    private var activityIndicator : UIActivityIndicatorView?
    private var activityIndicatorAdded : Bool = false
    
    weak var delegateNavigation : NavigationControllerProtocols!
    
    lazy var mainView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return temp
        
    }()
    
    lazy var shadowView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor(white: 0, alpha: 0.5)
        temp.alpha = 0
        
        return temp
        
    }()
    
    lazy var topView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        temp.layer.cornerRadius = 100
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
        
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        temp.textAlignment = .center
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
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.followers
        
        return temp
        
    }()
    
    var followingLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.following
        
        return temp
        
    }()
    
    var followerCount: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "\(Constants.NumericConstants.INTEGER_ZERO)"
        
        return temp
        
    }()
    
    var followingCount: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "\(Constants.NumericConstants.INTEGER_ZERO)"
        
        return temp
        
    }()
    
    
    init(frame: CGRect, delegate : NavigationControllerProtocols) {
        super.init(frame: frame)
        
        self.delegateNavigation = delegate
        
        initializeViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        addSpinner()
//
//    }
}

// MARK: - major functions
extension UserProfileMainView {
    
    func initializeViews() {
        
        addViews()
        getUserProfileInformation()
        
    }
    
    func addViews() {
        
        addSpinner()
        
        self.addSubview(mainView)
        self.addSubview(shadowView)
        self.shadowView.addSubview(activityIndicator!)
        self.mainView.addSubview(topView)
        self.topView.addSubview(profileImageContainer)
        self.profileImageContainer.addSubview(profileImageView)
        self.topView.addSubview(userNameLabel)
        self.topView.addSubview(stackView)
        self.topView.addSubview(changeIconContainer)
        self.changeIconContainer.addSubview(changeIconImageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeMainView = self.mainView.safeAreaLayoutGuide
        let safeTopView = self.topView.safeAreaLayoutGuide
        let safeProfileImageContainer = self.profileImageContainer.safeAreaLayoutGuide
        let safeShadowView = self.shadowView.safeAreaLayoutGuide
        let safeChangeIconContainer = self.changeIconContainer.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            shadowView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: safe.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            activityIndicator!.centerXAnchor.constraint(equalTo: safeShadowView.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: safeShadowView.centerYAnchor),
            
            topView.leadingAnchor.constraint(equalTo: safeMainView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeMainView.trailingAnchor),
            topView.topAnchor.constraint(equalTo: safeMainView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_180),
            
            profileImageContainer.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            profileImageContainer.topAnchor.constraint(equalTo: safeTopView.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
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
            
            userNameLabel.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            userNameLabel.topAnchor.constraint(equalTo: safeProfileImageContainer.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            userNameLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            userNameLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            stackView.topAnchor.constraint(equalTo: safeTopView.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_50),
            stackView.trailingAnchor.constraint(equalTo: safeTopView.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            stackView.leadingAnchor.constraint(equalTo: safeProfileImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            
            changeIconImageView.centerXAnchor.constraint(equalTo: safeChangeIconContainer.centerXAnchor),
            changeIconImageView.centerYAnchor.constraint(equalTo: safeChangeIconContainer.centerYAnchor),
            changeIconImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            changeIconImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            ])
        
        
        
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
    
    func getUserProfileInformation() {
        
        activateShadowView(active: true)
        
        if let userid = User.shared.userid {
            APIGatewayManager.shared.getUserProfileInfo(userid: userid, requestedUserid: userid) { (reUserProfileResult, finish) in
                if finish {
                    User.shared.convertReUserDataToUserObject(httpRequest: reUserProfileResult)
                    self.setUserDataToViews()
                    self.activateShadowView(active: false)
                }
            }
        }
        
    }
    
    func addSpinner() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.style = .whiteLarge
        
        activityIndicator!.startAnimating()
        
    }
    
    func activityAnimationManager(active : Bool) {
        
        if activityIndicator != nil {
            
            DispatchQueue.main.async {
                if active {
                    self.activityIndicator!.startAnimating()
                } else {
                    self.activityIndicator!.stopAnimating()
                }
            }
            
        }
        
    }
    
    func activateShadowView(active : Bool) {
        
        activityAnimationManager(active: active)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            
            DispatchQueue.main.async {
                if active {
                    self.shadowView.alpha = 1
                } else {
                    self.shadowView.alpha = 0
                }
            }
            
        }
        
    }
    
}
