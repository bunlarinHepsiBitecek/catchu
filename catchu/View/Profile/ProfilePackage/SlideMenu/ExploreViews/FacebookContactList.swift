//
//  FacebookContactList.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FacebookContactList: UIView {

    private var requestView : FacebookContactRequestView?
    
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
        
        temp.register(FacebookContactTableViewCell.self, forCellReuseIdentifier: Constants.Collections.TableView.facebookContactTableViewCell)
        
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
extension FacebookContactList {
    
    func initializeView() {
        
//        addViews()
        addRequestView()
        
    }
    
    func addViews() {
        
        self.addSubview(containerView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func addRequestView() {
        
        requestView = FacebookContactRequestView()
        requestView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(requestView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            requestView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            requestView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            requestView!.topAnchor.constraint(equalTo: safe.topAnchor),
            requestView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FacebookContactList : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FacebookContactListManager.shared.returnTwoDimensionalListCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FacebookContactListManager.shared.returnExpandableSectionContactListItemCount(index: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableViewFacebookContactList.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.facebookContactTableViewCell, for: indexPath) as? FacebookContactTableViewCell else { return UITableViewCell()
        }
        
        return cell
        
    }
    
    
}
