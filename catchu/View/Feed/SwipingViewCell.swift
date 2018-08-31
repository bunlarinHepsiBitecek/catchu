//
//  SwipingViewVideoCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVKit

class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class SwipingViewImageCell: BaseCollectionCell {
    
    var item: SwipingViewModelItem? {
        didSet {
            guard let item = item as? SwipingViewModelImageItem else {
                return
            }
            
            imageView.loadImageUsingUrlString(urlString: item.imageUrl)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "8771.jpg")
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
        addSubview(imageView)
        
        let safeLayout = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
    }
    
}

class SwipingViewVideoCell: BaseCollectionCell {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var item: SwipingViewModelItem? {
        didSet {
            guard let item = item as? SwipingViewModelVideoItem else {
                return
            }
            self.preparePlayerLayer(urlString: item.videoUrl)
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
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var isPlaying = false
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = UIColor.white
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handlePlay() {
        if isPlaying {
            player?.pause()
            playButton.setImage(UIImage(named: "play"), for: UIControlState())
        } else {
            player?.play()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        
        isPlaying = !isPlaying
    }
    
    override func setupViews() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        addSubview(activityIndicatorView)
        addSubview(playButton)
        addSubview(remainingTime)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        //x,y,w,h
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: safeLayout.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        //x,y,w,h
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: safeLayout.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            remainingTime.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            remainingTime.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -8),
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
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        //Called when player finished playing
        playButton.setImage(UIImage(named: "play"), for: UIControlState())
        isPlaying = !isPlaying
        
        let seekTime = CMTime(value: 0, timescale: 1)
        
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            //perhaps do something later here
            
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            playButton.isHidden = false
            
            
            if let duration = self.player?.currentItem?.duration {
                self.remainingTime.text = self.remainingTime.text ?? formatTimeText(duration: duration)
            }
            
        }
    }
    
    private func preparePlayerLayer(urlString: String) {
//            guard let path = Bundle.main.path(forResource: "video", ofType:"mov") else {
//                debugPrint("video.m4v not found")
//                return
//            }
//            guard let url = URL(fileURLWithPath: path) else {return}
        
        
        guard let url = URL(string: urlString) else {return}
        player = AVPlayer(url: url)
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
        
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            if let duration = self.player?.currentItem?.duration {
                let remainingDuration = duration - progressTime
                self.remainingTime.text = self.formatTimeText(duration: remainingDuration)
            }
            
        })
    }
    
    private func formatTimeText(duration: CMTime) -> String {
        let durationSeconds = CMTimeGetSeconds(duration)
        
        let seconds = Int(durationSeconds) % 60
        let minutes = Int(durationSeconds) / 60
        
        let remainingText = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        
        return remainingText
    }
    
}


