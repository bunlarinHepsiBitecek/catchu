//
//  FacebookContactList.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookContactList: UIView {

    private var requestView : FacebookContactRequestView!
    
    lazy var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return temp
    }()
    
    lazy var tableViewFacebookContactList: UITableView = {
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        temp.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        temp.register(UserViewCell.self, forCellReuseIdentifier: Constants.Collections.TableView.facebookContactTableViewCell)
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("accesstoken : \(FBSDKAccessToken.current()?.tokenString)")
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FacebookContactList {
    
    func initializeView() {
        
        addViews()
        addRequestView()
        
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(tableViewFacebookContactList)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            tableViewFacebookContactList.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor),
            tableViewFacebookContactList.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor),
            tableViewFacebookContactList.topAnchor.constraint(equalTo: safeContainerView.topAnchor),
            tableViewFacebookContactList.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),

            
            ])
        
    }
    
    func addRequestView() {
        
        requestView = FacebookContactRequestView(frame: .zero, delegate: self)
        requestView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(requestView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            requestView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            requestView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            requestView!.topAnchor.constraint(equalTo: safe.topAnchor),
            requestView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        decideFacebookRequetViewDisplay()
        
    }
    
    func activateFacebookRequestView(active : Bool) {
        if active {
            requestView.alpha = 1
        } else {
            requestView.alpha = 0
        }
    }
    
    
    func decideFacebookRequetViewDisplay() {
        
        print("initiateFacebookContackListFlow starts")
        
        if FacebookContactListManager.shared.returnFacebookFriendArrayExist() {
            
            UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
                self.activateFacebookRequestView(active: false)
            }
            
        } else {
            
            // if access token is expired, make requestView is active. RequestView has a facebook connect button to establish an updated connection between cliend and facebook server
            // otherwise (else), trigger a direct graphRequest to get a list of facebook friend via current accessToken.
            if FacebookContactListManager.shared.askAccessTokenExpire() {
                activateFacebookRequestView(active: true)
            } else {
                FacebookContactListManager.shared.initiateFacebookContactListProcess { (finish) in
                    if finish {
                        FacebookContactListManager.shared.getFacebookFriendsExistedInCatchU(completion: { (finish) in
                            if finish {
                                
                                DispatchQueue.main.async {
                                    self.activateFacebookRequestView(active: false)
                                    
                                    UIView.transition(with: self.tableViewFacebookContactList, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                                        self.tableViewFacebookContactList.reloadData()
                                    })
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func getViewModelUser(index : Int) -> ViewModelUser {
        
        switch FacebookContactListManager.shared.returnViewModelUser(index: index) {
        case .success(let data):
            /*
            if let user = data.user {
                return ViewModelUser(user: user)
            }*/
            return data
        default:
            return ViewModelUser(user: User())
        }
        
        return ViewModelUser(user: User())
        
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FacebookContactList : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return FacebookContactListManager.shared.returnFacebookArrayCount()
        return FacebookContactListManager.shared.returnFacebookViewModelUserArray()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableViewFacebookContactList.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.facebookContactTableViewCell, for: indexPath) as? UserViewCell else { return UITableViewCell()
        }
        
        cell.configure(item: getViewModelUser(index: indexPath.row))
        
        return cell
        
    }
    
}

// MARK: - SlideMenuProtocols
extension FacebookContactList : SlideMenuProtocols {
    func dismissView(active: Bool) {
        
        activateFacebookRequestView(active: active)
        
    }
    
    func dataLoadTrigger() {
        
        UIView.transition(with: self.tableViewFacebookContactList, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            self.tableViewFacebookContactList.reloadData()
        })
        
    }
}

// MARK: - ViewModelItem
extension FacebookContactList : ViewModelItem {
    
}

