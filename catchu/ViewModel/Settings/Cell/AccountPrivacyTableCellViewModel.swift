//
//  AccountPrivacyTableCellViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 1/29/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class AccountPrivacyTableCellViewModel: CommonViewModel {
    
    var updateProcess = CommonDynamic(CRUD_OperationStates.done)
    var switchListener = CommonDynamic(true)
    
    func updatePrivacyInformation(isPrivateValue: Bool) {
        
        updateProcess.value = .processing
        
        User.shared.isUserHasAPrivateAccount = isPrivateValue
        
        APIGatewayManager.shared.updateUserProfileInformation(user: User.shared, requestType: .user_profile_update) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        switch networkResult {
        case .success(let data):
            if let data = data as? REBaseResponse {
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                updateProcess.value = .done
                
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
