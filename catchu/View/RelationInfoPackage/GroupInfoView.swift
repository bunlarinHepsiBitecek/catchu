//
//  GroupInfoView.swift
//  catchu
//
//  Created by Erkut Baş on 12/13/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoView: UIView {

    private let imageContainerHeight = Constants.StaticViewSize.ConstraintValues.constraint_250
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    var header : ScretchableView!
    var navigationView = UIView()
    
    lazy var topView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    lazy var groupDetailTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        //temp.prefetchDataSource = self
        
        //temp.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        //temp.tableFooterView = UIView()
        //temp.contentInset = UIEdgeInsetsMake(imageContainerHeight, 0, 0, 0)
        
        temp.register(GroupInfoParticipantTableViewCell.self, forCellReuseIdentifier: GroupInfoParticipantTableViewCell.identifier)
        
        return temp
        
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.layer.masksToBounds = true
        return temp
    }()
    
    lazy var blurView2: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.layer.masksToBounds = true
        return temp
    }()
    
    lazy var backButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        temp.addTarget(self, action: #selector(backProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        
        return temp
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension GroupInfoView {
    
    private func initializeView() {
        //self.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        addViews()
    }
    
    private func addViews() {
        addMainViews()
        setupHeaderView()
        
        // NavigationHeader
        let navibarHeight : CGFloat = 44
        let statusbarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navibarHeight + statusbarHeight)
        //navigationView.backgroundColor = UIColor(red: 121/255.0, green: 193/255.0, blue: 203/255.0, alpha: 1.0)
        navigationView.backgroundColor = UIColor.clear
        navigationView.alpha = 0.0
        self.addSubview(navigationView)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        button.setImage(UIImage(named: "navi_back_btn")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.white
        self.addSubview(button)
        
        button.insertSubview(blurView, at: 0)
        
        let safe = button.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        navigationView.insertSubview(blurView2, at: 0)
        
        let safe2 = navigationView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView2.leadingAnchor.constraint(equalTo: safe2.leadingAnchor),
            blurView2.trailingAnchor.constraint(equalTo: safe2.trailingAnchor),
            blurView2.topAnchor.constraint(equalTo: safe2.topAnchor),
            blurView2.bottomAnchor.constraint(equalTo: safe2.bottomAnchor),
            
            ])
        
       // addBackButton()
        
        //groupDetailTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        /*
        let groupInfoProfileContainer = GroupInfoImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        groupDetailTableView.tableHeaderView = groupInfoProfileContainer
        */
    }
    
    private func addMainViews() {
        //self.addSubview(topView)
        self.addSubview(groupDetailTableView)
        
        let safe = self.safeAreaLayoutGuide
        let safeTopView = self.topView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupDetailTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupDetailTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupDetailTableView.topAnchor.constraint(equalTo: safe.topAnchor, constant: -statusBarHeight),
            groupDetailTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        //addBlurEffectToBackButton2()
    }
    
    private func addBackButton() {
        self.addSubview(backButton)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            backButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: safe.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            ])
        
        //addBlurEffectToBackButton()
        
    }
    
    private func addBlurEffectToBackButton() {
        backButton.insertSubview(blurView, at: 0)
        
        let safe = self.backButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    private func addBlurEffectToBackButton2() {
        topView.insertSubview(blurView, at: 0)
        
        let safe = self.topView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
    }
    
    func setupHeaderView() {
        
        let options = ScretchableViewOptions()
        options.position = .fullScreenTop
        
        print("self.frame.size.width : \(self.frame.size.width)")
        
        let currentViewController = LoaderController.currentViewController()
        
        header = ScretchableView()
        header.scretchableViewSize(headerSize: CGSize(width: UIScreen.main.bounds.width, height: 220),
                                 imageSize: CGSize(width: UIScreen.main.bounds.width, height: 220),
                                 controller: currentViewController!,
                                 options: options)
        header.imageView.image = UIImage(named: "8771.jpg")
        
        groupDetailTableView.tableHeaderView = header
    }
    
    @objc func backProcess(_ sender : UIButton) {
        print("\(#function)")
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GroupInfoView : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: GroupInfoParticipantTableViewCell.identifier, for: indexPath) as? GroupInfoParticipantTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(indexPath.row) + takasi bom bom"
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.imageView?.image = UIImage(named: "8771.jpg")
        
        cell.accessoryType = .detailButton
        
        
        return cell
        
    }
    
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
        // NavigationHeader alpha update
        let offset : CGFloat = scrollView.contentOffset.y
        if (offset > 50) {
            let alpha : CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(50) + (navigationView.frame.height) - offset) / (navigationView.frame.height))
            navigationView.alpha = CGFloat(alpha)
            
        } else {
            navigationView.alpha = 0.0;
        }
    }
    
}

