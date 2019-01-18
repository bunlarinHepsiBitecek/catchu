//
//  FollowersViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowersViewModel: CommonViewModel {

    var followersArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var totalFollowersCount = CommonDynamic(Int())
    var searchedFollowerArray = [CommonViewModelItem]()
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    var currentPage = 1
    var totalNumberOfFollowers = 0
    var totalNumberOfFollowersGet : Bool = false
    var perPage = 40
    
    // servera kaç defa gidildiğini test etmek için yazıldı
    var koko = 0
    
    // to control fetch process
    private var isFetchInProgress = false
    
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
            
            try APIGatewayManager.shared.getUserFollowInfo(userid: userid, requesterUserid: selectedProfileUserid, page: currentPage, perPage: perPage, requestType: .followers, completion: { (result) in
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
    
    private func createFollowerArrayData(reUserList : [REUser])  {
        print("\(#function) starts")
        
        // remove all items in FollowerArray
        //followersArray.removeAll()
        
        for item in reUserList {
            let newUser = User(user: item)
            followersArray.append(CommonUserViewModel(user: newUser))
        }
        
        state.value = followersArray.count == 0 ? .empty : .populate
        
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
                }
                
                if let resultArray = data.items {
                    currentPage += 1
                    
                    if let count = data.totalNumberOfPeople {
                        
                        if !self.totalNumberOfFollowersGet {
                            self.totalNumberOfFollowers = count.intValue
                            print("self.totalNumberOfFollowers : \(self.totalNumberOfFollowers)")
                            self.totalFollowersCount.value = totalNumberOfFollowers
                            self.totalNumberOfFollowersGet = true
                        }
                        
                    }
                    
                    self.createFollowerArrayData(reUserList: resultArray)
                    // total user count is set to observe from top view
                    //self.totalFollowerCount.value = resultArray.count
                    print("self.totalFollowerCount.value : \(self.totalFollowersCount.value)")
                    self.isFetchInProgress = false
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
            return totalFollowersCount.value
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
    
}
