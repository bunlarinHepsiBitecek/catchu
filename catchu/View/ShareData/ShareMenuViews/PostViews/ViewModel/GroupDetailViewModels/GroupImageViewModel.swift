//
//  GroupImageViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct UpdatedGroupImageInformation {
    var newGroupImage: UIImage?
    var newGroupImageOrientation: ImageOrientation?
    var newGroupImageExtension: String?
    var newGroupImageAsData: Data?
    var newGroupObject: Group?
    var newGroupImageDownloadUrl: String?
}

class GroupImageViewModel: BaseViewModel, CommonViewModel {
    
    // this model is required to sync groupRelationView data (specially for groupImage)
    var groupViewModel: CommonGroupViewModel?
    
    // dynamic closures
    var groupInfoViewExit = CommonDynamic(GroupInfoLifeProcess.start)
    var stackTitleTapped = CommonDynamic(false)
    var groupParticipantCount = CommonDynamic(Int())
    var groupTitleChangeListener = CommonDynamic(String())
    var groupDataChangeListener = CommonDynamic(UpdatedGroupImageInformation())
    var groupImageChangeProcess = CommonDynamic(CRUD_OperationStates.done)
    
    var updatedGroupImageInformation = UpdatedGroupImageInformation(newGroupImage: nil, newGroupImageOrientation: nil, newGroupImageExtension: nil, newGroupImageAsData: nil, newGroupObject: nil, newGroupImageDownloadUrl: nil)
    
    
    /// Description : update group profile picture
    ///
    /// - Throws: exception throws
    func updateGroupImage() throws {
        
        groupImageChangeProcess.value = .done
        
        guard let groupViewModel = groupViewModel else { throw ClientPresentErrors.missingGroupViewModel }
        guard let group = groupViewModel.group else { throw ClientPresentErrors.missingGroupObject }
        
        guard let data = updatedGroupImageInformation.newGroupImageAsData else { throw ClientPresentErrors.missingImageAsData }
        guard let imageExtension = updatedGroupImageInformation.newGroupImageExtension else { throw ClientPresentErrors.missingImageExtension }
        
        // create a copy group object for update operations
        updatedGroupImageInformation.newGroupObject = (group.copy() as! Group)
        
        guard let copyGroup = updatedGroupImageInformation.newGroupObject else { throw ClientPresentErrors.missingGroupObject }
        
        // start processing animation
        self.groupImageChangeProcess.value = .processing
        
        APIGatewayManager.shared.uploadImageToBucket(data: data, mediaType: .image, imageExtension: imageExtension) { (downloadUrl) in
            
            copyGroup.groupPictureUrl = downloadUrl
            // let's get new downloadUrl in update information struct
            self.updatedGroupImageInformation.newGroupObject = copyGroup
            
            APIGatewayManager.shared.updateGroupInformation(group: copyGroup, completion: { (result) in
                self.handleAwsTaskResponse(networkResult: result)
            })
            
        }

    }
    
    /// Description: AWS task response handler
    ///
    /// - Parameter networkResult: task result
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function)")
        
        switch networkResult {
        case .success(let data):
            if let data = data as? REGroupRequestResult {
                print("groupUpdata operation is successfull")
                self.updateGroupObjectInViewModels()
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
    
    /// Description : to hold updated information for group image process
    ///
    /// - Parameters:
    ///   - newImage: image
    ///   - newImagePathExtension: extension, jpg, png etc ...
    ///   - newImageAsData: image converted data
    ///   - newGroupObject: copied object containing new information
    func prepareUpdatedGroupImageInformation(newImage: UIImage?, newImagePathExtension: String?, newImageAsData: Data?, newGroupObject: Group?, newGroupImageOrientation: ImageOrientation?, newGroupImageDownloadUrl: String?) {
        
        if let newImage = newImage {
            updatedGroupImageInformation.newGroupImage = newImage
        }
        
        if let newImagePathExtension = newImagePathExtension {
            updatedGroupImageInformation.newGroupImageExtension = newImagePathExtension
        }
        
        if let newImageAsData = newImageAsData {
            updatedGroupImageInformation.newGroupImageAsData = newImageAsData
        }
        
        if let newGroupObject = newGroupObject {
            updatedGroupImageInformation.newGroupObject = newGroupObject
        }
        
        if let newGroupImageOrientation = newGroupImageOrientation {
            updatedGroupImageInformation.newGroupImageOrientation = newGroupImageOrientation
        }
        
        if let newGroupImageDownloadUrl = newGroupImageDownloadUrl {
            updatedGroupImageInformation.newGroupImageDownloadUrl = newGroupImageDownloadUrl
        }
    }
    
    private func updateGroupObjectInViewModels() {
        
        if let newImage = updatedGroupImageInformation.newGroupImage {
            groupViewModel?.groupImageChanged.value = newImage
            groupDataChangeListener.value = updatedGroupImageInformation
            
            // erase previous image url from cache
            if let group = groupViewModel?.group {
                if let url = group.groupPictureUrl {
                    ImageCacheManager.shared.eraseImageFromCache(url)
                }
            }
            
            groupViewModel?.group = updatedGroupImageInformation.newGroupObject
            
            self.groupImageChangeProcess.value = .done
            
        }
        
    }
    
    private func reduceImageSize() -> UIImage {
     
        return UIImage()
        
    }
    
}
