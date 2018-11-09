//
//  CustomCapturedVideoView.swift
//  catchu
//
//  Created by Erkut Baş on 9/12/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CustomCapturedVideoView: UIView {

    private var player : AVPlayer!
    private var playerLayer : AVPlayerLayer!
    
    private var recordedVideoURL : URL!
    
    private var activityIndicator: UIActivityIndicatorView!
    private var labelText : UILabel?
    
    private var isPlaying: Bool = false
    
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
    
    lazy var downloadButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var saveProcessView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        temp.layer.cornerRadius = 10
        
        return temp
    }()
    
    lazy var playStopButtonView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
    }()
    
    required init(outputFileURL : URL) {
        super.init(frame: .zero)
        
        recordedVideoURL = outputFileURL
        
        setupViews()
        downloadButtonGesture()
        addGestureRecognizerToCloseButton()
        addGestureRecognizerToPlayStopButton()
        initializeVideoPlay(inputUrl : outputFileURL)
        
        setNotificationToKnowVideoIsEnded()
        
        saveToSelectedItems()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = self.frame
    }
    
}

// MARK: - major functions
extension CustomCapturedVideoView {

    /// start adjust views
    func setupViews() {
        
        self.addSubview(closeButton)
        self.addSubview(closeButtonShadow)
        self.addSubview(downloadButton)
        self.addSubview(playStopButtonView)
        
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
            
            downloadButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            downloadButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40),
            
            playStopButtonView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            playStopButtonView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10),
            playStopButtonView.heightAnchor.constraint(equalToConstant: 40),
            playStopButtonView.widthAnchor.constraint(equalToConstant: 40)
            
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
    
    func startAnimation() {
        
        downloadButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.downloadButton.transform = CGAffineTransform.identity
                
                
        })
        self.downloadButton.layoutIfNeeded()
        
    }
    
    /// save captured image to gallery
    func setupSaveProcessView() {
        
        UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            self.addSubview(self.saveProcessView)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.saveProcessView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
                self.saveProcessView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
                self.saveProcessView.heightAnchor.constraint(equalToConstant: 80),
                self.saveProcessView.widthAnchor.constraint(equalToConstant: 120)
                
                ])
            
            self.showSpinning()
            
        })
        
    }
    
    func showSpinning() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        activityIndicator.startAnimating()
        
        saveProcessView.addSubview(activityIndicator)
        
        let safe = saveProcessView.safeAreaLayoutGuide
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            ])
        
    }
    
    func deleteSaveProcessView() {
        
        guard let saveProcessViewSuperview = saveProcessView.superview else { return }
        
        UIView.transition(with: saveProcessView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            
            self.addLabelToSavedProcessView(result: true)
            
        }) { (result) in
            
            if result {
                
                guard let labelText = self.labelText else { return }
                
                UIView.transition(with: saveProcessViewSuperview, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
                    
                    self.saveProcessView.removeFromSuperview()
                    labelText.removeFromSuperview()
                    
                })
                
            }
            
        }
        
    }
    
    func addLabelToSavedProcessView(result : Bool) {
        
        labelText = UILabel()
        
        guard let labelText = labelText else { return }
        
        if result {
            labelText.text = LocalizedConstants.TitleValues.LabelTitle.saved
        } else {
            labelText.text = LocalizedConstants.TitleValues.LabelTitle.failed
        }
        
        labelText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelText.textAlignment = .center
        
        saveProcessView.addSubview(labelText)
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = saveProcessView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            labelText.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            labelText.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 20),
            labelText.widthAnchor.constraint(equalToConstant: 100)
            
            ])
        
    }
    
    func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.deleteSaveProcessView()
        }
        
    }
    
    /// saving selected items into array to show user before posting process
    func saveToSelectedItems() {
        
        print("saveToSelectedItems starts")
        print("recordedVideoURL : \(recordedVideoURL)")
        
        if PostItems.shared.selectedVideoUrl == nil {
            PostItems.shared.selectedVideoUrl = Array<URL>()
        }
        
        PostItems.shared.selectedVideoUrl!.append(recordedVideoURL)
//        getScreenShotForRecordedVideo()
        
        print("PostItems.shared.selectedVideoUrl count : \(PostItems.shared.selectedVideoUrl?.count)")
        
    }
    
    func deleteRecordedVideoFromSavedArray(url : URL) {
        
        if PostItems.shared.selectedVideoUrl != nil {
            if let i = PostItems.shared.selectedVideoUrl!.firstIndex(of: recordedVideoURL) {
                PostItems.shared.selectedVideoUrl!.remove(at: i)
                PostItems.shared.deleteVideoScreenShot(inputUrl: recordedVideoURL)
            }
            
        }
        
    }
    
    func getScreenShotForRecordedVideo() {
        
        PostItems.shared.appendVideoScreenShot(inputURL: recordedVideoURL, inputImage: videoSnapshot(url: recordedVideoURL)!)
        
    }
    
    func videoSnapshot(url: URL) -> UIImage? {
        
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomCapturedVideoView.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(_ notification : Notification) {
        print("playerDidFinishPlaying triggered")
        
        resetPlayer()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomCapturedVideoView : UIGestureRecognizerDelegate {

    func addGestureRecognizerToCloseButton() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomCapturedVideoView.closeView(_:)))
        tapGestureRecognizer.delegate = self
        closeButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        
        deleteRecordedVideoFromSavedArray(url : recordedVideoURL)
        
        self.removeFromSuperview()
        
    }
    
    func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCapturedVideoView.saveRecordedVideo(_:)))
        tapGesture.delegate = self
        downloadButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func saveRecordedVideo(_ sender : UITapGestureRecognizer) {
        
        print("saveRecordedVideo starts")
        
        startAnimation()
        setupSaveProcessView()
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.recordedVideoURL)
            
            
        }) { (response, error) in
            
            print("error : \(error)")
            print("response : \(response)")
            
            if response {
                
                self.stopSpinning()
                
            }
            
        }
        
    }
    
    func addGestureRecognizerToPlayStopButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCapturedVideoView.playStopVideoOperations(_:)))
        tapGesture.delegate = self
        playStopButtonView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc func playStopVideoOperations(_ sender : UITapGestureRecognizer) {
        
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
