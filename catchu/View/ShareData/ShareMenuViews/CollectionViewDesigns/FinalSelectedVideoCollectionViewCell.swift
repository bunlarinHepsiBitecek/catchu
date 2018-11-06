//
//  FinalSelectedVideoCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 10/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation

class FinalSelectedVideoCollectionViewCell: UICollectionViewCell {
    
    private var player : AVPlayer?
    private var playerLayer : AVPlayerLayer?
    private var isPlaying: Bool = false
    
    lazy var playStopButtonView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime
            , object: player!.currentItem)
    }
    
    
}

// MARK: - major functions
extension FinalSelectedVideoCollectionViewCell {
    
    func setupCellSettings(url : URL) {
        
        print("self.frame : \(self.frame)")
        print("self.bound : \(self.bounds)")
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
//        player!.actionAtItemEnd = .pause
        playerLayer!.frame = self.bounds
        
        playerLayer!.videoGravity = .resizeAspectFill
        
        self.layer.insertSublayer(playerLayer!, at: 0)

        addTapGestureForVideo()
        addPlayStopView()
        setNotificationToKnowVideoIsEnded()
    }
    
    func addPlayStopView() {
        
        self.addSubview(playStopButtonView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            playStopButtonView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            playStopButtonView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant : -10),
            playStopButtonView.heightAnchor.constraint(equalToConstant: 40),
            playStopButtonView.widthAnchor.constraint(equalToConstant: 40),
            
            ])
        
    }
    
    func changePlayStopView(playing : Bool) {
        
        if !playing {
            playStopButtonView.image = UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate)
            playStopButtonView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            playStopButtonView.image = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
            playStopButtonView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
        
    }
    
    func resetPlayer() {
        
        guard player != nil else {
            return
        }
        
        player!.seek(to: kCMTimeZero)
        isPlaying = false
        changePlayStopView(playing: false)
        
    }
    
    func setNotificationToKnowVideoIsEnded() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(FinalSelectedVideoCollectionViewCell.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(_ notification : Notification) {
        print("playerDidFinishPlaying triggered")
        
        resetPlayer()
    }
    
}

extension FinalSelectedVideoCollectionViewCell : UIGestureRecognizerDelegate {
    
    func addTapGestureForVideo() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalSelectedVideoCollectionViewCell.videoProcess(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func videoProcess(_ sender : UITapGestureRecognizer) {
        
        if isPlaying {
            guard player != nil else {
                return
            }
            
            player!.pause()
            isPlaying = false
            
        } else {
            guard player != nil else {
                return
            }
            
            player!.play()
            isPlaying = true
            
        }
        
        changePlayStopView(playing: isPlaying)
        
    }
    
}
