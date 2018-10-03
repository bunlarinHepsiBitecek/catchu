//
//  FinalSharePageView.swift
//  catchu
//
//  Created by Erkut Baş on 10/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

class FinalSharePageView: UIView {

    private var customMapView : CustomMapView?
    
    private var attachmentArray : [UIView]?
    private var postItemArray : [UIView]?
    private var attachmentSelectedInfo = Dictionary<Int, Bool>()
    
    weak var delegate : ViewPresentationProtocols!
    weak var delegateForViewController : ShareDataProtocols!
    
    lazy var viewControllerContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return temp
    }()
    
    lazy var controllerTab: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
//        temp.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        return temp
    }()
    
    lazy var backButtonContainer: UIView = {
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
    
    lazy var backButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "back_button")
        
        return temp
    }()
    
    lazy var closeButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cross-2")
        
        return temp
    }()
    
    lazy var stackViewForPostAttachments: UIStackView = {
        
        let temp = UIStackView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .horizontal
        
        return temp
    }()
    
    lazy var stackViewForPostItems: UIStackView = {
        
        let temp = UIStackView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .vertical
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addGradientToControllerTab()

    }
    
}

// MARK: - major functions
extension FinalSharePageView {
    
    func setDelegates(delegate : ViewPresentationProtocols, delegateForShareMenuViews : ShareDataProtocols) {
        self.delegate = delegate
        self.delegateForViewController = delegateForShareMenuViews
    }
    
    func initializeDictionary() {
    
        guard attachmentArray != nil else {
            return
        }
        
        let count = attachmentArray!.count
        var i = 1
        
        while i <= count {
            attachmentSelectedInfo[i] = false
            i += 1
        }
        
    }
    
    func setupViews() {
        
        addCustomMapView()
        addViewControllerContainer()
        
        addGestureToBackButton()
        addGestureToCloseButton()
        
        createStackViewObjects2()
        createStackView()
        initializeDictionary()
        
        createPostItemArray()
        createStackView2()
    }
    
    func addCustomMapView() {
        
        customMapView = CustomMapView()

        customMapView!.translatesAutoresizingMaskIntoConstraints = false
        customMapView!.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)

        self.addSubview(customMapView!)
        
//        self.addSubview(test)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
//            customMapView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            customMapView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            customMapView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//            customMapView!.topAnchor.constraint(equalTo: safe.topAnchor),
            
            customMapView!.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            customMapView!.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            customMapView!.heightAnchor.constraint(equalToConstant: 150),
            customMapView!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)
            
//            test.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            test.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            test.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//            test.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func addViewControllerContainer() {
        
        self.addSubview(controllerTab)
        self.controllerTab.addSubview(backButtonContainer)
        self.controllerTab.addSubview(closeButtonContainer)
        self.backButtonContainer.addSubview(backButton)
        self.closeButtonContainer.addSubview(closeButton)
        
        guard customMapView != nil else {
            return
        }
        
        let safe = self.customMapView!.safeAreaLayoutGuide
        let safeControllerTab = self.controllerTab.safeAreaLayoutGuide
        let safeBack = self.backButtonContainer.safeAreaLayoutGuide
        let safeClose = self.closeButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            controllerTab.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            controllerTab.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            controllerTab.topAnchor.constraint(equalTo: safe.topAnchor),
            controllerTab.heightAnchor.constraint(equalToConstant: 40),
            
            backButtonContainer.leadingAnchor.constraint(equalTo: safeControllerTab.leadingAnchor),
            backButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            backButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            backButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            closeButtonContainer.trailingAnchor.constraint(equalTo: safeControllerTab.trailingAnchor
            ),
            closeButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            closeButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            closeButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            backButton.centerXAnchor.constraint(equalTo: safeBack.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: safeBack.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            
            closeButton.centerXAnchor.constraint(equalTo: safeClose.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: safeClose.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    func addGradientToControllerTab() {
        
        print("addGradientToControllerTab starts")
        print("controllerTab.bounds : \(controllerTab.bounds)")
        
        guard controllerTab != nil else {
            return
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = controllerTab.bounds
        gradient.cornerRadius = 10
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        controllerTab.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func createStackViewObjects() {
        
        let attachment1 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), inputContainerSize: 50)
        
        attachment1.setImage(inputImage: UIImage(named: "earth")!)
        
        self.addSubview(attachment1)
        
        attachment1.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            attachment1.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            attachment1.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            attachment1.heightAnchor.constraint(equalToConstant: 50),
            attachment1.widthAnchor.constraint(equalToConstant: 50)
            
            ])
        
        
    }
    
    private func createStackViewObjects2() {
        
        let attachment1 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), inputContainerSize: 50)

        attachment1.setDelegation(inputDelegate: self)
        attachment1.tag = 1
        attachment1.setType(type: PostAttachmentTypes.publicPost)
        attachment1.setImage(inputImage: UIImage(named: "earth")!)
        attachment1.setLabel(inputText: LocalizedConstants.PostAttachments.publicInfo)

        attachment1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        attachment1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        if attachmentArray == nil {
            attachmentArray = [UIView]()
        }
        
        attachmentArray!.append(attachment1)

        let attachment2 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), inputContainerSize: 50)
        
        attachment2.setDelegation(inputDelegate: self)
        attachment2.tag = 2
        attachment2.setType(type: PostAttachmentTypes.friends)
        attachment2.setImage(inputImage: UIImage(named: "friend")!)
        attachment2.setLabel(inputText: LocalizedConstants.PostAttachments.friends)
        
        attachment2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        attachment2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        attachmentArray!.append(attachment2)
        
        let attachment3 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), inputContainerSize: 50)
        
        attachment3.setDelegation(inputDelegate: self)
        attachment3.tag = 3
        attachment3.setType(type: PostAttachmentTypes.group)
        attachment3.setImage(inputImage: UIImage(named: "group")!)
        attachment3.setLabel(inputText: LocalizedConstants.PostAttachments.group)
        
        attachment3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        attachment3.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        attachmentArray!.append(attachment3)
        
        let attachment4 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), inputContainerSize: 50)
        
        attachment4.setDelegation(inputDelegate: self)
        attachment4.tag = 4
        attachment4.setType(type: PostAttachmentTypes.onlyMe)
        attachment4.setImage(inputImage: UIImage(named: "unlocked")!)
        attachment4.setLabel(inputText: LocalizedConstants.PostAttachments.onlyMe)
        
        attachment4.heightAnchor.constraint(equalToConstant: 50).isActive = true
        attachment4.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        attachmentArray!.append(attachment4)
        
        print("hihi")
        
    }
    
    private func createStackView() {
        
        guard let attachmentArray = attachmentArray else { return }
        
        stackViewForPostAttachments = UIStackView(arrangedSubviews: attachmentArray)
        stackViewForPostAttachments.translatesAutoresizingMaskIntoConstraints = false
        //        stackView.spacing = 5
        stackViewForPostAttachments.alignment = .center
        stackViewForPostAttachments.axis = .horizontal
        stackViewForPostAttachments.distribution = .equalSpacing
        stackViewForPostAttachments.backgroundColor = UIColor.red
        
        self.addSubview(stackViewForPostAttachments)
        
        let safe = self.safeAreaLayoutGuide
        
        guard customMapView != nil else {
            return
        }
        
        let safeMapView = self.customMapView!.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            stackViewForPostAttachments.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stackViewForPostAttachments.topAnchor.constraint(equalTo: safeMapView.bottomAnchor, constant: 10),
            stackViewForPostAttachments.heightAnchor.constraint(equalToConstant: 50),
            stackViewForPostAttachments.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)
            
            ])
        
    }
    
    func createPostItemArray() {
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        if postItemArray == nil {
            postItemArray = [UIView]()
        }
        
        postItemArray!.append(textView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.minimumInteritemSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.sectionInset = UIEdgeInsets(top: Constants.Cell.imageCollectionViewEdgeInsets_02, left: Constants.Cell.imageCollectionViewEdgeInsets_02, bottom: Constants.Cell.imageCollectionViewEdgeInsets_02, right: Constants.Cell.imageCollectionViewEdgeInsets_02)
        
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)
        
        collectionView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        postItemArray!.append(collectionView)
        
        
    }
    
    private func createStackView2() {
        
        guard let postItemArray = postItemArray else { return }
        
        stackViewForPostItems = UIStackView(arrangedSubviews: postItemArray)
        stackViewForPostItems.translatesAutoresizingMaskIntoConstraints = false
        //        stackView.spacing = 5
        stackViewForPostItems.alignment = .center
        stackViewForPostItems.axis = .vertical
        stackViewForPostItems.distribution = .equalSpacing
        stackViewForPostItems.backgroundColor = UIColor.red
        
        self.addSubview(stackViewForPostItems)
        
        let safe = self.safeAreaLayoutGuide
        let x = self.stackViewForPostAttachments.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

            stackViewForPostItems.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stackViewForPostItems.topAnchor.constraint(equalTo: x.bottomAnchor, constant: 10),
            stackViewForPostItems.heightAnchor.constraint(equalToConstant: 200),
            stackViewForPostItems.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)

            ])
        
    }
    
}

extension FinalSharePageView : UIGestureRecognizerDelegate {
    
    func addGestureToBackButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalSharePageView.backToShareMenuViews(_:)))
        tapGesture.delegate = self
        backButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func backToShareMenuViews(_ sender : UITapGestureRecognizer) {
        
        // if you dont stop location service, even if you remove view, because of no changes on location, update location service does not work
        LocationManager.shared.stopUpdateLocation()
        LocationManager.shared.externalViewInitialize = false
        
        delegate.dismissFinalShareViewController()
        
    }
    
    func addGestureToCloseButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalSharePageView.closeShareMenuCompletely(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func closeShareMenuCompletely(_ sender : UITapGestureRecognizer) {
        
        // if you dont stop location service, even if you remove view, because of no changes on location, update location service does not work
        LocationManager.shared.stopUpdateLocation()
        LocationManager.shared.externalViewInitialize = false
        
        delegate.dismissFinalShareViewController()
        delegateForViewController.dismisViewController()
        
    }
}

extension FinalSharePageView : ShareDataProtocols {
    
    func clearPostAttachmentType() {
        
        guard attachmentArray != nil else {
            return
        }
        
        for item in attachmentArray! {
            
            if let view = item as? PostAttachmentView {
                view.clearTintColor()
            }
            
        }
        
    }
    
    func selectedPostAttachmentTypeManagement(returned: PostAttachmentView) {
        
        guard let postType = returned.postAttachmentType else { return }
        
        switch postType {
        case .friends, .group:
            print(".")
        case .publicPost:
            print(".")
        case .onlyMe:
            returned.setImage(inputImage: UIImage(named: "locked")!)
            print(".")
        }
        
    }
    
    
}

