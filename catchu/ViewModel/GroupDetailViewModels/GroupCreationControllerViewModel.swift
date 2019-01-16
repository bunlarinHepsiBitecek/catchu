//
//  GroupCreationControllerViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct NewGroupImageInformation {
    var image: UIImage?
    var imageOrientation: ImageOrientation?
    var imageExtension: String?
    var imageAsData: Data?
    var groupObject: Group?
    var downloadUrl: String?
    var groupName: String?
}

class GroupCreationControllerViewModel: BaseViewModel, CommonViewModel {
    
    var newGroup = NewGroupImageInformation(image: nil, imageOrientation: nil, imageExtension: nil, imageAsData: nil, groupObject: nil, downloadUrl: nil, groupName: nil)
    
    // first step, we have no group data. At group creation step, we'll make a group object by gathering data
    var newGroupViewModel: CommonGroupViewModel?
    
    // to get selected participant count from friend relation view to group creation view controller
    var selectedCommonUserViewModelList = Array<CommonUserViewModel>()
    
    // to sync group creation participant count and friend group relation view count
    var friendGroupRelationViewModel: FriendGroupRelationViewModel?
    
    var newGroupCreationState = CommonDynamic(CRUD_OperationStates.done)
    
    init(selectedCommonUserViewModelList : Array<CommonUserViewModel>, friendGroupRelationViewModel: FriendGroupRelationViewModel) {
        self.selectedCommonUserViewModelList = selectedCommonUserViewModelList
        self.friendGroupRelationViewModel = friendGroupRelationViewModel
    }
    
    func startNewGroupCreationProcess() throws {
        
        newGroupCreationState.value = .processing

        guard let groupName = newGroup.groupName else { throw ClientPresentErrors.missingNewGroupName }
        guard let userid = User.shared.userid else { throw ClientPresentErrors.missingUserid }

        if let data = newGroup.imageAsData {

            guard let imageExtension = newGroup.imageExtension else { throw ClientPresentErrors.missingImageExtension }
            
            APIGatewayManager.shared.uploadImageToBucket(data: data, mediaType: .image, imageExtension: imageExtension) { (downloadUrl) in
                
                // get download url
                self.newGroup.downloadUrl = downloadUrl
                
                APIGatewayManager.shared.createNewGroup(groupName: groupName, groupPhotoUrl: downloadUrl, adminUserid: userid, participantList: self.returnUserList(), completion: { (result) in
                    self.handleAwsTaskResponse(networkResult: result)
                })
            }
            
        } else {
            APIGatewayManager.shared.createNewGroup(groupName: groupName, groupPhotoUrl: nil, adminUserid: userid, participantList: self.returnUserList(), completion: { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            })
        }
        
        

    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {
                
                if let businessError = data.error, let code = businessError.code, code != ApiLambdaError.success.rawValue {
                    print("Lambda error : \(String(describing: businessError.message))")
                    return
                }
                
                if let resultArray = data.resultArray {
                    //self.createGroupDetailSections(participantList: resultArray)
                    if let firstItem = resultArray.first {
                        self.createNewGroup(data: firstItem)
                        
                        do {
                            try self.releaseSelectedParticipantFromFriendGroupRelationView()
                        }
                        catch let error as ClientPresentErrors {
                            switch error {
                            case .missingFriendGroupRelationViewModel:
                                print("\(Constants.ALERT) friendGroupRelationViewModel is required")
                            default:
                                print("\(Constants.CRASH_WARNING)")
                            }
                        }
                        catch {
                            print("\(Constants.CRASH_WARNING)")
                        }
                    }
                    
                }
                
            }
            
            // reset viewModel operation tyoe
            newGroupCreationState.value = .done
            
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

    
    /// Description : to hold updated information for group image process
    ///
    /// - Parameters:
    ///   - newImage: image
    ///   - newImagePathExtension: extension, jpg, png etc ...
    ///   - newImageAsData: image converted data
    ///   - newGroupObject: copied object containing new information
    func prepareNewGroupInformationData(image: UIImage?, imageOrientation: ImageOrientation?, imageExtension: String?, imageAsData: Data?, groupObject: Group?, downloadUrl: String?, groupName: String?) {
        
        if let image = image {
            newGroup.image = image
        }
        
        if let imageExtension = imageExtension {
            newGroup.imageExtension = imageExtension
        }
        
        if let imageAsData = imageAsData {
            newGroup.imageAsData = imageAsData
        }
        
        if let groupObject = groupObject {
            newGroup.groupObject = groupObject
        }
        
        if let imageOrientation = imageOrientation {
            newGroup.imageOrientation = imageOrientation
        }
        
        if let downloadUrl = downloadUrl {
            newGroup.downloadUrl = downloadUrl
        }
        
        if let groupName = groupName {
            newGroup.groupName = groupName
        }
    }
    
    private func returnUserList() -> Array<User> {
        var tempUserArray = Array<User>()
        
        for item in selectedCommonUserViewModelList {
            if let user = item.user {
                tempUserArray.append(user)
            }
        }
        
        return tempUserArray
    }
    
    private func releaseSelectedParticipantFromFriendGroupRelationView() throws {
        guard let friendGroupRelationViewModel = friendGroupRelationViewModel else { throw ClientPresentErrors.missingFriendGroupRelationViewModel }
        
        // to unselect friendRelationView users
        for item in selectedCommonUserViewModelList {
            item.selectUserManagement(choise: .deSelected)
        }
        
        //selectedCommonUserViewModelList.removeAll()
        
        friendGroupRelationViewModel.resetFriendRelationView.value = true
        
        if let newGroupViewModel = newGroupViewModel {
            newGroupViewModel.groupSelected.value = .selected
            friendGroupRelationViewModel.resetGroupRelationView.value = newGroupViewModel
        }
    }
    
    /// Description: prepare group view model object after creating group successfully
    ///
    /// - Parameter data: data retrieved from neo4j
    /// - Author: Erkut Bas
    private func createNewGroup(data: REGroupRequestResult_resultArray_item) {
        let tempGroup = Group()
        
        if let groupid = data.groupid {
            tempGroup.groupID = groupid
        }
        
        if let name = data.name {
            tempGroup.groupName = name
        }
        
        if let groupPhotoUrl = data.groupPhotoUrl {
            tempGroup.groupPictureUrl = groupPhotoUrl
        }
        
        if let createAt = data.createAt {
            tempGroup.groupCreateDate = createAt
        }
        
        if let groupAdmin = data.groupAdmin {
            tempGroup.adminUserID = groupAdmin
        }
        
        newGroupViewModel = CommonGroupViewModel(group: tempGroup)
        
    }
}
