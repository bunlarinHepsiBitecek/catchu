//
//  CustomCapturedVideoView.swift
//  catchu
//
//  Created by Erkut Baş on 9/12/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCapturedVideoView: UIView {

    private var player : AVPlayer!
    private var playerLayer : AVPlayerLayer!
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
    }()
    
    lazy var closeButtonShadow: UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    required init(outputFileURL : URL) {
        super.init(frame: .zero)
        
        setupViews()
        addGestureRecognizerToCloseButton()
        initializeVideoPlay(inputUrl : outputFileURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = self.frame
    }
    
    /// start adjust views
    func setupViews() {
        
        self.addSubview(closeButton)
        self.addSubview(closeButtonShadow)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            closeButtonShadow.topAnchor.constraint(equalTo: safe.topAnchor, constant: 50),
            closeButtonShadow.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            closeButtonShadow.heightAnchor.constraint(equalToConstant: 30),
            closeButtonShadow.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func initializeVideoPlay(inputUrl : URL) {
        
        print("inputUrl : \(inputUrl)")
        print("self.frame : \(self.frame)")
        print("self.bound : \(self.bounds)")
        
        player = AVPlayer(url: inputUrl)
        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.frame
        playerLayer.videoGravity = .resizeAspectFill
        
        self.layer.insertSublayer(playerLayer, at: 0)
        player.play()
        
    }

}

extension CustomCapturedVideoView : UIGestureRecognizerDelegate {

    func addGestureRecognizerToCloseButton() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomCapturedVideoView.closeView(_:)))
        tapGestureRecognizer.delegate = self
        closeButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        
        self.removeFromSuperview()
        
    }

}
