//
//  FriendsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendsViewModel: BaseViewModel, CommonViewModel {
    
    var friendArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var selectedListActivationState = CommonDynamic(CollectionViewActivation.disable)
    var sectionTitle = TableViewSectionTitle.None
    
    func getUserFollowers() {
        
        // let's tell view, data is loading
        state.value = .loading
        
        guard let userid = User.shared.userid else { return }
        
        do {
            try APIGatewayManager.shared.getUserFriendList(userid: userid, page: 1, perPage: 1) { (result) in
            
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
        friendArray.removeAll()
        
        for item in reUserProfilePropertiesList {
            let newUser = User(user: item)
            friendArray.append(CommonUserViewModel(user: newUser))
        }
        
        state.value = friendArray.count == 0 ? .empty : .populate
        sectionTitle = .Friends
        
    }
    
    /// Description : CommonViewModel protocol
    ///
    /// - Parameter networkResult: any network result handler
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REFriendList {
                print("data to friendList casting is ok")
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                }
                
                if let resultArray = data.resultArray {
                    self.createFriendArrayData(reUserProfilePropertiesList: resultArray)
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
    
    
    
}

