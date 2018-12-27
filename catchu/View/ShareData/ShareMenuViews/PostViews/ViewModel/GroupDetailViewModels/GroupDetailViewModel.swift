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
    var groupParticipantCount = CommonDynamic(Int())
    var groupDetailViewModelOperationType = GroupOperationTypes.none
    
    // participantsSections must be reachable from outside of the function. Because, when
    var participantsSections = GroupParticipantsViewModel()
    var participantSectionNumber: Int = 0
    var addParticipantSectionNumber: Int = 0
    
    // it's used to send group participants to friendRelationView to sync current users with appendable new participants. (to say participants already in group)
    var participantArray = Array<User>()
    // to add new participants to view
    var newParticipantArray = Array<User>()
    
    var selectedUser: User?
    
    /// Description: Get group details, participants, images, group name
    /// - Author: Erkut Bas
    func getGroupDetails() {
        
        state.value = .loading
        groupParticipantCount.value = 0
        groupDetailViewModelOperationType = .getGroupDetails
        
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
    
    /// Description: adding new participants to group
    ///
    /// - Parameter newParticipantArray: user array
    /// - Author: Erkut Bas
    func addNewParticipantsToGroup(newParticipantArray: Array<User>) {
        
        groupDetailViewModelOperationType = .addNewParticipants
        self.newParticipantArray = newParticipantArray
        
        if let group = groupViewModel?.group {
            
            do {
                try APIGatewayManager.shared.addNewParticipantsToGroup(group: group, participantArray: newParticipantArray, completion: { (result) in
                    self.handleAwsTaskResponse(networkResult: result)
                })
            } catch let error as ApiGatewayClientErrors {
                if error == .participantArrayCanNotBeEmpty {
                    print("\(Constants.ALERT)participant array can not be empty!")
                }
            }
            catch {
                print(Constants.CRASH_WARNING)
            }
        }
        
    }
    
    /// Description: it's removed selected user from selected group
    ///
    /// - Parameter selectedUser: user
    /// - Author: Erkut Bas
    func exitGroup(selectedUser: User) {
        
        guard let groupViewModel = groupViewModel else { return }
        guard let group = groupViewModel.group else { return }
        guard let userid = selectedUser.userid else { return }
        
        groupDetailViewModelOperationType = .removeParticipantFromGroup
        
        APIGatewayManager.shared.removeParticipantFromGroup(group: group, userid: userid) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    /// Description: it's used to change a group admin
    ///
    /// - Parameters:
    ///   - adminUserid: admin
    ///   - newAdminUserid: new admin
    /// - Author: Erkut Bas
    func changeGroupAdmin(adminUserid: String, newAdminUserid: String) {
        
        guard let groupViewModel = groupViewModel else { return }
        guard let group = groupViewModel.group else { return }
        
        groupDetailViewModelOperationType = .changeGroupAdmin
        
        do {
            try APIGatewayManager.shared.changeGroupAdmin(group: group, adminUserid: adminUserid , newAdminUserid: newAdminUserid) { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            }
        } catch let error as ApiGatewayClientErrors {
            if error == .missingUserId {
                print("\(Constants.ALERT)userid is required")
            }
        }
        catch  {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    /// Description : handle task manager
    ///
    /// - Parameter networkResult: result
    /// - Author: Erkut Bas
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {

                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                switch groupDetailViewModelOperationType {
                case .getGroupDetails:
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
                                print("\(Constants.CRASH_WARNING)")
                            }
                        }
                        catch {
                            print("\(Constants.CRASH_WARNING)")
                        }
                    }
                    
                case .addNewParticipants:
                    print("new participant adding process successfull")
                    // everything is ok, now add new participants to view model
                    self.addNewParticipantsToViewModel(participantArray: self.newParticipantArray)
                    // now reload tableView with new participants
                    //self.state.value = .populate
                    self.state.value = .sectionReload
                    
                case .removeParticipantFromGroup:
                    print("selected participant removed successfully")
                    self.removeSelectedParticipantFromViewModel()
                    self.state.value = .sectionReload
                    
                case .changeGroupAdmin:
                    print("group admin changed successfully")
                    self.updateCurrentGroupViewModel()
                    self.state.value = .populate
                default:
                    return
                }
                
            }
            
            // reset viewModel operation tyoe
            groupDetailViewModelOperationType = .none
            
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
        
        var sectionNumber = 0
        
        guard let groupViewModel = groupViewModel else { throw ClientPresentErrors.missingGroupViewModel }
        guard let groupImageViewModel = groupImageViewModel else { throw ClientPresentErrors.missingGroupImageViewModel }
        guard let group = groupViewModel.group else { throw ClientPresentErrors.missingGroupObject }
        
        // erase array
        participantArray.removeAll()
        
        // first create a section for group name
        let groupNameSection = GroupNameViewModel(group: group, groupViewModel: groupViewModel, groupImageViewModel: groupImageViewModel)
        sectionNumber += 1
        
        groupDetailSections.append(groupNameSection)
        
        // second create admin section if exists
        if returnAuthenticatedUserIsAdmin() {
            let adminSection = GroupAddParticipantViewModel(group: group)
            addParticipantSectionNumber = sectionNumber
            sectionNumber += 1
            groupDetailSections.append(adminSection)
        }
        
        // third create participant list section
        // convert reuserprofileproperties to user
        //let participantsSections = GroupParticipantsViewModel()
        
        for item in participantList {
            let participantViewMode = GroupParticipantViewModel(user: User(user: item), group: group)
            participantsSections.participantList.append(participantViewMode)
            
            // it's used to send group participants to friendRelationView to sync current users with appendable new participants. (to say participants already in group)
            participantArray.append(User(user: item))
        }
        
        participantSectionNumber = sectionNumber
        sectionNumber += 1
        
        groupDetailSections.append(participantsSections)
        
        // fourth create exit section
        let exitSection = GroupExitViewModel()
        sectionNumber += 1
        groupDetailSections.append(exitSection)
        
        // let's reload tableview with data
        state.value = participantList.count == 0 ? .empty : .populate
        groupParticipantCount.value = participantList.count
        
    }
    
    func returnAuthenticatedUserIsAdmin() -> Bool {
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
    
    func returnSectionCount() -> Int {
        return groupDetailSections.count
    }
    
    func returnRowCount(section : Int) -> Int {
        return groupDetailSections[section].rowCount
    }
    
    func returnGroupDetailSectionItems(section : Int) -> CommonGroupViewModelItem {
        return groupDetailSections[section]
    }
    
    private func addNewParticipantsToViewModel(participantArray: Array<User>) {
        
        guard let groupViewModel = groupViewModel else {
            print("\(Constants.ALERT)groupViewModel can not be empty")
            return }
        guard let group = groupViewModel.group else {
            print("\(Constants.ALERT)group can not be empty")
            return }
        
        for item in participantArray {
            
            let participantViewModel = GroupParticipantViewModel(user: item, group: group)
            participantsSections.participantList.append(participantViewModel)
            
            self.participantArray.append(item)
            
        }
        
        // to update participant count value on group image container
        groupParticipantCount.value = participantsSections.participantList.count
        
    }
    
    private func removeSelectedParticipantFromViewModel() {
        guard let user = selectedUser else { print("\(Constants.ALERT)user can not be empty")
            return }
        
        if let index = participantsSections.participantList.firstIndex(where: { $0.user?.userid == user.userid}) {
            participantsSections.participantList.remove(at: index)
        }
        
        if let index = participantArray.firstIndex(where: { $0.userid == user.userid }) {
            participantArray.remove(at: index)
        }
        
        // to update participant count value on group image container
        groupParticipantCount.value = participantsSections.participantList.count
        
    }
    
    private func updateCurrentGroupViewModel() {
        guard let groupViewModel = groupViewModel else {
            print("\(Constants.ALERT)groupViewModel can not be empty")
            return }
        guard let group = groupViewModel.group else { return }
        guard let selectedUser = selectedUser else { return }
        guard let userid = selectedUser.userid else { return }
        
        // because we take groupViewModel as reference from previous view, this changes the data in group relation view list
        group.adminUserID = userid
        
        // remove add participant section from tableview
        groupDetailSections.remove(at: addParticipantSectionNumber)
    }
    
    
}
