//
//  PendingRequestTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/4/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct FollowRequestOperationData {
    var buttonOperation: ButtonOperation
    var requesterUserid: String
    var operationState: CRUD_OperationStates
}

struct FollowRequestOperationCellResult {
    var state: CRUD_OperationStates
    var requesterUserid: String
    var buttonOperation: ButtonOperation
}

class PendingRequestTableCellViewModel: CommonViewModel {
    
    var commonUserViewModel: CommonUserViewModel?
    var followOperation = CommonDynamic(FollowRequestOperationData(buttonOperation: .none, requesterUserid: Constants.CharacterConstants.EMPTY, operationState: .done))
    // it's used for trigger tableview reload process from cell
    var followOperationStateForController = CommonDynamic(FollowRequestOperationCellResult(state: .done, requesterUserid: Constants.CharacterConstants.EMPTY, buttonOperation: .none))
    
    init(commonUserViewModel: CommonUserViewModel) {
        self.commonUserViewModel = commonUserViewModel
    }
    
    func followRequestOperations(requestedUserid: String, requesterUserid: String) throws {
        
        guard let requestType = returnRequestType() else { throw ApiGatewayClientErrors.missingRequestType }
        
        APIGatewayManager.shared.followRequestOperations(requestedUserid: requestedUserid, requesterUserid: requesterUserid, requestType: requestType) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    /// Description : api gateway http request result handler
    ///
    /// - Parameter ConnectionResult: network result
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
     
        switch networkResult {
        case .success(let data):
            if let data = data as? REFriendRequestList {
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                followOperation.value = updateCurrentFollowRequestOperationData(operationState: .done)
                
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
    
    
    /// Description: returns request type according to button clicks
    ///
    /// - Returns: request type of follow operations
    private func returnRequestType() -> RequestType? {
        
        switch followOperation.value.buttonOperation {
        case .confirm:
            return RequestType.acceptFollowRequest
            
        case .delete:
            return RequestType.deletePendingFollowRequest
            
        default:
            return nil
        }
        
    }
    
    func returnCellUserid() -> String? {
        guard let commonUserViewModel = commonUserViewModel else { return nil }
        guard let user = commonUserViewModel.user else { return nil }
        guard let userid = user.userid else { return nil }
        
        return userid
    }
    
    private func updateCurrentFollowRequestOperationData(operationState: CRUD_OperationStates) -> FollowRequestOperationData {
        let followRequestOperationData = FollowRequestOperationData(buttonOperation: followOperation.value.buttonOperation, requesterUserid: followOperation.value.requesterUserid, operationState: operationState)
        
        return followRequestOperationData
    }
    
    func updateFollowRequestOperationCellResult(operationState: CRUD_OperationStates, buttonOperationData: ButtonOperation) -> FollowRequestOperationCellResult {
        
        let followRequestOperationCellResult = FollowRequestOperationCellResult(state: operationState, requesterUserid: returnCellUserid()!, buttonOperation: buttonOperationData)
        
        return followRequestOperationCellResult
    }
    
    
}
