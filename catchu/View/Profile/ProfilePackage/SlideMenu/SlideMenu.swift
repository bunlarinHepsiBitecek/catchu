//
//  SlideMenu.swift
//  catchu
//
//  Created by Erkut Baş on 11/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SlideMenu: UIView {

    private var userName : UILabel!
    private var userNameSurname : UILabel!
    private var profileViewLoaded : Bool = false
    
    lazy var mainView: UIView = {
        
        let temp = UIView()
//        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()

    lazy var topView: UIView = {
        
        let temp = UIView()
//        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return temp
    }()
    
    lazy var profilePictureContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        
        return temp
    }()
    
    lazy var profilePictureView: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
        temp.layer.borderWidth = 1
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_50
        temp.clipsToBounds = true
        
        return temp
    }()
    
    lazy var stackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: returnUserInformationViews())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    lazy var bodyView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        return temp
    }()
    
    lazy var menuTableView: UITableView = {
        let temp = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        temp.dataSource = self
        temp.delegate = self
        
        temp.register(SlideMenuTableViewCell.self, forCellReuseIdentifier: Constants.Collections.TableView.slideMenuTableViewCell)
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initiateView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addShadowToProfileContainerView()
    }
    
}

// MARK: - major functions
extension SlideMenu {
    
    func initiateView() {
        
        addViews()
        addSwipeGestureRecognizer()
        
    }
    
    func addViews() {
        
        print("self.frame : \(self.frame)")
        
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        topView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: Constants.StaticViewSize.ViewSize.Height.height_200)
        
        self.addSubview(mainView)
        self.mainView.addSubview(topView)
        
        self.mainView.addSubview(bodyView)
        
        self.topView.addSubview(profilePictureContainerView)
        self.profilePictureContainerView.addSubview(profilePictureView)
        self.topView.addSubview(stackView)
        
        let safe = self.safeAreaLayoutGuide
        let safeMain = self.mainView.safeAreaLayoutGuide
        let safeTopMain = self.topView.safeAreaLayoutGuide
        let safeProfilePictureContainerView = self.profilePictureContainerView.safeAreaLayoutGuide
        
        print("superview : \(self.superview)")
        print("superview : \(self.superview)")
        
        
        
        NSLayoutConstraint.activate([
            
            profilePictureContainerView.topAnchor.constraint(equalTo: safeTopMain.topAnchor, constant: 10),
            profilePictureContainerView.centerXAnchor.constraint(equalTo: safeTopMain.centerXAnchor),
            profilePictureContainerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            profilePictureContainerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            
            profilePictureView.centerXAnchor.constraint(equalTo: safeProfilePictureContainerView.centerXAnchor),
            profilePictureView.centerYAnchor.constraint(equalTo: safeProfilePictureContainerView.centerYAnchor),
            profilePictureView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            profilePictureView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ImageViewSize.profilePicture_100),
            
            stackView.leadingAnchor.constraint(equalTo: safeTopMain.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: safeTopMain.bottomAnchor, constant: -10),
            
            bodyView.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: safeTopMain.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor),
            
            ])
        
    }
    
    func returnUserInformationViews() -> [UIView] {
        
        var viewArray = [UIView]()
        
        userName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        userName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        userName.textAlignment = .left
        userName.contentMode = .center
        userName.text = "UserName"
        
        viewArray.append(userName)
        
        userNameSurname = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        userNameSurname.font = UIFont.systemFont(ofSize: 13, weight: .light)
        userNameSurname.textAlignment = .left
        userNameSurname.contentMode = .center
        userNameSurname.text = "Name_Surname"
        
        viewArray.append(userNameSurname)
        
        return viewArray
        
    }
    
    func setUserInformationToViews() {
        print("setUserInformationToViews starts")
        print("User.shared.name : \(User.shared.name)")
        
        if let name = User.shared.name {
            self.userNameSurname.text = name
        }
        
        if let userName = User.shared.username {
            self.userName.text = userName
        }
        
        if let profilePictureURL = User.shared.profilePictureUrl {
            self.profilePictureView.setImagesFromCacheOrFirebaseForFriend(profilePictureURL)
        }
        
    }
    
    func addShadowToProfileContainerView() {
        
        print("addShadowToProfileContainerView starts")
        print("profilePictureView.bounds : \(profilePictureView.bounds)")
        
        if profilePictureContainerView.bounds.height > 0 {
            
            if !profileViewLoaded {
                
                self.profilePictureContainerView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.profilePictureContainerView.layer.shadowOffset = .zero
                self.profilePictureContainerView.layer.shadowOpacity = 2;
                self.profilePictureContainerView.layer.shadowRadius = 5;
                self.profilePictureContainerView.layer.shadowPath = UIBezierPath(roundedRect: profilePictureContainerView.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_50).cgPath
                
                profileViewLoaded = true
                
            }
            
        }
    
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension SlideMenu : UIGestureRecognizerDelegate {
    
    func addSwipeGestureRecognizer() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SlideMenu.swipeToClose(_:)))
        swipeGesture.direction = .left
        swipeGesture.delegate = self
        mainView.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeToClose(_ sender : UISwipeGestureRecognizer) {
        
        print("swipeToClose starts")
        
        switch sender.direction {
        case .left:
            SlideMenuLoader.shared.animateSlideMenu(active: false)
            return
        default:
            break
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SlideMenu : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = menuTableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.slideMenuTableViewCell, for: indexPath) as? SlideMenuTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "Deneme"
        
        return cell
        
    }
    
    
    
    
}
