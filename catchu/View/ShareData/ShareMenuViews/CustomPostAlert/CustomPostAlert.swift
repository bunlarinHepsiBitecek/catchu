//
//  CustomPostAlert.swift
//  catchu
//
//  Created by Erkut Baş on 11/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomPostAlert: UIView {

    lazy var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true

        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)

        return temp
        
    }()
    
    lazy var alertView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 10
        
        temp.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        return temp
        
    }()
    
    lazy var imageView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
        
    }()

    lazy var informationLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
        
    }()
    
    lazy var stackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [imageView, informationLabel])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .center
        temp.axis = .horizontal
        temp.distribution = .fillProportionally
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomPostAlert {
    
    func setupViews() {
        addViews()
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(alertView)
        self.alertView.addSubview(stackView)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        let safeAlertView = self.alertView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            alertView.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor, constant: 5),
            alertView.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor, constant: -5),
            alertView.topAnchor.constraint(equalTo: safeContainerView.topAnchor, constant: 5),
            alertView.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor, constant: -5),
            
            stackView.leadingAnchor.constraint(equalTo: safeAlertView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAlertView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAlertView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAlertView.bottomAnchor),
            
            ])
        
    }
}
