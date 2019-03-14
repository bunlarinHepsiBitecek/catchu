//
//  GroupInfoEditTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoEditTableViewCell: CommonTableCell, CommonDesignableCell {
    
    // to make this cell sync with its controller
    var groupInfoEditViewModel: GroupInfoEditViewModel?
    
    private var maxLetterCount = Constants.NumericConstants.MAX_LETTER_COUNT_25
    
    lazy var groupNameTextField: UITextField = {
        let temp = UITextField()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.clearButtonMode = .whileEditing
        temp.keyboardType = .namePhonePad
        temp.keyboardAppearance = .dark
        temp.autocorrectionType = .no
        
        temp.delegate = self
        
        temp.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: UIControl.Event.editingChanged)
        
        return temp
    }()
    
    lazy var letterCounterStickerCounterView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.groupTableViewBackground
        
        return temp
    }()
    
    lazy var letterCountSticker: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.text = Constants.CharacterConstants.EMPTY
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.contentMode = .center
        
        return label
        
    }()
    
    override func initializeCellSettings() {
        
        addViews()
        
    }
    
}

// MARK: - major functions
extension GroupInfoEditTableViewCell {
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        
        guard let groupInfoEditViewModel = item as? GroupInfoEditViewModel else { return }
        
        self.groupInfoEditViewModel = groupInfoEditViewModel
        
        if let groupNameViewModel = groupInfoEditViewModel.groupNameViewModel {
            if let groupViewModel = groupNameViewModel.groupViewModel {
                if let group = groupViewModel.group {
                    if let groupName = group.groupName {
                        self.groupNameTextField.text = groupName
                        self.letterCountSticker.text = "\(maxLetterCount - groupName.count)"
                    }
                }
            }
        }
        
    }
    
    private func addViews() {
        
        self.contentView.addSubview(groupNameTextField)
        self.contentView.addSubview(letterCounterStickerCounterView)
        self.letterCounterStickerCounterView.addSubview(letterCountSticker)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeGroupNameTextField = self.groupNameTextField.safeAreaLayoutGuide
        let safeLetterContainer = self.letterCounterStickerCounterView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupNameTextField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            groupNameTextField.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            
            letterCounterStickerCounterView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            letterCounterStickerCounterView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            letterCounterStickerCounterView.topAnchor.constraint(equalTo: safeGroupNameTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            letterCounterStickerCounterView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            letterCounterStickerCounterView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            letterCountSticker.leadingAnchor.constraint(equalTo: safeLetterContainer.leadingAnchor),
            letterCountSticker.trailingAnchor.constraint(equalTo: safeLetterContainer.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            letterCountSticker.topAnchor.constraint(equalTo: safeLetterContainer.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            letterCountSticker.bottomAnchor.constraint(equalTo: safeLetterContainer.bottomAnchor),
            
            ])
        
    }
    
    @objc func textFieldChanged(_ sender : UITextField) {
        
        if let group = groupInfoEditViewModel?.groupNameViewModel?.groupViewModel?.group {
            if let text = sender.text {
                if text.isEmpty || text == group.groupName {
                    groupInfoEditViewModel?.saveButtonActivation.value = false
                } else {
                    groupInfoEditViewModel?.saveButtonActivation.value = true
                }
            }
        }
        
        if let text = sender.text {
            
            groupInfoEditViewModel?.newGroupNameText = text
            
            let countString = maxLetterCount - text.count
            
            UIView.transition(with: letterCountSticker, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.letterCountSticker.text = "\(countString)"
            })

        }
        
    }
    
    
}

// MARK: - UITextFieldDelegate
extension GroupInfoEditTableViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLetterCount
    }
    
}

