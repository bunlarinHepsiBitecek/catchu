//
//  FollowersViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowersViewModel: CommonViewModel {

    var user: User!
    var followersArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var searchedFollowerArray = [CommonViewModelItem]()
    var totalNumberOfFollowers = CommonDynamic(Int())
    var refreshProcessState = CommonDynamic(CRUD_OperationStates.done)
    var flagForFetchMore : Bool = false
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    // it's used for trigger tableview reload process from cell
    var removeFollowerOperationsState = CommonDynamic(FollowRequestOperationCellResult(state: .done, requesterUserid: Constants.CharacterConstants.EMPTY, buttonOperation: .none))
    
    var currentPage = 1
    var totalNumberOfFollowersRetrievedFromServer = 0
    var perPage = 40
    
    // servera kaç defa gidildiğini test etmek için yazıldı
    var koko = 0
    
    // to control fetch process
    private var isFetchInProgress = false
    
    init(user: User) {
        self.user = user
    }
    
    var currentFollowersArrayCount : Int {
        return followersArray.count
    }
    
    func getUserFollowersPageByPage(selectedProfileUserid: String) {
        print("\(#function) starts")
        print("currentPage : \(currentPage)")
        print("isFetchInProgress : \(isFetchInProgress)")
        // let's tell view, data is loading
        state.value = .loading
        
        guard let userid = User.shared.userid else { return }
        
        guard !isFetchInProgress else {
            return
        }
        
        self.isFetchInProgress = true
        print("isFetchInProgress : \(isFetchInProgress)")
        
        do {
            
            try APIGatewayManager.shared.getUserFollowInfo(requesterUserid: userid, requestedUserid: selectedProfileUserid, page: currentPage, perPage: perPage, requestType: .followers, completion: { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            })
            
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(#function) : missing userid")
            }
        }
        catch  {
            print("")
        }
        
    }
    
    func getUserFollowersPageByPage2() {
        print("\(#function) starts")
        
        //state.value = .loading
        guard let userid = User.shared.userid else { return }
        guard let requestedUserid = self.user.userid else { return }

        do {
            
            try APIGatewayManager.shared.getUserFollowInfo(requesterUserid: userid, requestedUserid: requestedUserid, page: currentPage, perPage: perPage, requestType: .followers, completion: { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            })
            
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(Constants.ALERT) : missing userid")
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
                print("data to FollowerList casting is ok")
                koko += 1
                print("koko : \(koko)")
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                if let resultArray = data.items {
                    if let count = data.totalNumberOfPeople {
                        totalNumberOfFollowers.value = Int(truncating: count)
                        //self.checkIfFollowersExists()
                    }
                    
                    if resultArray.count > 0 {
                        currentPage += 1
                        self.createFollowerArrayData(reUserList: resultArray)
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
    
    private func createFollowerArrayData(reUserList : [REUser])  {
        print("\(#function) starts")
        
        if refreshProcessState.value == .processing {
            // remove all items in FollowerArray
            followersArray.removeAll()
        }
        
        for item in reUserList {
            let newUser = User(user: item)
            followersArray.append(CommonUserViewModel(user: newUser))
        }
        
        refreshProcessState.value = .done
        state.value = followersArray.count == 0 ? .empty : .populate
        flagForFetchMore = false
        
    }
    
    func returnFollowerArrayData(index: Int) -> CommonViewModelItem {
        
        if searchTool.value.searchIsProgress {
            return searchedFollowerArray[index]
        } else {
            return followersArray[index]
        }
        
    }
    
    func returnFollowerArrayCount() -> Int {
        
        if searchTool.value.searchIsProgress {
            return searchedFollowerArray.count
        } else {
            return followersArray.count
        }
        
    }
    
    func searchFollowersInTableViewData(inputText : String) {
        print("\(#function) starts")
        
        // remove items from searchFriendArray
        searchedFollowerArray.removeAll()
        
        if let array = followersArray as? [CommonUserViewModel] {
            for item in array {
                
                if let user = item.user {
                    if let name = user.name {
                        if name.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowerArray.append(item)
                            continue
                        }
                    }
                    
                    if let username = user.username {
                        if username.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFollowerArray.append(item)
                            continue
                        }
                    }
                }
            }
        }
        
        //searchTool.value.searchIsProgress = true
        state.value = .populate
        
    }
    
    func removeFollowerFromFollowersArray(userid: String) {
        
        if let commonUserViewModelArray = followersArray as? [CommonUserViewModel] {
            if let index = commonUserViewModelArray.firstIndex(where: { $0.user?.userid == userid}) {
                followersArray.remove(at: index)
            }
        }
        
        if searchTool.value.searchIsProgress {
            if let commonUserViewModelArray = searchedFollowerArray as? [CommonUserViewModel] {
                if let index = commonUserViewModelArray.firstIndex(where: { $0.user?.userid == userid}) {
                    searchedFollowerArray.remove(at: index)
                }
            }
            
        }
        
        totalNumberOfFollowers.value -= 1
        
    }
    
    func fetchMoreProcess() {
        if !flagForFetchMore {
            print("more data is going to be fetched")
            flagForFetchMore = true
            getUserFollowersPageByPage2()
        }
    }
    
    func refreshProcess() {
        currentPage = 1
        getUserFollowersPageByPage2()
    }
    
}

