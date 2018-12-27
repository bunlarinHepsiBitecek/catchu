//
//  NewGroupCreationHeaderView.swift
//  catchu
//
//  Created by Erkut Baş on 12/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class NewGroupCreationHeaderView: UIView {
    
    private var maxLetterCount = Constants.NumericConstants.MAX_LETTER_COUNT_25

    lazy var groupProfileImageContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        return temp
    }()
    
    lazy var groupProfileImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "icon_camera")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        return temp
    }()
    
    lazy var groupNameTextField: UITextField = {
        let temp = UITextField()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.clearButtonMode = .whileEditing
        temp.keyboardType = .namePhonePad
        temp.keyboardAppearance = .dark
        temp.autocorrectionType = .no
        temp.placeholder = LocalizedConstants.TitleValues.LabelTitle.groupNameDefault
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        temp.leftView = paddingView
        temp.leftViewMode = UITextFieldViewMode.always
        
        temp.delegate = self
        
        temp.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: UIControlEvents.editingChanged)
        
        return temp
    }()
    
    lazy var infoLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        //temp.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        temp.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        temp.numberOfLines = 0
        temp.lineBreakMode = .byWordWrapping
        temp.text = LocalizedConstants.TitleValues.LabelTitle.provideGroupName
        return temp
    }()
    
    lazy var letterCountSticker: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.text = "\(maxLetterCount)"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.contentMode = .center
        
        return label
        
    }()
    
    
    init(frame: CGRect, backgroundColor: UIColor) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        
        initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major funtcions
extension NewGroupCreationHeaderView {
    
    private func initializeViews() {
        addViews()
        addBordersToGroupNameTextField()
    }
    
    private func addViews() {
        
        self.addSubview(groupProfileImageContainer)
        self.addSubview(groupNameTextField)
        self.addSubview(infoLabel)
        self.addSubview(letterCountSticker)
        self.groupProfileImageContainer.addSubview(groupProfileImageView)
        
        let safe = self.safeAreaLayoutGuide
        let safeImageContainer = self.groupProfileImageContainer.safeAreaLayoutGuide
        let safeTextField = self.groupNameTextField.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupProfileImageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupProfileImageContainer.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            //groupProfileImageContainer.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupProfileImageContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            groupProfileImageContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            groupProfileImageView.centerXAnchor.constraint(equalTo: safeImageContainer.centerXAnchor),
            groupProfileImageView.centerYAnchor.constraint(equalTo: safeImageContainer.centerYAnchor),
            groupProfileImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            groupProfileImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_30),
            
            groupNameTextField.leadingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_20),
            groupNameTextField.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_30),
            //groupNameTextField.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            groupNameTextField.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            
            infoLabel.leadingAnchor.constraint(equalTo: safeTextField.leadingAnchor),
            infoLabel.topAnchor.constraint(equalTo: safeTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            infoLabel.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            infoLabel.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            letterCountSticker.trailingAnchor.constraint(equalTo: safeTextField.trailingAnchor),
            letterCountSticker.topAnchor.constraint(equalTo: safeTextField.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            letterCountSticker.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_20),
            letterCountSticker.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_20),
            
            /*
            groupProfileImageView.leadingAnchor.constraint(equalTo: safeImageContainer.leadingAnchor),
            groupProfileImageView.trailingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor),
            groupProfileImageView.topAnchor.constraint(equalTo: safeImageContainer.topAnchor),
            groupProfileImageView.bottomAnchor.constraint(equalTo: safeImageContainer.bottomAnchor),
            */
            
            ])
        
    }
    
    private func addBordersToGroupNameTextField() {

        
        
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        print("\(#function)")
        
        if let text = sender.text {
            
            let countString = maxLetterCount - text.count
            
            UIView.transition(with: letterCountSticker, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                self.letterCountSticker.text = "\(countString)"
            })
            
        }
        
    }
    
}

// MARK: - UITextFieldDelegate
extension NewGroupCreationHeaderView: UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLetterCount
    }
    
    
}

