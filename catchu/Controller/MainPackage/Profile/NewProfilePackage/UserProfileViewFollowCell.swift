//
//  UserProfileViewFollowCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

fileprivate extension Selector {
    static let followersAction = #selector(UserProfileViewFollowCell.followersList)
    static let followingAction = #selector(UserProfileViewFollowCell.followingList)
}

class UserProfileViewFollowCell: BaseTableCell, ConfigurableCell {
    
    var viewModelItem: UserProfileViewModelItemFollow!
    
    private let padding = Constants.Profile.Padding
    
    lazy var followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: .followersAction, for: .touchUpInside)
        return button
    }()
    
    lazy var followingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: .followingAction, for: .touchUpInside)
        return button
    }()
    
    lazy var followInfoStackView: UIStackView = {
        
        let layoutMargin = UIEdgeInsets(top: padding/2, left: padding, bottom: padding/2, right: padding)
        let separatorView = self.createSeparatorView(color: .black)
        
        let stackView = UIStackView(arrangedSubviews: [followersButton, separatorView, followingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = padding
        stackView.layoutMargins = layoutMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        
        separatorView.heightAnchor.constraint(equalTo: followersButton.heightAnchor, multiplier: 1).isActive = true
        
        return stackView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(followInfoStackView)
        NSLayoutConstraint.activate([
            followInfoStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            followInfoStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            followInfoStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            followInfoStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor)
            ])
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemFollow else { return }
        self.viewModelItem = viewModelItem
        
        let formattedFollowerCount = Formatter.roundedWithAbbreviations(viewModelItem.followerCount)
        let formattedFollowingCount = Formatter.roundedWithAbbreviations(viewModelItem.followingCount)
        fillFollowerFollowingButtons(followerCount: formattedFollowerCount, followingCount: formattedFollowingCount)
    }
    
    private func fillFollowerFollowingButtons(followerCount: String, followingCount: String) {
        let followersString = Formatter.followAttributeString(title: followerCount, subtitle: LocalizedConstants.Profile.Followers)
        let followingString = Formatter.followAttributeString(title: followingCount, subtitle: LocalizedConstants.Profile.Following)
        
        DispatchQueue.main.async {
            self.followersButton.setAttributedTitle(followersString, for: .normal)
            self.followingButton.setAttributedTitle(followingString, for: .normal)
        }
    }
    
    func fillFollowerButtons(followerCount: Int) {
        let formattedFollowerCount = Formatter.roundedWithAbbreviations(followerCount)
        let followersString = Formatter.followAttributeString(title: formattedFollowerCount, subtitle: LocalizedConstants.Profile.Followers)
        
        DispatchQueue.main.async {
            self.followersButton.setAttributedTitle(followersString, for: .normal)
        }
    }
    
    private func createSeparatorView(color : UIColor) -> UIView {
        let separator = UIView()
        let widthConstraint = separator.widthAnchor.constraint(equalToConstant: 1)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        separator.backgroundColor = color
        return separator
    }
    
    @objc func followersList() {
        print("\(#function) run")
        self.triggerMutualFollowViewController(pageType: .followers)
    }
    
    @objc func followingList() {
        print("\(#function) run")
        self.triggerMutualFollowViewController(pageType: .followings)
    }
    
}

// MARK: - followers, following list flow
extension UserProfileViewFollowCell {
    
    private func triggerMutualFollowViewController(pageType: FollowPageIndex) {
        let mutualFollowViewController = MutualFollowViewController()
        mutualFollowViewController.user = self.viewModelItem.user
        mutualFollowViewController.activePageType = pageType
        
        if let currentViewController = LoaderController.currentViewController() {
            if let navigationController = currentViewController.navigationController {
                navigationController.pushViewController(mutualFollowViewController, animated: true)
            } else {
                currentViewController.present(mutualFollowViewController, animated: true, completion: nil)
            }
        }
        
        mutualFollowViewController.listenUpdatedFollowersCount { (count) in
            self.fillFollowerButtons(followerCount: count)
        }
    }
}
