//
//  GroupCreateView.swift
//  catchu
//
//  Created by Erkut Baş on 9/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupCreateView: UIView {

    @IBOutlet var groupName: UITextField!
    @IBOutlet var cancelButton: UILabel!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    var referenceOfGroupCreateViewController = GroupCreateViewController()
    
    func initialize() {
        
        setTableDelegation()
        setupViewSettings()
        setGestureRecognizerForGroupImage()
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        referenceOfGroupCreateViewController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        let inputRequest = REGroupRequest()
        inputRequest?.groupParticipantArray = [REGroupRequest_groupParticipantArray_item]()
        
        inputRequest?.requestType = RequestType.create_group.rawValue
        inputRequest?.userid = User.shared.userid
        inputRequest?.groupName = "Erkut Unit Test"
        
        for item in SectionBasedFriend.shared.selectedUserArray {
            
            let temp = REGroupRequest_groupParticipantArray_item()
            
            temp?.participantUserid = item.userid
            inputRequest?.groupParticipantArray?.append(temp!)
            
        }
        
        APIGatewayManager.shared.createNewGroup(groupBody: inputRequest!) { (groupRequestResult, response) in
            
            if response {
                
//                print("groupRequestResult : \(groupRequestResult.display())")
                
                
            }
            
        }
        
    }
    
    
}

extension GroupCreateView {
    
    func setupViewSettings() {
        
        print("self.groupName.frame.origin.x : \(self.groupName.frame.origin.x)")
        print("self.groupName.frame.origin.y : \(self.groupName.frame.origin.y)")
        print("self.groupName.frame.height : \(self.groupName.frame.height)")
        print("self.groupName.frame.width : \(self.groupName.frame.width)")
        
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0.3, width: self.groupName.frame.width, height: 0.3)
        topLayer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.groupName.frame.height - 0.3, width: self.groupName.frame.width, height: 0.3)
        bottomLayer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        groupName.layer.addSublayer(topLayer)
        groupName.layer.addSublayer(bottomLayer)
        
//        groupName.layer.masksToBounds = true

        detailLabel.text = LocalizedConstants.TitleValues.LabelTitle.createGroupName
        
    }
    
}

extension GroupCreateView: UIGestureRecognizerDelegate {
    
    func setGestureRecognizerForGroupImage() {
        
        let tapGestureRecognizerForGroupImage = UITapGestureRecognizer(target: self, action: #selector(GroupCreateView.triggerPictureChoiseProcess(_:)))
        tapGestureRecognizerForGroupImage.delegate = self
        tapGestureRecognizerForGroupImage.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizerForGroupImage)
        
    }
    
    @objc func triggerPictureChoiseProcess(_ sender : UITapGestureRecognizer) {
        
        ImageVideoPickerHandler.shared.delegate = self
        ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
    }
    
}

extension GroupCreateView: ImageHandlerProtocol {
    func returnImage(inputImage: UIImage) {
        imageView.image = inputImage
    }
    
}

extension GroupCreateView: UITableViewDelegate, UITableViewDataSource {
    
    func setTableDelegation() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("REMZİ TEST 1")
        return contentSize.contentSizeOfCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.groupCreateHeaderCell) as? GroupCreateHeaderTableViewCell else { return UIView() }
        
        cell.participantTag.text = "Participant : "
        cell.selectedCount.text = "5"
        cell.totalCount.text = " of 256"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.groupCreateCell, for: indexPath) as? GroupCreateTableViewCell else { return UITableViewCell() }
        
        cell.referenceOfGroupCreateView = self
        
        return cell
        
    }
    
}
