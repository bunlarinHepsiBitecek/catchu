//
//  SubjectChangeViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SubjectChangeViewController: UIViewController {

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var subjectLetterCount: UILabel!
    
    private var maxLetterCount = 25
    
    var referenceGroupInfoView = GroupInformationView()
    
    var doneActivityView : UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    var group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let newGroupName = subjectTextField.text {
            group.groupName = newGroupName
        }

        updateGroupName()
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}


// MARK: - major operations
extension SubjectChangeViewController {
    
    func initializeViewController() {
        
        subjectTextField.text = group.groupName
        subjectLetterCount.text = String(describing: maxLetterCount - group.groupName.count)
        
        subjectTextField.delegate = self
        
        setupForTextFieldDidChangeRecognize()
        
        doneButton.isEnabled = false
        
    }
    
    func showSpinning() {
        
        //originalButtonText = doneButton.titleLabel?.text
        
        doneActivityView = UIView()
        
        doneActivityView.frame = CGRect(x: 0, y: 0, width: doneButton.frame.width, height: doneButton.frame.height)
        
        doneActivityView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.addSubview(doneActivityView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = doneActivityView.center
        
        activityIndicator.startAnimating()
        
        doneActivityView.addSubview(activityIndicator)
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            //            self.doneButton.willRemoveSubview(self.tempView)
            self.doneActivityView.removeFromSuperview()
            self.doneButton.isEnabled = false
        }
    }
    
    func updateGroupName() {
        
        showSpinning()
        
        var inputGroupRequest = REGroupRequest()
        
        inputGroupRequest = Group.shared.returnREGroupRequestFromGroup(inputGroup: group)
        inputGroupRequest?.requestType = RequestType.update_group_info.rawValue
        
        APIGatewayManager.shared.updateGroupInformation(groupBody: inputGroupRequest!) { (groupRequestResult, response) in
            
            if response {
                
                print("Update process is successfull")
                print("result : \(groupRequestResult.error?.code)")
                print("result : \(groupRequestResult.error?.message)")
            
                self.stopSpinning()
                
                self.updateInitialBasedGroupData()
                
                DispatchQueue.main.async {
                    self.doneButton.isEnabled = false
                    self.referenceGroupInfoView.groupName.text = self.group.groupName
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    
    /// Asagidaki fonksiyonun amacı group tableview ına geri döndüğümüzde neo4j deki güncellemenin yansıtılabilmesi
    func updateInitialBasedGroupData() {
        
        Group.shared.updateGroupInfoInGroupList(inputGroupID: self.group.groupID, inputGroupName: self.group.groupName)
        SectionBasedGroup.shared.emptySectionBasedGroupData()
        SectionBasedGroup.shared.createInitialLetterBasedGroupDictionary()
        
    }
    
}

extension SubjectChangeViewController : UITextFieldDelegate {
    
    func setupForTextFieldDidChangeRecognize() {
        
        subjectTextField.addTarget(self, action: #selector(SubjectChangeViewController.subjectCountUpdate(_:)), for: .editingChanged)
        
    }
    
    @objc func subjectCountUpdate(_ textField : UITextField) {
        
        let countString = maxLetterCount - (self.subjectTextField.text?.count)!

        UIView.transition(with: subjectLetterCount, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            self.subjectLetterCount.text = "\(countString)"
                
        })
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLetterCount
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.doneButton.isEnabled = true
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        print("textFieldDidEndEditing starts")
//        print("textField : \(textField.text)")
//        print("subjectTF : \(subjectTextField.text)")
//
//        group.groupName = subjectTextField.text!
//
//    }
    
}
