//
//  GroupInfoView2.swift
//  catchu
//
//  Created by Erkut Baş on 12/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoView2: UIView {

    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private let groupImageContainerViewHeight : CGFloat = 80
    private let groupImageContainerVisibleHeight : CGFloat = 40
    
    lazy var groupDetailTableView: UITableView = {
        
        //let temp = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 700), style: UITableView.Style.plain)
        let temp = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.contentInset = UIEdgeInsets(top: groupImageContainerViewHeight + statusBarHeight, left: 0, bottom: 0, right: 0)
        //temp.contentInsetAdjustmentBehavior = .automatic
        
        temp.register(GroupInfoParticipantTableViewCell.self, forCellReuseIdentifier: GroupInfoParticipantTableViewCell.identifier)
        
        return temp
        
    }()
    
    lazy var groupImageContainer: UIView = {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: groupImageContainerViewHeight))
        //temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return temp
    }()
    
    lazy var imageHolder: UIImageView = {
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 344))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.image = UIImage(named: "8771.jpg")
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension GroupInfoView2 {
    
    private func initializeView() {
        
        addViews()
        //addGroupInfoImageView()
        
    }
    
    private func addViews() {
        
        self.addSubview(groupDetailTableView)
        self.addSubview(groupImageContainer)
        self.groupImageContainer.addSubview(imageHolder)
        
        let safe = self.safeAreaLayoutGuide
        let safeGroupImageContainer = self.groupImageContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            groupDetailTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupDetailTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupDetailTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            groupDetailTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            groupImageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            groupImageContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            groupImageContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            //            groupImageContainer.heightAnchor.constraint(equalToConstant: 150),
            
            imageHolder.leadingAnchor.constraint(equalTo: safeGroupImageContainer.leadingAnchor),
            imageHolder.trailingAnchor.constraint(equalTo: safeGroupImageContainer.trailingAnchor),
            imageHolder.topAnchor.constraint(equalTo: safeGroupImageContainer.topAnchor, constant: -statusBarHeight),
            imageHolder.bottomAnchor.constraint(equalTo: safeGroupImageContainer.bottomAnchor),
            
            ])
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupInfoView2 : UITableViewDelegate, UITableViewDataSource {
    
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
        cell.imageView?.clipsToBounds = true
        
        cell.accessoryType = .detailButton
        
        
        return cell
        
    }
    
}

// MARK: - scroll override functions
extension GroupInfoView2 {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("yarro scroll")
        let y = (groupImageContainerViewHeight) - (scrollView.contentOffset.y + groupImageContainerViewHeight)
        let height = min(max(y, groupImageContainerVisibleHeight), UIScreen.main.bounds.height)
        print("scrollView.contentOffset.y : \(scrollView.contentOffset.y)")
        print("y : \(y)")
        print("height : \(height)")
        groupImageContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
    }
    
}
