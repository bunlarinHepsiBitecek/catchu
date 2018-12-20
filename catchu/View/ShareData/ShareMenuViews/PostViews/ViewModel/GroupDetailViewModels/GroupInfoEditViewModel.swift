//
//  GroupInfoEditViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupInfoEditViewModel: BaseViewModel, CommonViewModelItem, CommonViewModel {
    
    var groupNameViewModel: GroupNameViewModel?
    
    var saveButtonActivation = CommonDynamic(false)
    var saveProcessState = CommonDynamic(CRUD_OperationStates.done)
    var newGroupNameText: String?
    var updatedGroup: Group?
    
    init(groupNameViewModel: GroupNameViewModel) {
        self.groupNameViewModel = groupNameViewModel
        
    }
    
    func updateGroupInformation() throws {
        
        saveProcessState.value = .processing
        
        guard let groupNameViewModel = groupNameViewModel else { throw ClientPresentErrors.missingGroupNameViewModel }
        guard let groupViewModel = groupNameViewModel.groupViewModel else { throw ClientPresentErrors.missingGroupViewModel }
        guard let group = groupViewModel.group else { throw ClientPresentErrors.missingGroupObject }
        
        // create copy object for update process
        
        updatedGroup = group.copy() as? Group
        updatedGroup?.groupName = newGroupNameText
        
        APIGatewayManager.shared.updateGroupInformation(group: updatedGroup!) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function)")
    
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {
                print("groupUpdata operation is successfull")
                saveButtonUpdateProcessDone()
                updateGroupObjectInViewModels()
                
                
                
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
    
    private func saveButtonUpdateProcessDone() {
        saveProcessState.value = .done
        saveButtonActivation.value = false
    }
    
    private func updateGroupObjectInViewModels() {
        
        if let updatedGroup = updatedGroup {
            groupNameViewModel?.groupViewModel?.group = updatedGroup
            
            if let updatedName = updatedGroup.groupName {
                groupNameViewModel?.groupNameUpdated.value = updatedName
                groupNameViewModel?.groupViewModel?.groupNameChanged.value = updatedName
                groupNameViewModel?.groupImageViewModel?.groupTitleChangeListener.value = updatedName
            }
        }
        
    }
    
}
