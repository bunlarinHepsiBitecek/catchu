//
//  ExplorePhoneContactViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import Contacts

class ExplorePhoneContactViewModel: CommonViewModel {
    
    var commonExplorePhoneContactArray =
        Array<CommonExplorePhoneContactTableCellViewModelItem>()
    var state = CommonDynamic(TableViewState.empty)
    var rawContactList = Array<CNContact>()
    var syncedContactList = Array<REUser>()
    var refreshProcessState = CommonDynamic(CRUD_OperationStates.done)
    var searchTool = CommonDynamic(SearchTools(searchText: Constants.CharacterConstants.EMPTY, searchIsProgress: false))
    
    // search process attributes
    var searchedCommonExplorePhoneContactArray = Array<CommonExplorePhoneContactTableCellViewModelItem>()
    var searchedRawContactList = Array<CNContact>()
    var searchedSyncedContactList = Array<REUser>()
    
    func returnCommonExplorePhoneContactArray() -> Int {
        
        if searchTool.value.searchIsProgress {
            return searchedCommonExplorePhoneContactArray.count
        } else {
            return commonExplorePhoneContactArray.count
        }

    }
    
    func returnViewModel(index: Int) -> CommonExplorePhoneContactTableCellViewModelItem {
        
        if searchTool.value.searchIsProgress {
            return searchedCommonExplorePhoneContactArray[index]
        } else {
            return commonExplorePhoneContactArray[index]
        }
        
    }
    
    func returnNumberOfRowsInSections(index: Int) -> Int {
        if searchTool.value.searchIsProgress {
            return self.searchedCommonExplorePhoneContactArray[index].rowCount
        } else{
            return self.commonExplorePhoneContactArray[index].rowCount
        }
            
    }
    
    func startFetchingContactsFromDevice() {
        
        ContactListManager.shared.initiateFetchContactBusiness { (finish, contactListPhoneArray, rawContactList) in
            if finish {
                self.rawContactList = rawContactList
                // get synced phone numbers in neo4j
                self.getPhoneContactsWithProvidersInCatchUApp(contactListPhoneArray: contactListPhoneArray)
            }
        }
        
    }
    
    func triggerPermissionFlow() {
        ContactListManager.shared.triggerPermissionForContact { (granted) in
            if granted {
                self.startFetchingContactsFromDevice()
            }
        }
    }
    
    private func getPhoneContactsWithProvidersInCatchUApp(contactListPhoneArray: Array<Provider>) {
        
        guard let userid = User.shared.userid else { return }
        
        let providerList = REProviderList()
        
        if providerList?.items == nil {
            providerList?.items = [REProvider]()
        }
        
        for item in contactListPhoneArray {
            let reProvider = REProvider()
            reProvider?.providerid = item.providerid
            reProvider?.providerType = item.providerType
            
            providerList?.items?.append(reProvider!)
            
            print("reProvider?.providerid : \(reProvider?.providerid)")
            
        }
        
        APIGatewayManager.shared.initiateDeviceContactListExploreOnCatchU(userid: userid, providerList: providerList!) { (result) in
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
                
                // before creating new lists remove old ones
                commonExplorePhoneContactArray.removeAll()
                
                if let resultArray = data.items {
                    if resultArray.count > 0 {
                        self.createPhoneContactArray(reUserList: resultArray)
                    }
                }
                
                // create raw contactList view model items
                self.createRawContactViewModelItems()
                
                refreshProcessState.value = .done
                state.value = commonExplorePhoneContactArray.count == 0 ? .empty : .populate
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
    
    private func createPhoneContactArray(reUserList: Array<REUser>) {

        syncedContactList = reUserList
        
        let syncedPhoneContactsViewModel = SyncedPhoneContactsViewModel()
        
        // create array for synced contacts with neo4j
        for item in reUserList {
            let commonUserViewModel = CommonUserViewModel(user: User(user: item))
            syncedPhoneContactsViewModel.syncedPhoneContactsUserArray.append(commonUserViewModel)
        }
        
        commonExplorePhoneContactArray.append(syncedPhoneContactsViewModel)
        
    }
    
    private func createRawContactViewModelItems() {
        
        let invitedPhoneContactsViewModel = InvitedPhoneContactsViewModel()
        
        for item in rawContactList {
            let commonContactViewModel = CommonContactViewModel(contact: item)
            invitedPhoneContactsViewModel.invitedPhoneContactsUserArray.append(commonContactViewModel)

        }
        
        invitedPhoneContactsViewModel.sortInvitedPhoneContactsUserArray()
        commonExplorePhoneContactArray.append(invitedPhoneContactsViewModel)
    }
    
    func returnRawContactListCount() -> Int {
        if searchTool.value.searchIsProgress {
            return searchedRawContactList.count
        } else {
            return rawContactList.count
        }
    }
    
    func returnSyncedContactListCount() -> Int {
        if searchTool.value.searchIsProgress {
            return searchedSyncedContactList.count
        } else {
            return syncedContactList.count
        }
    }
    
    func refreshProcess() {
        startFetchingContactsFromDevice()
    }
    
    private func clearSearchArrays() {
        // remove items from search arrays
        searchedCommonExplorePhoneContactArray.removeAll()
        searchedSyncedContactList.removeAll()
        searchedRawContactList.removeAll()
    }
    
    func searchContactsInTableViewData(inputText: String) {
        clearSearchArrays()
        
        for item in syncedContactList {
            let user = User(user: item)
            
            if let name = user.name {
                if name.lowercased().hasPrefix(inputText.lowercased()) {
                    searchedSyncedContactList.append(item)
                    continue
                }
            }
            
            if let username = user.username {
                if username.lowercased().hasPrefix(inputText.lowercased()) {
                    searchedSyncedContactList.append(item)
                    continue
                }
            }
            
        }
        
        let searchedSyncedPhoneContactsViewModel = SyncedPhoneContactsViewModel()
        
        // create array for synced contacts with neo4j
        for item in searchedSyncedContactList {
            let commonUserViewModel = CommonUserViewModel(user: User(user: item))
            searchedSyncedPhoneContactsViewModel.syncedPhoneContactsUserArray.append(commonUserViewModel)
        }
        
        searchedCommonExplorePhoneContactArray.append(searchedSyncedPhoneContactsViewModel)
        
        // raw contact list search
        for item in rawContactList {
            if item.givenName.lowercased().hasPrefix(inputText.lowercased()) {
                searchedRawContactList.append(item)
                continue
            }
            
        }
        
        let searchedInvitedPhoneContactsViewModel = InvitedPhoneContactsViewModel()
        
        // create array for synced contacts with neo4j
        for item in searchedRawContactList {
            let commonContactViewModel = CommonContactViewModel(contact: item)
            searchedInvitedPhoneContactsViewModel.invitedPhoneContactsUserArray.append(commonContactViewModel)
        }
        
        searchedCommonExplorePhoneContactArray.append(searchedInvitedPhoneContactsViewModel)
        
        state.value = .populate
    }
    
}
