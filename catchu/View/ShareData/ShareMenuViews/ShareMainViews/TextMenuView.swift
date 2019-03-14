//
//  TextMenuView.swift
//  catchu
//
//  Created by Erkut Baş on 9/24/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class TextMenuView: UIView {

    private var keyboardHeigth : CGFloat?
    private var customColorPalette : ColorPaletteView?
    
    lazy var imageViewContainer: UIImageView = {
        
        let temp = UIImageView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: "default_postit.png")
        temp.contentMode = .scaleAspectFill
        
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
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupColorPaletteSettings()
        addObservers()

        focusTextView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setHeigthForImageContainer()
        
    }
    
}

// MARK: - major functions
extension TextMenuView {

    func setupViews() {
        
//        self.addSubview(imageViewContainer)
//        self.imageViewContainer.addSubview(textView)
        
        self.addSubview(textView)
        
        let safe = self.safeAreaLayoutGuide
        let safeImageContainer = self.imageViewContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
//            imageViewContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            imageViewContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            imageViewContainer.topAnchor.constraint(equalTo: safe.topAnchor),
//
//            textView.centerXAnchor.constraint(equalTo: safeImageContainer.centerXAnchor),
//            textView.centerYAnchor.constraint(equalTo: safeImageContainer.centerYAnchor),
            
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safe.topAnchor),

            ])
        
    }
    
    func focusTextView() {
        
        textView.becomeFirstResponder()
        
        setHeigthForImageContainer()

    }
    
    func stopFocusingTextView() {
        
        textView.resignFirstResponder()
        
        
    }
    
    func addObservers() {

        print("addObservers starts")

        NotificationCenter.default.addObserver(self, selector: #selector(TextMenuView.keyboardViewChangeFrame(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    @objc func keyboardViewChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            print("keyboard heigth 1: \(keyboardSize.height)")

            keyboardHeigth = keyboardSize.height

        }
    }
    
    func setHeigthForImageContainer() {
        
        print("setHeigthForImageContainer starts")
        print("keyboardHeigth : \(keyboardHeigth)")
        
        guard let keyboardHeigth = keyboardHeigth else { return }
        
        if self.frame.height > 0 {
        
            textView.heightAnchor.constraint(equalToConstant: self.frame.height - keyboardHeigth).isActive = true

        }
        
    }
    
    /// color palette view setups
    func setupColorPaletteSettings() {
        
        print("textView.inputAccessoryView : \(textView.inputAccessoryView)")
        print("customColorPalette : \(customColorPalette)")
        textView.inputAccessoryView = nil
        
        customColorPalette = ColorPaletteView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        guard customColorPalette != nil else {
            return
        }
        
        customColorPalette!.delegate = self
        
        textView.inputAccessoryView = customColorPalette
        
    }
    
}

extension TextMenuView : ShareDataProtocols {

    func updateSelectedColorFromPalette(inputView: UIView) {
        print("OHA bastık bastık")
        
        textView.textColor = inputView.backgroundColor
        
    }
    
}


//var timer: Timer!
//var progressCounter:Float = 0
//let duration:Float = 10.0
//var progressIncrement:Float = 0
//
////    let progressBar = CustomProgressBarLayer2()
//
//var circleView : CircleView?
//
//var count: CGFloat = 0
//var progressRing: CustomProgressBarLayer2!

//    @objc func showProgress() {
//        if(progressCounter > 1.0){timer.invalidate()}
////        progressBar.progress = progressCounter
//        progressCounter = progressCounter + progressIncrement
//    }
    
    // Note only works when time has not been invalidated yet
//    @objc func resetProgressCount() {
//        count = 0
//        timer.fire()
//    }
//
//    @objc func incrementCount() {
//        count += 1
//        progressRing.progress = count
//        if count >= 100.0 {
//            timer.invalidate()
//        }
//    }
    
//    let xPosition = self.center.x
    //        let yPosition = self.center.y
    //        let position = CGPoint(x: xPosition, y: yPosition)
    //
    //        progressRing = CustomProgressBarLayer2(radius: 100, position: position, innerColor: .defaultInnerColor, outerColor: .defaultOuterColor, lineWidth: 20)
    //        self.layer.addSublayer(progressRing)
    //        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(incrementCount), userInfo: nil, repeats: true)
    //        timer.fire()
    //
    //        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(resetProgressCount)))
    
    // Create a new CircleView
    //        circleView = CircleView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    //
    //        guard let circleView = circleView else { return }
    //
    //        circleView.animateCircle(duration: 50)
    //
    //        circleView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        self.addSubview(circleView)
    //
    //        let safe = self.safeAreaLayoutGuide
    //
    //        NSLayoutConstraint.activate([
    //
    //            circleView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
    //            circleView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
    //
    //            ])
    
    //        self.addSubview(progressBar)
    //
    //        progressBar.translatesAutoresizingMaskIntoConstraints = false
    //
    //        let safe = self.safeAreaLayoutGuide
    //
    //        NSLayoutConstraint.activate([
    //
    //            progressBar.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
    //            progressBar.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
    //            progressBar.heightAnchor.constraint(equalToConstant: 50),
    //            progressBar.widthAnchor.constraint(equalToConstant: 50),
    //
    //            ])
    //
    //        progressIncrement = 1.0/duration
    //        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TextMenuView.showProgress), userInfo: nil, repeats: true)
    
//}
//
//extension UIColor {
//    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
//        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
//    }
//    static let defaultOuterColor = UIColor.rgb(56, 25, 49)
//    static let defaultInnerColor: UIColor = .rgb(234, 46, 111)
//    static let defaultPulseFillColor = UIColor.rgb(86, 30, 63)
//}
