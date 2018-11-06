//
//  CustomSticker2.swift
//  catchu
//
//  Created by Erkut Baş on 10/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomSticker2: UIView {
    
    var sticker = Sticker()
    
    private var lastScale:CGFloat = 1.0
    
    private var heightLabel = NSLayoutConstraint()
    private var widthLabel = NSLayoutConstraint()
    
    weak var delegateOfCapturedImageView : ShareDataProtocols!
    weak var delegateOfCustomAddingText : StickerProtocols!
    weak var delegateForMenuViewOperations : ShareDataProtocols!
    
    lazy var textView: UITextView = {
        
        let temp = UITextView()
        temp.backgroundColor = UIColor.clear
        //        temp.isEditable = false
        
        temp.textAlignment = .center
        temp.font = UIFont.boldSystemFont(ofSize: 28)
        temp.isScrollEnabled = true
        temp.textContainer.lineBreakMode = .byWordWrapping
        temp.textContainer.widthTracksTextView = true
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var label: UILabel = {
        
        let temp = UILabel()
        temp.isUserInteractionEnabled = true
        temp.numberOfLines = 0
        temp.textAlignment = .center
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    init(frame: CGRect, inputSticker : Sticker) {
        
        super.init(frame: frame)
        
        print("frame : \(frame)")
        
        self.sticker = inputSticker
        
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomSticker2 {
    
    func initializeView() {
        
        self.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
//        addTextView()
        addLabel()
        addGestures()
        
    }
    
    func addLabel() {
        
        guard let stickerFrame = sticker.frame else { return }
        
        self.addSubview(label)
        
        setLabelProperties()
        
        let safe = self.safeAreaLayoutGuide
        
        heightLabel = label.heightAnchor.constraint(equalToConstant: stickerFrame.height)
        widthLabel = label.widthAnchor.constraint(equalToConstant: stickerFrame.width)
        
        NSLayoutConstraint.activate([
            
            label.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            //label.heightAnchor.constraint(equalToConstant: stickerFrame.height),
            //label.widthAnchor.constraint(equalToConstant: stickerFrame.width)
            
            heightLabel,
            widthLabel
            
            ])
        
    }
    
    func addTextView() {
        
        guard let stickerFrame = sticker.frame else { return }
        
        self.addSubview(textView)
        
        setTextViewProperties()
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            textView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            textView.heightAnchor.constraint(equalToConstant: stickerFrame.height),
            textView.widthAnchor.constraint(equalToConstant: stickerFrame.width)
            
            ])
        
    }
    
    func textViewScrollManagement(isScroll : Bool) {
        textView.isScrollEnabled = isScroll
    }
    
    func setProtocols(delegateOfCapturedImageView : ShareDataProtocols, delegateForMenuViewOperations : ShareDataProtocols, delegateOfCustomAddingText : StickerProtocols) {
        
        self.delegateOfCapturedImageView = delegateOfCapturedImageView
        self.delegateForMenuViewOperations = delegateForMenuViewOperations
        self.delegateOfCustomAddingText = delegateOfCustomAddingText
        
    }
    
    func setTextViewProperties() {
        
        textView.textColor = sticker.textColor
        textView.text = sticker.text
        
        print("textView.text : \(textView.text)")
        
    }
    
    func setLabelProperties() {
        
        label.text = sticker.text
        label.textColor = sticker.textColor
        label.font = sticker.font
        
        print("textView.text : \(label.text)")
        
    }
    
    func activationManager(active : Bool) {
        if active {
            self.alpha = 1
        } else {
            self.alpha = 0
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomSticker2 : UIGestureRecognizerDelegate {
    
    func addGestures() {
        
        addPanGestureRecognizer()
        addTapGestureRecognizer()
        addRotateGestureRecognizer()
        addPinchGestureRecognizer()
        
    }
    
    func addPanGestureRecognizer() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CustomSticker2.changePosition(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
    }
    
    @objc func changePosition(_ sender : UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.superview)
        let point = sender.location(in: self.superview)
        let newP = CGPoint.init(x: self.center.x + translation.x, y: self.center.y + translation.y)
        self.center = newP
        sender.setTranslation(CGPoint.zero, in: self.superview)
        
        switch sender.state {
        case .changed, .began:
            textViewScrollManagement(isScroll: false)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: true)
            delegateOfCustomAddingText.detectDeleteButtonIntersect(inputView: self)
            delegateForMenuViewOperations.scrollableManagement(enabled: false)
            
        default:
            textViewScrollManagement(isScroll: true)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: false)
            delegateOfCustomAddingText.detectDeleteButtonIntersect(inputView: self)
//            delegateOfCustomAddingText.stickerDeleteAnimationManager(active: false)
            delegateOfCustomAddingText.deleteSticker(selectedSticker: self)
            delegateForMenuViewOperations.scrollableManagement(enabled: true)
        }
        
    }
    
    func addPinchGestureRecognizer() {
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(CustomSticker2.changeViewScale(_:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
        
    }
    
    @objc func changeViewScale(_ sender : UIPinchGestureRecognizer) {
        
        if(sender.state == .ended) {
            lastScale = 1.0
            return
        }
        
        let scale = 1.0 - (lastScale - sender.scale)
        
        let newTransform = self.transform.scaledBy(x: scale, y: scale)
        
        self.transform = newTransform
        lastScale = sender.scale
        
        switch sender.state {
        case .changed, .began:
            textViewScrollManagement(isScroll: false)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: true)
            //            delegateOfCapturedImageView.detectDeleteButtonIntersect(inputView: false)
            delegateForMenuViewOperations.scrollableManagement(enabled: false)
            
        default:
            textViewScrollManagement(isScroll: true)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: false)
            //            delegateOfCapturedImageView.detectDeleteButtonIntersect(inputView: true)
            delegateForMenuViewOperations.scrollableManagement(enabled: true)
        }
        
    }
    
    func addRotateGestureRecognizer() {
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(CustomSticker2.rotateView(_:)))
        rotate.delegate = self
        self.addGestureRecognizer(rotate)
        
    }
    
    @objc func rotateView(_ sender : UIRotationGestureRecognizer) {
        self.transform = self.transform.rotated(by: sender.rotation)
        sender.rotation = 0
        
        switch sender.state {
        case .changed, .began:
            textViewScrollManagement(isScroll: false)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: true)
            //            delegateOfCapturedImageView.detectDeleteButtonIntersect(inputView: false)
            delegateForMenuViewOperations.scrollableManagement(enabled: false)
            
        default:
            textViewScrollManagement(isScroll: true)
            delegateOfCapturedImageView.menuContainersHideManagement(inputValue: false)
            //            delegateOfCapturedImageView.detectDeleteButtonIntersect(inputView: true)
            delegateForMenuViewOperations.scrollableManagement(enabled: true)
        }
        
    }
    
    func addTapGestureRecognizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CustomSticker2.textViewTapped(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func textViewTapped(_ sender : UITapGestureRecognizer) {
        print("TAPPED")
        activationManager(active: false)
        delegateOfCustomAddingText.activateTextStickerEditigMode(inputSticker: self.sticker, selfView: self)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

// MARK: - StickerProtocols
extension CustomSticker2 : StickerProtocols {
    
    func updateTextSticker(inputSticker: Sticker) {
        
        print("updateTextSticker starts")
        
        sticker = inputSticker
        
        label.text = inputSticker.text
        label.textColor = inputSticker.textColor
        label.font = inputSticker.font!
//        label.frame = inputSticker.frame!
        
        guard let frame = inputSticker.frame else { return }
        
        heightLabel.constant = frame.height
        widthLabel.constant = frame.width
        
        self.activationManager(active: true)
        
    }
    
//    func customStickerActivationManager(active: Bool) {
//
//        activationManager(active: active)
//
//    }
    
}
