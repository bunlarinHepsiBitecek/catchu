//
//  FeedFilterRangeSectionFooterView.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let resetFilterRangeSelector = #selector(FeedFilterRangeSectionFooterView.resetFilterRange)
}

class FeedFilterRangeSectionFooterView: UIView {
    
    var feedFilterRangeSectionFooterViewModel = FeedFilterRangeSectionFooterViewModel()
    
    lazy var minValueLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1
        temp.text = "0m"
        temp.isHidden = true
        return temp
    }()
    
    lazy var maxValueLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1
        temp.text = "1000m"
        temp.isHidden = true
        return temp
    }()
    
    lazy var resetButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: .resetFilterRangeSelector, for: .touchUpInside)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.reset, for: UIControl.State.normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.borderWidth = Constants.StaticViewSize.BorderWidth.borderWidth_1
        temp.layer.borderColor = self.tintColor.cgColor
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_15
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FeedFilterRangeSectionFooterView {
    
    private func initializeViews() {
        addViews()
    }
    
    private func addViews() {
        self.addSubview(minValueLabel)
        self.addSubview(maxValueLabel)
        self.addSubview(resetButton)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            minValueLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            //minValueLabel.bottomAnchor.constraint(fequalTo: safe.bottomAnchor),
            minValueLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            minValueLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            maxValueLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_15),
            //maxValueLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            maxValueLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            maxValueLabel.heightAnchor.constraint(equalToConstant:
                Constants.StaticViewSize.ViewSize.Height.height_30),
            
            resetButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            resetButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            resetButton.heightAnchor.constraint(equalToConstant:
                Constants.StaticViewSize.ViewSize.Height.height_30),
            resetButton.widthAnchor.constraint(equalToConstant:
                Constants.StaticViewSize.ViewSize.Height.height_150),
            
            ])
    }
    
    @objc fileprivate func resetFilterRange(_ sender: UIButton) {
        feedFilterRangeSectionFooterViewModel.resetFeedFilterRangeValue.value = Constants.NumericConstants.INITIAL_FILTER_RANGE
    }
    
    func listenResetButton(completion: @escaping(_ resetValue: Int) -> Void) {
        feedFilterRangeSectionFooterViewModel.resetFeedFilterRangeValue.bind(completion)
    }
}
