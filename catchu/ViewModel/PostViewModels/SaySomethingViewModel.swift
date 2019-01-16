//
//  SaySomethingViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SaySomethingViewModel: CommonViewModel {
    
    var closePostPage = CommonDynamic(false)
    var postState = CommonDynamic(PostProcessState.none)
    
    func startPostProcess() {
        print("\(#function)")
        
        postState.value = .posting
        
        // singleton post items are being converted to share data
        Share.shared.convertPostItemsToShare()

        APIGatewayManager.shared.initiatePostProcess(share: Share.shared) { (result) in
            self.handleAwsTaskResponse(networkResult: result)
        }
        
    }
    
    
    func handleAwsTaskResponse<AnyModel>(networkResult: NetworkResult<AnyModel>) {
        print("\(#function)")
        
        switch networkResult {
        case .success(let data):
            
            if let data = data as? REPostResponse {
                if let businessError = data.error {
                    if businessError.code != 1 {
                        // to do
                        //self.postResultNotification(granted: false)
                        InformerLoader.shared.animateInformerViews(postState: .failed)
                        return
                    }
                }
                
                //self.postResultNotification(granted: false)
                InformerLoader.shared.animateInformerViews(postState: .success)
                PostItems.shared.clearPostItemsObjects()
                
            }
            
        case .failure(let apiError):
            
            // if post process failes, inform user
            self.postResultNotification(granted: false)
            InformerLoader.shared.animateInformerViews(postState: .failed)
            
            switch apiError {
            case .serverError(error: let error):
                print("serverError : \(error.localizedDescription)")
                
            case .connectionError(error: let error):
                print("serverError : \(error.localizedDescription)")
                
            case .missingDataError:
                print("missing data error")
                
            }
            
        }
        
    }
    
    func postResultNotification(granted : Bool) {
        print("\(#function)")
        
        var imageAttachmentArray = [UIImage]()
        
        if !granted {
            if let imageArray = PostItems.shared.selectedImageArray {
                if let image = imageArray.first {
                    imageAttachmentArray.append(image)
                }
            }
            
            if let videoScreenShot = PostItems.shared.selectedVideoScreenShootWithPlayButton {
                if let imageObject = videoScreenShot.first {
                    imageAttachmentArray.append(imageObject.value)
                }
            }
            
            if let noteSnapShot = PostItems.shared.messageScreenShot {
                imageAttachmentArray.append(noteSnapShot)
            }
            
            CustomNotificationManager.shared.sendNotification(inputTitle: LocalizedConstants.Notification.postTitle , inputSubTitle: Constants.CharacterConstants.EMPTY, inputMessage: LocalizedConstants.Notification.postFailedMessage, inputIdentifier: "postIdentifier", operationResult: granted, image: imageAttachmentArray) { (finish) in
                
                if finish {
                    print("GOGOGOGOGOGOGOGOOG")
                }
            }
            
        } else {
            
            // if post operation is succesfull
            CustomNotificationManager.shared.sendNotification(inputTitle: LocalizedConstants.Notification.postTitle , inputSubTitle: Constants.CharacterConstants.EMPTY, inputMessage: LocalizedConstants.Notification.postSuccessMessage, inputIdentifier: "postIdentifier", operationResult: granted, image: []) { (finish) in
                
                if finish {
                    print("GOGOGOGOGOGOGOGOOG 2")
                }
            }
            
        }
        
    }

    
}
