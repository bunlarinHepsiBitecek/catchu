//
//  UserProfileHeaderView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileHeaderView: BaseView {
    
    // MARK: - Variables
    private let padding = Constants.Profile.Padding
    private let dimension: CGFloat = 80
    private let textTintColor = UIColor.white
    
    // MARK: - View
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        // MARK: When use with satackview
        let imageHeightConstraint = imageView.safeHeightAnchor.constraint(equalToConstant: dimension)
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        imageHeightConstraint.isActive = true
        
        let imageWidthConstraint = imageView.safeWidthAnchor.constraint(equalToConstant: dimension)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        imageWidthConstraint.isActive = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.black
        label.text = "catchuname"
        label.numberOfLines = 1
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black
        label.text = "Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio Özloş bio"
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1).cgColor]
        gradient.frame = self.bounds
        return gradient
    }()
    
    // MARK: - Funtions
    override func setupView() {
        super.setupView()
        setup()
    }
    
    func setup() {
        let layoutMargin = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let nameBioStackView = UIStackView(arrangedSubviews: [nameLabel, bioLabel])
        nameBioStackView.axis = .vertical
        nameBioStackView.alignment = .fill
        nameBioStackView.distribution = .fill
        nameBioStackView.spacing = padding / 2
        
        let profileStackView = UIStackView(arrangedSubviews: [profileImageView, nameBioStackView])
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.alignment = .top
        profileStackView.distribution = .fillProportionally
        profileStackView.spacing = padding
        profileStackView.layoutMargins = layoutMargin
        profileStackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(profileStackView)
        NSLayoutConstraint.activate([
            profileStackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            profileStackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            profileStackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            profileStackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
    }
    
    func configure() {
        
    }
    
    @objc func followProcess(_ sender: UIButton) {
        
    }
}


fileprivate extension Selector {
    static let followProcess = #selector(UserProfileHeaderView.followProcess(_:))
}

