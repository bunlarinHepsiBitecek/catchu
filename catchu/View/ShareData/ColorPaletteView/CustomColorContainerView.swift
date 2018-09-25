//
//  CustomColorContainerView.swift
//  catchu
//
//  Created by Erkut Baş on 9/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomColorContainerView: UIView {

    private var colorArray : Array<UIColor>?
    private var colorDotViewArray : [UIView]?
    
    weak var delegate : ShareDataProtocols!
    
    lazy var stackView: UIStackView = {
        
        let temp = UIStackView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .horizontal
        
        return temp
    }()
    
    init(frame: CGRect, inputColorArray : Array<UIColor>) {
        super.init(frame: frame)
        colorArray = inputColorArray
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension CustomColorContainerView {
    
    func setupViews() {
        
        guard let colorArray = colorArray else { return }

        for item in colorArray {
            createAndAppendColorDotView(inputColor: item)
        }
        
        createStackView()
        
    }
    
    func createStackView() {
        
        guard let colorDotViewArray = colorDotViewArray else { return }
        
        let stackView = UIStackView(arrangedSubviews: colorDotViewArray)
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.spacing = 5
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor.red
        
        self.addSubview(stackView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safe.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func createAndAppendColorDotView(inputColor : UIColor) {
        
        let colorDot = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        colorDot.translatesAutoresizingMaskIntoConstraints = false
        colorDot.layer.cornerRadius = 13
        colorDot.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        colorDot.layer.borderWidth = 2
        colorDot.isUserInteractionEnabled = true
        
        colorDot.widthAnchor.constraint(equalToConstant: 26).isActive = true
        colorDot.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        colorDot.backgroundColor = inputColor
        
        if colorDotViewArray == nil {
            colorDotViewArray = [UIView]()
        }
        
        colorDotViewArray!.append(colorDot)
        
        addGestureToColorDots(inputView: colorDot)
        
    }

}

extension CustomColorContainerView : UIGestureRecognizerDelegate {
    
    func addGestureToColorDots(inputView : UIView) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomColorContainerView.enlargeColorDot(_:)))
        tapGesture.delegate = self
        inputView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func enlargeColorDot(_ sender : UITapGestureRecognizer) {
        print("enlargeColorDot starts")
        
        guard let view = sender.view else { return }

        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            view.transform = CGAffineTransform.identity
        }
        
        guard let color = view.backgroundColor else { return }
        
        delegate.updateSelectedColorFromPalette(inputView: view)
        
//        UIView.animate(withDuration: 1.0,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.20),
//            initialSpringVelocity: CGFloat(6.0),
//            options: UIViewAnimationOptions.allowUserInteraction,
//            animations: {
//
//                view.transform = CGAffineTransform.identity
//
//        })
        
    }
    
}
