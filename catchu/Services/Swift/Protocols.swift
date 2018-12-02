//
//  Protocols.swift
//  catchu
//
//  Created by Erkut Baş on 9/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos
import Contacts

protocol ViewPresentationProtocols : class {
    
    func directToSaySometingPages()
    func directToContactsViewController(inputPostType : PostAttachmentTypes)
    func dismissViewController()
    func sharpDismissViewController()
    func directFromSlideMenu(inputSlideMenuType : SlideMenuViewTags)

}

extension ViewPresentationProtocols {
    
    func directToSaySometingPages() {}
    func directToContactsViewController(inputPostType : PostAttachmentTypes) {}
    func dismissViewController() {}
    func sharpDismissViewController() {}
    func directFromSlideMenu(inputSlideMenuType : SlideMenuViewTags) {}
    
}

protocol ContactsProtocols : class {
    
    func returnSelectedContactProcess(selectedChoise : SegmentedButtonChoise)
    
}

extension ContactsProtocols {
    
    func returnSelectedContactProcess(selectedChoise : SegmentedButtonChoise) {}
    
}

protocol ImageHandlerProtocol: class {
    
    func returnImage(inputImage : UIImage)
    
}

protocol GroupInformationUpdateProtocol: class {
    
    func syncGroupInfoWithClient(inputGroup: Group, completion : @escaping (_ completionResult : Bool) -> Void)
    
}

protocol PermissionProtocol: class {
    
    func returnPermissionResult(status : PHAuthorizationStatus, permissionType : PermissionFLows)
    func returnPermissinResultBoolValue(result : Bool, permissionType : PermissionFLows)
    func initiateSpecificActions()
    func requestPermission(permissionType : PermissionFLows)
//    func enablePermissionForGallery(permissionType : PermissionFLows)
    
}

extension PermissionProtocol {
    
    func initiateSpecificActions() {}
    func requestPermission(permissionType : PermissionFLows) {}
    func returnPermissionResult(status : PHAuthorizationStatus, permissionType : PermissionFLows) {}
    func returnPermissinResultBoolValue(result : Bool, permissionType : PermissionFLows) {}
    
    
}

protocol ShareDataProtocols: class {
    
    func dismisViewController(sharply : Bool)
    func closeViewControllerSharply()
    func resizeShareTypeSliderConstraint(input : CGFloat)
    func selectSliderTypeCell(inputIndexPath : IndexPath)
    func returnSliderWidth() -> CGFloat
    func selectFunctionCell(inputIndex: Int)
    func selectFunctionCell2(indexPath: IndexPath)
    func deliverDelegation() -> UIViewController
    func initiateCustomCamera() throws
    func directToCapturedVideoView(url : URL)
    func initiateCustomVideo()
    func getPhotosFromLibrary(inputIndex: Int)
    func updateSelectedColorFromPalette(inputView : UIView)
    func menuContainersHideManagement(inputValue : Bool)
    func returnTextViewScreenShot(inputScreenShot : UIImage)
    func makeVisibleCustomViews()
    func closeCameraOperations()
    
    // new protocols for shareMenuViews
    func forceScrollMenuScrollView(selectedMenuIndex : Int)
    func setCapturedImage(inputImage : UIImage, cameraPosition : CameraPosition)
    func customVideoViewSessionManagement(inputIndex : Int)
    func startingICloudDownloadAnimation(animation : CircleAnimationProcess, inputProgressValue : CGFloat)
    func setCroppedImage(inputImage : UIImage)
    func closeShareDataViewController2()
    func nextToFinalSharePage()
    func scrollableManagement(enabled : Bool)
    func gridViewTriggerManagement(hidden : Bool)
    func addTextSticker(inputView : UIView)
    func createSnapShotProcess()
    func checkAlphaValuesOfCustomEmbeddedViews()
    func resetViewSettings()
    
}

extension ShareDataProtocols {
    
    func dismisViewController(sharply : Bool) {}
    func closeViewControllerSharply() {}
    func resizeShareTypeSliderConstraint(input : CGFloat) {}
    func selectSliderTypeCell(inputIndexPath : IndexPath) {}
    func returnSliderWidth() -> CGFloat { return 0 }
    func selectFunctionCell(inputIndex: Int) {}
    func selectFunctionCell2(indexPath: IndexPath) {}
    func deliverDelegation() -> UIViewController { return UIViewController() }
    func initiateCustomCamera() throws {}
    func directToCapturedVideoView(url : URL) {}
    func initiateCustomVideo() {}
    func getPhotosFromLibrary(inputIndex: Int) {}
    func updateSelectedColorFromPalette(inputView : UIView) {}
    func menuContainersHideManagement(inputValue : Bool) {}
    func returnTextViewScreenShot(inputScreenShot : UIImage) {}
    func makeVisibleCustomViews() {}
    func closeCameraOperations() {}
    
    // new protocols for shareMenuViews
    func forceScrollMenuScrollView(selectedMenuIndex : Int) {}
    func setCapturedImage(inputImage : UIImage, cameraPosition : CameraPosition) {}
    func customVideoViewSessionManagement(inputIndex : Int) {}
    func startingICloudDownloadAnimation(animation : CircleAnimationProcess, inputProgressValue : CGFloat) {}
    func setCroppedImage(inputImage : UIImage) {}
    func closeShareDataViewController2() {}
    func nextToFinalSharePage() {}
    func scrollableManagement(enabled : Bool) {}
    func gridViewTriggerManagement(hidden : Bool) {}
    func addTextSticker(inputView : UIView) {}
    func createSnapShotProcess() {}
    func checkAlphaValuesOfCustomEmbeddedViews() {}
    func resetViewSettings() {}
    
}

protocol TabBarControlProtocols : class {
    
    func tabBarHiddenManagement(hidden : Bool)
    
}

extension TabBarControlProtocols {
    
    func tabBarHiddenManagement(hidden : Bool) {}
    
}

protocol NavigationControllerProtocols : class {
    
    func setNavigationTitle(input : String)
    
}

extension NavigationControllerProtocols {
    
    func setNavigationTitle(input : String) {}
    
}

protocol StickerProtocols : class {
    
    func addTextStickerWithParameters(sticker : Sticker)
//    func activateTextStickerEditigMode(sticker : Sticker, customSticker : CustomSticker2)
    func activateTextStickerEditigMode(inputSticker : Sticker, selfView : CustomSticker2)
    func activateTextStickerCommonEditigMode(inputSticker : Sticker, selfView : StickerCommonView)
//    func updateTextSticker(customSticker : CustomSticker)
    func updateTextSticker(inputSticker : Sticker)
    func customStickerActivationManager(active : Bool)
    func detectDeleteButtonIntersect(inputView : UIView)
    func stickerDeleteAnimationManager(active : Bool)
    func deleteSticker(selectedSticker : CustomSticker2)
    func deleteCommonSticker(selectedSticker : StickerCommonView)
    
}

extension StickerProtocols {
    
    func addTextStickerWithParameters(sticker : Sticker) {}
//    func activateTextStickerEditigMode(sticker : Sticker, customSticker : CustomSticker2) {}
    func activateTextStickerEditigMode(inputSticker : Sticker, selfView : CustomSticker2) {}
    func activateTextStickerCommonEditigMode(inputSticker : Sticker, selfView : StickerCommonView) {}
//    func updateTextSticker(customSticker : CustomSticker) {}
    func updateTextSticker(inputSticker : Sticker) {}
    func customStickerActivationManager(active : Bool) {}
    func detectDeleteButtonIntersect(inputView : UIView) {}
    func stickerDeleteAnimationManager(active : Bool) {}
    func deleteSticker(selectedSticker : CustomSticker2) {}
    func deleteCommonSticker(selectedSticker : StickerCommonView) {}
    
}

protocol SlideMenuProtocols : class {
    
    func animateSliderView(indexPath: IndexPath)
    func scrollStick(inputConstant : CGFloat)
    func dismissView(active : Bool)
    func dataLoadTrigger() 
    
}

extension SlideMenuProtocols {
    func animateSliderView(indexPath: IndexPath) {}
    func scrollStick(inputConstant : CGFloat) {}
    func dismissView(active : Bool) {}
    func dataLoadTrigger() {}

}

protocol UserProfileViewProtocols : class {
    func pullToViewDown()
    func showAlertAction(alertController : UIAlertController)
    func presentMessageController(phoneNumber : String)
    func triggerInviteMessageProcess(contactData : CNContact)
}

extension UserProfileViewProtocols {
    func pullToViewDown() {}
    func showAlertAction(alertController : UIAlertController) {}
    func presentMessageController(phoneNumber : String) {}
    func triggerInviteMessageProcess(contactData : CNContact) {}
}

protocol PostViewProtocols : class  {
    func dismissPostView()
    func triggerContentCheckAnimation(active : Bool, postContentType: PostContentType)
    func initiateAlertControllerProcess(postContentType : PostContentType)
    func committedCapturedImage()
    func committedCapturedVideo()
    func activationProcessOfVideoView(active : Bool)
    func deselectPostAttachmentAnimations()
    func selectedPostAttachmentAnimations(selectedAttachmentType : PostAttachmentTypes, completion : @escaping (_ finished : Bool) -> Void)
}

extension PostViewProtocols {
    func dismissPostView() {}
    func triggerContentCheckAnimation(active : Bool, postContentType: PostContentType) {}
    func initiateAlertControllerProcess(postContentType : PostContentType) {}
    func committedCapturedImage() {}
    func committedCapturedVideo() {}
    func activationProcessOfVideoView(active : Bool) {}
    func deselectPostAttachmentAnimations() {}
    func selectedPostAttachmentAnimations(selectedAttachmentType : PostAttachmentTypes, completion : @escaping (_ finished : Bool) -> Void) {}
}

protocol CameraImageVideoHandlerProtocol : class  {
    func returnPickedImage(image : UIImage)
    func returnPickedVideo(url : URL)
    func triggerPermissionProcess(permissionType : PermissionFLows)
    func updateProcessOfCapturedImage()
    func initiateVideoViewPermissionProcess()
}

extension CameraImageVideoHandlerProtocol {
    func returnPickedImage(image : UIImage) {}
    func returnPickedVideo(url : URL) {}
    func triggerPermissionProcess(permissionType : PermissionFLows) {}
    func updateProcessOfCapturedImage() {}
    func initiateVideoViewPermissionProcess() {}
}

protocol ActionSheetProtocols : class  {
    func returnOperations(selectedProcessType : ActionButtonOperation)
}

extension ActionSheetProtocols {
    func returnOperations(selectedProcessType : ActionButtonOperation) {}
}

// view model protocols
protocol CommonViewModel {

    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>)
    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>) where AnyModel : AnyObject
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>)
    
}

protocol CommonViewModelItem {}

