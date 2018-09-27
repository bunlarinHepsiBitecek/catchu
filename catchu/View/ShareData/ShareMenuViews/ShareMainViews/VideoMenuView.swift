//
//  VideoMenuView.swift
//  catchu
//
//  Created by Erkut Baş on 9/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class VideoMenuView: UIView {

    var customVideoView : CustomVideoView?
    weak var delegate : ShareDataProtocols!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("VideoMenuView starts")
        
        initializeCustomVideoView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension VideoMenuView {
    
    func initializeCustomVideoView() {
        
        customVideoView = CustomVideoView()
        
        guard customVideoView != nil else {
            return
        }
        
        customVideoView!.delegate = delegate
        customVideoView!.isOpaque = true
        
        self.addSubview(customVideoView!)
        
        customVideoView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customVideoView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customVideoView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customVideoView!.topAnchor.constraint(equalTo: safe.topAnchor),
            customVideoView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
        //        DispatchQueue.main.async {
        //            self.closeActiveCaptureSessions()
        //        }
        
    }
    
    func startVideoProcess() {
        
        print("startVideoProcess starts")
        
        guard customVideoView != nil else {
            return
        }
        
        customVideoView!.startVideo()
        
    }
    
    /// stop video capture session
    func stopVideoProcess() {
        
        print("stopVideoProcess starts")
        
        guard customVideoView != nil else {
            return
        }
        
        customVideoView!.stopVideo()
        
    }
    
}

extension VideoMenuView : ShareDataProtocols {
    
    func closeActiveCaptureSessions() {
        
        delegate.closeCameraOperations()
        
    }
    
}
