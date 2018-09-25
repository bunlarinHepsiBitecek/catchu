//
//  VideoCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    var customVideoView : CustomVideoView?
    weak var delegate : ShareDataProtocols!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("VideoCollectionViewCell starts")
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        /* not to call initializeCustomVideoView in awakenFromNib, because even if cell is not visible, cell is loaded while scrollview triggered. In other words, while user is not scroll to this view yet, video capture session is triggered unnecessarily */
        initializeCustomVideoView()
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                print("Video cell is selected bro")
//                startVideoProcess()
            } else {
//                stopVideoProcess()
                print("Video cell is deselected bro")
            }
            
        }
    }
    
    
}

// MARK: - major functions
extension VideoCollectionViewCell {
    
    func initializeCustomVideoView() {
        
        customVideoView = CustomVideoView()
        
        guard customVideoView != nil else {
            return
        }
        
        customVideoView!.delegate = delegate
        customVideoView!.alpha = 0
        customVideoView!.isOpaque = true
        
        self.contentView.addSubview(customVideoView!)
        
        customVideoView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.contentView.safeAreaLayoutGuide
        
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
        
        customVideoView!.alpha = 1
        customVideoView!.startVideo()
        
    }
    
    /// stop video capture session
    func stopVideoProcess() {
        
        print("stopVideoProcess starts")
        
        guard customVideoView != nil else {
            return
        }
        
        customVideoView!.alpha = 0
//        customVideoView!.stopVideoProcess()
        
    }
    
}

extension VideoCollectionViewCell : ShareDataProtocols {

    func closeActiveCaptureSessions() {

        delegate.closeCameraOperations()

    }
    
}
