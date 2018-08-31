//
//  EditableProfileView.swift
//  catchu
//
//  Created by Erkut Baş on 8/21/18.
//  Copyright © 0.318 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class EditableProfileView: UIView {

    @IBOutlet var genderPickerController: UIPickerView!
    @IBOutlet var genderPickerViewContainer: UIView!
    @IBOutlet var genderPickerViewContainerHeightConstraints: NSLayoutConstraint!
    
    // view
    @IBOutlet var nameView: UIView!
    @IBOutlet var UsernameView: UIView!
    @IBOutlet var websiteView: UIView!
    @IBOutlet var shortBioView: UIView!
    @IBOutlet var birthDayView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var phoneNumberView: UIView!
    @IBOutlet var genderView: UIView!
    
    // label
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var shortBioLabel: UILabel!
    @IBOutlet var birthDayLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    // textField
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var shortBioTextField: UITextField!
    @IBOutlet var birthDayTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    
    private var datePicker : UIDatePicker?
    private var genderPicker : UIPickerView?
    
    private var genderArray : [String] = ["Not Specified", "Male", "Female"]
    
    var referenceOfViewController = EditProfileViewController()
    
    func initialize()  {
        
        setupDatePicker()
//        setupGenderPicker()
        setupViewPropertyLabelText()
        setupBottomLineForViews()
        setCurrentValuesToView()
        setupPickerProperties()
        setDelegatesForTextFields()
        
        genderPickerViewContainerHeightConstraints.constant = 0
        
    }
    
    func setCurrentValuesToView() {
        
        nameTextField.text = User.shared.name
        usernameTextField.text = User.shared.userName
        websiteTextField.text = User.shared.userWebsite
        shortBioTextField.text = Constants.CharacterConstants.SPACE
        birthDayTextField.text = User.shared.userBirthday
        emailTextField.text = User.shared.email
        phoneNumberTextField.text = User.shared.userPhone
        genderTextField.text = User.shared.userGender
        
    }
    
    func setupDatePicker() {
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditableProfileView.doneButtonClicked(_:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditableProfileView.cancelButtonClicked(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        birthDayTextField.inputAccessoryView = toolBar
        
        birthDayTextField.inputView = datePicker
        
    }
    
    @objc func doneButtonClicked(_ barButtonItem : UIBarButtonItem) {
        
        print("doneButtonClicked starts")
        print("barButtonItem :\(barButtonItem)")
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
//        dateFormatter1.dateFormat = "MM/dd/yyyy"
        dateFormatter1.timeStyle = .none
        
        UIView.transition(with: birthDayTextField, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.birthDayTextField.text = dateFormatter1.string(from: (self.datePicker?.date)!)
            self.endEditing(true)
        })
        
        print("fuckyou")
        //birthDayTextField.resignFirstResponder()
        
    }
    
    @objc func cancelButtonClicked(_ barButtonItem : UIBarButtonItem) {
        
        //birthDayTextField.resignFirstResponder()
        
        UIView.transition(with: birthDayTextField, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.endEditing(true)
        })
        
    }
    
    
    func setupViewPropertyLabelText() {
    
        nameLabel.text = LocalizedConstants.EditableProfileView.Name
        usernameLabel.text = LocalizedConstants.EditableProfileView.Username
        websiteLabel.text = LocalizedConstants.EditableProfileView.Website
        shortBioLabel.text = LocalizedConstants.EditableProfileView.Bio
        birthDayLabel.text = LocalizedConstants.EditableProfileView.Birthday
        emailLabel.text = LocalizedConstants.EditableProfileView.Email
        phoneLabel.text = LocalizedConstants.EditableProfileView.Phone
        genderLabel.text = LocalizedConstants.EditableProfileView.Gender
        
    }
    
    func setupBottomLineForViews() {
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        bottomBorder.frame = CGRect(x: nameView.frame.minX + 150, y: nameView.frame.maxY - 0.3, width: nameView.frame.width - 10, height: 30)
        bottomBorder.frame = CGRect(x: 150, y: nameView.frame.maxY - 0.3, width: nameTextField.frame.width, height: 0.3)
        
        print("nameView.frame.maxY - 0.3 : \(nameView.frame.maxY - 0.3)")
        
        nameView.layer.addSublayer(bottomBorder)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder2.frame = CGRect(x: 150, y: 50 - 0.3, width: usernameTextField.frame.width, height: 0.3)
        
        print("UsernameView.frame.origin.y : \(UsernameView.frame.origin.y)")
        print("UsernameView.frame.maxY : \(UsernameView.frame.maxY)")
        print("UsernameView.frame.origin.y + UsernameView.frame.maxY - 0.3 : \(UsernameView.frame.origin.y + UsernameView.frame.maxY - 0.3)")

        let bottomBorder3 = CALayer()
        bottomBorder3.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder3.frame = CGRect(x: 150, y: 50 - 0.3, width: websiteTextField.frame.width, height: 0.3)
        
        let bottomBorder4 = CALayer()
        bottomBorder4.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder4.frame = CGRect(x: 150, y: 50 - 0.3, width: birthDayTextField.frame.width, height: 0.3)
        
        let bottomBorder5 = CALayer()
        bottomBorder5.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder5.frame = CGRect(x: 150, y: 50 - 0.3, width: emailTextField.frame.width, height: 0.3)
        
        let bottomBorder6 = CALayer()
        bottomBorder6.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder6.frame = CGRect(x: 150, y: 50 - 0.3, width: phoneNumberTextField.frame.width, height: 0.3)
        
        let bottomBorder7 = CALayer()
        bottomBorder7.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder7.frame = CGRect(x: 150, y: 50 - 0.3, width: genderTextField.frame.width, height: 0.3)
        
        let bottomBorder8 = CALayer()
        bottomBorder8.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder8.frame = CGRect(x: 150, y: 50 - 0.3, width: shortBioTextField.frame.width, height: 0.3)
        
        nameView.layer.addSublayer(bottomBorder)
        UsernameView.layer.addSublayer(bottomBorder2)
        websiteView.layer.addSublayer(bottomBorder3)
        birthDayView.layer.addSublayer(bottomBorder4)
        emailView.layer.addSublayer(bottomBorder5)
        phoneNumberView.layer.addSublayer(bottomBorder6)
        genderView.layer.addSublayer(bottomBorder7)
        shortBioView.layer.addSublayer(bottomBorder8)
        
    }
    
}

extension EditableProfileView: UITextFieldDelegate {
    
    func setDelegatesForTextFields() {
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        websiteTextField.delegate = self
        shortBioTextField.delegate = self
        birthDayTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        genderTextField.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == nameTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == usernameTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == websiteTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == shortBioTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == birthDayTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == emailTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == phoneNumberTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else if textField == genderTextField {
            
            referenceOfViewController.editProfile4View.doneButton.isEnabled = true
            
        } else {
            
            print("passed")
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        genderPickerViewContainerHeightConstraints.constant = 150
        
        if textField == genderTextField {
            
            UIView.transition(with: genderPickerViewContainer, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.layoutIfNeeded()
            })

        }
        
    }
    
    func checkInput() {
        
//        do {
//            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
//            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
//            if let res = matches.first {
//                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
//            } else {
//                return false
//            }
//        } catch {
//            return false
//        }
        
    }
    
}

extension EditableProfileView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPickerProperties() {
        
        genderPickerController.delegate = self
        genderPickerController.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return genderArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genderArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.genderPickerViewContainerHeightConstraints.constant = 0
        
        UIView.transition(with: genderTextField, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.genderTextField.text = self.genderArray[row]
            
            
        })
        
        self.endEditing(true)
    }
    
}

