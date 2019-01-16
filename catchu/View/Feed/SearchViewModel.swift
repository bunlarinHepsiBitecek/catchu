//
//  SearchViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/14/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class SearchViewModel: BaseViewModel, ViewModel {
    let sectionCount = 1
    var page = 1
    var perPage = 20
    private var items = [ViewModelItem]()  // mutable array
    var filteredItems = [ViewModelItem]()
    
    var searchTimer: Timer?
    let state = Dynamic(TableViewState.suggest)
    
    func search(text: String) {
        let text = text.lowercased()
        searchTimer?.invalidate()
        print("timer basladi")
        
        if text.isEmpty {
            removeAll()
            return
        }
        
        
        filterItems(text)
        state.value = .loading
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            print("tetiklendi")
            self.searchUser(text)
        })
    }
    
    func filterItems(_ text: String) {
        let filteredUser = items.compactMap {$0 as? ViewModelUser}.compactMap {$0.user}.filter {$0.name?.lowercased().range(of: text) != nil || $0.username?.lowercased().range(of: text) != nil }
        filteredItems = filteredUser.compactMap {ViewModelUser(user: $0)}
    }
    
    func removeAll() {
        state.value = .suggest
        items.removeAll()
        
        // MARK: ek
        filteredItems = items
    }
    
    func searchUser(_ text: String) {
        REAWSManager.shared.searchUsersGet(searchText: text, page: page, perPage: perPage) { (result) in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    private func handleResult(_ result: NetworkResult<REUserListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                state.value = .error
                return
            }
            
            guard let users = response.items else { return }
            
            var newItems = [User]()
            for user in users {
                newItems.append(User(user: user))
            }
            self.populate(users: newItems)
            
        case .failure(let apiError):
            state.value = .error
            switch apiError {
            case .serverError(let error):
                print("Server error: \(error)")
            case .connectionError(let error) :
                print("Connection error: \(error)")
            case .missingDataError:
                print("Missing Data Error")
            }
        }
    }
    
    private func populate(users: [User]) {
        items.removeAll()
        
        for user in users {
            items.append(ViewModelUser(user: user))
        }
        
        // MARK: ek
        filteredItems = items
        
        state.value = items.count == 0 ? .empty : .populate
    }
    
    
}
