//
//  CustomAddingTextView22.swift
//  catchu
//
//  Created by Erkut Baş on 9/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomAddingTextView2: UIView {
    
    private var leadingConstraintsOfTextView = NSLayoutConstraint()
    private var trailingConstraintsOfTextView = NSLayoutConstraint()
    private var topConstraintsOfTextView = NSLayoutConstraint()
    private var heigthConstraintsOfTextView = NSLayoutConstraint()
    
    private var bottomConstraintsOfColorPalette = NSLayoutConstraint()
    
    private var heigthConstraintOfTextViewContainer = NSLayoutConstraint()
    private var heigthActivated : Bool = false
    private var tempSize : CGFloat = 0.0
    private var tempSizeFlag : Bool = false
    
    private var keyboardHeigth : CGFloat?
    
    weak var customColorPalette : ColorPaletteView!
    
    weak var delegate : ShareDataProtocols!
    
    lazy var containerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return temp
        
    }()
    
    lazy var menuContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var doneButton: UIView = {
        
        let temp = UIView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 12.5
        temp.backgroundColor = UIColor.clear
        temp.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.borderWidth = 1
        
        return temp
        
    }()
    
    lazy var doneLabel: UILabel = {
        
        let temp = UILabel()
        temp.isUserInteractionEnabled = true
        temp.text = LocalizedConstants.TitleValues.ButtonTitle.add
        temp.font = UIFont.systemFont(ofSize: 17)
        temp.numberOfLines = 0
        temp.textAlignment = .center
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var textViewContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var textView: UITextView = {
        
        let temp = UITextView()
        temp.backgroundColor = UIColor.clear
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 7
        temp.text = "erkut"
        
        temp.textAlignment = .center
        temp.font = UIFont.boldSystemFont(ofSize: 28)
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
        
        setupMajorSettings()
        setupColorPaletteSettings()
        focusTextField()
        addObservers()
        addGestureToDoneButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        setHeigthConstraintsForTextView()
        
    }
    
}

// MARK: - major functions
extension CustomAddingTextView2 {
    
    func setHeigthConstraintsForTextView() {
        
        print("setHeigthConstraintsForTextView starts")
        print("keyboardHeigth : \(keyboardHeigth)")
        print("containerView size : \(containerView.frame.height)")
        print("menuContainerView size : \(menuContainerView.frame.height)")
        print("self.frame.size : \(self.frame.height)")
        
        guard let keyboardHeigth = keyboardHeigth else { return }
        
        if menuContainerView.frame.height > 0 {
            
            let textContainerFinalHeigth = self.frame.height - (keyboardHeigth + menuContainerView.frame.height)
            
            print("textContainerFinalHeigth : \(textContainerFinalHeigth)")
            
            heigthConstraintOfTextViewContainer = textViewContainer.heightAnchor.constraint(equalToConstant: textContainerFinalHeigth)
            
            heigthConstraintOfTextViewContainer.isActive = true
            
        }
        
    }
    
    func setupMajorSettings() {
        
        print("keyboardHeigth : \(keyboardHeigth)")
        
        self.addSubview(containerView)
        self.containerView.addSubview(menuContainerView)
        self.menuContainerView.addSubview(doneButton)
        self.containerView.addSubview(textViewContainer)
        self.textViewContainer.addSubview(textView)
        self.doneButton.addSubview(doneLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeDoneButton = self.doneButton.safeAreaLayoutGuide
        let safeTextViewContainer = self.textViewContainer.safeAreaLayoutGuide
        let safeMenuContainer = self.menuContainerView.safeAreaLayoutGuide
        
        leadingConstraintsOfTextView = textView.leadingAnchor.constraint(equalTo: safeTextViewContainer.leadingAnchor, constant: 30)
        trailingConstraintsOfTextView = textView.trailingAnchor.constraint(equalTo: safeTextViewContainer.trailingAnchor, constant: -30)
        topConstraintsOfTextView = textView.bottomAnchor.constraint(equalTo: safeTextViewContainer.bottomAnchor)
        heigthConstraintsOfTextView = textView.heightAnchor.constraint(equalToConstant: returnTextViewInitialHeight())
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            menuContainerView.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            menuContainerView.topAnchor.constraint(equalTo: safeContainer.topAnchor),
            menuContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            doneButton.topAnchor.constraint(equalTo: safeContainer.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor, constant: -15),
            doneButton.heightAnchor.constraint(equalToConstant: 25),
            doneButton.widthAnchor.constraint(equalToConstant: 80),
            
            doneLabel.leadingAnchor.constraint(equalTo: safeDoneButton.leadingAnchor),
            doneLabel.trailingAnchor.constraint(equalTo: safeDoneButton.trailingAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: safeDoneButton.bottomAnchor),
            doneLabel.topAnchor.constraint(equalTo: safeDoneButton.topAnchor),
            
            textViewContainer.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            textViewContainer.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            textViewContainer.topAnchor.constraint(equalTo: safeMenuContainer.bottomAnchor),
            
            leadingConstraintsOfTextView,
            trailingConstraintsOfTextView,
            topConstraintsOfTextView,
            heigthConstraintsOfTextView
            
            //            textView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 100),
            //            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            //            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            //            textView.heightAnchor.constraint(equalToConstant: 100)
            
            ])
        
    }
    
    
    /// color palette view setups
    func setupColorPaletteSettings() {
        
        print("textView.inputAccessoryView : \(textView.inputAccessoryView)")
        print("customColorPalette : \(customColorPalette)")
        textView.inputAccessoryView = nil
        
        if customColorPalette == nil {
            customColorPalette = ColorPaletteView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        }
        
        guard let customColorPalette = customColorPalette else { return }
        
        customColorPalette.addingTextViewDelegate = self
        textView.inputAccessoryView = customColorPalette
        
    }
    
    func returnTextViewInitialHeight() -> CGFloat {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        print("newSize.height : \(newSize.height)")
        
        tempSize = newSize.height
        
        return newSize.height
        
    }
    
    func focusTextField() {
        
        textView.becomeFirstResponder()
        
        reloadInputViews()
        
    }
    
    /// observers for keyboard displays
    func addObservers() {
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(CustomAddingTextView2.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAddingTextView2.keyboardViewChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(CustomAddingTextView2.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardViewChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboard heigth : \(keyboardSize.height)")
            
            keyboardHeigth = keyboardSize.height
            
            //            if self.frame.origin.y == 0{
            //                self.frame.origin.y -= keyboardSize.height
            //            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboard heigth : \(keyboardSize.height)")
            
            keyboardHeigth = keyboardSize.height
            
            //            if self.frame.origin.y == 0{
            //                self.frame.origin.y -= keyboardSize.height
            //            }
        }
    }
    
    //    @objc func keyboardWillHide(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.frame.origin.y != 0 {
    //                self.frame.origin.y += keyboardSize.height
    //            }
    //        }
    //    }
    
    func createScreenShot() {
        
        print("self.textView.bounds.size : \(self.textView.bounds.size)")
        print("self.textView.bounds : \(self.textView.bounds)")
        print("self.textView.frame : \(self.textView.frame)")
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(self.textViewContainer.bounds.size, false, 0)
        self.textViewContainer.drawHierarchy(in: self.textViewContainer.bounds, afterScreenUpdates: false)
        
        let copiedScreenShot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let temp = UIImageView(image: copiedScreenShot)
        
        self.returnTextViewScreenShot(inputScreenShot: copiedScreenShot!)
        
        //        UIGraphicsBeginImageContextWithOptions(self.textView.bounds.size, false, 0);
        //        self.textField.drawViewHierarchyInRect(self.textField.bounds, afterScreenUpdates: true)
        //        let copied = UIGraphicsGetImageFromCurrentImageContext();
        //        imageView.image = copied
        //        UIGraphicsEndImageContext();
        
        
    }
    
}

extension CustomAddingTextView2 : ShareDataProtocols {
    
    func updateSelectedColorFromPalette(inputView: UIView) {
        
        textView.textColor = inputView.backgroundColor
        
    }
    
}

extension CustomAddingTextView2 : UIGestureRecognizerDelegate {
    
    func addGestureToDoneButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomAddingTextView2.closeView(_:)))
        tapGesture.delegate = self
        doneButton.addGestureRecognizer(tapGesture)
        doneLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        
        print("self : \(self)")
        print("superview : \(self.superview)")
        
        guard let superView = self.superview else { return }
        
        self.textView.resignFirstResponder()
        self.textView.removeFromSuperview()
        
        createScreenShot()
        
        NotificationCenter.default.removeObserver(self)
        
        UIView.transition(with: superView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            self.delegate.menuContainersHideManagement(inputValue: false)
            self.removeFromSuperview()
            
        })
        
    }
    
}

extension CustomAddingTextView2 : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: .infinity))
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        print("textView.font?.pointSize : \(textView.font?.pointSize)")
        print("heigthConstraintsOfTextView.constant : \(heigthConstraintsOfTextView.constant)")
        print("newFrame.height : \(newFrame.height)")
        print("textViewContainer.frame.height : \(textViewContainer.frame.height)")
        
        guard let currentTextViewFont = textView.font else { return }
        
        if heigthConstraintsOfTextView.constant < textViewContainer.frame.height {
            heigthConstraintsOfTextView.constant = newFrame.height
            
            if heigthConstraintsOfTextView.constant > textViewContainer.frame.height {
                heigthConstraintsOfTextView.constant = textViewContainer.frame.height
            }
            
        } else {
            
            textView.isScrollEnabled = true
            
            //            if newFrame.height > heigthConstraintsOfTextView.constant {
            //
            //                if currentTextViewFont.pointSize > 21 {
            //                    let newFont = currentTextViewFont.pointSize - 3
            //
            //                    textView.font = UIFont.systemFont(ofSize: newFont)
            //
            //                    leadingConstraintsOfTextView.constant += 15
            //                    trailingConstraintsOfTextView.constant -= 15
            //
            //                } else {
            //
            //                }
            //
            //            }
            
        }
        
    }
    
    
}
