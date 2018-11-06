//
//  TopControlView.swift
//  catchu
//
//  Created by Erkut Baş on 11/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class TopControlView: UIView {

    lazy var mainContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return temp
        
    }()
    
    lazy var buttonContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        return temp
        
    }()
    
    lazy var searchBarStack: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [searchBar, segmentedButton])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .vertical
        
        temp.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        return temp
        
    }()
    
    lazy var cancelButton: UIButton = {
        
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        temp.titleLabel?.tintColor = self.tintColor
        
        return temp
    }()
    
    lazy var nextButton : UIButton = {
        
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        
        return temp
        
    }()
    
    lazy var screenLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.addParticipant
        temp.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        
        return temp
        
    }()
    
    lazy var selectedItemCount: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        
        return temp
        
    }()
    
    lazy var totalItemCount: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        
        return temp
        
    }()
    
    lazy var apostrophe: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "/"
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        
        return temp
        
    }()
    
    lazy var totalCountStackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [selectedItemCount, apostrophe, totalItemCount])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .horizontal
        
        return temp
    }()
    
    lazy var searchBar: UISearchBar = {
        
        let temp = UISearchBar()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    lazy var segmentedButton: UISegmentedControl = {
        
        let temp = UISegmentedControl()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - major functions
extension TopControlView {
    
    func addViews(){
        
        self.addSubview(mainContainerView)
        self.mainContainerView.addSubview(buttonContainerView)
        self.mainContainerView.addSubview(searchBarStack)
        
        self.buttonContainerView.addSubview(cancelButton)
        self.buttonContainerView.addSubview(nextButton)
        self.buttonContainerView.addSubview(screenLabel)
        self.buttonContainerView.addSubview(totalCountStackView)
        
        let safe = self.safeAreaLayoutGuide
        let safeMainContainerView = self.mainContainerView.safeAreaLayoutGuide
        let safeButtonContainerView = self.buttonContainerView.safeAreaLayoutGuide
        let safeScreenLabel = self.screenLabel.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainContainerView.heightAnchor.constraint(equalToConstant: 170),
            
            buttonContainerView.leadingAnchor.constraint(equalTo: safeMainContainerView.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: safeMainContainerView.trailingAnchor),
            buttonContainerView.topAnchor.constraint(equalTo: safeMainContainerView.topAnchor),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            cancelButton.leadingAnchor.constraint(equalTo: safeButtonContainerView.leadingAnchor, constant: 10),
            cancelButton.topAnchor.constraint(equalTo: safeButtonContainerView.topAnchor, constant: 25),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 50),
            
            nextButton.trailingAnchor.constraint(equalTo: safeButtonContainerView.trailingAnchor, constant: -10),
            nextButton.topAnchor.constraint(equalTo: safeButtonContainerView.topAnchor, constant: 25),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            
            screenLabel.topAnchor.constraint(equalTo: safeButtonContainerView.topAnchor, constant: 10),
            screenLabel.centerXAnchor.constraint(equalTo: safeButtonContainerView.centerXAnchor),
            screenLabel.heightAnchor.constraint(equalToConstant: 30),
            screenLabel.widthAnchor.constraint(equalToConstant: 200),
            
            totalCountStackView.topAnchor.constraint(equalTo: safeScreenLabel.bottomAnchor, constant: 10),
            totalCountStackView.centerXAnchor.constraint(equalTo: safeButtonContainerView.centerXAnchor),
            totalCountStackView.heightAnchor.constraint(equalToConstant: 30),
            totalCountStackView.widthAnchor.constraint(equalToConstant: 200),
            
            searchBarStack.leadingAnchor.constraint(equalTo: safeMainContainerView.leadingAnchor),
            searchBarStack.trailingAnchor.constraint(equalTo: safeMainContainerView.trailingAnchor),
            searchBarStack.topAnchor.constraint(equalTo: safeButtonContainerView.bottomAnchor),
            searchBarStack.heightAnchor.constraint(equalToConstant: 100),
            
            ])
        
    }
    
}
