//
//  FollowersViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowersViewModel: CommonViewModel {
/*
    var followersArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var totalFollowersCount = CommonDynamic(Int())
    var searchedFriendArray = [CommonViewModelItem]()
    
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    var currentPage = 1
    var totalNumberOfFriends = 0
    var totalNumberOfFriendsGet : Bool = false
    var perPage = 40
    
    var koko = 0
    
    // to control fetch process
    private var isFetchInProgress = false
    
    var currentFriendCount : Int {
        return friendArray.count
    }
    
    func getUserFollowersPageByPage() {
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
            try APIGatewayManager.shared.getUserFriendList(userid: userid, page: currentPage, perPage: perPage) { (result) in
                
                self.handleAwsTaskResponse(networkResult: result)
            }
            
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(#function) : missing userid")
            }
        }
        catch  {
            print("")
        }
        
    }
    
    private func createFriendArrayData(reUserProfilePropertiesList : [REUserProfileProperties])  {
        
        print("\(#function) starts")
        
        // remove all items in friendArray
        //friendArray.removeAll()
        
        for item in reUserProfilePropertiesList {
            let newUser = User(user: item)
            friendArray.append(CommonUserViewModel(user: newUser))
        }
        
        state.value = friendArray.count == 0 ? .empty : .populate
        sectionTitle.value = .Friends
        
    }
    
    /// Description : CommonViewModel protocol
    ///
    /// - Parameter networkResult: any network result handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REFriendList {
                print("data to friendList casting is ok")
                koko += 1
                print("koko : \(koko)")
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                }
                
                if let resultArray = data.resultArray {
                    currentPage += 1
                    
                    if let count = data.totalNumberOfFriend {
                        
                        if !self.totalNumberOfFriendsGet {
                            self.totalNumberOfFriends = count.intValue
                            print("self.totalNumberOfFriends : \(self.totalNumberOfFriends)")
                            self.totalFriendCount.value = totalNumberOfFriends
                            self.totalNumberOfFriendsGet = true
                        }
                        
                    }
                    
                    self.createFriendArrayData(reUserProfilePropertiesList: resultArray)
                    // total user count is set to observe from top view
                    //self.totalFriendCount.value = resultArray.count
                    print("self.totalFriendCount.value : \(self.totalFriendCount.value)")
                    
                    self.isFetchInProgress = false
                    
                    /*
                     if self.totalNumberOfFriends <= self.friendArray.count {
                     print("TEK TEK")
                     self.isFetchInProgress = true
                     }*/
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
    
    func checkIfSelectedFriendExist() {
        
        if let array = friendArray as? [CommonUserViewModel] {
            for item in array {
                if item.userSelected.value == .selected {
                    if selectedListActivationState.value == .disable {
                        selectedListActivationState.value = .enable
                        //return
                    }
                    
                    return
                    
                }
            }
        }
        
        selectedListActivationState.value = .disable
    }
    
    func returnSelectedFriendCount() -> Int {
        
        var counter = 0
        
        if let array = friendArray as? [CommonUserViewModel] {
            for item in array {
                if item.userSelected.value == .selected {
                    counter += 1
                }
            }
            
        }
        
        return counter
        
    }
    
    func returnFriendArrayData(index: Int) -> CommonViewModelItem {
        
        if searchTool.value.searchIsProgress {
            return searchedFriendArray[index]
        } else {
            return friendArray[index]
        }
        
    }
    
    func returnFriendArrayCount() -> Int {
        if searchTool.value.searchIsProgress {
            return searchedFriendArray.count
        } else {
            return totalFriendCount.value
        }
    }
    
    func findSelectedFriendCount() {
        
        var counter = 0
        
        if let array = friendArray as? [CommonUserViewModel] {
            for item in array {
                if item.userSelected.value == .selected {
                    counter += 1
                }
            }
            
        }
        
        selectedFrientCount.value = counter
    }
    
    func convertSelectedFriendListToUserList() {
        
        var temp = [User]()
        var tempCommonViewModelArray = [CommonUserViewModel]()
        
        if let array = friendArray as? [CommonUserViewModel] {
            for item in array {
                if item.userSelected.value == .selected {
                    
                    tempCommonViewModelArray.append(item)
                    
                    if let user = item.user {
                        temp.append(user)
                    }
                }
            }
        }
        
        selectedUserList.value = temp
        selectedCommonUserViewModel.value = tempCommonViewModelArray
    }
    
    func triggerSectionTitleChange() {
        if searchTool.value.searchIsProgress {
            sectionTitle.value = .SearchResult
        } else {
            sectionTitle.value = .Friends
        }
    }
    
    // search mode functions
    func returnSearchedFriendArrayCount() -> Int {
        return searchedFriendArray.count
    }
    
    func searchFriendInTableViewData(inputText : String) {
        print("\(#function) starts")
        
        // remove items from searchFriendArray
        searchedFriendArray.removeAll()
        
        if let array = friendArray as? [CommonUserViewModel] {
            for item in array {
                if let user = item.user {
                    if let name = user.name {
                        if name.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFriendArray.append(item)
                            continue
                        }
                    }
                    
                    if let username = user.username {
                        if username.lowercased().hasPrefix(inputText.lowercased()) {
                            searchedFriendArray.append(item)
                            continue
                        }
                    }
                }
            }
        }
        
        // update total
        state.value = .populate
        
    }
    */
}
