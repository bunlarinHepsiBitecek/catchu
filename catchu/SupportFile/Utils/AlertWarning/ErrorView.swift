//
//  AlertView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/1/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

enum Placement {
    case top
    case bottom
}

public enum ErrorType {
    case info
    case success
    case warning
    case error
}

class ErrorView: BaseView {
    
    var placement: Placement = .top
    var delay: TimeInterval? { return 4.0 }
    var showDuration: TimeInterval? { return 0.8 }
    var hideDuration: TimeInterval? { return 0.8 }
    
    public typealias AnimationCompletion = (_ completed: Bool) -> Void
    private let padding: CGFloat = 10
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        label.text = "[Title]"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        label.text = "[Body]"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 5
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupView() {

        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor, constant: padding),
            stackView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: -padding),
            stackView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: padding),
            stackView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: -padding),
            ])
    }
    
    func configureTheme(_ type: ErrorType, _ placement: Placement? = nil) {
        self.placement = placement ?? self.placement
        
        switch type {
        case .error:
            let backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            let foregroundColor = UIColor.white
            configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        default:
            return
        }
    }
    
    func configureTheme(backgroundColor: UIColor, foregroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.titleLabel.textColor = foregroundColor
        self.bodyLabel.textColor = foregroundColor
    }
    
    func configureContent(title: String? = nil, body: String? = nil) {
        self.titleLabel.text = title
        self.bodyLabel.text = body
        
        self.titleLabel.isHidden = title == nil
        self.bodyLabel.isHidden = body == nil
    }
    
    func show(targetView: UIView? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var currentView = targetView
        if currentView == nil {
            guard let currentVC = LoaderController.currentViewController() else {
                print("Current View controller can not be found for \(String(describing: self))")
                return
            }
            currentView = currentVC.view
        }
        
        guard let mainView = currentView else { return }
        
        mainView.addSubview(self)
        NSLayoutConstraint.activate([
            self.safeLeadingAnchor.constraint(equalTo: mainView.safeLeadingAnchor),
            self.safeTrailingAnchor.constraint(equalTo: mainView.safeTrailingAnchor),
            ])
        
        self.showAnimation(view: mainView) { (complated) in
            self.hideAnimation(view: mainView, completion: { (complated) in
                self.removeFromSuperview()
            })
        }
    }
    
    private func showAnimation(view: UIView, completion: @escaping AnimationCompletion) {
        let animationDistance = view.frame.height
        
        switch placement {
        case .top:
            self.safeTopAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
            self.transform = CGAffineTransform(translationX: 0, y: -animationDistance)
        case .bottom:
            self.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
            self.transform = CGAffineTransform(translationX: 0, y: animationDistance)
        }
        
        UIView.animate(withDuration: self.showDuration!, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear], animations: {
            self.transform = .identity
        }, completion: { complated in
            completion(complated)
        })
    }
    
    private func hideAnimation(view: UIView, completion: @escaping AnimationCompletion) {
        let animationDistance = view.frame.height
        
        UIView.animate(withDuration: self.hideDuration!, delay: self.delay!, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            switch self.placement {
            case .top:
                self.transform = CGAffineTransform(translationX: 0, y: -animationDistance)
            case .bottom:
                self.transform = CGAffineTransform(translationX: 0, y: view.frame.maxY + animationDistance)
            }
        }, completion: { complated in
            completion(complated)
        })
    }
}

