//
//  FilterColorCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 10/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FilterColorCollectionViewCell: UICollectionViewCell {
    
    private var isGradientColorAdded : Bool = false
    
    lazy var containerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = 10
        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        temp.clipsToBounds = true
        
        return temp
    }()
    
    lazy var filternameContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        return temp
    }()
    
    lazy var filterName: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        temp.contentMode = .center
        temp.textAlignment = .center
        
        return temp
        
    }()
    
    lazy var filterImage: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = 5
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        
        return temp
        
    }()
    
    lazy var selectedIcon: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "check_2")
//        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
//        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.contentMode = .scaleAspectFill
        temp.layer.cornerRadius = 10
        temp.clipsToBounds = true
        temp.alpha = 0
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FilterColorCollectionViewCell {
    
    func configuration() {
        
        addContainer()
        
    }
    
    func addContainer() {
        
        self.addSubview(containerView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
        
    }
    
    func setupCells(image : UIImage, name: String) {
        
        self.layer.cornerRadius = 5
        
        addContainer()
        
        filterImage.image = image
        filterName.text = name
        
        self.containerView.addSubview(filterImage)
        self.containerView.addSubview(filternameContainer)
        self.filternameContainer.addSubview(filterName)
        self.containerView.addSubview(selectedIcon)
        
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeFilterContainer = self.filternameContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            filterImage.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            filterImage.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            filterImage.topAnchor.constraint(equalTo: safeContainer.topAnchor),
            filterImage.bottomAnchor.constraint(equalTo: safeContainer.bottomAnchor),
            
            filternameContainer.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            filternameContainer.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            filternameContainer.bottomAnchor.constraint(equalTo: safeContainer.bottomAnchor),
            filternameContainer.heightAnchor.constraint(equalToConstant: 20),
            
            filterName.leadingAnchor.constraint(equalTo: safeFilterContainer.leadingAnchor),
            filterName.trailingAnchor.constraint(equalTo: safeFilterContainer.trailingAnchor),
            filterName.topAnchor.constraint(equalTo: safeFilterContainer.topAnchor),
            filterName.bottomAnchor.constraint(equalTo: safeFilterContainer.bottomAnchor),
            
            selectedIcon.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor, constant: -2),
            selectedIcon.topAnchor.constraint(equalTo: safeContainer.topAnchor, constant: 2),
            selectedIcon.heightAnchor.constraint(equalToConstant: 20),
            selectedIcon.widthAnchor.constraint(equalToConstant: 20)
            
            ])
        
    }
    
    /// gradientColor definitions
    func addGradientToInformationContainer() {
        
        print("addGradientToInformationContainer starts")
        print("filternameContainer.bounds : \(filternameContainer.bounds)")
        print("filternameContainer.frame : \(filternameContainer.frame)")
        
        let gradient = CAGradientLayer()
        //        gradient.frame = filternameContainer.bounds
        gradient.frame = self.frame
        //        gradient.cornerRadius = 10
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        filternameContainer.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func activateselectedIcon(active : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if active {
                self.selectedIcon.alpha = 1
            } else {
                self.selectedIcon.alpha = 0
            }
        }
        
    }
    
}
