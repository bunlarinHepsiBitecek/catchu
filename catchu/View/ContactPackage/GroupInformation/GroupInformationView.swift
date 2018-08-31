//
//  GroupInformationView.swift
//  catchu
//
//  Created by Erkut Baş on 8/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInformationView: UIView {

    @IBOutlet var topView: UIView!
    @IBOutlet var leftBarButton: UIButton!
    @IBOutlet var viewTopicLabel: UILabel!
    @IBOutlet var groupNameUpdateView: UIView!
    @IBOutlet var groupName: UILabel!
    @IBOutlet var headerViewInsideTableView: UIView!
    
    @IBOutlet var addParticipantView: UIView!
    @IBOutlet var addParticipantLabel: UILabel!
    @IBOutlet var addParticipantImage: UIImageViewDesign!
    
    @IBOutlet var participantTag: UILabel!
    @IBOutlet var addParticipantHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet var exitView: UIView!
    @IBOutlet var exitLabel: UILabel!
    
    var group = Group()
    var participantArray = [User]()
    var authenticatedUserAdmin : Bool?
    
    let imageView = UIImageView()
    let imageChangeView = UIViewDesign()
    var groupInfoView = UIView()
    
    var referenceViewController = GroupInformationViewController()
    
    @IBOutlet var tableView: UITableView!
    
    func initialize() {
        
        setupImageViewSettings()
        setupTableViewSettings()
        checkAuthenticatedUserIsAdmin()
        viewArrangements()
        setParticipantCount()
        
        setFooterViewHeight()
    }

    @IBAction func backBarButtonClicked(_ sender: Any) {

        referenceViewController.referenceOfContainerGroupViewController.tableView.reloadData()
        referenceViewController.dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK: - Major Functions
extension GroupInformationView {
    
    func setFooterViewHeight() {
        
        let viewDeviceHeight = self.bounds.size.height
        print("viewDeviceHeight : \(viewDeviceHeight)")
        
        let viewDeviceHeight2 = UIScreen.main.bounds.height
        print("viewDeviceHeight2 : \(viewDeviceHeight2)")
        
        let tableViewSize = viewDeviceHeight2 - topView.frame.height - imageView.frame.height
        let necessarySize = viewDeviceHeight2 - topView.frame.height - 60
        
        print("tableViewSize : \(tableViewSize)")
        
        let calculated = headerViewInsideTableView.frame.height + exitView.frame.height + CGFloat((Participant.shared.participantDictionary[group.groupID]?.count)!) * Constants.NumericValues.rowHeight50
        
        print("(Participant.shared.participantDictionary[group.groupID]?.count)!) : \((Participant.shared.participantDictionary[group.groupID]?.count)!)")
        print("calculated : \(calculated)")
        
        if calculated < necessarySize {

//            exitView.frame.size.height = tableViewSize - calculated
            exitView.frame.size.height = necessarySize - calculated


        }
        
    }
    
    func setupTableViewSettings() {
        
        tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupImageViewSettings() {
        
        groupInfoView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
        
        groupInfoView.backgroundColor = UIColor.white
        groupInfoView.alpha = 0
        
        imageView.frame = CGRect(x: 0, y: topView.frame.height, width: UIScreen.main.bounds.size.width, height: 200)
        imageView.image = UIImage.init(named: "8771.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        groupInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(groupInfoView)
        
        let safe = imageView.safeAreaLayoutGuide
        
//        groupInfoView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        groupInfoView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        groupInfoView.bottomAnchor.constraint(equalTo: safe.bottomAnchor).isActive = true
        groupInfoView.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
        groupInfoView.trailingAnchor.constraint(equalTo: safe.trailingAnchor).isActive = true
        
        addSubview(imageView)
        
        
        imageView.setImagesFromCacheOrFirebaseForFriend(group.groupPictureUrl)
        
    }
    
    func checkAuthenticatedUserIsAdmin() {
        
        authenticatedUserAdmin = false
        
        if User.shared.userID == group.adminUserID {
            authenticatedUserAdmin = true
            
        }
        
    }
    
    func viewArrangements() {
        
        if !authenticatedUserAdmin! {
            
            headerViewInsideTableView.frame = CGRect(x: headerViewInsideTableView.frame.origin.x, y: headerViewInsideTableView.frame.origin.y, width: headerViewInsideTableView.frame.width, height: headerViewInsideTableView.frame.height - addParticipantView.frame.height)
            
            addParticipantHeightConstraints.constant = 0
            
            addParticipantView.alpha = 0
            
        }
        
        exitLabel.text = "Exit Group"
        exitLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        viewTopicLabel.text = group.groupName
        
        //groupName.text = group.groupName
        
        addBorders()
        setupGestureRecognizerForImageView()
//        setupGestureRecognizerForGroupNameView()
        setupGestureRecognizerForAddParticipantView()
        
        
    }
    
    func setParticipantCount() {
        
        if let count = Participant.shared.participantDictionary[group.groupID]?.count {
            participantTag.text = "\(count)" + " Participant(s)"
            
        }
        
    }
    
    func addBorders() {
        
        let bottomBorder1 = CALayer()
        //bottomBorder1.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder1.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder1.frame = CGRect(x: 0, y: 50 - 0.3, width: 375, height: 0.3)
        
//        groupNameUpdateView.layer.addSublayer(bottomBorder1)
        
        let bottomBorder2 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder2.frame = CGRect(x: 0, y: 50 - 0.3, width: 375, height: 0.3)
        
        let bottomBorder3 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder3.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder3.frame = CGRect(x: 0, y: 0.3, width: 375, height: 0.3)
        
        addParticipantView.layer.addSublayer(bottomBorder2)
        addParticipantView.layer.addSublayer(bottomBorder3)
        
        let bottomBorder4 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder4.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder4.frame = CGRect(x: 0, y: 50 - 0.3, width: 375, height: 0.3)
        
        let bottomBorder5 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder5.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder5.frame = CGRect(x: 0, y: 0.3, width: 375, height: 0.3)

//        exitView.layer.addSublayer(bottomBorder4)
//        exitView.layer.addSublayer(bottomBorder5)
        
    }
    
    func setupImageChangeView() {
        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageChangeView.translatesAutoresizingMaskIntoConstraints = false
        
        imageChangeView.frame = CGRect(x: 325, y: 250, width: 40, height: 40)
        imageChangeView.cornerRadius = 20.0
        imageChangeView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        imageView.addSubview(imageChangeView)
        
        let safeLayoutGuide = self.imageView.safeAreaLayoutGuide

        print("safe : \(safeLayoutGuide)")
        
//        imageChangeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: <#T##CGFloat#>)
        imageChangeView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageChangeView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}


// MARK: - Gesture_Process
extension GroupInformationView: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizerForGroupNameView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupInformationView.openGroupSubjectViewController(_:)))
        
        tapGesture.delegate = self
        groupNameUpdateView.isUserInteractionEnabled = true
        groupNameUpdateView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openGroupSubjectViewController(_ sender : UITapGestureRecognizer) {
        
        UIView.transition(with: self.groupNameUpdateView, duration: 0.8, options: .transitionCrossDissolve, animations: {
            self.groupNameUpdateView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        })
        
        UIView.transition(with: self.groupNameUpdateView, duration: 0.8, options: .transitionCrossDissolve, animations: {
            self.groupNameUpdateView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
        })

        if sender.state == .ended {
            
            if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: "SubjectChangeViewController") as? SubjectChangeViewController {

                destinationController.group = group
                destinationController.referenceGroupInfoView = self
                referenceViewController.present(destinationController, animated: true, completion: nil)
            }
        }
    }
    
    func setupGestureRecognizerForAddParticipantView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupInformationView.openFriendsPageToAddParticipant(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(GroupInformationView.openFriendsPageToAddParticipant2(_:)))
        
        addParticipantView.isUserInteractionEnabled = true
        tapGesture.delegate = self
        pinchGesture.delegate = self
        
//        addParticipantView.addGestureRecognizer(pinchGesture)
        addParticipantView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openFriendsPageToAddParticipant(_ sender : UITapGestureRecognizer) {
        
        UIView.transition(with: self.addParticipantView, duration: 0.8, options: .transitionCrossDissolve, animations: {
            self.addParticipantView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        })
        
        UIView.transition(with: self.addParticipantView, duration: 0.8, options: .transitionCrossDissolve, animations: {
            self.addParticipantView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
        })
        
        if sender.state == .ended {
            
            if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: "ParticipantListViewController") as? ParticipantListViewController {
                
                destinationController.participantListView.group = group
                /* participantListViewController yeni adamları eklediğinde geri donup guncelleme islemi yapmak icin gerekli
                 */
                destinationController.referenceOfGroupInformationView = self
                referenceViewController.present(destinationController, animated: true, completion: nil)
            }
        }

    }
    
    @objc func openFriendsPageToAddParticipant2(_ sender : UIPinchGestureRecognizer) {
        
        print("takasi bombombommmmmm")
        
        print("sender.state : \(sender.state)")
        print("sender.state : \(sender.state.rawValue)")
        print("sender.state : \(sender.state.hashValue)")
        
        if sender.state == .began {
            
            //            addParticipantView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            addParticipantView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            
        } else if sender.state == .changed {
            
            addParticipantView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            
        } else {
            
            addParticipantView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
        
    
    func setupGestureRecognizerForImageView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupInformationView.imagePickerActions(_:)))
        tapGesture.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func imagePickerActions(_ sender : UITapGestureRecognizer) {
        
        ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
    }
    
}

// MARK: - TableView Operations
extension GroupInformationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("(Participant.shared.participantDictionary[group.groupID]?.count)! : \((Participant.shared.participantDictionary[group.groupID]?.count)!)")
        print("authenticatedUserAdmin : \(authenticatedUserAdmin)")
        
        return (Participant.shared.participantDictionary[group.groupID]?.count)!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.NumericValues.rowHeight50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.groupInfoCell, for: indexPath) as? GroupInfoTableViewCell else { return UITableViewCell() }
        
        cell.initializeProperties()
        
        cell.participant = Participant.shared.participantDictionary[group.groupID]![indexPath.row]
        
        if cell.participant.userID == group.adminUserID {
            cell.adminLabel.text = "Admin"
            cell.isUserAdmin = true
        }
        
        cell.participantImage.setImagesFromCacheOrFirebaseForFriend(cell.participant.profilePictureUrl)
        cell.participantName.text = cell.participant.name
        cell.participantUsername.text = cell.participant.userName
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print("scrollView.contentOffset.y : \(scrollView.contentOffset.y)")
        
        let y = 200 - (scrollView.contentOffset.y + 200)
        //let height = min(max(y, 60), 250 + topView.frame.height)
        let height = min(max(y, 50), 250 + topView.frame.height)
        
        print("heigth : \(height)")
        
        groupInfoView.alpha = 50 / height
//        imageView.alpha = 44 / height
        
        if height >= 200 {
            
            groupInfoView.alpha = 0
//            imageView.alpha = 0
        }
        
        imageView.frame = CGRect(x: 0, y: topView.frame.height, width: UIScreen.main.bounds.size.width, height: height)
//
//        print("height : \(height)")
//        print("imageView.frame.height : \(imageView.frame.height)")
//        print("tableView.contentInset.bottom : \(tableView.contentInset.bottom)")
//        print("tableView.contentInset.top : \(tableView.contentInset.top)")
//
//        let  x = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < x {
//            print(" you reached end of the table")
//        }
        
        if scrollView.contentOffset.y < -300 {
                        print(" you reached top of the table")
            
            
            if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: "GroupImageViewController") as? GroupImageViewController {
                
                destinationController.group = group
                self.referenceViewController.present(destinationController, animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? GroupInfoTableViewCell else { return }
//
        createAlertActions(inputCell: cell, indexPath: indexPath)

    }
    
    func createAlertActions(inputCell : GroupInfoTableViewCell, indexPath : IndexPath) {
        
        let alertControl = UIAlertController(title: inputCell.participant.userName, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let actionGotoInfo = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.gotoInfo, style: .default) { (alertAction) in
            
        }

        alertControl.addAction(actionGotoInfo)

        if let admin = authenticatedUserAdmin {
            
            if admin {
                
                let actionMakeGroupAdmin = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.makeGroupAdmin, style: .default) { (alertAction) in
                    
                }
                
                let actionRemoveFromGroup = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.RemoveFromGroup, style: .destructive) { (alertAction) in
                    
                    self.removeFromGroup(inputCell: inputCell, indexPath: indexPath)
                    
                }
                
                alertControl.addAction(actionMakeGroupAdmin)
                alertControl.addAction(actionRemoveFromGroup)
                
            }
            
        }
        
        
        let actionCancel = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel) { (alertAction) in
            
            
        }
        
        alertControl.addAction(actionCancel)
        
        
        self.referenceViewController.present(alertControl, animated: true, completion: nil)

    }
    
    func removeFromGroup(inputCell : GroupInfoTableViewCell, indexPath : IndexPath) {
        
        let inputRequest = REGroupRequest()
        
        inputRequest?.requestType = RequestType.exit_group.rawValue
        inputRequest?.groupid = group.groupID
        inputRequest?.userid = inputCell.participant.userID
        
        APIGatewayManager.shared.removeParticipantFromGroup(groupBody: inputRequest!) { (groupRequestResult, response) in
            
            if response {
                
                if let indexFound = Participant.shared.participantDictionary[self.group.groupID]?.index(where: { $0.userID == inputCell.participant.userID}) {
                    
                    Participant.shared.participantDictionary[self.group.groupID]?.remove(at: indexFound)
                    
                }
                
          
                DispatchQueue.main.async {
                    
                    self.setParticipantCount()
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
                    self.setFooterViewHeight()

                    
                }
                
            }
            
        }
        
    }
    
}
