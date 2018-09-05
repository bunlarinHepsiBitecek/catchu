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
    
    var tempView = UIView()
    let imageView = UIImageView()
    let imageChangeView = UIViewDesign()
    var coverView = UIView()
    var groupInfoView = UIView()
    var groupNameView = UIView()
    var groupNameLabel = UILabel()
    var groupNameEditButton = UIImageView()
    var editButtonContainer = UIView()
    var editButtonImageView = UIImageView()
    var cameraContainer = UIView()
    var cameraImageView = UIImageView()
    
    var staticColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    
    // static variables
    static var editButtonLeadingAnchor : CGFloat = 30.0
    static var editButtonContainerFrameBounds : CGFloat = 40.0
    static var contentOffsetForimageViewFrameMaxHeight : CGFloat = -300
    static var imageViewFrameMaxHeight : CGFloat = 300
    static var imageViewFrameHeight : CGFloat = 250
    static var imageViewFrameVisiblePartHeight : CGFloat = 50
    static var exitViewFrameMinimumVisiblePartHeight : CGFloat = 70
    static var tableViewInsetsRigthEdge : CGFloat = 5
    static var tableViewInsetsTopEdge : CGFloat = 250
    static var labelWidthSize : CGFloat = 200
    static var borderHeight : CGFloat = 0.3
    
    var referenceViewController = GroupInformationViewController()
    
    var activityIndicator: UIActivityIndicatorView!
    var activityIndicatorContainerView : UIView!
    
    @IBOutlet var tableView: UITableView!
    
    weak var delegate : GroupInformationUpdateProtocol!
    
    func initialize() {
        
        setupViewTitles()
        setupImageViewFrames()
        setupTableViewSettings()
        checkAuthenticatedUserIsAdmin()
        viewArrangements()
        setParticipantCount()
        
        setupExitViewFrameHeight()
    }

    @IBAction func backBarButtonClicked(_ sender: Any) {

        //referenceViewController.referenceOfContainerGroupViewController.tableView.reloadData()
        
        updateContainerGroupViewControllerTableView()
        referenceViewController.dismiss(animated: true, completion: nil)
        
    }
    
}

// MARK: - Major Functions
extension GroupInformationView {
    
    func updateContainerGroupViewControllerTableView() {
        
        Group.shared.updateGroupInfoInGroupListWithGroupObject(updatedGroup: group)
        
        self.delegate.syncGroupInfoWithClient(inputGroup: group, completion: { (result) in
            
            if result {
                
                
            }
            
        })
        
    }
    
    func showSpinning() {
        
        activityIndicatorContainerView = UIView()
        
        activityIndicatorContainerView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        
        activityIndicatorContainerView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        imageView.addSubview(activityIndicatorContainerView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        print("center x : \(String(describing: imageView.center.x))")
        print("center y : \(String(describing: imageView.center.y))")
        
        activityIndicator.center = CGPoint(x: imageView.center.x, y: imageView.center.y)
        
        activityIndicator.startAnimating()
        
        activityIndicatorContainerView.addSubview(activityIndicator)
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            //            self.doneButton.willRemoveSubview(self.tempView)
            self.activityIndicatorContainerView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.activityIndicatorContainerView.layoutIfNeeded()
                
            })
        }
        
        
    }
    
    func setupExitViewFrameHeight() {
        
        print("UIApplication.shared.statusBarFrame.height :\(UIApplication.shared.statusBarFrame.height)")
        
        let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        
        let safeAreaHeight :CGFloat = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height + bottomPadding!)
        let maxTableViewContainerSize = safeAreaHeight - topView.frame.height - GroupInformationView.imageViewFrameVisiblePartHeight
        let tableViewContentSize = returnTableViewContentSize()
        let difference = maxTableViewContainerSize - tableViewContentSize
        
        if tableViewContentSize < maxTableViewContainerSize && difference > GroupInformationView.exitViewFrameMinimumVisiblePartHeight {
            
            exitView.frame.size.height = maxTableViewContainerSize - tableViewContentSize
            
        }
        
    }
    
    func setupViewTitles() {
        
        viewTopicLabel.text = LocalizedConstants.TitleValues.LabelTitle.groupInformation
        
    }
    
    func returnTableViewContentSize() -> CGFloat {
        
        return CGFloat(returnParticipantCount()) * Constants.NumericValues.rowHeight50 + headerViewInsideTableView.frame.height
        
    }
    
    
    func returnParticipantCount() -> Int {
        
        var participantCount = 0
        
        if let groupid = group.groupID {
            if let userArray = Participant.shared.participantDictionary[groupid] {
                participantCount = userArray.count
            }
        }
        
        return participantCount
        
    }
    
    func setupTableViewSettings() {
        
        tableView.contentInset = UIEdgeInsetsMake(GroupInformationView.tableViewInsetsTopEdge, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func directToGroupNameLabelChangeViewController(_ sender : UITapGestureRecognizer) {
        
        if sender.state == .ended {
            
            if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.SubjectChangeViewController) as? SubjectChangeViewController {
                
                destinationController.group = group
                destinationController.referenceGroupInfoView = self
                referenceViewController.present(destinationController, animated: true, completion: nil)
            }
        }
        
    }
    
    func setupImageViewFrames() {
        
        tempView = UIView(frame: CGRect(x: 0, y: topView.frame.height, width: UIScreen.main.bounds.size.width, height: GroupInformationView.imageViewFrameHeight))
        tempView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        tempView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tempView.layer.shadowOpacity = 0.6
        tempView.layer.shadowRadius = 5.0
        tempView.layer.shadowColor = UIColor.black.cgColor
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.frame = CGRect(x: 0, y: topView.frame.height, width: UIScreen.main.bounds.size.width, height: GroupInformationView.imageViewFrameHeight)
//        imageView.image = UIImage.init(named: "8771.jpg")
        if let url = group.groupPictureUrl {
            imageView.setImagesFromCacheOrFirebaseForGroup(url)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: tempView.frame.height))
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = staticColor.withAlphaComponent(0)
        
        groupNameView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: GroupInformationView.imageViewFrameVisiblePartHeight))
        let gradient = CAGradientLayer()
        gradient.frame = groupNameView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        groupNameView.layer.insertSublayer(gradient, at: 0)
        groupNameView.backgroundColor = UIColor.clear
        
        groupNameView.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: GroupInformationView.labelWidthSize, height: GroupInformationView.imageViewFrameVisiblePartHeight))
        groupNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        groupNameLabel.font = UIFont(name: "System", size: 20)
        groupNameLabel.text = group.groupName
        groupNameLabel.isUserInteractionEnabled = true
        groupNameLabel.tag = 1
        
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameView.addSubview(groupNameLabel)
        
        let safeForGroupNameLabel = groupNameView.safeAreaLayoutGuide
        
//        groupNameLabel.topAnchor.constraint(equalTo: safeForGroupNameLabel.topAnchor).isActive = true
        groupNameLabel.heightAnchor.constraint(equalToConstant: GroupInformationView.imageViewFrameVisiblePartHeight).isActive = true
//        groupNameLabel.widthAnchor.constraint(equalToConstant: GroupInformationView.labelWidthSize).isActive = true
        groupNameLabel.bottomAnchor.constraint(equalTo: safeForGroupNameLabel.bottomAnchor).isActive = true
        groupNameLabel.leadingAnchor.constraint(equalTo: safeForGroupNameLabel.leadingAnchor, constant: 10).isActive = true
//        groupNameLabel.trailingAnchor.constraint(equalTo: safeForGroupNameLabel.trailingAnchor).isActive = true
        
        let tapGestureRecognizerForGroupNameLabel = UITapGestureRecognizer(target: self, action: #selector(GroupInformationView.directToGroupNameLabelChangeViewController(_:)))
        
        tapGestureRecognizerForGroupNameLabel.delegate = self
//        tapGestureRecognizerForGroupNameLabel.numberOfTapsRequired = 1
        groupNameLabel.addGestureRecognizer(tapGestureRecognizerForGroupNameLabel)
//        groupNameView.addGestureRecognizer(tapGestureRecognizerForGroupNameLabel)
        
        // edit button view
        editButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: GroupInformationView.editButtonContainerFrameBounds, height: GroupInformationView.editButtonContainerFrameBounds))
        editButtonContainer.backgroundColor = UIColor.clear
        editButtonContainer.layer.cornerRadius = 20
        
        groupNameView.addSubview(editButtonContainer)
        
        
        // edit button image
        editButtonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: GroupInformationView.editButtonContainerFrameBounds, height: GroupInformationView.editButtonContainerFrameBounds))
        editButtonImageView.image = #imageLiteral(resourceName: "outline_edit_white_36pt_1x.png")
        editButtonImageView.clipsToBounds = true
        editButtonImageView.isUserInteractionEnabled = true
        
        editButtonImageView.addGestureRecognizer(tapGestureRecognizerForGroupNameLabel)

        editButtonContainer.addSubview(editButtonImageView)
        
        coverView.addSubview(groupNameView)

        let safeAreaForGroupNameView = coverView.safeAreaLayoutGuide
        
        groupNameView.heightAnchor.constraint(equalToConstant: GroupInformationView.imageViewFrameVisiblePartHeight).isActive = true
        groupNameView.bottomAnchor.constraint(equalTo: safeAreaForGroupNameView.bottomAnchor).isActive = true
        groupNameView.leadingAnchor.constraint(equalTo: safeAreaForGroupNameView.leadingAnchor).isActive = true
        groupNameView.trailingAnchor.constraint(equalTo: safeAreaForGroupNameView.trailingAnchor).isActive = true
        
        
        
        editButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAreaForEditButtonContainer = groupNameLabel.safeAreaLayoutGuide
        let forBottom = groupNameView.safeAreaLayoutGuide
        
        // camera icon container
        cameraContainer = UIView(frame: CGRect(x: 0, y: 0, width: GroupInformationView.editButtonContainerFrameBounds, height: GroupInformationView.editButtonContainerFrameBounds))
        cameraContainer.backgroundColor = UIColor.clear
        cameraContainer.layer.cornerRadius = 20
        
        groupNameView.addSubview(cameraContainer)
        
        cameraContainer.translatesAutoresizingMaskIntoConstraints = false
        
        
        // camera image
        cameraImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: GroupInformationView.editButtonContainerFrameBounds, height: GroupInformationView.editButtonContainerFrameBounds))
        cameraImageView.image = #imageLiteral(resourceName: "outline_photo_camera_white_36pt_1x.png")
        cameraImageView.clipsToBounds = true
        cameraImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizerForCamereImage = UITapGestureRecognizer(target: self, action: #selector(GroupInformationView.triggerPictureChoiseProcess(_:)))
        tapGestureRecognizerForCamereImage.delegate = self
        tapGestureRecognizerForCamereImage.numberOfTapsRequired = 1
        cameraImageView.addGestureRecognizer(tapGestureRecognizerForCamereImage)
        
        cameraContainer.addSubview(cameraImageView)
        
        cameraContainer.translatesAutoresizingMaskIntoConstraints = false
        editButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsForCameraButton = groupNameView.safeAreaLayoutGuide
        
        cameraContainer.trailingAnchor.constraint(equalTo: constraintsForCameraButton.trailingAnchor, constant: -10).isActive = true
        cameraContainer.bottomAnchor.constraint(equalTo: safeAreaForGroupNameView.bottomAnchor, constant: -5).isActive = true
        cameraContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cameraContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let constraintsForEditButton = cameraContainer.safeAreaLayoutGuide
        let relationWithGroupNameLabel = groupNameLabel.safeAreaLayoutGuide
        
        editButtonContainer.trailingAnchor.constraint(equalTo: constraintsForEditButton.leadingAnchor, constant: -10).isActive = true
        editButtonContainer.bottomAnchor.constraint(equalTo: safeAreaForGroupNameView.bottomAnchor, constant: -5).isActive = true
        editButtonContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editButtonContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        editButtonContainer.leadingAnchor.constraint(equalTo: relationWithGroupNameLabel.trailingAnchor, constant: 30).isActive = true
        
        
        
        imageView.addSubview(coverView)
        
        let safeAreaForCoverView = imageView.safeAreaLayoutGuide
        
        coverView.topAnchor.constraint(equalTo: safeAreaForCoverView.topAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: safeAreaForCoverView.bottomAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: safeAreaForCoverView.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: safeAreaForCoverView.trailingAnchor).isActive = true
        
        tempView.addSubview(imageView)
        
        let safeAreaForImageView = tempView.safeAreaLayoutGuide
        
        imageView.topAnchor.constraint(equalTo: safeAreaForImageView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: safeAreaForImageView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: safeAreaForImageView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: safeAreaForImageView.trailingAnchor).isActive = true
        
        self.addSubview(tempView)
        
    }
    
    @objc func triggerPictureChoiseProcess(_ sender : UITapGestureRecognizer) {
        
        print("triggerPictureChoiseProcess starts")
        
        if let senderView = sender.view {
            
            print("senderView : \(senderView)")
            
        }
        
        ImageVideoPickerHandler.shared.delegate = self
        ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
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
        
        //groupName.text = group.groupName
        
        addBorders()
        setupGestureRecognizerForImageView()
//        setupGestureRecognizerForGroupNameView()
        setupGestureRecognizerForAddParticipantView()
        
        
    }
    
    func setParticipantCount() {
        
        if let groupid = group.groupID {
            if let count = Participant.shared.participantDictionary[groupid]?.count {
                participantTag.text = "\(count)" + " Participant(s)"
                
            }
        }
        
    }
    
    func addBorders() {
        
        let bottomBorder1 = CALayer()
        //bottomBorder1.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder1.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder1.frame = CGRect(x: 0, y: 50 - 0.3, width: frame.width, height: GroupInformationView.borderHeight)
        
//        groupNameUpdateView.layer.addSublayer(bottomBorder1)
        
        let bottomBorder2 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder2.frame = CGRect(x: 0, y: 50 - 0.3, width: frame.width, height: GroupInformationView.borderHeight)
        
        let bottomBorder3 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder3.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder3.frame = CGRect(x: 0, y: 0.3, width: frame.width, height: GroupInformationView.borderHeight)
        
        addParticipantView.layer.addSublayer(bottomBorder2)
        addParticipantView.layer.addSublayer(bottomBorder3)
        
        let bottomBorder4 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder4.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder4.frame = CGRect(x: 0, y: 50 - 0.3, width: frame.width, height: GroupInformationView.borderHeight)
        
        let bottomBorder5 = CALayer()
        //bottomBorder2.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder5.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bottomBorder5.frame = CGRect(x: 0, y: 0.3, width: frame.width, height: GroupInformationView.borderHeight)

//        exitView.layer.addSublayer(bottomBorder4)
//        exitView.layer.addSublayer(bottomBorder5)
        
    }
    
}


// MARK: - ImageHandlerProtocol
extension GroupInformationView: ImageHandlerProtocol {
    func returnImage(inputImage: UIImage) {
        imageView.image = inputImage
        
        startAWSGroupInfoUpdateProcess(inputImage: inputImage)
        
    }
    
    func startAWSGroupInfoUpdateProcess(inputImage : UIImage) {
        
        group.displayGroupProperties()

        showSpinning()

        APIGatewayManager.shared.startImageUploadProcess(inputImage: inputImage, inputGroup: group) { (requestSuccess, s3BucketResult, updatedGroup) in
            
            if requestSuccess {
                
                DispatchQueue.main.async {
                    
                    // remove old url from cache and set new image
                    if let url = self.group.groupPictureUrl {
                        SectionBasedFriend.shared.cachedFriendProfileImages.removeObject(forKey: NSString(string: url))
                        SectionBasedFriend.shared.cachedFriendProfileImages.setObject(inputImage, forKey: NSString(string: url))
                    }
                    
                    // update view's group object
                    updatedGroup.displayGroupProperties()
                    self.group = updatedGroup
                   
                    self.group.displayGroupProperties()
                    
                    self.stopSpinning()
                    
                }
            }
        }
        
    }
    
}

// MARK: - Gesture_Process
extension GroupInformationView: UIGestureRecognizerDelegate {
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//
//    }
    
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
            
            if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.SubjectChangeViewController) as? SubjectChangeViewController {

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
        
        print("imagePickerActions starts")
        
        if let senderView = sender.view {
            
            print("senderView.tag : \(senderView.tag)")

            if senderView.tag == 1 {
                
                if sender.state == .ended {
                    
                    if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.SubjectChangeViewController) as? SubjectChangeViewController {
                        
                        destinationController.group = group
                        destinationController.referenceGroupInfoView = self
                        referenceViewController.present(destinationController, animated: true, completion: nil)
                    }
                }
                
                
            } else {
                
                ImageVideoPickerHandler.shared.delegate = self
                ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
                
            }
            
        }
        
    }
    
}

// MARK: - TableView Operations
extension GroupInformationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if let groupid = group.groupID {
            if let userArray = Participant.shared.participantDictionary[groupid] {
                return (userArray.count)
            }
        }
        
        return 0
        
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
        
        if let groupid = group.groupID {
            cell.participant = Participant.shared.participantDictionary[groupid]![indexPath.row]
        }
        
        if cell.participant.userID == group.adminUserID {
            cell.adminLabel.text = "Admin"
            cell.isUserAdmin = true
        }
        
        cell.participantImage.setImagesFromCacheOrFirebaseForFriend(cell.participant.profilePictureUrl)
        cell.participantName.text = cell.participant.name
        cell.participantUsername.text = cell.participant.userName
        
        return cell
        
    }
    
    // scroll process
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = GroupInformationView.imageViewFrameHeight - (scrollView.contentOffset.y + GroupInformationView.imageViewFrameHeight)
        let height = min(max(y, GroupInformationView.imageViewFrameVisiblePartHeight), GroupInformationView.imageViewFrameMaxHeight + topView.frame.height)
        
        coverView.backgroundColor = staticColor.withAlphaComponent(50 / height)
//        topView.backgroundColor = staticColor.withAlphaComponent(50 / height)
        
        if height >= 250 {
            
            coverView.backgroundColor = staticColor.withAlphaComponent(0)
//            topView.backgroundColor = staticColor.withAlphaComponent(0)
            
        
        } else if height <= 50 {
            
            coverView.backgroundColor = staticColor.withAlphaComponent(1)
//            topView.backgroundColor = staticColor.withAlphaComponent(1)
            
        }
        
        tempView.frame = CGRect(x: 0, y: topView.frame.height, width: UIScreen.main.bounds.size.width, height: height)
        
        if scrollView.contentOffset.y < GroupInformationView.contentOffsetForimageViewFrameMaxHeight {
            
            gotoGroupImageViewController()
            
        }
        
    }
    
    func gotoGroupImageViewController() {
        
        if let destinationController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.GroupImageViewController) as? GroupImageViewController {
            
            destinationController.group = group
            self.referenceViewController.present(destinationController, animated: true, completion: nil)
            
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
                
                if let groupid = self.group.groupID {
                    if let indexFound = Participant.shared.participantDictionary[groupid]?.index(where: { $0.userID == inputCell.participant.userID}) {
                        
                        Participant.shared.participantDictionary[groupid]?.remove(at: indexFound)
                        
                    }
                }
          
                DispatchQueue.main.async {
                    
                    self.setParticipantCount()
                    
                    self.tableView.beginUpdates()
                    
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
                    self.setupExitViewFrameHeight()
                    
                    self.tableView.endUpdates()
                    //self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
}
