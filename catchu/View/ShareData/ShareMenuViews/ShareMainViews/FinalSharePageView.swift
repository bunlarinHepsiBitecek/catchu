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
    
    private var postItemArray = [UIView]()
    private var attachmentSelectedInfo = Dictionary<Int, Bool>()
    private var collectionView : UICollectionView!
    
    private var leadingConstraintsOfStackViewForAttachments = NSLayoutConstraint()
    
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
        
        return temp
    }()
    
    lazy var attachmentContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
//        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
//        temp.layer.cornerRadius = 10
        
        return temp
    }()
    
    lazy var saySomethingContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        
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
        
        let temp = UIStackView(arrangedSubviews: createStackViewObjects2())
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
    
    func setupViews() {
        
        addCustomMapView()
        addViewControllerContainer()
        
        addGestureToBackButton()
        addGestureToCloseButton()
        
        createStackView()
        
        createPostItemArray()
        createStackView2()
    }
    
    func addCustomMapView() {
        
        customMapView = CustomMapView()

        customMapView!.clipsToBounds = true
        customMapView!.translatesAutoresizingMaskIntoConstraints = false

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
            customMapView!.heightAnchor.constraint(equalToConstant: 200),
            customMapView!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)
            
//            test.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            test.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            test.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
//            test.topAnchor.constraint(equalTo: safe.topAnchor),
            
            ])
        
    }
    
    func addViewControllerContainer() {
        
        self.addSubview(controllerTab)
        self.addSubview(attachmentContainerView)
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
            
            attachmentContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            attachmentContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            attachmentContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            attachmentContainerView.heightAnchor.constraint(equalToConstant: 40),
            
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
        gradient.colors = [UIColor.black.cgColor.copy(alpha: 0.7), UIColor.clear.cgColor]
        controllerTab.layer.insertSublayer(gradient, at: 0)
        
        let gradientForAttachments = CAGradientLayer()
        gradientForAttachments.frame = attachmentContainerView.bounds
        gradientForAttachments.cornerRadius = 10
        gradientForAttachments.colors = [UIColor.clear.cgColor, UIColor.black.cgColor.copy(alpha: 1)]
        attachmentContainerView.layer.insertSublayer(gradientForAttachments, at: 0)
        
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
    
    private func createStackViewObjects2() -> [UIView] {
        
        var attachmentArray = [UIView]()
        
        let attachment1 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)

        attachment1.setDelegation(inputDelegate: self)
        attachment1.setType(type: PostAttachmentTypes.publicPost)
        attachment1.setImage(inputImage: UIImage(named: "earth")!)
        attachment1.setLabel(inputText: LocalizedConstants.PostAttachments.publicInfo)

        attachmentArray.append(attachment1)
        
        let attachment2 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment2.setDelegation(inputDelegate: self)
        attachment2.setType(type: PostAttachmentTypes.onlyMe)
        attachment2.setImage(inputImage: UIImage(named: "unlocked")!)
        attachment2.setLabel(inputText: LocalizedConstants.PostAttachments.onlyMe)
        
        attachmentArray.append(attachment2)

        let attachment3 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment3.setDelegation(inputDelegate: self)
        attachment3.setType(type: PostAttachmentTypes.group)
        attachment3.setImage(inputImage: UIImage(named: "group")!)
        attachment3.setLabel(inputText: LocalizedConstants.PostAttachments.group)
        
        attachmentArray.append(attachment3)
        
        let attachment4 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment4.setDelegation(inputDelegate: self)
        attachment4.setType(type: PostAttachmentTypes.friends)
        attachment4.setImage(inputImage: UIImage(named: "friend")!)
        attachment4.setLabel(inputText: LocalizedConstants.PostAttachments.friends)
        
        attachmentArray.append(attachment4)
        
        print("hihi")
        
        return attachmentArray
        
    }
    
    private func createStackView() {
        
        stackViewForPostAttachments.alignment = .fill
        stackViewForPostAttachments.axis = .horizontal
        stackViewForPostAttachments.distribution = .equalSpacing
        stackViewForPostAttachments.backgroundColor = UIColor.red
        
        self.attachmentContainerView.addSubview(stackViewForPostAttachments)
        
        guard customMapView != nil else {
            return
        }
        
        let safeAttachmentContainer = self.attachmentContainerView.safeAreaLayoutGuide
        
        leadingConstraintsOfStackViewForAttachments = stackViewForPostAttachments.leadingAnchor.constraint(equalTo: safeAttachmentContainer.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            stackViewForPostAttachments.trailingAnchor.constraint(equalTo: safeAttachmentContainer.trailingAnchor, constant: -10),
            leadingConstraintsOfStackViewForAttachments,
            stackViewForPostAttachments.bottomAnchor.constraint(equalTo: safeAttachmentContainer.bottomAnchor),
            
            ])
        
    }
    
    func createPostItemArray() {
        
        let textView = UILabel()
        textView.text = "Erkut Deneme"
        textView.numberOfLines = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        
        postItemArray.append(textView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.minimumInteritemSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.sectionInset = UIEdgeInsets(top: Constants.Cell.imageCollectionViewEdgeInsets_02, left: Constants.Cell.imageCollectionViewEdgeInsets_02, bottom: Constants.Cell.imageCollectionViewEdgeInsets_02, right: Constants.Cell.imageCollectionViewEdgeInsets_02)
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)

        collectionView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "erkut")
        
        postItemArray.append(collectionView)
        
        
    }
    
    private func createStackView2() {
        
        for item in postItemArray {
            stackViewForPostItems.addArrangedSubview(item)
        }
        
        //        stackView.spacing = 5
        stackViewForPostItems.alignment = .fill
        stackViewForPostItems.axis = .horizontal
        stackViewForPostItems.distribution = .fillProportionally
        stackViewForPostItems.backgroundColor = UIColor.red
        
        self.addSubview(stackViewForPostItems)
        
        let safe = self.safeAreaLayoutGuide
        let x = self.stackViewForPostAttachments.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

            stackViewForPostItems.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            stackViewForPostItems.topAnchor.constraint(equalTo: x.bottomAnchor, constant: 10),
            stackViewForPostItems.heightAnchor.constraint(equalToConstant: 300),
            stackViewForPostItems.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)

            ])
        
    }
    
}

extension FinalSharePageView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "erkut", for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
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
        
        delegate.dismissFinalShareViewController()
        delegateForViewController.dismisViewController()
        
    }
}

extension FinalSharePageView : ShareDataProtocols {
    
    func clearPostAttachmentType() {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                view.clearTintColor()
            }
        }
    }
    
    func selectedPostAttachmentAnimations(selectedAttachmentType : PostAttachmentTypes) {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                
                if view.postAttachmentType != selectedAttachmentType {
                    
                    UIView.animate(withDuration: 0.3) {
                        view.isHidden = true
                        view.alpha = 0
                    }
                    
                }
                
            }
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraintsOfStackViewForAttachments.isActive = false
            self.layoutIfNeeded()

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

