//
//  PermissionHandler.swift
//  catchu
//
//  Created by Erkut Baş on 9/7/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class PermissionHandler {
    
    public static var shared = PermissionHandler()

    weak var delegate : PermissionProtocol!
    weak var delegateForExternalClass : PermissionProtocol!
    weak var delegateForShareData : ShareDataProtocols!
    
    func gotoRequestProcessViewControllers(inputPermissionType : PermissionFLows) {
        
        switch inputPermissionType {
        case .camera, .photoLibrary, .microphone:
            
            if let destinationViewControler = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: "PhotoLibraryPrePermissionViewController") as? PhotoLibraryPrePermissionViewController {
                
                destinationViewControler.viewControllerFlowType = inputPermissionType
                destinationViewControler.delegate = delegate
                destinationViewControler.delegateForExternalClass = delegateForExternalClass
                UIApplication.topViewController()?.present(destinationViewControler, animated: true, completion: nil)
                
            }
            
        case .cameraUnathorized, .photoLibraryUnAuthorized, .microphoneUnAuthorizated:
            
            if let destinationViewControler = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil).instantiateViewController(withIdentifier: "MediaPermissionUnAuthorizedViewController") as? MediaPermissionUnAuthorizedViewController {
                
                destinationViewControler.flowType = inputPermissionType
                
                UIApplication.topViewController()?.present(destinationViewControler, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}
