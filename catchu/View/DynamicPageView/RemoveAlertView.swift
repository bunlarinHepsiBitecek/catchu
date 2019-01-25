//
//  RemoveAlertView.swift
//  catchu
//
//  Created by Erkut Baş on 1/19/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class RemoveAlertView: UIView {

    lazy var profilePictureContainerView: UIView = {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_46, height: Constants.StaticViewSize.ViewSize.Height.height_46))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_23
        
        temp.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.shadowOffset = .zero
        temp.layer.shadowOpacity = 2;
        temp.layer.shadowRadius = 5;
        temp.layer.shadowPath = UIBezierPath(roundedRect: temp.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_22).cgPath
        
        return temp
    }()
    
    lazy var profilePictureView: UIImageView = {
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_44, height: Constants.StaticViewSize.ViewSize.Height.height_44))
        temp.image = UIImage(named: "8771.jpg")
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_22
        temp.clipsToBounds = true
        
        return temp
    }()
    
    lazy var subjectStackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [subjectTitle, subjectSubTitle])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.spacing = 5
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        return temp
    }()
    
    let subjectTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = LocalizedConstants.ActionSheetTitles.removeFollower
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.text = LocalizedConstants.ActionSheetTitles.removeFollowerInfo
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, user: User) {
        super.init(frame: frame)
        initializeView()
        setTitleValues(user: user)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension RemoveAlertView {
    
    private func initializeView() {
        addViews()
    }
    
    private func addViews() {
        
        self.addSubview(profilePictureContainerView)
        self.profilePictureContainerView.addSubview(profilePictureView)
        self.addSubview(subjectStackView)
        
        let safe = self.safeAreaLayoutGuide
        let safeProfilePictureContainerView = self.profilePictureContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            profilePictureContainerView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            profilePictureContainerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            profilePictureContainerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_46),
            profilePictureContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_46),
            
            profilePictureView.centerXAnchor.constraint(equalTo: safeProfilePictureContainerView.centerXAnchor),
            profilePictureView.centerYAnchor.constraint(equalTo: safeProfilePictureContainerView.centerYAnchor),
            profilePictureView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_44),
            profilePictureView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_44),
            
            subjectStackView.topAnchor.constraint(equalTo: safeProfilePictureContainerView.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
//            subjectStackView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            subjectStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            subjectStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_30),
            
            ])
    }
    
    private func setTitleValues(user: User) {
        if let name = user.name {
            profilePictureView.setImageInitialPlaceholder(name, circular: true)
        }
        
        if let urlString = user.profilePictureUrl {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    profilePictureView.setImagesFromCacheOrDownloadWithTypes(urlString, type: .thumbnails)
                }
            }
        }
    }
}
