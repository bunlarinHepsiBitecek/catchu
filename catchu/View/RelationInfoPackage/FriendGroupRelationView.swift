//
//  FriendGroupRelationTopView.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendGroupRelationView: UIView {

    weak var delegate : ViewPresentationProtocols!
    private var friendRelationChoise : FriendRelationViewChoise!
    private var friendRelationView : FriendRelationView!
    
    // to make it segmented button visible to user or not
    private var segmentedButtonHeigthConstraints = NSLayoutConstraint()
    
    lazy var informationContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        return temp
    }()
    
    lazy var topicInformationView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return temp
    }()
    
    lazy var counterInformationView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return temp
    }()
    
    var topViewInfo: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.addParticipant
        
        return temp
        
    }()
    
    var selectedParticipantCount: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .right
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        
        return temp
        
    }()
    
    var sliceCharacter: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "/"
        
        return temp
        
    }()
    
    var totalParticipantCount: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        
        return temp
        
    }()
    
    var cancelButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        temp.addTarget(self, action: #selector(dismissViewController(_:)), for: .touchUpInside)
        
        return temp
    }()
    
    var nextButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        temp.addTarget(self, action: #selector(initiatePostProcess(_:)), for: .touchUpInside)
        
        return temp
    }()
    
    lazy var searchBar: UISearchBar = {
        
        let temp = UISearchBar()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var segmentedButton: UISegmentedControl = {
        let temp = UISegmentedControl()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    lazy var tableViewContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        return temp
    }()
    
    init(frame: CGRect, delegate : ViewPresentationProtocols, friendRelationChoise: FriendRelationViewChoise) {
        super.init(frame: frame)
        self.delegate = delegate
        self.friendRelationChoise = friendRelationChoise
        initiateViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - major functions
extension FriendGroupRelationView {
    
    private func initiateViewSettings() {
        
        addViews()
        configureViewSettings()
        addFriendRelationView()
        
    }
    
    private func configureViewSettings() {
        
        configureSearchBarSettings()
        configureSegmentedButtonSettings()
        
    }
    
    private func configureSearchBarSettings() {
        
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchBarProperties.searchField) as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        searchBar.searchBarStyle = .minimal
    }
    
    private func configureSegmentedButtonSettings() {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        switch friendRelationChoise {
        case .friend:
            segmentedButtonActivationManagement(active: false)
        case .group:
            segmentedButton.insertSegment(withTitle: LocalizedConstants.TitleValues.ButtonTitle.group, at: 0, animated: true)
            segmentedButton.insertSegment(withTitle: LocalizedConstants.TitleValues.ButtonTitle.newGroup, at: 1, animated: true)
            segmentedButtonActivationManagement(active: true)
            return
        }
        
    }
    
    private func segmentedButtonActivationManagement(active : Bool) {
        if active {
            segmentedButton.alpha = 1
            segmentedButtonHeigthConstraints.constant = Constants.StaticViewSize.ViewSize.Height.height_30
        } else {
            segmentedButton.alpha = 0
            segmentedButtonHeigthConstraints.constant = Constants.StaticViewSize.ViewSize.Height.height_0
        }
        
    }
    
    private func addViews() {
        
        self.addSubview(informationContainer)
        self.informationContainer.addSubview(topicInformationView)
        self.topicInformationView.addSubview(topViewInfo)
        self.counterInformationView.addSubview(selectedParticipantCount)
        self.counterInformationView.addSubview(sliceCharacter)
        self.counterInformationView.addSubview(totalParticipantCount)
        self.informationContainer.addSubview(counterInformationView)
        self.counterInformationView.addSubview(selectedParticipantCount)
        self.counterInformationView.addSubview(sliceCharacter)
        self.counterInformationView.addSubview(totalParticipantCount)
        self.addSubview(cancelButton)
        self.addSubview(nextButton)
        
        self.addSubview(searchBar)
        self.addSubview(segmentedButton)
        
        self.addSubview(tableViewContainer)
        
        let safe = self.safeAreaLayoutGuide
        let safeInformationContainer = self.informationContainer.safeAreaLayoutGuide
        let safeCounterInformation = self.counterInformationView.safeAreaLayoutGuide
        let safeTopicInformation = self.topicInformationView.safeAreaLayoutGuide
        let safeSelectedParticipant = self.selectedParticipantCount.safeAreaLayoutGuide
        let safeSliceCharacter = self.sliceCharacter.safeAreaLayoutGuide
        let safeSearchBar = self.searchBar.safeAreaLayoutGuide
        let safeSegmentedButton = self.segmentedButton.safeAreaLayoutGuide
        
        segmentedButtonHeigthConstraints = segmentedButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30)
        
        NSLayoutConstraint.activate([
            
            informationContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            informationContainer.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            informationContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_60),
            informationContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_200),
            
            topicInformationView.topAnchor.constraint(equalTo: safeInformationContainer.topAnchor),
            topicInformationView.leadingAnchor.constraint(equalTo: safeInformationContainer.leadingAnchor),
            topicInformationView.trailingAnchor.constraint(equalTo: safeInformationContainer.trailingAnchor),
            topicInformationView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            
            counterInformationView.topAnchor.constraint(equalTo: safeTopicInformation.bottomAnchor),
            counterInformationView.leadingAnchor.constraint(equalTo: safeInformationContainer.leadingAnchor),
            counterInformationView.trailingAnchor.constraint(equalTo: safeInformationContainer.trailingAnchor),
            counterInformationView.bottomAnchor.constraint(equalTo: safeInformationContainer.bottomAnchor),
            
            topViewInfo.leadingAnchor.constraint(equalTo: safeTopicInformation.leadingAnchor),
            topViewInfo.trailingAnchor.constraint(equalTo: safeTopicInformation.trailingAnchor),
            topViewInfo.topAnchor.constraint(equalTo: safeTopicInformation.topAnchor),
            topViewInfo.bottomAnchor.constraint(equalTo: safeTopicInformation.bottomAnchor),
            
            selectedParticipantCount.leadingAnchor.constraint(equalTo: safeCounterInformation.leadingAnchor),
            selectedParticipantCount.bottomAnchor.constraint(equalTo: safeCounterInformation.bottomAnchor),
            selectedParticipantCount.topAnchor.constraint(equalTo: safeCounterInformation.topAnchor),
            selectedParticipantCount.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ConstraintValues.constraint_90),
            
            sliceCharacter.leadingAnchor.constraint(equalTo: safeSelectedParticipant.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            sliceCharacter.bottomAnchor.constraint(equalTo: safeCounterInformation.bottomAnchor),
            sliceCharacter.topAnchor.constraint(equalTo: safeCounterInformation.topAnchor),
            sliceCharacter.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_10),
            
            totalParticipantCount.leadingAnchor.constraint(equalTo: safeSliceCharacter.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            totalParticipantCount.bottomAnchor.constraint(equalTo: safeCounterInformation.bottomAnchor),
            totalParticipantCount.topAnchor.constraint(equalTo: safeCounterInformation.topAnchor),
            totalParticipantCount.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_90),
            
            cancelButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ViewSize.Width.width_10),
            cancelButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_25),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            cancelButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            nextButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ViewSize.Width.width_10),
            nextButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_25),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            nextButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            searchBar.topAnchor.constraint(equalTo: safeInformationContainer.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            searchBar.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            segmentedButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            segmentedButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            segmentedButton.topAnchor.constraint(equalTo: safeSearchBar.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            segmentedButtonHeigthConstraints,
            
            tableViewContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            tableViewContainer.topAnchor.constraint(equalTo: safeSegmentedButton.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5)
            
            ])
        
    }
    
    @objc func dismissViewController(_ sender : UIButton) {
        
        delegate.dismissViewController()
    }
    
    private func addFriendRelationView() {
        friendRelationView = FriendRelationView()
        friendRelationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableViewContainer.addSubview(friendRelationView)
        
        let safe = self.tableViewContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            friendRelationView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            friendRelationView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            friendRelationView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            friendRelationView.topAnchor.constraint(equalTo: safe.topAnchor)
            
            ])
            
    }
    
}


