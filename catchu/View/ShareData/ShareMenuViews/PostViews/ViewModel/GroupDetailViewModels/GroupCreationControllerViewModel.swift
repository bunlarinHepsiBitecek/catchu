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
    
    var groupImageSelected = false
    
    init(selectedCommonUserViewModelList : Array<CommonUserViewModel>, friendGroupRelationViewModel: FriendGroupRelationViewModel) {
        self.selectedCommonUserViewModelList = selectedCommonUserViewModelList
        self.friendGroupRelationViewModel = friendGroupRelationViewModel
    }
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function)")
    }
    
    func setNewGroupName(groupName: String) {
        newGroup.groupObject?.groupName = groupName
    }
    
    func setNewGroupImage(groupImage: UIImage) {
        newGroup.image = groupImage
    }
    
    func startNewGroupCreationProcess() throws {
        
        newGroupCreationState.value = .processing
        
        //guard let groupImage = newGroup.groupImage else { throw ClientPresentErrors.missingNewGroupImage }
        
        
        
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
    
}
