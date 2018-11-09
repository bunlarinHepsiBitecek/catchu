//
//  CustomVideoView.swift
//  catchu
//
//  Created by Erkut Baş on 9/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CustomVideoView: UIView {
    
    let customVideo = CustomVideo()
    
    var capturedVideoView : CustomCapturedVideoView?
    
    var heigthConstraint : NSLayoutConstraint?
    var widthConstraint : NSLayoutConstraint?
    var bottomConstraints : NSLayoutConstraint?
    
    var circleLayer: CAShapeLayer!
    var circleView : CircleView?
    
    var recordStopFlag : Bool = false
    
    weak var delegate : ShareDataProtocols!
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var recordContainerView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        temp.layer.cornerRadius = 30
        
        return temp
    }()
    
    lazy var switchButtonContainer: UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var switchButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "rotate-1")?.withRenderingMode(.alwaysTemplate)
        //        temp.image = UIImage(named: "switch_camera_default")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var recordButton: UIView = {
        
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        temp.layer.borderWidth = 5
        //        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 30
        
        return temp
    }()
    
    lazy var flashButtonContainer: UIView = {
        
        let temp = UIView()
        temp.layer.cornerRadius = 30
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var flashButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "flash")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.tag = 1
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: .zero)
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus{
        case .authorized:
            
            let statusForMicrophone = AVAudioSession.sharedInstance().recordPermission()
            
            switch statusForMicrophone {
            case .granted:
                initalizeViews()
                
            default:
                microphonePermissionProcess(inputStatus: statusForMicrophone)
            }
            
        default:
            videoCameraPermissionProcess(status: cameraAuthorizationStatus)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func initalizeViews() {
        
        setupViews()
        initiateVideoProcess()
        setGestureToRecordButton()
        setupGestureRecognizerForSwitchCamera()
        setupGestureRecognizerForFlashButton()
        customVideoViewVisibilityManagement(inputValue: true)
        
    }
    
    func customVideoViewVisibilityManagement(inputValue : Bool) {
        
        if inputValue {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
        
    }
    
    func startVideo() {
        
        customVideoViewVisibilityManagement(inputValue: true)
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus{
        case .authorized:
            
            let statusForMicrophone = AVAudioSession.sharedInstance().recordPermission()
            
            switch statusForMicrophone {
            case .granted:
                //                initiateVideoProcess()
                startVideoProcess()
                
                
            default:
                microphonePermissionProcess(inputStatus: statusForMicrophone)
            }
            
        default:
            videoCameraPermissionProcess(status: cameraAuthorizationStatus)
        }
        
    }
    
    func startVideoProcess() {
        
        //        customVideoViewVisibilityManagement(inputValue: false)
        
        do {
            try customVideo.enableVideoSession()
        } catch  {
            print("customVideo session can not be enabled")
        }
        
    }
    
    func stopVideo() {
        
        customVideoViewVisibilityManagement(inputValue: false)
        
        do {
            try customVideo.disableVideoSession()
        } catch  {
            print("customVideo session can not be disabled")
        }
        
    }
    
    func initializeRequestProcess() {
        
        PermissionHandler.shared.delegateForShareData = self
        PermissionHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .microphone)
        
    }
    
    func setupViews() {
        
        self.addSubview(mainView)
        self.mainView.addSubview(recordContainerView)
        self.mainView.addSubview(recordButton)
        self.mainView.addSubview(switchButtonContainer)
        self.switchButtonContainer.addSubview(switchButton)
        self.mainView.addSubview(flashButtonContainer)
        self.flashButtonContainer.addSubview(flashButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeMainview = self.mainView.safeAreaLayoutGuide
        let safeRecordButton = self.recordButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            recordContainerView.centerXAnchor.constraint(equalTo: safeMainview.centerXAnchor),
            recordContainerView.bottomAnchor.constraint(equalTo: safeMainview.bottomAnchor, constant: -35),
            recordContainerView.heightAnchor.constraint(equalToConstant: 60),
            recordContainerView.widthAnchor.constraint(equalToConstant: 60),
            
            recordButton.centerXAnchor.constraint(equalTo: safeMainview.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: safeMainview.bottomAnchor, constant: -35),
            recordButton.heightAnchor.constraint(equalToConstant: 60),
            recordButton.widthAnchor.constraint(equalToConstant: 60),
            
            switchButtonContainer.leadingAnchor.constraint(equalTo: safeRecordButton.trailingAnchor, constant: 20),
            switchButtonContainer.bottomAnchor.constraint(equalTo: safeMainview.bottomAnchor, constant: -35),
            switchButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            switchButtonContainer.widthAnchor.constraint(equalToConstant: 60),
            
            switchButton.centerXAnchor.constraint(equalTo: switchButtonContainer.safeCenterXAnchor),
            switchButton.centerYAnchor.constraint(equalTo: switchButtonContainer.safeCenterYAnchor),
            switchButton.heightAnchor.constraint(equalToConstant: 30),
            switchButton.widthAnchor.constraint(equalToConstant: 30),
            
            flashButtonContainer.trailingAnchor.constraint(equalTo: safeRecordButton.leadingAnchor, constant: -20),
            flashButtonContainer.bottomAnchor.constraint(equalTo: safeMainview.bottomAnchor, constant: -35),
            flashButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            flashButtonContainer.widthAnchor.constraint(equalToConstant: 60),
            
            flashButton.centerXAnchor.constraint(equalTo: flashButtonContainer.safeCenterXAnchor),
            flashButton.centerYAnchor.constraint(equalTo: flashButtonContainer.safeCenterYAnchor),
            flashButton.heightAnchor.constraint(equalToConstant: 30),
            flashButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func initiateVideoProcess() {
        
        customVideo.delegate = self
        
        func configureCustomVideo() {
            customVideo.prepare { (error) in
                if let error = error {
                    print(error)
                }
                
                print("initiateVideoProcess starts")
                
                try? self.customVideo.displayPreviewForVideo(on: self.mainView)
            }
        }
        
        configureCustomVideo()
        
        
    }
    
    func adjustRecordButtonBorders(input : RecordStatus) {
        
        switch input {
        case .active:
            
            print("activeeeeee")
            
        case .passive:
            
            print("passiveeeee")
            
            if !recordStopFlag {
                
                stopRecordButtonAnimation()
                
            }
        }
        
    }
    
    func addCircle() {
        
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        var circleWidth = CGFloat(110)
        var circleHeight = circleWidth
        
        // Create a new CircleView
        circleView = CircleView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        guard let circleView = circleView else { return }
        
        recordContainerView.addSubview(circleView)
        //        recordContainerView.insertSubview(circleView, at: 0)
        
        // Animate the drawing of the circle over the course of 1 second
        //        circleView.animateCircle(duration: 20)
        
    }
    
    func startCircleAnimation() {
        
        guard let circleView = circleView else { return }
        
        circleView.animateCircle(duration: 20)
        
    }
    
    func stopCircleAnimation() {
        
        guard let circleView = circleView else { return }
        
        circleView.stop()
        
    }
    
    
    /// Record Button Animation Start
    func startRecordButtonAnimation() {
        
        delegate.scrollableManagement(enabled: false)
        
        recordStopFlag = false
        
        addCircle()
        startCircleAnimation()
        
        UIView.transition(with: recordButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.recordButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.recordContainerView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.recordButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        
        startCircleAnimation()
        
        customVideo.startRecording()
        
    }
    
    /// Record Button Animation Stops
    func stopRecordButtonAnimation() {
        
        delegate.scrollableManagement(enabled: true)
        
        recordStopFlag = true
        
        UIView.transition(with: recordButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.recordButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.recordContainerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.recordButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        guard let circleView = circleView else { return }
        
        stopCircleAnimation()
        
        circleView.removeFromSuperview()
        
        customVideo.stopRecording()
        
    }
    
    func videoCameraPermissionProcess(status : AVAuthorizationStatus) {
        
        CustomPermissionViewController.shared.delegate = self
        
        switch status {
        case .notDetermined:
            // mainview lazy var oldugundan dolayı henuz o ayaga kalkmadan ona add subview yapılamıyor.
            //CustomPermissionViewController.shared.createAuthorizationView(inputView: mainView, permissionType: .camera)
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .camera)
        case .denied, .restricted:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .cameraUnathorized)
        default:
            break
        }
        
    }
    
    func microphonePermissionProcess(inputStatus : AVAudioSessionRecordPermission) {
        
        CustomPermissionViewController.shared.delegate = self
        
        switch inputStatus {
        case .undetermined:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .microphone)
        default:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .microphoneUnAuthorizated)
        }
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomVideoView : UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if touch.view == recordButton {
                
                startRecordButtonAnimation()
                
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesEnded")
        
        if let touch = touches.first {
            
            if touch.view == recordButton {
                
                if !recordStopFlag {
                    stopRecordButtonAnimation()
                }
                
            }
        }
    }
    
    func setGestureToRecordButton() {
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(CustomVideoView.startRecordAnimation(_:)))
        longGesture.delegate = self
        recordButton.addGestureRecognizer(longGesture)
        
    }
    
    @objc func startRecordAnimation(_ sender : UILongPressGestureRecognizer)  {
        
        if sender.state == .began {
            
            print("long press begins")
            
            //            customVideo.startRecording()
            //
            //            addCircle()
            
            adjustRecordButtonBorders(input: .active)
            
            
            
        } else if sender.state == .ended {
            
            print("long press finishes")
            
            adjustRecordButtonBorders(input: .passive)
            
            //            customVideo.stopRecording()
        }
        
    }
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCameraView.dismissCustomCameraView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        self.mainView.bringSubview(toFront: closeButton)
        
    }
    
    @objc func dismissCustomCameraView(_ sender : UITapGestureRecognizer) {
        
        print("dismissCustomCameraView starts")
        
        do {
            try customVideo.enableVideoSession()
        } catch  {
            print("custom view is not enabled")
        }
        
    }
    
    func setupGestureRecognizerForSwitchCamera() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomVideoView.switchCamera(_:)))
        tapGesture.delegate = self
        switchButton.addGestureRecognizer(tapGesture)
        switchButtonContainer.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func switchCamera(_ sender : UITapGestureRecognizer) {
        
        print("switchCamera starts")
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_05) {
            
            self.switchButton.transform = self.switchButton.transform == CGAffineTransform(rotationAngle: CGFloat(Double.pi)) ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        do {
            try customVideo.switchCameras()
        }
            
        catch {
            print(error)
        }
        
    }
    
    func setupGestureRecognizerForFlashButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomVideoView.flashManagement(_:)))
        tapGesture.delegate = self
        //        flashButton.addGestureRecognizer(tapGesture)
        flashButtonContainer.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func flashManagement(_ sender : UITapGestureRecognizer) {
        
        print("flashManagement starts")
        
        print("customCamera flash : \(customVideo.flashMode)")
        print("flash tag : \(flashButton.tag)")
        
        if flashButton.tag == 1 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 2
                self.customVideo.flashMode = .on
                
            }
            
        } else if flashButton.tag == 2 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash-2")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 3
                self.customVideo.flashMode = .off
                
            }
            
        } else if flashButton.tag == 3 {
            
            UIView.transition(with: flashButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.flashButton.image = UIImage(named: "flash-3")?.withRenderingMode(.alwaysTemplate)
                self.flashButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }) { (result) in
                
                self.flashButton.tag = 1
                self.customVideo.flashMode = .auto
                
            }
            
        }
        
    }
    
}

extension CustomVideoView : PermissionProtocol {
    
    func returnPermissinResultBoolValue(result: Bool) {
        
        if result {
            
            let statusForMicrophone = AVAudioSession.sharedInstance().recordPermission()
            
            switch statusForMicrophone {
            case .granted:
                //                initalizeViews()
                startVideo()
                
            default:
                microphonePermissionProcess(inputStatus: statusForMicrophone)
            }
            
        }
        
    }
    
}


// MARK: - ShareDataProtocols
extension CustomVideoView : ShareDataProtocols {
    
    func directToCapturedVideoView(url: URL) {
        
        capturedVideoView = CustomCapturedVideoView(outputFileURL: url)
        
        capturedVideoView?.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        
        UIView.transition(with: mainView, duration: Constants.AnimationValues.aminationTime_05, options: .transitionCrossDissolve, animations: {
            
            self.mainView.addSubview(self.capturedVideoView!)
            
            self.capturedVideoView!.translatesAutoresizingMaskIntoConstraints = false
            
            let safe = self.mainView.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.capturedVideoView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                self.capturedVideoView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                self.capturedVideoView!.topAnchor.constraint(equalTo: safe.topAnchor),
                self.capturedVideoView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
                
                ])
            
        })
        
    }
    
    func initiateCustomVideo() {
        
        initalizeViews()
        
    }
    
}
