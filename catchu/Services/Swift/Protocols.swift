//
//  Protocols.swift
//  catchu
//
//  Created by Erkut Baş on 9/4/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

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
    func deliverDelegation() -> UIViewController
    func initiateCustomCamera()
    func directToCapturedVideoView(url : URL)
    func initiateCustomVideo()
    func getPhotosFromLibrary(inputIndex: Int)
    
}

extension ShareDataProtocols {
    func dismisViewController() {}
    
    func resizeShareTypeSliderConstraint(input : CGFloat) {}
    
    func selectSliderTypeCell(inputIndexPath : IndexPath) {}
    
    func returnSliderWidth() -> CGFloat { return 0 }
    
    func selectFunctionCell(inputIndex: Int) {}
    
    func deliverDelegation() -> UIViewController { return UIViewController() }
    
    func initiateCustomCamera() {}
    
    func directToCapturedVideoView(url : URL) {}
    
    func initiateCustomVideo() {}
    
    func getPhotosFromLibrary(inputIndex: Int) {}
    
}



