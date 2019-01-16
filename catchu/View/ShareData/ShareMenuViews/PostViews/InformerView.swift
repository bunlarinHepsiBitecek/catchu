
//
//  InformerView.swift
//  catchu
//
//  Created by Erkut Baş on 1/6/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class InformerView: UIView {
    
    var informerViewModel = InformerViewModel()
    
    private var isGradientAdded: Bool = false
    private let gradientColorForSuccess = CAGradientLayer()
    private let gradientColorForFailed = CAGradientLayer()
    
    var postState: PostState?
    
    lazy var containerView: UIView = {
        //let temp = UIView(frame: self.frame)
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        // clipsToBounds dersen uzerine eklenen diger viewlarda corner radius degerine uyar
        temp.clipsToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.ConstraintValues.constraint_15
        //temp.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        //temp.layer.insertSublayer(gradientColorForSuccess, at: 0)
        
        return temp
        
    }()
    
    // blur view
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        
        return temp
    }()
    
    lazy var resultImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        //temp.image = UIImage(named: "icon_thick_check")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return temp
    }()
    
    lazy var informerContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        temp.clipsToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        return temp
    }()
    
    lazy var stackViewForInformerMessage: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [mainMessage, subMessage])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let mainMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let subMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var informerMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = LocalizedConstants.Notification.postSuccessMessage
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var blurViewForInformerMessage: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_10
        
        return temp
    }()
    
    // button for cancel, to go back
    lazy var tryAgainButton: UIButton = {
        let temp = UIButton(type: UIButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        temp.setTitle(LocalizedConstants.TitleValues.ButtonTitle.tryAgain, for: .normal)
        
        //temp.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.titleLabel?.textAlignment = .center
        temp.titleLabel?.contentMode = .center
        temp.titleLabel?.lineBreakMode = .byWordWrapping
        temp.backgroundColor = UIColor.clear
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        temp.addTarget(self, action: #selector(tryAgainProcess(_:)), for: .touchUpInside)
        
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_25
        temp.clipsToBounds = true
        
        return temp
        
    }()
    
    // blur view
    lazy var blurViewForTryAgain: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let temp = UIVisualEffectView(effect: effect)
        temp.isUserInteractionEnabled = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.masksToBounds = true
        //temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_18
        return temp
    }()
    
    init(frame: CGRect, postState: PostState) {
        super.init(frame: frame)
        
        self.postState = postState
        
        do {
            try initializeViews()
        } catch let error as ClientPresentErrors {
            if error == .missingPostState {
                print("\(Constants.ALERT) postState is required.")
            }
        }
        catch {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.containerView.frame.height > 0 {
            if !isGradientAdded {
                addGradientColor()
                isGradientAdded = true
            }
        }
        
    }
    
}

// MARK: - major functions
extension InformerView {
    
    private func initializeViews() throws {
        
        guard let postState = postState else { throw ClientPresentErrors.missingPostState }
        
        // mandatory views
        addViews()
        addGestureRecognizersToContainerView()
        
        switch postState {
        case .success:
            successConfigurations()
        case .failed:
            failConfigurations()
            addTryAgainViews()
        }
        
    }
    
    private func successConfigurations() {
        resultImageView.image = UIImage(named: "icon_thick_check")?.withRenderingMode(.alwaysTemplate)
        resultImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainMessage.text = LocalizedConstants.Notification.postSuccessMessage
    }
    
    private func failConfigurations() {
        resultImageView.image = UIImage(named: "icon_cross")?.withRenderingMode(.alwaysTemplate)
        resultImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //informerMessage.text = LocalizedConstants.Notification.postFailedMessage
        mainMessage.text = LocalizedConstants.Notification.postFailedMessage
        subMessage.text = LocalizedConstants.Notification.tapToClose
    }
    
    private func addViews() {
        self.addSubview(containerView)
        self.containerView.addSubview(resultImageView)
        self.containerView.addSubview(blurView)
        self.containerView.addSubview(stackViewForInformerMessage)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        let safeResultImageView = self.resultImageView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_0),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            resultImageView.centerYAnchor.constraint(equalTo: safeContainerView.centerYAnchor),
            resultImageView.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_20),
            resultImageView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_30),
            resultImageView.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_30),
            
            blurView.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: safeContainerView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor),
            
            stackViewForInformerMessage.centerYAnchor.constraint(equalTo: safeContainerView.centerYAnchor),
            stackViewForInformerMessage.leadingAnchor.constraint(equalTo: safeResultImageView.trailingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            ])
        
        bringViewsFront()
        
    }
    
    private func addGradientColor() {
        
        guard let postState = postState else { return }
        
        switch postState {
        case .success:
            gradientColorForSuccess.frame = containerView.bounds
            gradientColorForSuccess.colors = [#colorLiteral(red: 0.06666666667, green: 0.6, blue: 0.5568627451, alpha: 1).cgColor, #colorLiteral(red: 0.2196078431, green: 0.937254902, blue: 0.4901960784, alpha: 1).cgColor]
            gradientColorForSuccess.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientColorForSuccess.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            containerView.layer.insertSublayer(gradientColorForSuccess, at: 0)
            
        case .failed:
            gradientColorForFailed.frame = containerView.bounds
            gradientColorForFailed.colors = [#colorLiteral(red: 0.5764705882, green: 0.1607843137, blue: 0.1176470588, alpha: 1).cgColor, #colorLiteral(red: 0.9294117647, green: 0.1294117647, blue: 0.2274509804, alpha: 1).cgColor]
            gradientColorForFailed.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientColorForFailed.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            containerView.layer.insertSublayer(gradientColorForFailed, at: 0)
        }
        
    }
    
    private func updateGradientFrame() {
        
        print("\(#function)")
        
        guard let postState = postState else { return }
        
        switch postState {
        case .success:
            gradientColorForSuccess.frame = containerView.frame
        case .failed:
            gradientColorForFailed.frame = containerView.frame
        }
        
    }
    
    private func bringViewsFront() {
        containerView.bringSubview(toFront: blurView)
        containerView.bringSubview(toFront: resultImageView)
        containerView.bringSubview(toFront: stackViewForInformerMessage)
        
        guard let postState = postState else { return }
        
        if postState == .failed {
            containerView.bringSubview(toFront: tryAgainButton)
        }

    }
    
    private func startAnimationCommon(inputObject: UIView) {
        
        inputObject.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.50),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                
                inputObject.transform = CGAffineTransform.identity
                
                
        })
        inputObject.layoutIfNeeded()
    }
    
    func listenInformerGestureRecognizers(completion: @escaping (_ state: InformerGestureStates) -> Void) {
        informerViewModel.informerState.bind(completion)
    }
    
    private func addTryAgainViews() {
        addTryAgainButton()
        addBlurEffectToTryAgainButton()
    }
    
    private func addTryAgainButton() {
        self.containerView.addSubview(tryAgainButton)

        let safeContainerView = self.containerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tryAgainButton.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            tryAgainButton.centerYAnchor.constraint(equalTo: safeContainerView.centerYAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_50),
            tryAgainButton.widthAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Width.width_50),
            
            ])
    }
    
    private func addBlurEffectToTryAgainButton() {
        
        tryAgainButton.insertSubview(blurViewForTryAgain, at: 0)
        
        let safe = self.tryAgainButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            blurViewForTryAgain.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            blurViewForTryAgain.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            blurViewForTryAgain.topAnchor.constraint(equalTo: safe.topAnchor),
            blurViewForTryAgain.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    @objc func tryAgainProcess(_ sender: UIButton) {
        informerViewModel.informerState.value = .tapped
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension InformerView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func addGestureRecognizersToContainerView() {
        
        guard let postState = postState else { return }

        addSwipeGestureRecognizerToContainerView()
        
        if postState == .failed {
            addTapGestureSubMessage()
        }
        
    }
    
    private func addTapGestureSubMessage() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InformerView.tapProcess(_:)))
        tapGesture.delegate = self
        subMessage.addGestureRecognizer(tapGesture)
        
    }
    
    private func addSwipeGestureRecognizerToContainerView() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(InformerView.swipeProcess(_:)))
        swipeGesture.direction = .up
        swipeGesture.delegate = self
        containerView.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func tapProcess(_ sender: UITapGestureRecognizer) {
        print("\(#function)")
        startAnimationCommon(inputObject: subMessage)
        informerViewModel.informerState.value = .tapped
    }
    
    @objc func swipeProcess(_ sender: UISwipeGestureRecognizer) {
        print("\(#function)")
        informerViewModel.informerState.value = .swipped
    }
    
}


/*
 
 @IBAction func tapped(_ sender: Any) {
 
 start { (finish) in
 if finish {
 self.stop(completion: { (finish) in
 if finish {
 print("yarro")
 }
 })
 }
 }
 
 }
 
 func start(completion: @escaping(_ animationFinish: Bool) -> Void) {
 
 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear], animations: {
 
 self.tempView2.transform = CGAffineTransform(translationX: 0, y: 200)
 
 }, completion: { complated in
 completion(complated)
 })
 
 }
 
 func stop(completion: @escaping(_ animationFinish: Bool) -> Void) {
 
 UIView.animate(withDuration: 0.5, delay: 1, options: [.beginFromCurrentState, .curveEaseIn], animations: {
 self.tempView2.transform = .identity
 })
 
 }
 */
