//
//  StickerManagementView.swift
//  catchu
//
//  Created by Erkut Baş on 11/23/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class StickerManagementView: UIView {
    
    private var bottomConstraintsOfTextView = NSLayoutConstraint()
    private var heigthConstraintsOfTextView = NSLayoutConstraint()
    
    private var bottomConstraintsOfColorPalette = NSLayoutConstraint()
    
    //    private var heigthConstraintOfTextViewContainer = NSLayoutConstraint()
    private var heigthActivated : Bool = false
    private var tempSize : CGFloat = 0.0
    
    private var keyboardHeigth : CGFloat?
    private var lastScale:CGFloat = 1.0
    
    private var customColorPalette : ColorPaletteView!
    
    weak var delegate : ShareDataProtocols!
    weak var delegateOfCameraCapturedImageView : StickerProtocols!
    weak var delegateForEditedView : StickerProtocols!
    
    var editingMode : Bool = false
    
    private var stickerFrame : CGRect?
    //    private var sticker = Sticker()
    
    private var defaultFontSize : CGFloat = 28
    private var fontIncrement : CGFloat = 1
    
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
        temp.text = LocalizedConstants.TitleValues.ButtonTitle.done
        temp.font = UIFont.systemFont(ofSize: 17)
        temp.numberOfLines = 0
        temp.textAlignment = .center
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var textView: UITextView = {
        
        let temp = UITextView()
        temp.backgroundColor = UIColor.clear
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 7
        //        temp.text = "erkut"
        //        temp.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
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
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isUserInteractionEnabled = true
        
        return temp
    }()
    
    init(delegate : ShareDataProtocols, delegateOfCameraCapturedImageView : StickerProtocols) {
        super.init(frame: .zero)
        
        print("INITINITINITINIT")
        
        self.isOpaque = true
        self.delegate = delegate
        self.delegateOfCameraCapturedImageView = delegateOfCameraCapturedImageView
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        setupMajorSettings()
        setupColorPaletteSettings()
        addObservers()
        addGestureToDoneButton()
        setupCloseButtonGesture()
        
        activationManagementDefault(granted : false)
        
    }
    
    // remove observer
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension StickerManagementView {
    
    func setHeigthConstraintsForTextView() {
        
        guard let keyboardHeigth = keyboardHeigth else { return }
        
        if menuContainerView.frame.height > 0 {
            
            let textContainerFinalHeigth = self.frame.height - (keyboardHeigth + menuContainerView.frame.height)
            
            print("textContainerFinalHeigth : \(textContainerFinalHeigth)")
            
            let safe = self.safeAreaLayoutGuide
            
            bottomConstraintsOfTextView = textView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -keyboardHeigth)
            
            bottomConstraintsOfTextView.isActive = true
            
        }
        
    }
    
    func setupMajorSettings() {
        
        print("keyboardHeigth : \(keyboardHeigth)")
        
        self.addSubview(containerView)
        self.containerView.addSubview(menuContainerView)
        self.menuContainerView.addSubview(closeButton)
        self.menuContainerView.addSubview(doneButton)
        self.addSubview(textView)
        self.doneButton.addSubview(doneLabel)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeDoneButton = self.doneButton.safeAreaLayoutGuide
        let safeMenuContainer = self.menuContainerView.safeAreaLayoutGuide
        
        heigthConstraintsOfTextView = textView.heightAnchor.constraint(equalToConstant: returnTextViewInitialHeight())
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeMenuContainer.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: safeMenuContainer.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
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
            
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 30),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -30),
            //            textView.heightAnchor.constraint(equalToConstant: returnTextViewInitialHeight()),
            //            heigthConstraintsOfTextView
            textView.topAnchor.constraint(equalTo: safeMenuContainer.bottomAnchor)
            
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
        
        customColorPalette.delegate = self
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
        
    }
    
    func stopFocusingTextField() {
        
        textView.resignFirstResponder()
        
    }
    
    /// observers for keyboard displays
    func addObservers() {
        
        print("addObservers starts")
        
        NotificationCenter.default.addObserver(self, selector: #selector(StickerManagementView.keyboardViewChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func keyboardViewChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboard heigth 3: \(keyboardSize.height)")
            
            keyboardHeigth = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboard heigth 4: \(keyboardSize.height)")
            
            keyboardHeigth = keyboardSize.height
            
        }
    }
    
    func activationManagementDefault(granted : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if granted {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
        }
        
    }
    
    /// StickerManagementView activation manager functions, it controls alpha of view and editing mode
    ///
    /// - Parameters:
    ///   - granted: if it's granted to be shown or not
    ///   - editingMode: if view is used to be add new sticker or update one of those current sticker
    func activationManagementWithDelegations(granted : Bool) {
        
        print("activationManagementWithDelegations starts")
        print("textView.text :\(textView.text)")
        
        initiateTextViewProperties()
        
        if granted {
            self.alpha = 1
            delegate.menuContainersHideManagement(inputValue: true)
            focusTextField()
            
        } else {
            self.alpha = 0
            delegate.menuContainersHideManagement(inputValue: false)
            stopFocusingTextField()
            
        }
        
        // the function below should run after menuContainersHideManagement
        setHeigthConstraintsForTextView()
        
    }
    
    func initiateTextViewProperties() {
        
        self.textView.text = Constants.CharacterConstants.EMPTY
        
    }
    
    func updateEditingTextView(inputSticker : Sticker, editingMode : Bool) {
        
        self.editingMode = editingMode
        
        textView.text = inputSticker.text
        textView.textColor = inputSticker.textColor
        textView.font = inputSticker.font
        
        print("done")
        
    }
    
    func returnStickerObject() -> Sticker {
        
        let sticker = Sticker()
        
        sticker.text = textView.text
        sticker.textColor = textView.textColor
        sticker.font = textView.font
        
        if stickerFrame != nil {
            sticker.frame = stickerFrame
        }
        
        return sticker
        
    }
    
    func doneButtonOperations() {
        
        if editingMode {
            
            self.delegateForEditedView.updateTextSticker(inputSticker: returnStickerObject())
            
            editingModeActivationManagement(active: false)
            
        } else {
            
            self.delegateOfCameraCapturedImageView.addTextStickerWithParameters(sticker: returnStickerObject())
            
        }
        
        closingOperations()
        
    }
    
    func editingModeCloseOperations() {
        
        if editingMode {
            //            delegateForEditedView.customStickerActivationManager(active: true)
            //            delegateOfCameraCapturedImageView.customStickerActivationManager(active: true)
            editingModeActivationManagement(active: false)
        }
        
    }
    
    func editingModeActivationManagement(active : Bool) {
        
        self.editingMode = active
        
    }
    
}

// MARK: - ShareDataProtocols
extension StickerManagementView : ShareDataProtocols {
    
    func updateSelectedColorFromPalette(inputView: UIView) {
        
        textView.textColor = inputView.backgroundColor
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension StickerManagementView : UIGestureRecognizerDelegate {
    
    func addGestureToDoneButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StickerManagementView.addTextSticker(_:)))
        tapGesture.delegate = self
        doneButton.addGestureRecognizer(tapGesture)
        doneLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func addTextSticker(_ sender : UITapGestureRecognizer) {
        
        print("addTextSticker starts")
        print("textView : \(textView.text)")
        
        doneButtonOperations()
    }
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StickerManagementView.closeView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func closeView(_ sender : UITapGestureRecognizer) {
        
        print("self : \(self)")
        
        self.closingOperations()
        
    }
    
    func closingOperations() {
        
        initiateTextViewProperties()
        editingModeCloseOperations()
        
        // make stickers visible again
        delegateOfCameraCapturedImageView.customStickerActivationManager(active: true)
        
        activationManagementWithDelegations(granted: false)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}

// MARK: - UITextViewDelegate
extension StickerManagementView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: .infinity))
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        if (newFrame.height > textView.frame.size.height) {
            textView.font = UIFont.systemFont(ofSize: defaultFontSize - fontIncrement)
            fontIncrement += 1
            
        }
        
        // set newFrame value
        print("newFrame : \(newFrame)")
        stickerFrame = newFrame
        print("stickerFrame : \(stickerFrame)")
    }
    
}
