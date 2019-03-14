//
//  FollowersTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FollowersTableCellViewModel: CommonViewModel {
    
    var commonUserViewModel: CommonUserViewModel?
    var buttonProcessData = CommonDynamic(FollowRequestOperationData(buttonOperation: ButtonOperation.none, requesterUserid: Constants.CharacterConstants.EMPTY, operationState: CRUD_OperationStates.done))
    var viewModelNetworkOperationType = FollowOperationType.none
    
    init(commonUserViewModel: CommonUserViewModel) {
        self.commonUserViewModel = commonUserViewModel
    }
    
    func returnUser() -> User? {
        if let commonUserViewModel = commonUserViewModel {
            if let user = commonUserViewModel.user {
                return user
            }
        }
        return nil
    }
    
    func returnFollowersUserid() -> String? {
        guard let commonUserViewModel = commonUserViewModel else { return nil }
        guard let user = commonUserViewModel.user else { return nil }
        guard let userid = user.userid else { return nil }
        
        return userid

    }
    
    func findRequestType() -> RequestType {
        guard let user = returnUser() else { return .defaultRequest }
        guard let followStatus = user.followStatus else { return .defaultRequest }
        let isPrivateAccount = user.isUserHasAPrivateAccount ?? false
        
        switch followStatus {
        case .none:
            return isPrivateAccount ? .followRequest : .createFollowDirectly
        case .following:
            return .deleteFollow
        case .pending:
            return .deletePendingFollowRequest
        default:
            return .defaultRequest
        }
    }
    
    func followButtonProcess() {
        guard let requesterUserid = User.shared.userid else { return }
        guard let user = returnUser() else { return }
        guard let requestedUserid = user.userid else { return }
        
        let requestType = findRequestType()
        updateFollowStatus(requestType)
        
        viewModelNetworkOperationType = .followProcess
        
        APIGatewayManager.shared.followRequestOperations(requestedUserid: requestedUserid, requesterUserid: requesterUserid, requestType: requestType) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    func removeFromFollowers() {
        
        guard let userid = User.shared.userid else { return }
        guard let follower = returnUser() else { return }
        guard let followerUserid = follower.userid else { return }
        
        updateButtonProcessData(operationState: .processing, requesterUserid: followerUserid, buttonOperation: .more)
        
        viewModelNetworkOperationType = .removeProcess
        
        APIGatewayManager.shared.followRequestOperations(requestedUserid: userid, requesterUserid: followerUserid, requestType: .removeFromFollower) { (result) in
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
            }
            
            switch viewModelNetworkOperationType {
            case .removeProcess:
                print("Follower Remove has done.")
                buttonProcessData.value.operationState = .done
                
            case .followProcess:
                // for success, there is nothing to do :)
                return
            default:
                return
            }
            
            viewModelNetworkOperationType = FollowOperationType.none
            
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
    
    func updateButtonProcessData(operationState: CRUD_OperationStates, requesterUserid: String, buttonOperation: ButtonOperation) {
        
        let temp = FollowRequestOperationData(buttonOperation: buttonOperation, requesterUserid: requesterUserid, operationState: operationState)
        
        buttonProcessData.value = temp
        
    }
    
    private func updateFollowStatus(_ requestType: RequestType) {
        guard let user = returnUser() else { return }
        
        switch requestType {
        case .createFollowDirectly:
            user.followStatus = User.FollowStatus.following
        case .followRequest:
            user.followStatus = User.FollowStatus.pending
        case .deleteFollow, .deletePendingFollowRequest:
            user.followStatus = User.FollowStatus.none
        default:
            return
        }
    }
}
