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
    var items = [ViewModelItem]()
    
    var isLoading = Dynamic(false)
    var reloadTableView = Dynamic(false)
    
    private func populate(users: [User]) {
        items.removeAll()
        
        for user in users {
            items.append(ViewModelUser(user: user))
        }
        
        isLoading.value = false
        reloadTableView.value = true
    }
    
    func searchUsers(text: String) {
        if text.isEmpty {
            removeAll()
            return
        }
        
        isLoading.value = true
        REAWSManager.shared.searchUsersGet(searchText: text, page: page, perPage: perPage) { (result) in
            print("\(#function) working and get data")
            self.handleResult(result)
        }
    }
    
    func removeAll() {
        items.removeAll()
        isLoading.value = false
        reloadTableView.value = true
    }
    
    private func handleResult(_ result: NetworkResult<REUserListResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                return
            }
            
            guard let users = response.items else { return }
            
            var newItems = [User]()
            for user in users {
                newItems.append(User(user: user))
            }
            self.populate(users: newItems)
            
        case .failure(let apiError):
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
    
    
}
