//
//  CameraGalleryMenuView.swift
//  catchu
//
//  Created by Erkut Baş on 9/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CameraGalleryMenuView: UIView {

    var imageManagementView : ImageManagementView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - major functions
extension CameraGalleryMenuView {
    
    func setupView() {

        // change self background color to clear
        self.backgroundColor = UIColor.clear
        
        imageManagementView = ImageManagementView()
        
        self.addSubview(imageManagementView!)

        imageManagementView!.translatesAutoresizingMaskIntoConstraints = false

        let safe = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            imageManagementView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            imageManagementView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            imageManagementView!.topAnchor.constraint(equalTo: safe.topAnchor),
            imageManagementView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),

            ])

    }
    
    func checkIfCustomCameraSessionActive() {
        
        guard imageManagementView != nil else {
            return
        }
        
        guard let customCameraObject = imageManagementView!.customCameraView else {
            return
        }
        
        customCameraObject.disableCustomCameraProcess()
        
    }
    
}
