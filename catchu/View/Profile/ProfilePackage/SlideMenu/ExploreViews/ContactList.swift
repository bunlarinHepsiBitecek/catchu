//
//  ContactList.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MessageUI
import Contacts

class ContactList: UIView {
    
    private var contactListRequestView : ContactRequestView?
    
    weak var delegate : UserProfileViewProtocols!
    
    var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
    }()
    
    lazy var tableViewContactList: UITableView = {
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        
        temp.rowHeight = UITableView.automaticDimension
//        temp.tableFooterView = UIView()
        temp.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        temp.register(UserViewCell.self, forCellReuseIdentifier: Constants.Collections.TableView.contactSyncedTableViewCell)
        temp.register(ContactInvitationTableViewCell.self, forCellReuseIdentifier: Constants.Collections.TableView.contactTableViewCell)
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    init(frame: CGRect, delegate : UserProfileViewProtocols) {
        super.init(frame: frame)
        
        self.delegate = delegate
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ContactList {
    
    func initializeView() {
        
        addViews()
        addRequestView()
        decideContactRequetViewDisplay()
        
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(tableViewContactList)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            tableViewContactList.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor),
            tableViewContactList.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor),
            tableViewContactList.topAnchor.constraint(equalTo: safeContainerView.topAnchor),
            tableViewContactList.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),

            
            ])
        
    }
    
    func addRequestView() {
        
        contactListRequestView = ContactRequestView(frame: .zero, delegate: self)
        contactListRequestView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contactListRequestView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            contactListRequestView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            contactListRequestView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            contactListRequestView!.topAnchor.constraint(equalTo: safe.topAnchor),
            contactListRequestView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        //decideFacebookRequetViewDisplay()
        
    }
    
    func activateContactRequestView(active : Bool) {
        
        guard contactListRequestView != nil else { return }
        
        if active {
            contactListRequestView!.alpha = 1
        } else {
            contactListRequestView!.alpha = 0
        }
    }
    
    func decideContactRequetViewDisplay() {
        
        print("decideContactRequetViewDisplay starts")
        
        if ContactListManager.shared.isAtLeastOneContactListExist() {
            
            print("contact information exists")
            
            UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
                self.activateContactRequestView(active: false)
            }
            
        } else {
            
            print("contact information does not exist, fetch from contacts")
            
            ContactListManager.shared.initiateFetchContactBusiness { (finish) in
                if finish {
                    print("fetching contact information finished")
                    
                    DispatchQueue.main.async {
                        self.activateContactRequestView(active: false)
                        
                        UIView.transition(with: self.tableViewContactList, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                            self.tableViewContactList.reloadData()
                        })
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func getViewModelUser(index : Int) -> ViewModelUser {
        
        switch ContactListManager.shared.returnViewModelUser(index: index) {
        case .success(let data):
            /*
            if let user = data.user {
                return ViewModelUser(user: user)
            }*/
            
            return data
            
        default:
            return ViewModelUser(user: User())
        }
        
    }
    
}

// MARK: -
extension ContactList : SlideMenuProtocols {
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactList : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionCount = 0
        
        if let rawContactList = ContactListManager.shared.rawContactList {
            if rawContactList.count > 0 {
                sectionCount += 1
            }
        }
        
        if let userList = ContactListManager.shared.contactListUserArray {
            if userList.count > 0 {
                sectionCount += 1
            }
        }
        
        print("sectionCount : \(sectionCount)")
        return sectionCount
        
        //return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return ContactListManager.shared.returnUserListCount()
            /*
            if !ContactListManager.shared.contactListExists {
                return ContactListManager.shared.returnRawContactListCount()
            } else {
                return ContactListManager.shared.returnUserListCount()
            }*/
        } else if section == 1 {
            return ContactListManager.shared.returnRawContactListCount()
        } else {
            return 0
        }
        
        //return ContactListManager.shared.returnRawContactListCount()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let sectionView = SectionHeaderInfo()
            sectionView.configureView(explanation: LocalizedConstants.SlideMenu.activePeopleOnCatchU, count: ContactListManager.shared.returnUserListCount())
            
            return sectionView
            
        } else if section == 1 {
            let sectionView = SectionHeaderInfo()
            sectionView.configureView(explanation: LocalizedConstants.SlideMenu.invitePeopleOncatchU, count: ContactListManager.shared.returnRawContactListCount())
            
            return sectionView
        }
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("indexPath : \(indexPath.section)")
        if indexPath.section == 0 {
            
            guard let cell = tableViewContactList.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.contactSyncedTableViewCell, for: indexPath) as? UserViewCell else { return UITableViewCell() }
            
            cell.configure(viewModelItem: getViewModelUser(index: indexPath.row))
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableViewContactList.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.contactTableViewCell, for: indexPath) as? ContactInvitationTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(contact: ContactListManager.shared.returnRawContact(index: indexPath.row), delegate: self)
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
}

// MARK: - UserProfileViewProtocols
extension ContactList : UserProfileViewProtocols {
    
    func triggerInviteMessageProcess(contactData: CNContact) {
        
        let alertController = UIAlertController(title: LocalizedConstants.SlideMenu.inviteFriendTitle, message: LocalizedConstants.SlideMenu.inviteFriendInformation, preferredStyle: .actionSheet)
        
        for phone in contactData.phoneNumbers {
            
            let alertAction = UIAlertAction(title: phone.value.stringValue, style: .default) { (task) in
                self.delegate.presentMessageController(phoneNumber: phone.value.stringValue)
            }
            
            alertController.addAction(alertAction)
            
        }
        
        let cancelAction = UIAlertAction(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: .cancel) { (task) in
            print("cancel is tapped")
        }
        
        alertController.addAction(cancelAction)
        
        delegate.showAlertAction(alertController: alertController)
        
    }
    
}

