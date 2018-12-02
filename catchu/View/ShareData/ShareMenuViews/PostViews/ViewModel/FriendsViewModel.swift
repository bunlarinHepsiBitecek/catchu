//
//  FriendsViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 11/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FriendsViewModel: BaseViewModel, CommonViewModel {
    
    var isFriendDataLoading = CommonDynamic(false)
    var reloadTableView = CommonDynamic(false)
    
    var friendArray = [CommonViewModelItem]()
    
    func getUserFollowers() {
        
        do {
            try APIGatewayManager.shared.getUserFriendList(userid: "", page: 1, perPage: 1) { (result) in
            
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
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REFriendList {
                print("data to friendList casting is ok")
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(businessError.message)")
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
    
}
