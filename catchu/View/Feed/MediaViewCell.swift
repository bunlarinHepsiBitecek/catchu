//
//  SwipingViewVideoCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVKit

class MediaViewImageCell: BaseCollectionCell {
    
    var item: MediaViewModelItem? {
        didSet {
            guard let item = item as? MediaViewModelMediaItem else {
                return
            }
            guard let media = item.media else { return }
            guard let url = media.url else { return }
            
            imageView.loadAndCacheImage(url: url)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    
    override func setupViews() {
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            imageView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            imageView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            imageView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])
    }
    
}

class MediaViewVideoCell: BaseCollectionCell {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var playerItem: AVPlayerItem?
    
    var item: MediaViewModelItem? {
        didSet {
            guard let item = item as? MediaViewModelMediaItem else { return }
            
            guard let media = item.media else { return }
            guard let url = media.url else { return }
            
            self.preparePlayerLayer(urlString: url)
        }
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    let remainingTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    var isPlaying = false
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.black
        button.setImage(image, for: UIControlState())
        
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    deinit {
        // remove all observer when de allocated
        NotificationCenter.default.removeObserver(self)
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    
    @objc func handlePlay() {
        if isPlaying {
            player?.pause()
            playButton.setImage(UIImage(named: "play"), for: UIControlState())
        } else {
            if #available(iOS 10.0, *) {
                player?.playImmediately(atRate: 1.0)
            } else {
                player?.play()
            }
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        
        isPlaying = !isPlaying
    }
    
    override func setupViews() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        self.addSubview(activityIndicatorView)
        self.addSubview(playButton)
        self.addSubview(remainingTime)
        
        //x,y,w,h
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: safeCenterYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        //x,y,w,h
        NSLayoutConstraint.activate([
            playButton.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 10),
            playButton.safeBottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 20),
            playButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            remainingTime.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            remainingTime.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -8),
            remainingTime.widthAnchor.constraint(equalToConstant: 50),
            remainingTime.heightAnchor.constraint(equalToConstant: 24)
            ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    @objc func playerDidFinishPlaying(note: Notification){
        //Called when player finished playing
        playButton.setImage(UIImage(named: "play"), for: UIControlState())
        isPlaying = !isPlaying
        
        let seekTime = CMTime(value: 0, timescale: 1)
        
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            //perhaps do something later here
            
        })
    }
    
    private func preparePlayerLayer(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        // Create the asset to play
        let asset = AVAsset(url: url)
        
        if Constants.LOCALTEST {
            guard let path = Bundle.main.path(forResource: "video", ofType:"mov") else {
                debugPrint("video.mov not found")
                return
            }
            
            playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: path)))
        } else {
            playerItem = AVPlayerItem(asset: asset)
        }
        
        player = AVPlayer(playerItem: playerItem)
//        player?.replaceCurrentItem(with: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        playerLayer?.frame = self.bounds
        self.layer.addSublayer(playerLayer!)
        
        // with observe it stopped
        self.activityIndicatorView.startAnimating()
        playButton.isHidden = true
        
        self.bringSubview(toFront: activityIndicatorView)
        self.bringSubview(toFront: playButton)
        self.bringSubview(toFront: remainingTime)
        
        
        // or addObserver to player and forKey #keyPath(AVPlayer.currentItem.loadedTimeRanges)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        
//        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.reasonForWaitingToPlay), options: .new, context: nil)
        
        
        // for calculate remaining time and update UI
        let interval = CMTime(value: 1, timescale: 2) // notify per 1 second
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self](progressTime) in
            
            if let duration = self?.player?.currentItem?.duration {
                let remainingDuration = duration - progressTime
                self?.remainingTime.text = self?.formatTimeText(duration: remainingDuration)
            }
            
//            if let playbackLikelyToKeepUp = self?.player?.currentItem?.isPlaybackLikelyToKeepUp {
//                print("playbackLikelyToKeepUp: \(playbackLikelyToKeepUp)")
//                if playbackLikelyToKeepUp {
//                    self?.activityIndicatorView.stopAnimating()
//                } else {
//                    self?.activityIndicatorView.startAnimating()
//                }
//            }
            
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when the player is ready and rendering frames
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            // AVPlayerItem.status move belove
//            activityIndicatorView.stopAnimating()
//            playButton.isHidden = false
            
            if let duration = self.player?.currentItem?.duration {
                self.remainingTime.text = self.remainingTime.text ?? formatTimeText(duration: duration)
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                // Player item is ready to play.
                print("Status : readyToPlay")
                activityIndicatorView.stopAnimating()
                playButton.isHidden = false
            case .failed:
                // Player item failed. See error.
                print("Status : Failded")
            case .unknown:
                // Player item is not yet ready.
                 print("Status : unknown")
            }
        }
        
    }
    
    
    private func formatTimeText(duration: CMTime) -> String {
        var seconds: Int = 0
        var minutes: Int = 0
        
        let durationSeconds = CMTimeGetSeconds(duration)
        
        if !durationSeconds.isNaN {
            seconds = Int(durationSeconds) % 60
            minutes = Int(durationSeconds) / 60
        }
        // 00:00
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
}
