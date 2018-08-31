//
//  EditProfile4View.swift
//  catchu
//
//  Created by Erkut Baş on 8/21/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class EditProfile4View: UIView {
    
    @IBOutlet var editProfileTitleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var changeProfilePhotoButton: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet var viewInsideTableView: UIView!
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    var referenceOfRootView : EditProfileViewController!
    var tempView : UIView!
    
    func initialize() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupUserProfileInformation()
        setBottomBorderToTopView()
        setBottomBorderToViewInsideTableView()
        setupGestureRecognizer()
        setupTableViewProperties()
        
        doneButton.isEnabled = false
        
    }
    
    func showSpinning() {
        
        //originalButtonText = doneButton.titleLabel?.text
        
        tempView = UIView()
        
        tempView.frame = CGRect(x: 0, y: 0, width: doneButton.frame.width, height: doneButton.frame.height)
        
        tempView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.addSubview(tempView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = tempView.center
        
        activityIndicator.startAnimating()

        tempView.addSubview(activityIndicator)
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
//            self.doneButton.willRemoveSubview(self.tempView)
            self.tempView.removeFromSuperview()
            self.doneButton.isEnabled = false
        }
        
        
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        referenceOfRootView.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        
//        if let destinationViewController = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: "PhotoLibraryPrePermissionViewController") as? PhotoLibraryPrePermissionViewController {
//
//            referenceOfRootView.present(destinationViewController, animated: true, completion: nil)
//
//        }
        
//        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        
        User.shared.name            = referenceOfRootView.editableProfileView.nameTextField.text!
        User.shared.userName        = referenceOfRootView.editableProfileView.usernameTextField.text!
        User.shared.userWebsite     = referenceOfRootView.editableProfileView.websiteTextField.text!
        User.shared.userBirthday    = referenceOfRootView.editableProfileView.birthDayTextField.text!
        User.shared.email           = referenceOfRootView.editableProfileView.emailTextField.text!
        User.shared.userPhone       = referenceOfRootView.editableProfileView.phoneNumberTextField.text!
        User.shared.userGender      = referenceOfRootView.editableProfileView.genderTextField.text!
        
        User.shared.displayProperties()
        
//        var temp = User()
//
//        temp = User.shared.returnShared()
//
//        temp.displayProperties()
        
        showSpinning()
        
        APIGatewayManager.shared.updateUserProfileInformation(requestType: .user_profile_update, userObject: User.shared) { (response, result) in

            if result {
            
                print("result :\(result)")
            
                self.stopSpinning()
            }
            
        }
        
        
        
    }
    
    @IBAction func changeProfilePhotoButtonTapped(_ sender: Any) {
        
        ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
    }
    
    
}

extension EditProfile4View: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfile4View.startProfilePictureEdit(_:)))
        tapGestureRecognizer.delegate = self
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func startProfilePictureEdit(_ inputTapGestureRecognizer : UITapGestureRecognizer) {
        
        //ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
        
    }
    
    func setupUserProfileInformation() {
        
        profileImage.setImagesFromCacheOrFirebaseForFriend(User.shared.profilePictureUrl)
        
    }
    
    func setBottomBorderToTopView() {
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        bottomBorder.frame = CGRect(x: topView.frame.minX, y: topView.frame.maxY - 0.3, width: topView.frame.width, height: 0.3)
        
        topView.layer.addSublayer(bottomBorder)
        
    }
    
    func setBottomBorderToViewInsideTableView() {
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        bottomBorder.frame = CGRect(x: viewInsideTableView.frame.minX, y: viewInsideTableView.frame.maxY - 0.3, width: viewInsideTableView.frame.width, height: 0.3)
        
        viewInsideTableView.layer.addSublayer(bottomBorder)
        
    }
    
}

extension EditProfile4View : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableViewProperties() {
        
        self.tableView.showsVerticalScrollIndicator = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditProfile4TableViewCell else { return UITableViewCell() }
        
        cell.mainView.addSubview(referenceOfRootView.editableProfileView)
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return referenceOfRootView.editableProfileView.frame.height
        
    }
    
    
    
}

