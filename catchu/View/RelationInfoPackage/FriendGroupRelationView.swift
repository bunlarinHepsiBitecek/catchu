//
//  FriendGroupRelationTopView.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendGroupRelationView: UIView {

    private var friendGroupRelationViewModel = FriendGroupRelationViewModel()
    
    weak var delegate : ViewPresentationProtocols!
    weak var delegatePostView : PostViewProtocols!
    
    private var friendRelationChoise : FriendRelationViewChoise!
    private var friendRelationPurpose : FriendRelationViewPurpose!
    private var friendRelationView : FriendRelationView!
    private var groupRelationView : GroupRelationView!

    // caller view controller choise
    
    
    // to make it segmented button visible to user or not
    private var segmentedButtonHeigthConstraints = NSLayoutConstraint()
    
    // post target informations
    private var selectedFriendList = Array<User>()
    private var selectedGroupList = Array<Group>()
    
    //private var selectedCommonUserViewModelList = Array<CommonUserViewModel>()
    
    // to sync current participants with user friend array
    private var participantArray: Array<User>?
    private var selectedGroup: Group?
    
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
        temp.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        temp.textAlignment = .right
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        
        return temp
        
    }()
    
    var sliceCharacter: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
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
        temp.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        temp.textAlignment = .left
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.text = "0"
        
        return temp
        
    }()
    
    var cancelButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.cancel, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        temp.addTarget(self, action: #selector(dismissViewController(_:)), for: .touchUpInside)
        
        return temp
    }()
    
    var nextButton: UIButton = {
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.contentMode = .center
        temp.titleLabel?.textAlignment = .center
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        temp.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)
        temp.isEnabled = false
        temp.titleLabel?.lineBreakMode = .byWordWrapping
        
        return temp
    }()
    
    lazy var searchBar: UISearchBar = {
        
        let temp = UISearchBar()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        //temp.setShowsCancelButton(true, animated: true)
        temp.placeholder = LocalizedConstants.SearchBar.searchFollower
        temp.delegate = self
        
        return temp
    }()
    
    lazy var segmentedButton: UISegmentedControl = {
        let temp = UISegmentedControl()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.addTarget(self, action: #selector(FriendGroupRelationView.segmentedButtonClicked(_:)), for: UIControl.Event.valueChanged)
        return temp
    }()
    
    lazy var tableViewContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
    }()
    
    init(frame: CGRect, delegate : ViewPresentationProtocols, delegatePostView : PostViewProtocols?, friendRelationChoise: FriendRelationViewChoise, friendRelationPurpose: FriendRelationViewPurpose, participantArray: Array<User>?, selectedGroup: Group?) {
        super.init(frame: frame)
        self.delegate = delegate
        self.delegatePostView = delegatePostView
        self.friendRelationChoise = friendRelationChoise
        self.friendRelationPurpose = friendRelationPurpose
        self.selectedGroup = selectedGroup
        
        if let participantArray = participantArray {
            self.participantArray = participantArray
        }
        
        // initialize view
        initiateViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        friendGroupRelationViewModel.groupCreationRemovedParticipant.unbind()
        friendGroupRelationViewModel.resetFriendRelationView.unbind()
        friendGroupRelationViewModel.resetGroupRelationView.unbind()
        friendGroupRelationViewModel.nextButtonActivation.unbind()
    }
    
}

// MARK: - major functions
extension FriendGroupRelationView {
    
    private func initiateViewSettings() {
        
        addViews()
        addFriendRelationViews(choise: friendRelationChoise)
        configureViewSettings()
        addGestures()
        setTopViewInformation()
        
    }
    
    private func addFriendRelationViews(choise: FriendRelationViewChoise) {
        switch choise {
        case .friend:
            self.addFriendRelationView()
            self.friendRelationView.viewActivationManager(active: true, animated: true)
        case .group:
            self.addGroupRelationView()
            self.addFriendRelationView()
            self.activationManagerOfCounterInformationView(active: false, animated: false)
        }
    }
    
    private func configureViewSettings() {
        
        setupSearchBarSettings()
        configureSegmentedButtonSettings()
        addObserverForNextButtonActivation()
        configureButtonSettings()
        addObserverToCounterSettings()
        addObserverForSelectedGroup()
        listenGroupCreationChanges ()

        /*
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        // the configurations below is related to friendRelationView
        if friendRelationChoise == .friend {
        }*/
        
    }
    
    private func setupSearchBarSettings() {
        
        searchBar.configureSearchBarSettings()
        
        /*
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchBarProperties.searchField) as? UITextField

        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        searchBar.searchBarStyle = .minimal*/
    }
    
    private func configureSegmentedButtonSettings() {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        switch friendRelationChoise {
        case .friend:
            segmentedButtonActivationManagement(active: false)
        case .group:
            segmentedButton.insertSegment(withTitle: LocalizedConstants.TitleValues.ButtonTitle.group, at: 0, animated: true)
            segmentedButton.insertSegment(withTitle: LocalizedConstants.TitleValues.ButtonTitle.newGroup, at: 1, animated: true)
            segmentedButton.selectedSegmentIndex = 0
            segmentedButtonActivationManagement(active: true)
            return
        }
        
    }
    
    private func addObserverForNextButtonActivation() {
        // add observer for group management process
        friendGroupRelationViewModel.nextButtonActivation.bind { (state) in
            self.nextButtonActivationManager(state: state)
        }
    }
    
    private func nextButtonActivationForGroupManagementProcess(_ activeSegment: Int) {
        if activeSegment == 0 {
            friendGroupRelationViewModel.nextButtonActivation.value = .passise
        } else {
            friendGroupRelationViewModel.nextButtonActivation.value = .active
        }
    }
    
    private func configureButtonSettings() {
        guard let friendRelationPurpose = friendRelationPurpose else { return }
        
        switch friendRelationPurpose {
        case .groupManagement:
            cancelButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.back, for: .normal)
            self.nextButtonActivationForGroupManagementProcess(returnSegmentedButtonIndex())
        default:
            return
        }
    }
    
    
    /// OBSERVERS - begin
    /// Description : adding observer to counter labels on top information view
    private func addObserverToCounterSettings() {
        
        friendRelationView.startObserverForSelectedFriendCount { (counter) in
            
            DispatchQueue.main.async {
                UIView.transition(with: self.totalParticipantCount, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                    self.selectedParticipantCount.text = "\(counter)"
                })
            }
        }
        
        friendRelationView.startObserverForTotalFriendCount { (totalCount) in
            
            DispatchQueue.main.async {
                
                UIView.transition(with: self.totalParticipantCount, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                    self.totalParticipantCount.text = "\(totalCount)"
                })
            }
            
        }
        
        friendRelationView.addSelectedFriendCountObserver { (counter) in
            
            DispatchQueue.main.async {
                UIView.transition(with: self.totalParticipantCount, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                    self.selectedParticipantCount.text = "\(counter)"
                })
            }
        }
        
        friendRelationView.startObserverForSelectedUserList { (userList) in
            print("userList : \(userList)")
            print("userList.count : \(userList.count)")
            self.selectedFriendList = userList
            self.nextButtonManagement(count: userList.count)
            /*
            if self.selectedFriendList.count > 0 {
                self.nextButtonEnableManagement(enable: true)
            } else {
                self.nextButtonEnableManagement(enable: false)
            }*/
            
        }
        
        friendRelationView.startObserverForSelectedCommonUserViewModelList { (commonUserViewModelList) in
            print("commonUserViewModelList :\(commonUserViewModelList)")
            print("commonUserViewModelList.count :\(commonUserViewModelList.count)")
            
            self.friendGroupRelationViewModel.selectedCommonUserViewModelList = commonUserViewModelList
            
        }
        
    }
    
    private func addObserverForSelectedGroup() {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        switch friendRelationChoise {
        case .friend:
            return
        case .group:
            groupRelationView.startObservingForSelectedGroup { (groupList) in
                print("groupList : \(groupList)")
                print("groupList count : \(groupList.count)")
                self.selectedGroupList = groupList
                self.nextButtonManagement(count: groupList.count)
                
            }
        }
        
    }
    
    private func nextButtonActivationManager(state: CommitButtonStates) {
        switch state {
        case .active:
            nextButton.alpha = 1
        case .passise:
            nextButton.alpha = 0
        }
    }
    
    // group creation view listeners
    private func listenGroupCreationChanges () {
        friendGroupRelationViewModel.groupCreationRemovedParticipant.bind { (commonUserViewModel) in
            print("commonUserViewModel : \(commonUserViewModel)")
            print("commonUserViewModel state : \(commonUserViewModel.userSelected.value)")
            self.triggerFriendSelectionViewItemRemoveProcess(commonUserViewModel: commonUserViewModel)
        }
        
        friendGroupRelationViewModel.resetFriendRelationView.bind { (finished) in
            if finished {
                self.clearFriendSelectionCollectionViewData(active : finished)
                self.closeFriendSelectionCollectionView()
            }
        }
        
        friendGroupRelationViewModel.resetGroupRelationView.bind { (commonGroupViewModel) in
            self.triggerNewGroupAddProcess(newGroup: commonGroupViewModel)
            DispatchQueue.main.async {
//                self.friendGroupActivationManager(selectedIndex: 0)
                self.focusGroupSegment()
            }
        }
        
    }
    /// OBSERVERS - end
    
    private func triggerFriendSelectionViewItemRemoveProcess(commonUserViewModel: CommonUserViewModel) {
        friendRelationView.selectedFriendListAnimationManagement2(commonUserViewModel)
    }
    
    private func clearFriendSelectionCollectionViewData(active: Bool) {
        friendRelationView.callTriggerCollectionClear(active: active)
    }
    
    private func closeFriendSelectionCollectionView() {
        // in order to trigger close animation of friendselection collectionView
        DispatchQueue.main.async {
            self.friendRelationView.closeFriendSelectionCollectionView(activation: .disable)
        }
    }
    
    private func triggerNewGroupAddProcess(newGroup: CommonGroupViewModel) {
        groupRelationView.getNewGroupOutside(newGroup: newGroup)
    }
    
    func nextButtonManagement(count : Int) {
        
        if count > 0 {
            self.nextButtonEnableManagement(enable: true)
        } else {
            self.nextButtonEnableManagement(enable: false)
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
    
    private func nextButtonEnableManagement(enable : Bool) {
        nextButton.isEnabled = enable
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
            cancelButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_60),
            
            nextButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ViewSize.Width.width_10),
            nextButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_25),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            nextButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_70),
            
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
        
        friendRelationView = FriendRelationView(frame: .zero, participantArray: participantArray, friendRelationPurpose: friendRelationPurpose)
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
    
    private func addGroupRelationView() {
        groupRelationView = GroupRelationView(frame: .zero, friendRelationPurpose: friendRelationPurpose)
        groupRelationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableViewContainer.addSubview(groupRelationView)
        
        let safe = self.tableViewContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupRelationView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupRelationView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupRelationView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            groupRelationView.topAnchor.constraint(equalTo: safe.topAnchor)
            
            ])
    }
    
    private func directToGroupCreationViewController() {
        
        let groupCreationViewController = NewGroupCreationViewController()
        groupCreationViewController.groupCreationControllerViewModel = GroupCreationControllerViewModel(selectedCommonUserViewModelList: self.friendGroupRelationViewModel.selectedCommonUserViewModelList, friendGroupRelationViewModel: friendGroupRelationViewModel)
        
        let navigationViewController = UINavigationController(rootViewController: groupCreationViewController)
        
        if let currentViewController = LoaderController.currentViewController() {
            currentViewController.present(navigationViewController, animated: true) {
                print("NewGroupCreationViewController is presented!")
            }
        }
        
    }
    
    @objc func nextPressed(_ sender : UIButton) {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        guard let friendRelationPurpose = friendRelationPurpose else { return }

        switch friendRelationPurpose {
        // it means that FriendRelationViewController is called from PostViewController for attach a target person(s) or a group
        case .post:
            
            switch friendRelationChoise {
            case .friend:
                PostItems.shared.createSelectedFriendArray(userList: selectedFriendList)
            case .group:
                let activeSegment = returnSegmentedButtonIndex()
                if activeSegment == 0 {
                    if let groupid = selectedGroupList[0].groupID {
                        PostItems.shared.groupid = groupid
                    }
                } else if activeSegment == 1 {
                    // to make a create new group process
                    self.directToGroupCreationViewController()
                    // return statement is required. Because, if function does not return from this line, later it tries to set post target information before we set any value to it.
                    return
                }
            }
            
            // delegatePostView could be nil. User does not have to set delegation.
            if delegatePostView != nil {
                delegatePostView.setPostTargetInformation(info: returnInformationForSelectedListData())
            }
            
            delegate.dismissViewController()
            
        case .groupManagement:
            switch friendRelationChoise {
            case .friend:
                // we have no need to get friend tab in group management page
                return
            case .group:
                self.directToGroupCreationViewController()
            }
            
        case .participant:
            
            if delegatePostView != nil {
                AlertControllerManager.shared.startActionSheetManager(type: .newParticipant, operationType: nil, delegate: self, title: createTitleForNewParticipants())
            }
            
            return
        }
        
    }
    
    private func returnInformationForSelectedListData() -> String {
        
        var finalInformationText = ""
        let information = "Posting to "
        
        if let friendRelationChoise = friendRelationChoise {
            switch friendRelationChoise {
            case .friend:
                let extraPartCount = selectedFriendList.count - 1
                
                if selectedFriendList.count == 1 {
                    if let user = selectedFriendList.first {
                        if let username = user.username {
                            finalInformationText = information + username
                        } else if let name = user.name {
                            finalInformationText = information + name
                        }
                    }
                } else if selectedFriendList.count > 1 {
                    if let user = selectedFriendList.first {
                        if let username = user.username {
                            finalInformationText = information + username + " and " + "\(extraPartCount)" + " others..."
                        } else if let name = user.name {
                            finalInformationText = information + name + " and " + "\(extraPartCount)" + " more others..."
                        }
                    }
                }
                
            case .group:
                if let groupName = selectedGroupList[0].groupName {
                    finalInformationText = information + "\"" + groupName + "\""
                }
            }
        }
        
        return finalInformationText
    }
    
    /// Description : creates title of action sheet for adding new participants
    ///
    /// - Returns: title value
    private func createTitleForNewParticipants() -> String {
        
        var title = "Add "
        var count = 0
        
        if selectedFriendList.count > 4 {
            for item in selectedFriendList {
                if let name = item.name {
                    title += name
                }
                
                count += 1
                
                if selectedFriendList.endIndex < 4 {
                    title += ", "
                }
                
                if count > 4 {
                    break
                }
            }
            
            let countValue = "\(selectedFriendList.count - 4)"
            let part1 = " and " + countValue
            var part2 = ""
            if let groupName = selectedGroup?.groupName {
                part2 = " to \"" + groupName
            }
            let part3 = "\" group."
            let part4 = part1 + part2 + part3
            
            title += part4
            
        } else {
            
            for item in selectedFriendList {
                if let name = item.name {
                    title += name
                }
                
                count += 1
                
                if selectedFriendList.endIndex != count {
                    title += ", "
                }
                
            }
            
            if let groupName = selectedGroup?.groupName {
                title =  title + " to \"" + groupName + "\" group."
            }
            
        }
        
        return title
        
    }
    
    @objc func segmentedButtonClicked(_ sender : UISegmentedControl) {
        print("\(#function)")
        
        //resetSearchProcessAccordingToSegmentClicked()
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        guard let friendRelationPurpose = friendRelationPurpose else { return }
        
        switch friendRelationChoise {
        case .group:
            self.friendGroupActivationManager(selectedIndex: sender.selectedSegmentIndex)
            
            switch friendRelationPurpose {
            case .groupManagement:
                self.nextButtonActivationForGroupManagementProcess(returnSegmentedButtonIndex())
            default:
                return
            }
            
        case .friend:
            return
        }
    }
    
    private func resetSearchProcessAccordingToSegmentClicked() {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = nil
        
        /*
        let activeSegment = returnSegmentedButtonIndex()
        let searchTool = SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false)
        
        if activeSegment == 0 {
            friendRelationView.triggerSearchProcess(searchTool: searchTool)
        } else if activeSegment == 1 {
            groupRelationView.triggerSearchProcess(searchTool: searchTool)
        }*/
    }
    
    private func friendGroupActivationManager(selectedIndex : Int) {
        
        setNextButtonTitle(index: selectedIndex)
        
        if selectedIndex == 0 {
            groupRelationView.viewActivationManager(active: true, animated: true)
            friendRelationView.viewActivationManager(active: false, animated: true)
            self.activationManagerOfCounterInformationView(active: false, animated: false)
            self.nextButtonManagement(count: selectedGroupList.count)
        } else if selectedIndex == 1 {
            groupRelationView.viewActivationManager(active: false, animated: true)
            friendRelationView.viewActivationManager(active: true, animated: true)
            self.activationManagerOfCounterInformationView(active: true, animated: true)
            self.nextButtonManagement(count: selectedFriendList.count)
        }
        
    }
    
    private func focusGroupSegment() {
        segmentedButton.selectedSegmentIndex = 0
        friendGroupActivationManager(selectedIndex: 0)
    }
    
    private func activationManagerOfCounterInformationView(active : Bool, animated : Bool) {
    
        if animated {
            UIView.transition(with: self.counterInformationView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                if active {
                    self.counterInformationView.alpha = 1
                } else {
                    self.counterInformationView.alpha = 0
                }
            })
            
        } else {
            if active {
                self.counterInformationView.alpha = 1
            } else {
                self.counterInformationView.alpha = 0
            }
        }
        
    }
    
    private func setNextButtonTitle(index : Int) {
        if index == 0 {
            nextButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        } else if index == 1 {
            nextButton.setTitle(LocalizedConstants.TitleValues.ButtonTitle.createGroup, for: .normal)
        }
    }
    
    private func returnSegmentedButtonIndex() -> Int {
        return segmentedButton.selectedSegmentIndex
    }
    
    private func searchBarProgressManager(text: String){
        print("\(#function)")
        print("text : \(text)")
        
        var searchTool = SearchTools(searchText: text, searchIsProgress: false)
        
        if text.isEmpty {
            searchTool.searchIsProgress = false
        } else {
            searchTool.searchIsProgress = true
        }
        
        self.triggerSearchProcess(searchTool: searchTool)
        
    }
    
    private func triggerSearchProcess(searchTool: SearchTools) {
        
        guard let friendRelationChoise = friendRelationChoise else { return }
        
        switch friendRelationChoise {
        case .friend:
            friendRelationView.triggerSearchProcess(searchTool: searchTool)
        case .group:
            let activeSegment = self.returnSegmentedButtonIndex()
            
            if activeSegment == 0 {
                groupRelationView.triggerSearchProcess(searchTool: searchTool)
            } else if activeSegment == 1 {
                friendRelationView.triggerSearchProcess(searchTool: searchTool)
            }
        }
        
    }
    
    private func setTopViewInformation() {
        if let friendRelationPurpose = friendRelationPurpose {
            switch friendRelationPurpose {
            case .groupManagement:
                DispatchQueue.main.async {
                    self.topViewInfo.text = LocalizedConstants.TitleValues.LabelTitle.groupManagement
                }
            default:
                return
            }
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension FriendGroupRelationView : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(#function)")
        
        if let text = searchBar.text {
            self.searchBarProgressManager(text: text)
            
            if text.isEmpty {
                searchBar.resignFirstResponder()
                searchBar.setShowsCancelButton(false, animated: true)
            }
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("\(#function)")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.text = Constants.CharacterConstants.EMPTY
        self.searchBarProgressManager(text: Constants.CharacterConstants.EMPTY)
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension FriendGroupRelationView : UIGestureRecognizerDelegate {
    
    func addGestures() {
        //addTapGesturesToMainView()
    }
    
    func addTapGesturesToMainView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(FriendGroupRelationView.dismissKeyboard(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard(_ sender : UITapGestureRecognizer) {
        print("\(#function) starts")
        
        //self.endEditing(true)
    }
}

// MARK: - ActionSheetProtocols
extension FriendGroupRelationView : ActionSheetProtocols {
    
    func returnOperations(selectedProcessType: ActionButtonOperation) {
        switch selectedProcessType {
        case .addNewParticipant:
            delegatePostView.returnAddedParticipants(participantArray: selectedFriendList)
            delegate.dismissViewController()
        default:
            return
        }
    }
    
}
