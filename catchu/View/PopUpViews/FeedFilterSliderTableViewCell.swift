//
//  FeedFilterSliderTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 3/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let changeSliderValue = #selector(FeedFilterSliderTableViewCell.changeSliderValueProcess)
}

class FeedFilterSliderTableViewCell: CommonFeedFilterOptionsTableCell, CommonDesignableCellForFeedFilterOptions {
    
    private var feedFilterSliderViewModel: FeedFilterSliderViewModel!
    
    lazy var rangeSlider: UISlider = {
        let temp = UISlider()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.minimumValue = 0
        temp.maximumValue = 1000
        temp.setValue(Float(Constants.NumericConstants.INITIAL_FILTER_RANGE), animated: false)
        temp.addTarget(self, action: .changeSliderValue, for: .valueChanged)
        return temp
    }()
    
    lazy var minValueLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.numberOfLines = 1
        temp.text = "0m"
        temp.textColor = UIColor.lightGray
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
        temp.textColor = UIColor.lightGray
        return temp
    }()
    
    override func initializeCellSettings() {
        addViews()
    }
    
    deinit {
        feedFilterSliderViewModel.sliderRangeChangeListener.unbind()
    }

}

// MARK: - major functions
extension FeedFilterSliderTableViewCell {
    
    private func addViews() {
        
        self.contentView.addSubview(minValueLabel)
        self.contentView.addSubview(maxValueLabel)
        self.contentView.addSubview(stackViewAdvancedSettings)
        self.contentView.addSubview(rangeSlider)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeStackViewAdvancedSettings = self.stackViewAdvancedSettings.safeAreaLayoutGuide
        let safeRangeSlider = self.rangeSlider.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewAdvancedSettings.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            stackViewAdvancedSettings.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_15),
            stackViewAdvancedSettings.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            stackViewAdvancedSettings.bottomAnchor.constraint(equalTo: safeRangeSlider.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            
            rangeSlider.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            rangeSlider.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_15),
            rangeSlider.topAnchor.constraint(equalTo: safeStackViewAdvancedSettings.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            rangeSlider.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            
            minValueLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            minValueLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            minValueLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            maxValueLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_15),
            maxValueLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            maxValueLabel.heightAnchor.constraint(equalToConstant:
                Constants.StaticViewSize.ViewSize.Height.height_30),
            
            ])
        
    }
    
    @objc fileprivate func changeSliderValueProcess(_ sender: UISlider) {
        print("sender.value : \(sender.value)")
        let roundedStepValue = round(sender.value / feedFilterSliderViewModel.step) * feedFilterSliderViewModel.step
        sender.value = roundedStepValue
        rangeSlider.value = sender.value
        
        print("sender.value : \(sender.value)")
        print("rangeSlider.value : \(rangeSlider.value)")
        feedFilterSliderViewModel.sliderRangeChangeListener.value = Int(sender.value)
    }
    
}

// MARK: - outside functions
extension FeedFilterSliderTableViewCell {
    
    func initiateCellDesign(item: CommonFeedFilterOptionsModelItem?) {
        print("\(#function)")
        
        guard let model = item as? FeedFilterSliderViewModel else { return }
        self.feedFilterSliderViewModel = model
        //self.title.text = feedFilterSliderViewModel.sectionTitle
        self.subTitle.text = feedFilterSliderViewModel.subTitle
        
    }
    
    func addListenerForSliderValueChanged(completion: @escaping(_ sliderValue: Int) ->  Void) {
        feedFilterSliderViewModel.sliderRangeChangeListener.bind(completion)
    }
    
    func setSliderValue(value: Int) {
        rangeSlider.setValue(Float(value), animated: true)
    }
    
}
