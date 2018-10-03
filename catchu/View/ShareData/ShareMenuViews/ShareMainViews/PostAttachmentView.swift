//
//  PostAttachmentView.swift
//  catchu
//
//  Created by Erkut Baş on 10/3/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostAttachmentView: UIView {

    public var postAttachmentType : PostAttachmentTypes?
    private var isSelected : Bool = false
    
    weak var delegate : ShareDataProtocols!
    
    lazy var containerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var imageContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        
        return temp
        
    }()
    
    lazy var imageView: UIImageView =
        {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFill
//        temp.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return temp
        
    }()
    
    lazy var labelObject: UILabel = {
        
        let temp = UILabel()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.text = "deneme"
        temp.font = UIFont.systemFont(ofSize: 10)
        temp.textAlignment = .center
        
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        return temp
        
    }()
    
    lazy var labelContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
//        temp.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        
        return temp
        
    }()
    
    lazy var badge: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    init(frame: CGRect, inputContainerSize : CGFloat) {
        super.init(frame: frame)

        setupViewConfigurations(inputContainerSize: inputContainerSize)
        addGestureToContainer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension PostAttachmentView {

    func setupViewConfigurations(inputContainerSize : CGFloat) {
        
        self.addSubview(containerView)
        self.containerView.addSubview(imageContainer)
        self.imageContainer.addSubview(imageView)
        self.imageContainer.addSubview(badge)
        self.containerView.addSubview(labelContainer)
        self.labelContainer.addSubview(labelObject)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainer = self.containerView.safeAreaLayoutGuide
        let safeImageContainer = self.imageContainer.safeAreaLayoutGuide
        let safeLabelContainer = self.labelContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: safe.topAnchor),
            
            imageContainer.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            imageContainer.topAnchor.constraint(equalTo: safeContainer.topAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: inputContainerSize - 10),
            
            imageView.centerXAnchor.constraint(equalTo: safeImageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeImageContainer.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: inputContainerSize - 15),
            imageView.widthAnchor.constraint(equalToConstant: inputContainerSize - 15),
            
            badge.trailingAnchor.constraint(equalTo: safeImageContainer.trailingAnchor),
            badge.topAnchor.constraint(equalTo: safeImageContainer.topAnchor),
            badge.heightAnchor.constraint(equalToConstant: 15),
            badge.widthAnchor.constraint(equalToConstant: 15),
            
            labelContainer.leadingAnchor.constraint(equalTo: safeContainer.leadingAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: safeContainer.trailingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: safeContainer.bottomAnchor),
            labelContainer.heightAnchor.constraint(equalToConstant: 10),
            
            labelObject.leadingAnchor.constraint(equalTo: safeLabelContainer.leadingAnchor),
            labelObject.trailingAnchor.constraint(equalTo: safeLabelContainer.trailingAnchor),
            labelObject.bottomAnchor.constraint(equalTo: safeLabelContainer.bottomAnchor),
            labelObject.heightAnchor.constraint(equalToConstant: 10),
            
            ])
        
    }
    
    func setImage(inputImage : UIImage) {
        
        imageView.image = inputImage.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    func setLabel(inputText : String) {
        
        labelObject.text = inputText
        
    }
    
    func setType(type : PostAttachmentTypes) {
        
        postAttachmentType = type
        
    }
    
    func setDelegation(inputDelegate : ShareDataProtocols) {
        
        self.delegate = inputDelegate
        
    }
    
    func clearTintColor() {
        
        imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelObject.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        if let postType = postAttachmentType {
//            if postType == .onlyMe {
//                imageView.image = UIImage(named: "unlocked")
//                imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            }
//        }
        
        
    }
    
    func setTintColor() {
        imageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        labelObject.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
}

extension PostAttachmentView : UIGestureRecognizerDelegate {
    
    func addGestureToContainer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostAttachmentView.menuSelectionManagement(_:)))
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func menuSelectionManagement(_ sender : UITapGestureRecognizer) {

        imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            self.imageView.transform = CGAffineTransform.identity
        }
        
        print("menuSelectionManagement starts")
        print("self.tag : \(self.tag)")
        
        print("type : \(postAttachmentType!)")
        
        delegate.clearPostAttachmentType()
        
        self.setTintColor()
        
        delegate.selectedPostAttachmentTypeManagement(returned: self)
        
    }
    
}
