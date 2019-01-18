//
//  FollowingsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowingsViewModel: CommonViewModel {
    
    var followingsArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var totalFollowingsCount = CommonDynamic(Int())
    var searchedFollowingArray = [CommonViewModelItem]()
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    var currentPage = 1
    var totalNumberOfFollowings = 0
    var totalNumberOfFollowingsGet : Bool = false
    var perPage = 40
    
    // servera kaç defa gidildiğini test etmek için yazıldı
    var koko = 0
    
    // to control fetch process
    private var isFetchInProgress = false
    
    var currentFollowingsArrayCount : Int {
        return followingsArray.count
    }
    
    func getUserFollowingsPageByPage(selectedProfileUserid: String) {
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
            
            try APIGatewayManager.shared.getUserFollowInfo(userid: userid, requesterUserid: selectedProfileUserid, page: currentPage, perPage: perPage, requestType: .followings, completion: { (result) in
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
    
    private func createFollowingArrayData(reUserList : [REUser])  {
        print("\(#function) starts")
        
        // remove all items in FollowingArray
        //FollowingsArray.removeAll()
        
        for item in reUserList {
            let newUser = User(user: item)
            followingsArray.append(CommonUserViewModel(user: newUser))
        }
        
        state.value = followingsArray.count == 0 ? .empty : .populate
        
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
                }
                
                if let resultArray = data.items {
                    currentPage += 1
                    
                    if let count = data.totalNumberOfPeople {
                        
                        if !self.totalNumberOfFollowingsGet {
                            self.totalNumberOfFollowings = count.intValue
                            print("self.totalNumberOfFollowings : \(self.totalNumberOfFollowings)")
                            self.totalFollowingsCount.value = totalNumberOfFollowings
                            self.totalNumberOfFollowingsGet = true
                        }
                        
                    }
                    
                    self.createFollowingArrayData(reUserList: resultArray)
                    // total user count is set to observe from top view
                    //self.totalFollowingCount.value = resultArray.count
                    print("self.totalFollowingCount.value : \(self.totalFollowingsCount.value)")
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
            return totalFollowingsCount.value
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
    
}
