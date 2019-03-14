//
//  VideoView.swift
//  catchu
//
//  Created by Erkut Baş on 11/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class VideoView: UIView {

    let customVideo = CustomVideo()
    var immediatelyStartSession: Bool = false
    var mainViewAdded: Bool = false
    
    //private var capturedVideoView : CustomCapturedVideoView?
    private var capturedVideoView : CapturedVideoView?
    
    private var heigthConstraint : NSLayoutConstraint?
    private var widthConstraint : NSLayoutConstraint?
    private var bottomConstraints : NSLayoutConstraint?
    
    private var circleLayer: CAShapeLayer!
    private var circleView : CircleView?
    
    private var recordStopFlag : Bool = false
    private var bluerEffectAdded : Bool = false
    
    private var second = 0
    private var timer = Timer()
    private var isTimerRunning : Bool = false
    
    weak var delegate : PostViewProtocols!
    
    lazy var mainView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var topMenuContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var countTimerContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        return temp
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_20
        temp.layer.masksToBounds = true
        return temp
    }()
    
    lazy var stackViewCounterObjects: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [minuteLabel, semiColonLabel, secondLabel])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    var minuteLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.text = "00"
        
        return temp
        
    }()
    
    var semiColonLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.text = ":"
        
        return temp
        
    }()
    
    var secondLabel: UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.textAlignment = .center
        temp.contentMode = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.text = "00"
        
        return temp
        
    }()
    
    lazy var recordContainerView: UIView = {
        
        let temp = UIView(frame: .zero)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        //temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        temp.backgroundColor = UIColor.clear
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        
        return temp
    }()
    
    lazy var blurViewForRecordContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_30
        temp.layer.masksToBounds = true
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
    
    init(frame: CGRect, delegate: PostViewProtocols, immediatelyStartSession: Bool) {
        super.init(frame: frame)
        
        self.delegate = delegate
        self.immediatelyStartSession = immediatelyStartSession
        
        initializeView()
        // because addingSubview process can not catch preview layer adding process of customVideo
        //initiateVideoProcess()
        
//        if !immediatelyStartSession {
//            activationManager(active: false)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var count = 1
        
        print("count : \(count)")
        count += 1
        
        if !mainViewAdded {
            if self.mainView.frame.width > 0 && self.mainView.frame.height > 0 {
                mainViewAdded = true
                print("sevvvaalll")
                self.initiateVideoProcess()
                
                if !immediatelyStartSession {
                    activationManager(active: false)
                }
            }
        }
        
    }
    
}


// MARK: - major functions
extension VideoView {
    
    private func initializeView() {
        addViews()
        setupGestureRecognizers()
    }
    
    private func addViews() {
        
        self.addSubview(mainView)
        self.mainView.addSubview(topMenuContainer)
        self.topMenuContainer.addSubview(closeButton)
        self.topMenuContainer.addSubview(countTimerContainer)
        self.mainView.addSubview(recordContainerView)
        self.mainView.addSubview(recordButton)
        self.mainView.addSubview(switchButtonContainer)
        self.switchButtonContainer.addSubview(switchButton)
        self.mainView.addSubview(flashButtonContainer)
        self.flashButtonContainer.addSubview(flashButton)
        
        let safe = self.safeAreaLayoutGuide
        let safeMainview = self.mainView.safeAreaLayoutGuide
        let safeRecordButton = self.recordButton.safeAreaLayoutGuide
        let safeTopMenuContainer = self.topMenuContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            topMenuContainer.leadingAnchor.constraint(equalTo: safeMainview.leadingAnchor),
            topMenuContainer.trailingAnchor.constraint(equalTo: safeMainview.trailingAnchor),
            topMenuContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            topMenuContainer.topAnchor.constraint(equalTo: safeMainview.topAnchor, constant: UIApplication.shared.statusBarFrame.height),
            
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
            
            closeButton.centerYAnchor.constraint(equalTo: safeTopMenuContainer.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: safeTopMenuContainer.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            countTimerContainer.trailingAnchor.constraint(equalTo: safeTopMenuContainer.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            countTimerContainer.centerYAnchor.constraint(equalTo: safeTopMenuContainer.centerYAnchor),
            countTimerContainer.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            countTimerContainer.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_80),
            
            ])
        
        addBlurEffectToCountTimer()
        addBlurEffectToRecordButton()
        addCounterTimerStackOnBlurEffectView()
    }
    
    private func setupGestureRecognizers() {
        setupCloseButtonGesture()
    }
    
    private func adjustRecordButtonBorders(input : RecordStatus) {
        
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
    
    private func addCircle() {
        
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
    
    private func startCircleAnimation() {
        
        guard let circleView = circleView else { return }
        
        circleView.animateCircle(duration: 15)
        
    }
    
    private func stopCircleAnimation() {
        
        guard let circleView = circleView else { return }
        
        circleView.stop()
        
    }
    
    
    /// Record Button Animation Start
    private func startRecordButtonAnimation() {
        
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
    private func stopRecordButtonAnimation() {
        
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
    
    private func initiateVideoProcess() {
        
        customVideo.delegate = self
        
        func configureCustomVideo() {
            
            customVideo.prepare(immediatelyStartSession: immediatelyStartSession) { (error) in
                if let error = error {
                    print(error)
                }
                
                print("initiateVideoProcess starts")
                
                try? self.customVideo.displayPreviewForVideo(on: self.mainView)
            }
        }

        configureCustomVideo()
        
    }
    
    private func startVideoProcess() {
        print("\(#function) starts")
        do {
            try customVideo.enableVideoSession()
        } catch let error as CustomVideoError {
            print("error : \(error)")
        }
        catch  {
            print("customVideo session can not be enabled")
        }
        
    }
    
    private func stopVideoProcess() {
        print("\(#function) starts")
        do {
            try customVideo.disableVideoSession()
        } catch let error as CustomVideoError {
            print("error : \(error)")
        }catch  {
            print("customVideo session can not be disabled")
        }
        
    }
    
    func activationManager(active : Bool) {

        print("LOLOLOLOLOLOLOLOLO")
        
        if active {
            startVideoProcess()
        } else {
            stopVideoProcess()
        }
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            
            if active {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
            
        }
        
    }
    
    private func addBlurEffectToCountTimer() {
        
        countTimerContainer.insertSubview(blurView, at: 0)
        
        let safe = self.countTimerContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safe.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addBlurEffectToRecordButton() {
        
        recordContainerView.insertSubview(blurViewForRecordContainer, at: 0)
        
        let safe = self.recordContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurViewForRecordContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurViewForRecordContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurViewForRecordContainer.topAnchor.constraint(equalTo: safe.topAnchor),
            blurViewForRecordContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func addCounterTimerStackOnBlurEffectView() {
        
        countTimerContainer.addSubview(stackViewCounterObjects)
        
        let safe = self.countTimerContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewCounterObjects.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            stackViewCounterObjects.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            stackViewCounterObjects.topAnchor.constraint(equalTo: safe.topAnchor),
            stackViewCounterObjects.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(VideoView.setCounterTimeValue)), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_02) {
            self.second = 0
        }
    }
    
    @objc func setCounterTimeValue() {
        print("\(#function) starts")
        
        second += 1
        self.secondLabel.text = "\(self.second)"
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension VideoView : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VideoView.dismissVideoView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissVideoView(_ sender : UITapGestureRecognizer) {
        
        self.activationManager(active: false)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if touch.view == recordButton {
                runTimer()
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
                    stopTimer()
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
            adjustRecordButtonBorders(input: .active)
            
        } else if sender.state == .ended {
            print("long press finishes")
            adjustRecordButtonBorders(input: .passive)
            
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

// MARK: - ShareDataProtocols
extension VideoView : ShareDataProtocols {
    
    func directToCapturedVideoView(url: URL) {
        
        //capturedVideoView = CustomCapturedVideoView(outputFileURL: url)
        capturedVideoView = CapturedVideoView(outputFileURL: url, delegate: self)
        
        capturedVideoView?.backgroundColor = UIColor.clear
        
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
        
        //initalizeViews()
        
    }
    
}

// MARK: - PostViewProtocols
extension VideoView : PostViewProtocols {

    func activationProcessOfVideoView(active: Bool) {
        
        self.activationManager(active: active)
        self.delegate.committedCapturedVideo()
        
    }
    
}

