//
//  GroupRelationViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct SelectedGroupData {
    var selectedGroupViewModel: CommonGroupViewModel?
    var selectedGroupIndexPath: IndexPath?
}

class GroupRelationViewModel: BaseViewModel, CommonViewModel {
    
    var groupArray = [CommonViewModelItem]()
    var state = CommonDynamic(TableViewState.suggest)
    var sectionTitle = CommonDynamic(TableViewSectionTitle.Groups)
    var selectedGroupList = CommonDynamic([Group]())
    //var infoRequestedGroup: Group?
    //var infoRequestedGroup: CommonGroupViewModel?
    var groupRelationViewProcessType = GroupOperationTypes.getGroupList
    var selectedGroupData = SelectedGroupData(selectedGroupViewModel: nil, selectedGroupIndexPath: nil)
    var groupRelationOperationStates = CommonDynamic(CRUD_OperationStates.done)
    
    /// Description : Get authenticated users' group list
    func getGroups() {
        
        state.value = .loading
        
        groupRelationViewProcessType = GroupOperationTypes.getGroupList
        
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
    
    func exitGroup() {
        // infoRequested group is selected group as well
        //guard let infoRequestedGroup = infoRequestedGroup else { return }
        //guard let group = infoRequestedGroup.group else { return }
        
        groupRelationOperationStates.value = .processing
        
        guard let groupViewModel = selectedGroupData.selectedGroupViewModel else { return }
        guard let group = groupViewModel.group else { return }
        guard let userid = User.shared.userid else { return }
        
        groupRelationViewProcessType = GroupOperationTypes.removeParticipantFromGroup
        
        APIGatewayManager.shared.removeParticipantFromGroup(group: group, userid: userid) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
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
                
                switch groupRelationViewProcessType {
                case .getGroupList:
                    if let resultArray = data.resultArray {
                        self.createGroupArrayData(groupItems: resultArray)
                    }
                    
                case .removeParticipantFromGroup:
                    print("Remove process is successfull")
                    self.removeSelectedGroupFromViewModel()
                    
                default:
                    print("Nothing happened")
                    return
                }
                
                // reset viewModel operation tyoe
                groupRelationViewProcessType = GroupOperationTypes.none
            
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
    
    func setSelectedGroupData(groupViewModel: CommonGroupViewModel, indexPath: IndexPath) {
        selectedGroupData.selectedGroupIndexPath = indexPath
        selectedGroupData.selectedGroupViewModel = groupViewModel
    }
    
    func removeSelectedGroupFromViewModel() {
        guard let groupViewModel = selectedGroupData.selectedGroupViewModel else { return }
        guard let group = groupViewModel.group else { return }
        guard let groupid = group.groupID else { return }
        
        if let array = groupArray as? [CommonGroupViewModel] {
            
            if let index = array.firstIndex(where: { $0.group?.groupID == groupid }) {
                groupArray.remove(at: index)
            }

        }
        
        groupRelationOperationStates.value = .done
        
    }
    
}

