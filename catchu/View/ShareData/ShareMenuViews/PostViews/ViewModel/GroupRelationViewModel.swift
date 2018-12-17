//
//  GroupRelationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupRelationViewModel: BaseViewModel, CommonViewModel {
    
    var groupArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var sectionTitle = CommonDynamic(TableViewSectionTitle.Groups)
    var selectedGroupList = CommonDynamic([Group]())
    //var infoRequestedGroup: Group?
    var infoRequestedGroup: CommonGroupViewModel?
    
    /// Description : Get authenticated users' group list
    func getGroups() {
        
        state.value = .loading
        
        guard let userid = User.shared.userid else { return }
        
        do {
            try APIGatewayManager.shared.getUserGroupList(userid: userid, page: nil, perPage: nil, completion: { (result) in
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
    
    /// Description : network request handler
    ///
    /// - Parameter networkResult: api gateway result object
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function) starts")
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                }
                
                if let resultArray = data.resultArray {
                    self.createGroupArrayData(groupItems: resultArray)
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
    
    private func createGroupArrayData(groupItems : [REGroupRequestResult_resultArray_item]) {
        print("\(#function) stars")
        
        for item in groupItems {
            let newGroup = Group(reGroup: item)
            groupArray.append(CommonGroupViewModel(group: newGroup))
        }
        
        print("groupArray count : \(groupArray.count)")
        
        state.value = groupArray.count == 0 ? .empty : .populate
        sectionTitle.value = .Groups
    }
    
    func convertSelectedGroupViewModelToGroupList() {
        
        var temp = [Group]()
        
        if let array = groupArray as? [CommonGroupViewModel] {
            for item in array {
                if item.groupSelected.value == .selected {
                    if let group = item.group {
                        temp.append(group)
                    }
                }
            }
        }
        
        selectedGroupList.value = temp
    }
    
}

