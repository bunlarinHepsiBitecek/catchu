//
//  SlideMenuViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/2/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SlideMenuViewModel: CommonViewModel {
    
    var followRequesterArray = [CommonViewModelItem]()
    var state = CommonDynamic(DataFetchingState.none)
    
    func getUserFollowerRequestList() throws {
        
        state.value = .fetching
        
        guard let userid = User.shared.userid else { throw ApiGatewayClientErrors.missingUserId }
        
        APIGatewayManager.shared.getUserFollowerRequests(userid: userid) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }

    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REFriendRequestList {
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                if let resultArray = data.resultArray {
                    self.createFollowerRequestArrayData(reUserProfilePropertiesList: resultArray)
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
    
    /// Description: followRequesterArray creator
    ///
    /// - Parameter reUserProfilePropertiesList: server user data
    /// - Author: Erkut Bas
    private func createFollowerRequestArrayData(reUserProfilePropertiesList : [REUserProfileProperties])  {
        print("\(#function) starts")
        
        // remove all items in followRequesterArray
        followRequesterArray.removeAll()
        
        for item in reUserProfilePropertiesList {
            let newUser = User(user: item)
            followRequesterArray.append(CommonUserViewModel(user: newUser))
        }
        
        state.value = .fetched
            
    }
    
    func returnTotalRequestCount() -> Int {
        return followRequesterArray.count
    }
}
