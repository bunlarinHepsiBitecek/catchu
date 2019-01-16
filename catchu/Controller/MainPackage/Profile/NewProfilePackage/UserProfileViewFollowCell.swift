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
        
        let layoutMargin = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let separator = self.createSeparator(color: .black)
        
        let stackView = UIStackView(arrangedSubviews: [followersButton, separator, followingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.layoutMargins = layoutMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        
        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6).isActive = true
        
        return stackView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(followInfoStackView)
        NSLayoutConstraint.activate([
//            followInfoStackView.safeCenterXAnchor.constraint(equalTo: contentView.safeCenterXAnchor),
            followInfoStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            followInfoStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            followInfoStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            followInfoStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor)
            ])
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemFollow else { return }
        self.viewModelItem = viewModelItem
        setupViewModel()
    }
    

    func setupViewModel() {
        viewModelItem.followerCount.bindAndFire { [unowned self] (_) in
            let followersString = self.followAttributeString(title: self.viewModelItem.formattFollowersCount(), subtitle: LocalizedConstants.Profile.Followers)
            self.followersButton.setAttributedTitle(followersString, for: .normal)
        }
        
        viewModelItem.followingCount.bindAndFire { [unowned self] (_) in
            let followingString = self.followAttributeString(title: self.viewModelItem.formattFollowingCount(), subtitle: LocalizedConstants.Profile.Following)
            self.followingButton.setAttributedTitle(followingString, for: .normal)
        }
    }
    
    
    
    private func createSeparator(color : UIColor) -> UIView {
        let separator = UIView()
        let widthConstraint = separator.widthAnchor.constraint(equalToConstant: 1)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        separator.backgroundColor = color
        return separator
    }
    
    func followAttributeString(title: String, subtitle: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline),
            NSAttributedStringKey.paragraphStyle: style
        ]
        
        let subtitleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline),
            NSAttributedStringKey.paragraphStyle: style
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        
        return attributedString
    }
    
    
    @objc func followersList() {
        print("\(#function) run")
        
    }
    
    @objc func followingList() {
        print("\(#function) run")
        
    }
    
}
