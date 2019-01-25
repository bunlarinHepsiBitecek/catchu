//
//  FollowingsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowingsViewModel: CommonViewModel {
    
    var user: User!
    var followingsArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var totalFollowingsCount = CommonDynamic(Int())
    var searchedFollowingArray = [CommonViewModelItem]()
    var refreshProcessState = CommonDynamic(CRUD_OperationStates.done)
    var flagForFetchMore : Bool = false
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    var currentPage = 1
    var perPage = 40
    
    // servera kaç defa gidildiğini test etmek için yazıldı
    var koko = 0
    
    // to control fetch process
    private var isFetchInProgress = false
    
    init(user: User) {
        self.user = user
    }
    
    var currentFollowingsArrayCount : Int {
        return followingsArray.count
    }
    
    func getUserFollowingsPageByPage() {
        print("\(#function) starts")
        print("currentPage : \(currentPage)")
        // let's tell view, data is loading
        
        guard let userid = User.shared.userid else { return }
        guard let requestedUserid = self.user.userid else { return }
        
        do {
            
            try APIGatewayManager.shared.getUserFollowInfo(requesterUserid: userid, requestedUserid: requestedUserid, page: currentPage, perPage: perPage, requestType: .followings, completion: { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            })
            
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(#function) : missing userid")
            }
        }
        catch  {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    /// Description : CommonViewModel protocol
    ///
    /// - Parameter networkResult: any network result handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REFollowInfoListResponse {
                print("data to FollowingList casting is ok")
                koko += 1
                print("koko : \(koko)")
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                if let resultArray = data.items {
                    if resultArray.count > 0 {
                        currentPage += 1
                        self.createFollowingArrayData(reUserList: resultArray)
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
    
    private func createFollowingArrayData(reUserList : [REUser])  {
        print("\(#function) starts")
        
        if refreshProcessState.value == .processing {
            // remove all items in followingsArray
            followingsArray.removeAll()
        }
        
        for item in reUserList {
            let newUser = User(user: item)
            followingsArray.append(CommonUserViewModel(user: newUser))
        }
        
        refreshProcessState.value = .done
        state.value = followingsArray.count == 0 ? .empty : .populate
        flagForFetchMore = false
        
    }
    
    func returnFollowingArrayData(index: Int) -> CommonViewModelItem {
        
        if searchTool.value.searchIsProgress {
            return searchedFollowingArray[index]
        } else {
            return followingsArray[index]
        }
        
    }
    
    func returnFollowingArrayCount() -> Int {
        if searchTool.value.searchIsProgress {
            return searchedFollowingArray.count
        } else {
            return followingsArray.count
        }
    }
    
    func searchFollowingsInTableViewData(inputText : String) {
        print("\(#function) starts")
        
        // remove items from searchFriendArray
        searchedFollowingArray.removeAll()
        
        if let array = followingsArray as? [CommonUserViewModel] {
            for item in array {
                
                if let user = item.user {
                    if let name = user.name {
                        if name.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowingArray.append(item)
                            continue
                        }
                    }
                    
                    if let username = user.username {
                        if username.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowingArray.append(item)
                            continue
                        }
                    }
                }
            }
        }
        
        //searchTool.value.searchIsProgress = true
        state.value = .populate
        
    }
    
    func fetchMoreProcess(selectedProfileUserid: String) {
        if !flagForFetchMore {
            print("more data is going to be fetched")
            flagForFetchMore = true
            getUserFollowingsPageByPage()
        }
    }
    
    func refreshProcess() {
        currentPage = 1
        getUserFollowingsPageByPage()
    }
    
}
