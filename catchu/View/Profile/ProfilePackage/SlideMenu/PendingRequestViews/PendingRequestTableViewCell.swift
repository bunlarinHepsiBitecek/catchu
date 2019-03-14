//
//  PendingRequestTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 1/4/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PendingRequestTableViewCell: CommonTableCell, CommonDesignableCell {
    
    var pendingRequestTableCellViewModel: PendingRequestTableCellViewModel!
    
    lazy var requesterImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Width.width_50))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mainStackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [stackViewForRequesterInfo, stackViewForProcessButtons])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillEqually
        
        return temp
    }()
    
    lazy var stackViewForRequesterInfo: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [name, username])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackViewForProcessButtons: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [confirmButton, deleteButton])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.spacing = 5
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillEqually
        
        return temp
    }()
    
    lazy var activityIndicatorViewOnDelete: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .gray)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        temp.hidesWhenStopped = true
        temp.alpha = 0
        //temp.startAnimating()
        return temp
    }()
    
    lazy var activityIndicatorViewOnConfirm: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .gray)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        temp.hidesWhenStopped = true
        temp.alpha = 0
        //temp.startAnimating()
        return temp
    }()
    
    lazy var confirmButton: UIButton = {
        
        let temp = UIButton(type: .system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: #selector(PendingRequestTableViewCell.confirmButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.confirm, for: UIControl.State.normal)
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        temp.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        temp.layer.cornerRadius = 5
        
        /*
        temp.layer.shadowOffset = CGSize(width: 0, height: 5)
        temp.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.shadowRadius = 5.0
        temp.layer.shadowOpacity = 0.6
        */
        
        temp.addSubview(activityIndicatorViewOnConfirm)
        
        let safe = temp.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            activityIndicatorViewOnConfirm.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            activityIndicatorViewOnConfirm.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            activityIndicatorViewOnConfirm.topAnchor.constraint(equalTo: safe.topAnchor),
            activityIndicatorViewOnConfirm.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        return temp
        
    }()
    
    lazy var deleteButton: UIButton = {
        
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: #selector(PendingRequestTableViewCell.deleteButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.reject, for: UIControl.State.normal)
        temp.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.borderWidth = 1
        temp.layer.cornerRadius = 5

        /*
        temp.layer.shadowOffset = CGSize(width: 0, height: 5)
        temp.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.shadowRadius = 5.0
        temp.layer.shadowOpacity = 0.6
        */
        
        temp.addSubview(activityIndicatorViewOnDelete)
        
        let safe = temp.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            activityIndicatorViewOnDelete.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            activityIndicatorViewOnDelete.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            activityIndicatorViewOnDelete.topAnchor.constraint(equalTo: safe.topAnchor),
            activityIndicatorViewOnDelete.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        return temp
        
    }()
    
    override func initializeCellSettings() {
        addViews()
        configureCellSettings()
        
    }

}

// MARK: - major functions
extension PendingRequestTableViewCell {
    
    private func addViews() {
        
        self.contentView.addSubview(requesterImageView)
        self.contentView.addSubview(mainStackView)
        
        //self.contentView.addSubview(stackViewForRequesterInfo)
        //self.contentView.addSubview(stackViewForProcessButtons)
        
        let safe = self.contentView.safeAreaLayoutGuide
        let safeParticipantImage = self.requesterImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            requesterImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_15),
            requesterImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            requesterImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            requesterImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            requesterImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            mainStackView.leadingAnchor.constraint(equalTo: safeParticipantImage.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            mainStackView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10)
            
            ])
        
    }
    
    private func configureCellSettings() {
        self.separatorInset = UIEdgeInsets(top: 0, left: Constants.StaticViewSize.ConstraintValues.constraint_80, bottom: 0, right: 0)
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        
        guard let requesterUserid = pendingRequestTableCellViewModel.returnCellUserid() else { return }
        
        let followOperationData = FollowRequestOperationData(buttonOperation: .confirm, requesterUserid: requesterUserid, operationState: .processing)
        pendingRequestTableCellViewModel.followOperation.value = followOperationData
        
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        guard let requesterUserid = pendingRequestTableCellViewModel.returnCellUserid() else { return }
        
        let followOperationData = FollowRequestOperationData(buttonOperation: .delete, requesterUserid: requesterUserid, operationState: .processing)
        pendingRequestTableCellViewModel.followOperation.value = followOperationData
    }
    
    func initiateCellDesign(item: CommonViewModelItem?) {
        guard let userViewModel = item as? CommonUserViewModel else { return }
        
        pendingRequestTableCellViewModel = PendingRequestTableCellViewModel(commonUserViewModel: userViewModel)
        
        guard let commonUserViewModel = pendingRequestTableCellViewModel.commonUserViewModel else { return }
        guard let user = commonUserViewModel.user else { return }
        
        if let userName = user.username {
            self.username.text = userName
        }
        
        if let name = user.name {
            self.name.text = name
            self.requesterImageView.setImageInitialPlaceholder(name, circular: true)
        } else {
            self.requesterImageView.image = UIImage(named: "user.png")
        }
        
        if let url = user.profilePictureUrl {
            self.requesterImageView.setImagesFromCacheOrFirebaseForFriend(url)
        }
        
        pendingRequestTableCellViewModel.followOperation.bind { (operationData) in
            self.triggerFollowRequestOperations(operationData: operationData)
        }
        
    }
    
    private func triggerFollowRequestOperations(operationData: FollowRequestOperationData) {
        
        DispatchQueue.main.async {
            self.pendingRequestTableCellViewModel.followOperationStateForController.value = self.pendingRequestTableCellViewModel.updateFollowRequestOperationCellResult(operationState: operationData.operationState, buttonOperationData: operationData.buttonOperation)
        }
        
        switch operationData.operationState {
        case .processing:
            
            self.cellButtonsVisibiltyManager(buttonOperation: operationData.buttonOperation, active: true)
            
            do {
                try pendingRequestTableCellViewModel.followRequestOperations(requestedUserid: User.shared.userid!, requesterUserid: operationData.requesterUserid)
            } catch let error as ApiGatewayClientErrors {
                if error == .missingRequestType {
                    print("\(Constants.ALERT) request type is required.")
                }
            }
            catch {
                print("\(Constants.CRASH_WARNING)")
            }
            
        case .done:
            self.cellButtonsVisibiltyManager(buttonOperation: operationData.buttonOperation, active: false)
            
        }
        
    }
    
    func listenButtonOperations(completion: @escaping (_ cellResult: FollowRequestOperationCellResult) -> Void) {
        pendingRequestTableCellViewModel.followOperationStateForController.bind { (cellResult) in
            completion(cellResult)
        }
    }
    
    func setItemTagToButtons(item: Int) {
        self.deleteButton.tag = item
        self.confirmButton.tag = item
    }
    
    private func onDeleteManager(active: Bool) {
        if active {
            self.activityIndicatorViewOnDelete.alpha = 1
        } else {
            self.activityIndicatorViewOnDelete.alpha = 0
        }
    }
    
    private func cellButtonsVisibiltyManager(buttonOperation: ButtonOperation, active: Bool) {
        
        DispatchQueue.main.async {
            switch buttonOperation {
            case .confirm:
                if active {
                    self.activityIndicatorViewOnConfirm.alpha = 1
                    self.activityIndicatorViewOnConfirm.startAnimating()
                } else {
                    self.activityIndicatorViewOnConfirm.alpha = 0
                    self.activityIndicatorViewOnConfirm.stopAnimating()
                }
            case .delete:
                if active {
                    self.activityIndicatorViewOnDelete.alpha = 1
                    self.activityIndicatorViewOnDelete.startAnimating()
                    self.deleteButtonBorderManagement(active: false)
                } else {
                    self.activityIndicatorViewOnDelete.alpha = 0
                    self.activityIndicatorViewOnDelete.stopAnimating()
                    self.deleteButtonBorderManagement(active: true)
                }
            default:
                return
            }
        }
    }
    
    private func deleteButtonBorderManagement(active: Bool) {
        if active {
            deleteButton.layer.borderWidth = 1
        } else {
            deleteButton.layer.borderWidth = 0
        }
    }
    
    func returnCellUserid() -> String {
        return pendingRequestTableCellViewModel.returnCellUserid()!
    }
    
}
