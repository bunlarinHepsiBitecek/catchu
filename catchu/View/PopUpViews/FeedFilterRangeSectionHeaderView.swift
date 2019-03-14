//
//  FeedFilterRangeSectionHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedFilterRangeSectionHeaderView: UIView {
    
    var feedFilterRangeSectionHeaderViewModel = FeedFilterRangeSectionHeaderViewModel()
    
    lazy var infoLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        temp.textAlignment = .left
        temp.contentMode = .center
        //temp.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1
        temp.text = LocalizedConstants.TitleValues.LabelTitle.feedFilterRangeValue
        return temp
    }()
    
    lazy var countLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        temp.textAlignment = .left
        temp.contentMode = .center
        //temp.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1
        temp.text = "\(Constants.NumericConstants.INITIAL_FILTER_RANGE)"
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        initializeViews()
        setupListener()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FeedFilterRangeSectionHeaderView {
    
    private func initializeViews() {
        addViews()
    }
    
    private func addViews() {
        self.addSubview(infoLabel)
        self.addSubview(countLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeInfoLabel = self.infoLabel.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            infoLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            //infoLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            countLabel.leadingAnchor.constraint(equalTo: safeInfoLabel.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            //countLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            countLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            
            ])
    }
    
    private func setupListener() {
        feedFilterRangeSectionHeaderViewModel.newFeedFilterRange.bind { (participantCount) in
            self.setChangedFilterValue(count: participantCount)
        }
    }
    
    private func setChangedFilterValue(count : Int) {
        
        DispatchQueue.main.async {
            UIView.transition(with: self.countLabel, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.countLabel.text = "\(count)"
            })
        }
    }
    
    func setChangedFilterRange(value: Int) {
        countLabel.text = "\(value)"
    }
    
}
