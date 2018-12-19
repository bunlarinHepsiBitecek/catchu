//
//  GroupDetailViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupDetailViewModel: BaseViewModel, CommonViewModel {
    
    // to sync relationGroupView data
    var groupViewModel: CommonGroupViewModel?
    // to sync groupImageContainerView data
    var groupImageViewModel: GroupImageViewModel?
    
    var groupDetailSections = Array<CommonGroupViewModelItem>()
    var state = CommonDynamic(TableViewState.suggest)
    var isAuthenticatedUserAdmin = CommonDynamic(false)
    var groupParticipantCount = CommonDynamic(Int())
    
    func getGroupDetails() {
        
        state.value = .loading
        groupParticipantCount.value = 0
        
        if let group = groupViewModel?.group {
            guard let groupid = group.groupID else { return }
            
            print("groupid : \(groupid)")
            
            do {
                try APIGatewayManager.shared.getGroupParticipantList(groupid: groupid, completion: { (result) in
                    self.handleAwsTaskResponse(networkResult: result)
                })
                
            }
            catch let error as ApiGatewayClientErrors {
                if error == .missingGroupId {
                    print("Groupid is requeired!!!")
                }
            }
            catch {
                print("there is a serious problem over here")
            }
        }
        
    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {

                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                }
                
                if let resultArray = data.resultArrayParticipantList {
                    //self.createGroupDetailSections(participantList: resultArray)
                    
                    do {
                        try self.createGroupDetailSections(participantList: resultArray)
                    }
                    catch let error as ClientPresentErrors {
                        switch error {
                        case .missingGroupImageViewModel:
                            print("GroupImageViewModel is required")
                            
                        case .missingGroupViewModel:
                            print("GroupViewModel is required")
                            
                        case .missingGroupObject:
                            print("Group object is required")
                        default:
                            print("Something goes terribly wrong")
                        }
                    }
                    catch {
                        print("Something goes terribly wrong")
                    }
                    
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
    
    func createGroupDetailSections(participantList : [REUserProfileProperties]) throws {
        print("\(#function)")
        
        guard let groupViewModel = groupViewModel else { throw ClientPresentErrors.missingGroupViewModel }
        guard let groupImageViewModel = groupImageViewModel else { throw ClientPresentErrors.missingGroupImageViewModel }
        guard let group = groupViewModel.group else { throw ClientPresentErrors.missingGroupObject }
        
        // first create a section for group name
        let groupNameSection = GroupNameViewModel(group: group, groupViewModel: groupViewModel, groupImageViewModel: groupImageViewModel)
        groupDetailSections.append(groupNameSection)
        
        // second create admin section if exists
        if returnAuthenticatedUserIsAdmin() {
            let adminSection = GroupAddParticipantViewModel(group: group)
            groupDetailSections.append(adminSection)
        }
        
        // third create participant list section
        // convert reuserprofileproperties to user
        let participantsSections = GroupParticipantsViewModel()
        
        for item in participantList {
            let participantViewMode = GroupParticipantViewModel(user: User(user: item), group: group)
            participantsSections.participantList.append(participantViewMode)
        }
        
        groupDetailSections.append(participantsSections)
        
        // fourth create exit section
        let exitSection = GroupExitViewModel()
        groupDetailSections.append(exitSection)
        
        // let's reload tableview with data
        state.value = participantList.count == 0 ? .empty : .populate
        groupParticipantCount.value = participantList.count
        
    }
    
    func checkAuthenticatedUserIsAdmin() {
        
        guard let groupViewModel = groupViewModel else { return }
        
        if let group = groupViewModel.group {
            if let adminID = group.adminUserID, let userid = User.shared.userid {
                if adminID == userid {
                    isAuthenticatedUserAdmin.value = true
                }
            }
        }
        
    }

    func returnSectionCount() -> Int {
        return groupDetailSections.count
    }
    
    func returnRowCount(section : Int) -> Int {
        return groupDetailSections[section].rowCount
    }
    
    func returnGroupDetailSectionItems(section : Int) -> CommonGroupViewModelItem {
        return groupDetailSections[section]
    }
    
    private func returnAuthenticatedUserIsAdmin() -> Bool {
        guard let groupViewModel = groupViewModel else { return false }
        
        if let group = groupViewModel.group {
            if let adminID = group.adminUserID, let userid = User.shared.userid {
                if adminID == userid {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
}
