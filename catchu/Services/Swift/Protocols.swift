//
//  Protocols.swift
//  catchu
//
//  Created by Erkut Baş on 9/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

protocol ViewPresentationProtocols {
    
    func dismissLoginViews()
    
}

extension ViewPresentationProtocols {
    
    func dismissLoginViews() {}
    
}

protocol ImageHandlerProtocol: class {
    
    func returnImage(inputImage : UIImage)
    
}

protocol GroupInformationUpdateProtocol: class {
    
    func syncGroupInfoWithClient(inputGroup: Group, completion : @escaping (_ completionResult : Bool) -> Void)
    
}

protocol PermissionProtocol: class {
    
    func returnPermissionResult(status : PHAuthorizationStatus)
    func returnPermissinResultBoolValue(result : Bool)
    func initiateSpecificActions()
    func requestPermission(permissionType : PermissionFLows)
//    func enablePermissionForGallery(permissionType : PermissionFLows)
    
}

extension PermissionProtocol {
    
    func returnPermissionResult(status : PHAuthorizationStatus) {}
    func initiateSpecificActions() {}
    func returnPermissinResultBoolValue(result : Bool) {}
    func requestPermission(permissionType : PermissionFLows) {}
    
}

protocol ShareDataProtocols: class {
    
    func dismisViewController()
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
    func closeVideoOperations()
    
    // new protocols for shareMenuViews
    func forceScrollMenuScrollView(selectedMenuIndex : Int)
    func setCapturedImage(inputImage : UIImage, cameraPosition : CameraPosition)
    func customVideoViewSessionManagement(inputIndex : Int)
    func startingICloudDownloadAnimation(animation : CircleAnimationProcess, inputProgressValue : CGFloat)
    func setCroppedImage(inputImage : UIImage)
    func closeShareDataViewController2()
    
}

extension ShareDataProtocols {
    func dismisViewController() {}
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
    func closeVideoOperations() {}
    
    // new protocols for shareMenuViews
    func forceScrollMenuScrollView(selectedMenuIndex : Int) {}
    func setCapturedImage(inputImage : UIImage, cameraPosition : CameraPosition) {}
    func customVideoViewSessionManagement(inputIndex : Int) {}
    func startingICloudDownloadAnimation(animation : CircleAnimationProcess, inputProgressValue : CGFloat) {}
    func setCroppedImage(inputImage : UIImage) {}
    func closeShareDataViewController2() {}
    
}



