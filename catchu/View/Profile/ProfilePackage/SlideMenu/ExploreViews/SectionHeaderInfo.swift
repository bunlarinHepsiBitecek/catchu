//
//  SectionHeaderInfo.swift
//  catchu
//
//  Created by Erkut Baş on 11/19/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SectionHeaderInfo: UIView {

    lazy var infoLabel: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        //temp.text = LocalizedConstants.SlideMenu.activePeopleOnCatchU
        
        return temp
        
    }()
    
    lazy var infoCount: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - major functions
extension SectionHeaderInfo {
    
    func initializeView() {
        
        self.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        self.addSubview(infoLabel)
        self.addSubview(infoCount)
        
        let safe = self.safeAreaLayoutGuide
        let safeInfoLabel = self.infoLabel.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            infoLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            infoLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            infoLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            infoCount.leadingAnchor.constraint(equalTo: safeInfoLabel.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            infoCount.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            infoCount.topAnchor.constraint(equalTo: safe.topAnchor),
            infoCount.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            ])
        
    }
    
    func configureView(explanation : String, count : Int) {
        
        self.infoLabel.text = explanation
        self.infoCount.text = "\(count)"
        
    }
    
}
