//
//  FinalShareSaySomethingView.swift
//  catchu
//
//  Created by Erkut Baş on 10/8/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalShareSaySomethingView: UIView {

    weak var delegate : ViewPresentationProtocols!
    weak var delegateForViewController : ShareDataProtocols!
    
    private var keyboardHeigth : CGFloat?
    
    private var textViewHeightSet : Bool = false
    
    lazy var controllerTab: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
        
    }()
    
    lazy var postButtonContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var closeButtonContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    lazy var postButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "next-2")
        
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cross-2")
        
        return temp
    }()
    
    lazy var noteTextView: UITextView = {
        
        let temp = UITextView()
        temp.backgroundColor = UIColor.clear
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 10
        temp.text = LocalizedConstants.PostAttachmentInformation.saySomething
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        temp.textAlignment = .left
        temp.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.light)
//        temp.font = UIFont.boldSystemFont(ofSize: 28)
        temp.isScrollEnabled = false
        temp.textContainer.lineBreakMode = .byWordWrapping
        temp.textContainer.widthTracksTextView = true
        
        // keyboard settings
        temp.keyboardAppearance = .dark
        temp.keyboardType = .alphabet
        temp.keyboardDismissMode = .interactive
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        temp.delegate = self
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // remove observer
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}

// MARK: - major functions
extension FinalShareSaySomethingView {
    
    func initializeView() {
        
        addViews()
        addGestureToCloseButton()
        addGestureToPostButton()
        addObservers()
        
    }
    
    func setDelegations(delegate : ViewPresentationProtocols, delegateForViewController: ShareDataProtocols) {
        self.delegate = delegate
        self.delegateForViewController = delegateForViewController
    }
    
    func addViews() {
        
        self.addSubview(controllerTab)
        self.controllerTab.addSubview(postButtonContainer)
        self.controllerTab.addSubview(closeButtonContainer)
        self.postButtonContainer.addSubview(postButton)
        self.closeButtonContainer.addSubview(closeButton)
        self.addSubview(noteTextView)
        
        let safe = self.safeAreaLayoutGuide
        let safeControllerTab = self.controllerTab.safeAreaLayoutGuide
        let safePostContainer = self.postButtonContainer.safeAreaLayoutGuide
        let safeCloseContainer = self.closeButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            controllerTab.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            controllerTab.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            controllerTab.topAnchor.constraint(equalTo: safe.topAnchor),
            controllerTab.heightAnchor.constraint(equalToConstant: 40),
            
            postButtonContainer.trailingAnchor.constraint(equalTo: safeControllerTab.trailingAnchor),
            postButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            postButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            postButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            closeButtonContainer.leadingAnchor.constraint(equalTo: safeControllerTab.leadingAnchor
            ),
            closeButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            closeButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            closeButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            postButton.centerXAnchor.constraint(equalTo: safePostContainer.centerXAnchor),
            postButton.centerYAnchor.constraint(equalTo: safePostContainer.centerYAnchor),
            postButton.heightAnchor.constraint(equalToConstant: 36),
            postButton.widthAnchor.constraint(equalToConstant: 36),
            
            closeButton.centerXAnchor.constraint(equalTo: safeCloseContainer.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: safeCloseContainer.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            noteTextView.topAnchor.constraint(equalTo: safeControllerTab.bottomAnchor, constant: 10),
            noteTextView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            ])
        
    }
    
    /// observers for keyboard displays
    func addObservers() {
        print("addObservers starts")
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAddingTextView.keyboardViewChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func keyboardViewChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboardHeigth: \(keyboardSize.height)")
            
            keyboardHeigth = keyboardSize.height
            
            setTextViewHeight()
            
        }
    }
    
    func focusTextViewManagement(focus : Bool) {
        if focus {
            noteTextView.becomeFirstResponder()
        } else {
            noteTextView.resignFirstResponder()
        }
    }
    
    func setTextViewHeight() {
        
        print("controllerTab.frame.height : \(controllerTab.frame.height)")
        print("controllerTab.bounds.height : \(controllerTab.bounds.height)")
        print("UIScreen.main.bounds.height : \(UIScreen.main.bounds.height)")
        
        guard let keyboardHeigth = keyboardHeigth else { return }
     
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_07) {
            self.noteTextView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - (keyboardHeigth + self.controllerTab.frame.height + 40)).isActive = true
            
            self.layoutIfNeeded()
        }
        
        textViewHeightSet = true
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension FinalShareSaySomethingView : UIGestureRecognizerDelegate {
    
    func addGestureToCloseButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalShareSaySomethingView.dismissSaySomething(_:)))
        tapGesture.delegate = self
        closeButtonContainer.addGestureRecognizer(tapGesture)
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissSaySomething(_ sender : UITapGestureRecognizer) {
        
        delegate.dismissViewController()
        
    }
    
    func addGestureToPostButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalShareSaySomethingView.post(_:)))
        tapGesture.delegate = self
        postButtonContainer.addGestureRecognizer(tapGesture)
        postButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func post(_ sender : UITapGestureRecognizer) {
        
        PostItems.shared.setNote(inputString: noteTextView.text)
        self.delegateForViewController.dismisViewController(sharply: true)

        APIGatewayManager.shared.initiatePostOperations()
        
    }
    
}

// MARK: - UITextViewDelegate
extension FinalShareSaySomethingView : UITextViewDelegate {
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        noteTextView.text = nil
//
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        
//        if noteTextView.text.isEmpty {
//            noteTextView.text = LocalizedConstants.PostAttachmentInformation.saySomething
//        }
//
//    }
    
}
