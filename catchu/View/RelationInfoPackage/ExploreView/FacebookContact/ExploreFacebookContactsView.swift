//
//  ExploreFacebookContactsView.swift
//  catchu
//
//  Created by Erkut Baş on 1/22/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreFacebookContactsView: UIView {

    
    //private var requestView : FacebookContactRequestView!
    private var exploreFacebookViewModel = ExploreFacebookViewModel()
    private var requestView = FacebookContactRequestView(frame: .zero)
    
    lazy var searchBarHeaderView: SearchBarHeaderView = {
        let temp = SearchBarHeaderView()
        temp.frame.size = temp.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        print("temp.frame : \(temp.frame.size)")
        return temp
    }()
    
    lazy var facebookTableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        // delegations
        temp.delegate = self
        temp.dataSource = self
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.none
        temp.rowHeight = UITableView.automaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(ExploreFacebookContactTableViewCell.self, forCellReuseIdentifier: ExploreFacebookContactTableViewCell.identifier)
        
        temp.backgroundView = requestView
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        refreshControl.addTarget(self, action: #selector(ExploreFacebookContactsView.triggerRefreshProcess(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedConstants.TitleValues.LabelTitle.refreshing)
        
        temp.refreshControl = refreshControl
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        exploreFacebookViewModel.searchTool.unbind()
        exploreFacebookViewModel.state.unbind()
        exploreFacebookViewModel.refreshProcessState.unbind()
    }
    
}

// MARK: - major functions
extension ExploreFacebookContactsView {
    
    private func initializeViewSettings() {
        addViews()
        addFacebookViewModelListeners()
        getFacebookFriends()
        getSearchHeaderListener()
        addRequestViewListener()
        
    }
    
    private func addViews() {
        self.addSubview(facebookTableView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            facebookTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            facebookTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            facebookTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            facebookTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        tableViewActivationManager(active: false)
    }
    
    private func addFacebookViewModelListeners() {
        exploreFacebookViewModel.state.bind { (state) in
            self.facebookTableViewStateManager(state: state)
        }
        
        exploreFacebookViewModel.searchTool.bind { (searchTool) in
            self.triggerSearchProcess(searchTool: searchTool)
        }
        
        exploreFacebookViewModel.refreshProcessState.bind { (operationState) in
            self.handleRefreshControllState(state: operationState)
        }
        
    }
    
    private func handleRefreshControllState(state: CRUD_OperationStates) {
        switch state {
        case .processing:
            self.exploreFacebookViewModel.refreshProcess()
        case .done:
            self.refreshControllerActivationManager(active: false)
        }
    }
    
    private func facebookTableViewStateManager(state: TableViewState) {
        // to do
        switch state {
        case .populate:
            self.reloadFacebookTableView()
            self.tableViewActivationManager(active: true)
        default:
            return
        }
    }
    
    private func refreshControllerActivationManager(active: Bool) {
        
        DispatchQueue.main.async {
            guard let refreshControl = self.facebookTableView.refreshControl else { return }
            
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    private func reloadFacebookTableView() {
        DispatchQueue.main.async {
            self.facebookTableView.reloadData()
        }
    }
    
    private func addHeaderViewToTableView() {
        facebookTableView.tableHeaderView = searchBarHeaderView
    }
    
    private func tableViewActivationManager(active: Bool) {
        DispatchQueue.main.async {
            self.facebookTableView.isScrollEnabled = active
            self.facebookTableView.backgroundView?.isHidden = active
            
            if active {
                self.facebookTableView.tableHeaderView = self.searchBarHeaderView
            } else {
                self.facebookTableView.tableHeaderView = nil
            }
        }
        
    }
    
    private func getFacebookFriends() {
        exploreFacebookViewModel.startFetchingFacebookFriendsExistInApp()
        
    }
    
    private func getSearchHeaderListener() {
        searchBarHeaderView.getSearchActions { (searchTool) in
            print("searchTool : \(searchTool)")
            self.exploreFacebookViewModel.searchTool.value = searchTool
        }
    }
    
    private func triggerSearchProcess(searchTool: SearchTools) {
        exploreFacebookViewModel.searchFacebookFriendsInTableViewData(inputText: searchTool.searchText)
    }
    
    @objc private func triggerRefreshProcess(_ sender: UIRefreshControl) {
        exploreFacebookViewModel.refreshProcessState.value = .processing
    }
    
    private func addRequestViewListener() {
        requestView.listenConnectionRequestTriggered { (triggered) in
            self.triggerConnectionRequestToFacebook(triggered: triggered)
        }
    }
    
    private func triggerConnectionRequestToFacebook(triggered: Bool) {
        if triggered {
            exploreFacebookViewModel.startFetchingFacebookFriendsExistInAppByConnectionRequest()
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ExploreFacebookContactsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exploreFacebookViewModel.returnFacebookFriendsArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = facebookTableView.dequeueReusableCell(withIdentifier: ExploreFacebookContactTableViewCell.identifier, for: indexPath) as? ExploreFacebookContactTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: exploreFacebookViewModel.returnFacebookFriendsArrayData(index: indexPath.row))
        
        return cell
    }
    
    
}

// MARK: - major functions
extension ExploreFacebookContactsView {
    
    private func initializeView() {
        configureViewSettings()
    }
    
    private func configureViewSettings() {
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
}

// MARK: - PageItems
extension ExploreFacebookContactsView: PageItems {
    var title: String? {
        get {
            return LocalizedConstants.SlideMenu.facebook
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return nil
        }
        set {
            _ = newValue
        }
    }
}

/*

 Barometre altimeter - yüksek bir lokasyonda yapılan paylaşım
 Google api dan rakım ölçer.
 Accelometre - kişinin ayakta olup olmadığı veya oturdugu bilgisi
 
 image processing ile objenin en dogru yere konumlandırılması. Bina üzerinde ya da yüksek bölgelere bırakılan objeler için kullanıcı yönlendirmesi.
 
 100 mt yarıcapındasınız, tırmanıstasınız ? objeyi yakaladınız ama nerede ? Barometre ve rakım ile objeyi konumlandırmak, image processing ile etraftakı cisimlerin algılanması ve datanın onların önünde yer alması.
 
 compass
 
 Mekan içerisinde isek, marker based veya image processing ile obje yerleştirme.
 
 recommendation algoritmaları
 
*/
