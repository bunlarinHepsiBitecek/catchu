//
//  PostFinishActivityView.swift
//  catchu
//
//  Created by Erkut Baş on 12/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

// color codes
// sari FCB045, kirmizi FD1D1D
// mavi A5FECB, 20BDFF, 5433FF
// pembe EC38BC, 7303C0, 03001E
// mor 33001B, FF0084

import UIKit

class PostFinishActivityView: UIView {
    
    private var activityViewModel = PostFinishActivityViewModel()
    
    private var second = Constants.NumericConstants.INTEGER_FOUR
    private var timer = Timer()
    private var isTimerRunning : Bool = false

    lazy var containerView: UIView = {
        let temp = UIView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_150, height: Constants.StaticViewSize.ViewSize.Height.height_100))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_8
        
        temp.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.shadowOffset = .zero
        temp.layer.shadowOpacity = 2;
        temp.layer.shadowRadius = 6;
        temp.layer.shadowPath = UIBezierPath(roundedRect: temp.bounds, cornerRadius: Constants.StaticViewSize.CorderRadius.cornerRadius_8).cgPath
        
        return temp
    }()
    
    lazy var catchUIcon: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "Catchu_Transparent.png")
        
        return temp
    }()
    
    lazy var postingLabel: UILabel = {
        
        let temp = UILabel()
//        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        temp.text = LocalizedConstants.TitleValues.LabelTitle.posting
        temp.numberOfLines = 1
        temp.contentMode = .center
        temp.textAlignment = .center
        
        return temp
    }()
    
    lazy var gradientPostingLabel_1: GradientLabel = {
        let temp = GradientLabel(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_150, height: Constants.StaticViewSize.ViewSize.Height.height_30), text: LocalizedConstants.TitleValues.LabelTitle.posting, fontSize: 16, colorArray: [#colorLiteral(red: 0.9882352941, green: 0.6901960784, blue: 0.2705882353, alpha: 1).cgColor, #colorLiteral(red: 0.9921568627, green: 0.1137254902, blue: 0.1137254902, alpha: 1).cgColor])
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var gradientPostingLabel_3: GradientLabel = {
        let temp = GradientLabel(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_150, height: Constants.StaticViewSize.ViewSize.Height.height_30), text: LocalizedConstants.TitleValues.LabelTitle.posting, fontSize: 16, colorArray: [#colorLiteral(red: 0.6470588235, green: 0.9960784314, blue: 0.7960784314, alpha: 1).cgColor, #colorLiteral(red: 0.1254901961, green: 0.7411764706, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.3294117647, green: 0.2, blue: 1, alpha: 1).cgColor])
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var gradientPostingLabel_2: GradientLabel = {
        let temp = GradientLabel(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_150, height: Constants.StaticViewSize.ViewSize.Height.height_30), text: LocalizedConstants.TitleValues.LabelTitle.posting, fontSize: 16, colorArray: [#colorLiteral(red: 0.9254901961, green: 0.2196078431, blue: 0.737254902, alpha: 1).cgColor, #colorLiteral(red: 0.4509803922, green: 0.01176470588, blue: 0.7529411765, alpha: 1).cgColor, #colorLiteral(red: 0.01176470588, green: 0, blue: 0.1176470588, alpha: 1).cgColor])
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var gradientPostingLabel_4: GradientLabel = {
        let temp = GradientLabel(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_150, height: Constants.StaticViewSize.ViewSize.Height.height_30), text: LocalizedConstants.TitleValues.LabelTitle.posting, fontSize: 16, colorArray: [#colorLiteral(red: 0.2, green: 0, blue: 0.1058823529, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0, blue: 0.5176470588, alpha: 1).cgColor])
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension PostFinishActivityView {
    
    private func initializeView() {
        
        selfViewSettings()
        addViews()
        
        selfViewAlphaManagement(active: false)
        
    }
    
    private func selfViewSettings() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func addViews() {
        
        self.addSubview(containerView)
        self.addSubview(catchUIcon)
        //self.containerView.addSubview(postingLabel)
        self.containerView.addSubview(gradientPostingLabel_1)
        self.containerView.addSubview(gradientPostingLabel_2)
        self.containerView.addSubview(gradientPostingLabel_3)
        self.containerView.addSubview(gradientPostingLabel_4)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100),
            containerView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            
            catchUIcon.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            catchUIcon.topAnchor.constraint(equalTo: safeContainerView.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            catchUIcon.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_80),
            catchUIcon.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_80),
            
            gradientPostingLabel_1.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            gradientPostingLabel_1.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            gradientPostingLabel_1.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            gradientPostingLabel_1.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),
            
            gradientPostingLabel_2.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            gradientPostingLabel_2.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            gradientPostingLabel_2.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            gradientPostingLabel_2.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),
            
            gradientPostingLabel_3.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            gradientPostingLabel_3.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            gradientPostingLabel_3.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            gradientPostingLabel_3.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),
            
            gradientPostingLabel_4.centerXAnchor.constraint(equalTo: safeContainerView.centerXAnchor),
            gradientPostingLabel_4.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            gradientPostingLabel_4.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_150),
            gradientPostingLabel_4.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),

            ])
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.scaledBy(x: -1, y: 1)
        })
        
    }
    
    func runTimer() {
        second = Constants.NumericConstants.INTEGER_FOUR
        timer = Timer.scheduledTimer(timeInterval: Constants.AnimationValues.aminationTime_05, target: self,   selector: (#selector(CircleView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if second == 4 {
            gradientPostingLabel_4.viewActivationManager(active: false, animated: true)
        }
        if second == 3 {
            gradientPostingLabel_3.viewActivationManager(active: false, animated: true)
        }
        if second == 2 {
            gradientPostingLabel_2.viewActivationManager(active: false, animated: true)
        }
        if second == 1 {
            gradientPostingLabel_1.viewActivationManager(active: false, animated: true)
        }
        
        second -= 1
        
        // flip catchU icon
        self.rotateView(targetView: self.catchUIcon, duration: Constants.AnimationValues.aminationTime_05)
        
        if second <= 0 {
            timer.invalidate()
            
            self.catchUIcon.transform = .identity
            self.activityViewModel.viewTimerState.value = .stopped
            
        }
        
    }
    
}

// MARK: - outside
extension PostFinishActivityView {
    
    fileprivate func selfViewAlphaManagement(active : Bool) {
        if active {
            self.alpha = 1
            runTimer()
        } else {
            self.alpha = 0
        }
    }
    
    func viewActivationManager(active : Bool, animated: Bool){
        
        if animated {
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_03, options: .transitionCrossDissolve, animations: {
                    
                    self.selfViewAlphaManagement(active: active)
                    
                })
            }
        } else {
            self.selfViewAlphaManagement(active: active)
        }
        
    }
    
    func activityStateListener(completion : @escaping (_ state : TimerState) -> Void) {
        activityViewModel.viewTimerState.bind(completion)
    }
    
}
