//
//  PostTopBarView.swift
//  catchu
//
//  Created by Erkut Baş on 11/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostTopBarView: UIView {

    private var isGradientAdded : Bool = false
    private var profileViewLoaded : Bool = false
    
    /*
    lazy var mainContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()*/
    
    lazy var profilePictureContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_35
        
        return temp
    }()
    
    lazy var profileImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "8771.jpg")
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_35
        temp.clipsToBounds = true
        return temp
    }()
    
    lazy var stackViewFollowers: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [userNameLabel, informationLabel])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    lazy var informationLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        temp.text = "information information information"
        temp.numberOfLines = 0
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        temp.text = "erkutbas"
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds.height > 0 {
            if !isGradientAdded {
                addGradientColor()
                isGradientAdded = true
            }
        }
        
        print("profilePictureContainerView.bound.height : \(profilePictureContainerView.bounds.height)")
        print("profilePictureContainerView.frame.height : \(profilePictureContainerView.frame.height)")
        
        if profilePictureContainerView.bounds.height > 0 {

            if !profileViewLoaded {

                self.profilePictureContainerView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.profilePictureContainerView.layer.shadowOffset = .zero
                self.profilePictureContainerView.layer.shadowOpacity = 2;
                self.profilePictureContainerView.layer.shadowRadius = 5;
                self.profilePictureContainerView.layer.shadowPath = UIBezierPath(roundedRect: profilePictureContainerView.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_35).cgPath

                profileViewLoaded = true

            }

        }
        
    }
    
}

// MARK: - major functions
extension PostTopBarView {
    
    private func initializeView() {
        
        configureView()
        addViews()
        
    }
    
    private func configureView() {

        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    private func addViews() {
        /*
        self.addSubview(mainContainer)
        self.mainContainer.addSubview(profilePictureContainerView)
        self.profilePictureContainerView.addSubview(profileImageView)
        self.mainContainer.addSubview(stackViewFollowers)*/
        
        self.addSubview(profilePictureContainerView)
        self.profilePictureContainerView.addSubview(profileImageView)
        self.addSubview(stackViewFollowers)
        
        let safe = self.safeAreaLayoutGuide
        //let safeMainContainer = self.mainContainer.safeAreaLayoutGuide
        let safeProfileImageContainer = self.profilePictureContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            /*
            mainContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100),*/
            
            //profilePictureContainerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            profilePictureContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            profilePictureContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            profilePictureContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_70),
            profilePictureContainerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_70),
            
            profileImageView.centerYAnchor.constraint(equalTo: safeProfileImageContainer.centerYAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: safeProfileImageContainer.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_70),
            profileImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_70),

            stackViewFollowers.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ConstraintValues.constraint_50),
            stackViewFollowers.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            //stackViewFollowers.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            stackViewFollowers.leadingAnchor.constraint(equalTo: safeProfileImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            stackViewFollowers.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            /*
            informationLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            informationLabel.leadingAnchor.constraint(equalTo: safeProfileImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            informationLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            informationLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_24)*/
            
            ])
        
    }
    
    private func addGradientColor() {
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
}
