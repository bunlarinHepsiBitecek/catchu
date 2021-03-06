//
//  OtherUserProfileViewHeader.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class OtherUserProfileViewHeader: BaseCollectionReusableView {
    
    // MARK: - Variables
    var viewModelItem: OtherUserProfileViewModelItemHeader!
    
    private let padding = Constants.Profile.Padding
    private let dimension: CGFloat = 100
    private let textTintColor = UIColor.black
    
    // MARK: - Views
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        // MARK: When use with satackview
        let imageHeightConstraint = imageView.safeHeightAnchor.constraint(equalToConstant: dimension)
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        imageHeightConstraint.isActive = true
        
        let imageWidthConstraint = imageView.safeWidthAnchor.constraint(equalToConstant: imageView.frame.width)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        imageWidthConstraint.isActive = true
        
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.text = "catchuname"
        label.textColor = textTintColor
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = textTintColor
        label.preferredMaxLayoutWidth = self.frame.width
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedConstants.Profile.Loading, for: .normal)
        button.setTitleColor(textTintColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: .followAction, for: .touchUpInside)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedConstants.Profile.SendMessage, for: .normal)
        button.setTitleColor(textTintColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: .messageAction, for: .touchUpInside)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    lazy var followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(textTintColor, for: .normal)
        button.addTarget(self, action: .followersAction, for: .touchUpInside)
        return button
    }()
    
    lazy var followingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(textTintColor, for: .normal)
        button.addTarget(self, action: .followingAction, for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = padding / 2
        return stackView
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        let layoutMargin = UIEdgeInsets(top: padding, left: padding/2, bottom: padding, right: padding/2)
        
        let metadataStackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        metadataStackView.alignment = .center
        metadataStackView.distribution = .fill
        metadataStackView.spacing = padding
        
        let separator = createSeparator(color: textTintColor)
        let followStackView = UIStackView(arrangedSubviews: [followersButton, separator, followingButton])
        followStackView.alignment = .fill
        followStackView.distribution = .fillProportionally
        followStackView.spacing = padding / 2
        separator.heightAnchor.constraint(equalTo: followStackView.heightAnchor, multiplier: 1).isActive = true
        followersButton.backgroundColor = .red
        followingButton.backgroundColor = .red
        
        followersButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.textAlignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [metadataStackView, buttonsStackView, followStackView, bioLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = padding
        mainStackView.layoutMargins = layoutMargin
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(mainStackView)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            mainStackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            mainStackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            mainStackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            
            separatorView.safeHeightAnchor.constraint(equalToConstant: 0.5),
            separatorView.safeTopAnchor.constraint(equalTo: mainStackView.safeBottomAnchor),
            separatorView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            separatorView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            separatorView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
        
        fillFollowerFollowingButtons(followerCount: "", followingCount: "")
    }
    
    @objc func followProcess(_ sender: UIButton) {
        print("\(#function) run")
    }
    
    @objc func messageProcess(_ sender: UIButton) {
        print("\(#function) run")
    }
    
    @objc func followersList() {
        print("\(#function) run")
        
    }
    
    @objc func followingList() {
        print("\(#function) run")
        
    }
    
    private func createSeparator(color : UIColor) -> UIView {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = color
        return separator
    }
    
    private func followAttributeString(title: String, subtitle: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: textTintColor
        ]
        
        let subtitleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline),
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: textTintColor
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: Constants.CharacterConstants.NEWLINE))
        attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        
        return attributedString
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? OtherUserProfileViewModelItemHeader else { return }
        self.viewModelItem = viewModelItem
        updateUI(viewModelItem.user)
    }
    
    private func updateUI(_ user: User) {
        if let profileImageUrl = user.profilePictureUrl {
            profileImageView.loadAndCacheImage(url: profileImageUrl)
        }
        nameLabel.text = user.name
        bioLabel.text = user.bio
        
        if let userFollowerCount = user.userFollowerCount, let userFollowingCount = user.userFollowingCount {
            if let followerCount = Int(userFollowerCount), let followingCount = Int(userFollowingCount)  {
                
                let formattedFollowerCount = Formatter.roundedWithAbbreviations(followerCount)
                let formattedFollowingCount = Formatter.roundedWithAbbreviations(followingCount)
                
                fillFollowerFollowingButtons(followerCount: formattedFollowerCount, followingCount: formattedFollowingCount)
            }
        }
        
        if let followStatus = user.followStatus {
            Formatter.configure(followStatus, followButton)
        }
    }
    
    private func fillFollowerFollowingButtons(followerCount: String, followingCount: String) {
        let followersString = self.followAttributeString(title: followerCount, subtitle: LocalizedConstants.Profile.Followers)
        let followingString = self.followAttributeString(title: followingCount, subtitle: LocalizedConstants.Profile.Following)
        DispatchQueue.main.async {
            self.followersButton.setAttributedTitle(followersString, for: .normal)
            self.followingButton.setAttributedTitle(followingString, for: .normal)
        }
    }
    
    
}

fileprivate extension Selector {
    static let followAction = #selector(OtherUserProfileViewHeader.followProcess)
    static let messageAction = #selector(OtherUserProfileViewHeader.messageProcess)
    static let followersAction = #selector(UserProfileViewFollowCell.followersList)
    static let followingAction = #selector(UserProfileViewFollowCell.followingList)
}
