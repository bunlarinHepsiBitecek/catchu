//
//  ExploreFacebookViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/24/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class ExploreFacebookViewModel: CommonViewModel {
    
    var facebookFriendsViewModelArray = [CommonViewModelItem]()
    var searchedFacebookFriendsArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.empty)
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    var refreshProcessState = CommonDynamic(CRUD_OperationStates.done)
    
    func returnFacebookFriendsArrayData(index: Int) -> CommonViewModelItem {
        
        if searchTool.value.searchIsProgress {
            return searchedFacebookFriendsArray[index]
        } else {
            return facebookFriendsViewModelArray[index]
        }
        
    }
    
    func returnFacebookFriendsArrayCount() -> Int {
        
        if searchTool.value.searchIsProgress {
            return searchedFacebookFriendsArray.count
        } else {
            return facebookFriendsViewModelArray.count
        }
        
    }
    
    func startFetchingFacebookFriendsExistInApp() {
        print("\(#function)")
        
        FacebookContactListManager.shared.initiateFacebookContactListProcess { (finish) in
            if finish {
                self.getFacebookFriendsWithProvidersInCatchUApp()
            }
        }
        
        /*
         
         if !FacebookContactListManager.shared.askAccessTokenExpire() {
         FacebookContactListManager.shared.initiateFacebookContactListProcess { (finish) in
         if finish {
         self.getFacebookFriendsWithProvidersInCatchUApp()
         }
         }
         }
         
         FacebookContactListManager.shared.initiateFacebookContactListProcess { (finish) in
         
         if finish {
         FacebookContactListManager.shared.getFacebookFriendsExistedInCatchU(completion: { (finish) in
         if finish {
         self.delegate.dismissView(active: false)
         self.delegate.dataLoadTrigger()
         }
         })
         }
         }
         
         */
        
    }
    
    func startFetchingFacebookFriendsExistInAppByConnectionRequest() {
        print("\(#function)")
        FacebookContactListManager.shared.initiateFacebookContactListProcessByConnectionRequest { (finish) in
            
            if finish {
                self.getFacebookFriendsWithProvidersInCatchUApp()
            }
            
        }
        
    }
    
    private func getFacebookFriendsWithProvidersInCatchUApp() {
        
        let providerList = REProviderList()
        
        if providerList?.items == nil {
            providerList?.items = [REProvider]()
        }
        
        if let userArray = FacebookContactListManager.shared.facebookFriendArray {
            for item in userArray {
//                providerList?.items?.append(User.shared.convertUserToProvider(inputUser: item))
                if let provider = item.provider {
                    providerList?.items?.append(provider.getProvider())
                }
            }
        }
        
        guard let userid = User.shared.userid else { return }
        
        APIGatewayManager.shared.initiateFacebookContactExploreProcess(userid: userid, providerList: providerList!) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        switch networkResult {
        case .success(let data):
            if let data = data as? REUserListResponse {
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                if let resultArray = data.items {
                    if resultArray.count > 0 {
                        self.createFacebookFriendArray(reUserList: resultArray)
                    }
                }
                
            }
            
        case .failure(let apiError):
            switch apiError {
            case .serverError(error: let error):
                print("serverError : \(error.localizedDescription)")
            case .connectionError(error: let error):
                print("serverError : \(error.localizedDescription)")
            case .missingData:
                print("missing data")
            }
            
        }
    }
    
    private func createFacebookFriendArray(reUserList: [REUser]) {
        facebookFriendsViewModelArray.removeAll()
        
        for item in reUserList {
            appendNewUserToFacebookViewModelArray(newUser: CommonUserViewModel(user: User(user: item)))
        }
        
        refreshProcessState.value = .done
        state.value = facebookFriendsViewModelArray.count == 0 ? .empty : .populate
        
    }
    
    private func appendNewUserToFacebookViewModelArray(newUser: CommonUserViewModel) {
        facebookFriendsViewModelArray.append(newUser)
    }
    
    func searchFacebookFriendsInTableViewData(inputText : String) {
        print("\(#function) starts")
        
        // remove items from searchFriendArray
        searchedFacebookFriendsArray.removeAll()
        
        if let array = facebookFriendsViewModelArray as? [CommonUserViewModel] {
            for item in array {
                
                if let user = item.user {
                    if let name = user.name {
                        if name.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFacebookFriendsArray.append(item)
                            continue
                        }
                    }
                    
                    if let username = user.username {
                        if username.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFacebookFriendsArray.append(item)
                            continue
                        }
                    }
                }
            }
        }
        
        //searchTool.value.searchIsProgress = true
        state.value = .populate
        
    }
    
    func refreshProcess() {
        startFetchingFacebookFriendsExistInApp()
    }
}
