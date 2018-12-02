//
//  CapturedVideoView.swift
//  catchu
//
//  Created by Erkut Baş on 11/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CapturedVideoView: UIView {
    
    private var player : AVPlayer!
    private var playerLayer : AVPlayerLayer!
    
    private var recordedVideoURL : URL!
    
    private var activityIndicator: UIActivityIndicatorView!
    private var labelText : UILabel?
    
    private var isPlaying: Bool = false
    
    weak var delegate : PostViewProtocols!
    
    lazy var topMenuContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    lazy var footerContainerView: UIView = {
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
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
    
    lazy var commitButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.next, for: .normal)
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        temp.addTarget(self, action: #selector(commitProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        
        return temp
        
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.layer.masksToBounds = true
        return temp
    }()
    
    /*
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
        
    }*/
    
    init(outputFileURL : URL, delegate : PostViewProtocols) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        recordedVideoURL = outputFileURL
        
        setupViews()
        downloadButtonGesture()
        addGestureRecognizerToCloseButton()
        addGestureRecognizerToPlayStopButton()
        initializeVideoPlay(inputUrl : outputFileURL)
        
        setNotificationToKnowVideoIsEnded()
        
        //saveToSelectedItems()
        
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
extension CapturedVideoView {
    
    /// start adjust views
    func setupViews() {
        
        self.addSubview(topMenuContainer)
        self.topMenuContainer.addSubview(closeButton)
        self.topMenuContainer.addSubview(closeButtonShadow)
        self.addSubview(footerContainerView)
        self.footerContainerView.addSubview(downloadButton)
        self.footerContainerView.addSubview(playStopButtonView)
        self.footerContainerView.addSubview(commitButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeTopMenu = self.topMenuContainer.safeAreaLayoutGuide
        let safePlayStopButton = self.playStopButtonView.safeAreaLayoutGuide
        let safeFooterContainerView = self.footerContainerView.safeAreaLayoutGuide
        
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        
        NSLayoutConstraint.activate([
            
            topMenuContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            topMenuContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            topMenuContainer.topAnchor.constraint(equalTo: safe.topAnchor, constant: UIApplication.shared.statusBarFrame.height),
            topMenuContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            
            closeButton.centerYAnchor.constraint(equalTo: safeTopMenu.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: safeTopMenu.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            closeButtonShadow.topAnchor.constraint(equalTo: safeTopMenu.topAnchor, constant: 50),
            closeButtonShadow.leadingAnchor.constraint(equalTo: safeTopMenu.leadingAnchor, constant: 10),
            closeButtonShadow.heightAnchor.constraint(equalToConstant: 30),
            closeButtonShadow.widthAnchor.constraint(equalToConstant: 30),
            
            footerContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: bottomPadding!),
            footerContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            downloadButton.leadingAnchor.constraint(equalTo: safePlayStopButton.trailingAnchor, constant: 20),
            downloadButton.bottomAnchor.constraint(equalTo: safeFooterContainerView.bottomAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40),
            
            playStopButtonView.leadingAnchor.constraint(equalTo: safeFooterContainerView.leadingAnchor, constant: 10),
            playStopButtonView.bottomAnchor.constraint(equalTo: safeFooterContainerView.bottomAnchor, constant: -10),
            playStopButtonView.heightAnchor.constraint(equalToConstant: 40),
            playStopButtonView.widthAnchor.constraint(equalToConstant: 40),
            
            commitButton.centerYAnchor.constraint(equalTo: safeFooterContainerView.centerYAnchor),
            commitButton.trailingAnchor.constraint(equalTo: safeFooterContainerView.trailingAnchor, constant: -10),
            commitButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            commitButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_100),
            
            ])
        
        addGradientView()
        addBlurEffectToCommitButton()
        
    }
    
    /// add gradient to menu and footer view
    private func addGradientView() {
        
        let gradientForFooter = CAGradientLayer()
        
        gradientForFooter.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: Constants.StaticViewSize.ViewSize.Height.height_50)
        gradientForFooter.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        footerContainerView.layer.insertSublayer(gradientForFooter, at: 0)
        
    }
    
    private func addBlurEffectToCommitButton() {
        
        commitButton.insertSubview(blurView, at: 0)
        
        let safe = self.commitButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func initializeVideoPlay(inputUrl : URL) {
        
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
    
    private func startAnimation() {
        
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
    private func setupSaveProcessView() {
        
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
    
    private func showSpinning() {
        
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
    
    private func deleteSaveProcessView() {
        
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
    
    private func addLabelToSavedProcessView(result : Bool) {
        
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
    
    private func stopSpinning() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.deleteSaveProcessView()
        }
        
    }
    
    /// saving selected items into array to show user before posting process
    private func saveToSelectedItems() {
        
        print("saveToSelectedItems starts")
        print("recordedVideoURL : \(recordedVideoURL)")
        
        PostItems.shared.emptySelectedVideoUrl()
        PostItems.shared.appendNewItemToSelectedVideoUrl(url: recordedVideoURL)
        
        print("PostItems.shared.selectedVideoUrl count : \(PostItems.shared.selectedVideoUrl?.count)")
        
    }
    
    private func deleteRecordedVideoFromSavedArray(url : URL) {
        
        if PostItems.shared.selectedVideoUrl != nil {
            if let i = PostItems.shared.selectedVideoUrl!.firstIndex(of: recordedVideoURL) {
                PostItems.shared.selectedVideoUrl!.remove(at: i)
                PostItems.shared.deleteVideoScreenShot(inputUrl: recordedVideoURL)
            }
            
        }
        
    }
    
    private func getScreenShotForRecordedVideo() {
        
        PostItems.shared.appendVideoScreenShot(inputURL: recordedVideoURL, inputImage: videoSnapshot(url: recordedVideoURL)!)
        
    }
    
    private func videoSnapshot(url: URL) -> UIImage? {
        
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
    
    private func changePlayStopView(playing : Bool) {
        
        if !playing {
            playStopButtonView.image = UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate)
            playStopButtonView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            playStopButtonView.image = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
            playStopButtonView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
        
    }
    
    private func resetPlayer() {
        
        guard player != nil else {
            return
        }
        
        player!.seek(to: kCMTimeZero)
        isPlaying = false
        changePlayStopView(playing: false)
        
    }
    
    private func setNotificationToKnowVideoIsEnded() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(CapturedVideoView.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(_ notification : Notification) {
        print("playerDidFinishPlaying triggered")
        
        resetPlayer()
    }
    
    func startAnimationForCommitButton(completion : @escaping (_ finish : Bool) -> Void) {
        
        commitButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.commitButton.transform = CGAffineTransform.identity
            
        }, completion: completion)
        
    }
    
    @objc func commitProcess(_ sender : UIButton) {
        print("\(#function), \(#line) starts")
        
        print("selected image count : \(PostItems.shared.returnSelectedImageArrayCount())")
        
        saveToSelectedItems()
        
        startAnimationForCommitButton { (finish) in
            if finish {
                self.dismissView()
                self.delegate.activationProcessOfVideoView(active: false)
            }
        }
    }
    
    private func dismissView() {
        self.removeFromSuperview()
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate
extension CapturedVideoView : UIGestureRecognizerDelegate {
    
    func addGestureRecognizerToCloseButton() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CapturedVideoView.closeView(_:)))
        tapGestureRecognizer.delegate = self
        closeButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        deleteRecordedVideoFromSavedArray(url : recordedVideoURL)
        dismissView()
    }
    
    func downloadButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedVideoView.saveRecordedVideo(_:)))
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CapturedVideoView.playStopVideoOperations(_:)))
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
