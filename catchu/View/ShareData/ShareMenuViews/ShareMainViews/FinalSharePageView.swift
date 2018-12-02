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
    private var customFinalItemPage : FinalSharedItemsView?
    
    private var postItemArray = [UIView]()
    
    private var leadingConstraintsOfStackViewForAttachments = NSLayoutConstraint()
    
    weak var delegate : ViewPresentationProtocols!
    weak var delegateForViewController : ShareDataProtocols!
    
    private var isGradientColorAdded : Bool = false
    
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
        temp.layer.cornerRadius = 10
//        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
//        temp.layer.cornerRadius = 10
        
        return temp
    }()
    
    lazy var informationLabel: UILabel = {
        let temp = UILabel()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.text = LocalizedConstants.PostAttachmentInformation.publicInformation
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.textAlignment = .left
        temp.alpha = 0
        
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        return temp
    }()
    
    lazy var nextButtonContainer: UIView = {
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
    
    lazy var nextButton: UIImageView = {
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
    
    lazy var stackViewForPostAttachments: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: createStackViewObjects2())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .center
        temp.axis = .horizontal
        
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

        if !isGradientColorAdded {
            addGradientToControllerTab()
        }

    }
    
}

// MARK: - major functions
extension FinalSharePageView {
    
    func setDelegates(delegate : ViewPresentationProtocols, delegateForShareMenuViews : ShareDataProtocols) {
        // for viewController operations
        self.delegate = delegate
        self.delegateForViewController = delegateForShareMenuViews
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
//            if let postAttachmentItem = item as? PostAttachmentView {
//                postAttachmentItem.setDelegation(inputDelegate: self, inputViewControllerDelegate: delegate)
//            }
            
        }
    }
    
    func setupViews() {
        
        addCustomMapView()
        addViewControllerContainer()
        addCustomFinalItemPages()
        
        addGestureToNextButton()
        addGestureToCloseButton()
        
        createStackView()
        
    }
    
    func addCustomMapView() {
        
        customMapView = CustomMapView()

//        customMapView!.clipsToBounds = true
        customMapView!.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(customMapView!)
        
//        self.addSubview(test)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customMapView!.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            customMapView!.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            customMapView!.heightAnchor.constraint(equalToConstant: 150),
            customMapView!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20)
            
            ])
        
    }
    
    func addCustomFinalItemPages() {
        
        customFinalItemPage = FinalSharedItemsView()
        
        customFinalItemPage!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(customFinalItemPage!)
        
        let safe = self.safeAreaLayoutGuide
        let safeOfPostAttachments = self.attachmentContainerView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customFinalItemPage!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            customFinalItemPage!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            customFinalItemPage!.topAnchor.constraint(equalTo: safeOfPostAttachments.bottomAnchor, constant: 10),
            customFinalItemPage!.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10),
            
            ])
        
    }
    
    func addViewControllerContainer() {
        
        self.addSubview(controllerTab)
        self.addSubview(attachmentContainerView)
        self.controllerTab.addSubview(nextButtonContainer)
        self.controllerTab.addSubview(closeButtonContainer)
        self.nextButtonContainer.addSubview(nextButton)
        self.closeButtonContainer.addSubview(closeButton)
        
        guard customMapView != nil else {
            return
        }
        
        let safe = self.safeAreaLayoutGuide
        let safeCustomMapview = self.customMapView!.safeAreaLayoutGuide
        let safeControllerTab = self.controllerTab.safeAreaLayoutGuide
        let safeBack = self.nextButtonContainer.safeAreaLayoutGuide
        let safeClose = self.closeButtonContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            controllerTab.leadingAnchor.constraint(equalTo: safeCustomMapview.leadingAnchor),
            controllerTab.trailingAnchor.constraint(equalTo: safeCustomMapview.trailingAnchor),
            controllerTab.topAnchor.constraint(equalTo: safeCustomMapview.topAnchor),
            controllerTab.heightAnchor.constraint(equalToConstant: 40),
            
            attachmentContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            attachmentContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            attachmentContainerView.topAnchor.constraint(equalTo: safeCustomMapview.bottomAnchor, constant: 10),
            attachmentContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            nextButtonContainer.trailingAnchor.constraint(equalTo: safeControllerTab.trailingAnchor),
            nextButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            nextButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            nextButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            closeButtonContainer.leadingAnchor.constraint(equalTo: safeControllerTab.leadingAnchor
            ),
            closeButtonContainer.bottomAnchor.constraint(equalTo: safeControllerTab.bottomAnchor),
            closeButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            closeButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            
            nextButton.centerXAnchor.constraint(equalTo: safeBack.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: safeBack.centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 36),
            nextButton.widthAnchor.constraint(equalToConstant: 36),
            
            closeButton.centerXAnchor.constraint(equalTo: safeClose.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: safeClose.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
        
    }
    
    /// gradientColor definitions
    func addGradientToControllerTab() {
        
        print("addGradientToControllerTab starts")
        print("controllerTab.bounds : \(controllerTab.bounds)")
        
        let gradient = CAGradientLayer()
        gradient.frame = controllerTab.bounds
        gradient.cornerRadius = 10
        gradient.colors = [UIColor.black.cgColor.copy(alpha: 0.7)!, UIColor.clear.cgColor]
        controllerTab.layer.insertSublayer(gradient, at: 0)
        
        self.isGradientColorAdded = true
        
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

        attachment1.setType(type: PostAttachmentTypes.publicPost)
        attachment1.setImage(inputImage: UIImage(named: "earth")!)
        attachment1.setLabel(inputText: LocalizedConstants.PostAttachments.publicInfo)

        attachmentArray.append(attachment1)
        
        let attachment2 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment2.setType(type: PostAttachmentTypes.onlyMe)
        attachment2.setImage(inputImage: UIImage(named: "unlocked")!)
        attachment2.setLabel(inputText: LocalizedConstants.PostAttachments.onlyMe)
        
        attachmentArray.append(attachment2)

        let attachment3 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
        attachment3.setType(type: PostAttachmentTypes.group)
        attachment3.setImage(inputImage: UIImage(named: "group")!)
        attachment3.setLabel(inputText: LocalizedConstants.PostAttachments.group)
        
        attachmentArray.append(attachment3)
        
        let attachment4 = PostAttachmentView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), inputContainerSize: 40)
        
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
        self.attachmentContainerView.addSubview(informationLabel)
        
        self.attachmentContainerView.bringSubview(toFront: stackViewForPostAttachments)
        
        let safeAttachmentContainer = self.attachmentContainerView.safeAreaLayoutGuide
        
        leadingConstraintsOfStackViewForAttachments = stackViewForPostAttachments.leadingAnchor.constraint(equalTo: safeAttachmentContainer.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            stackViewForPostAttachments.trailingAnchor.constraint(equalTo: safeAttachmentContainer.trailingAnchor, constant: -10),
            leadingConstraintsOfStackViewForAttachments,
            stackViewForPostAttachments.centerYAnchor.constraint(equalTo: safeAttachmentContainer.centerYAnchor),

            informationLabel.leadingAnchor.constraint(equalTo: safeAttachmentContainer.leadingAnchor, constant: 10),
            informationLabel.trailingAnchor.constraint(equalTo: safeAttachmentContainer.trailingAnchor),
            informationLabel.topAnchor.constraint(equalTo: safeAttachmentContainer.topAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: safeAttachmentContainer.bottomAnchor),
            
            ])
        
    }
    
    func decideInformationText(postType : PostAttachmentTypes) {
        
        switch postType {
        case .friends:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.gettingFriends
        case .group:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.gettingGroup
        case .publicPost:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.publicInformation
        case .onlyMe:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.onlyMeInformation
        case .allFollowers:
            informationLabel.text = LocalizedConstants.PostAttachmentInformation.allFollowersInformation
        }
        
    }
    
    func resetPostAttachmentViews() {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            if let view = item as? PostAttachmentView {
                view.setSelected(isSelected: false)
                view.clearTintColor()
                view.isHidden = false
                view.alpha = 1
            }
        }
        
        self.leadingConstraintsOfStackViewForAttachments.isActive = true
        self.attachmentContainerView.backgroundColor = UIColor.clear
        self.informationLabel.alpha = 0
        
    }
    
    func setInformationLabel(inputPostType : PostAttachmentTypes) {
        
        switch inputPostType {
        case .friends:
            let selectedFriendCount = SectionBasedFriend.shared.selectedUserArray.count
            
            if let firstFriend = SectionBasedFriend.shared.selectedUserArray.first {
                
                if let name = firstFriend.name {
                    informationLabel.text = name + " and " + "\(selectedFriendCount - 1)" + " more..."
                }
            }
            
        case .group:
            if let firstGroup = SectionBasedGroup.shared.selectedGroupList.first {
                if let name = firstGroup.groupName {
                    informationLabel.text = name
                }
            }
            
        default:
            return
        }
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension FinalSharePageView : UIGestureRecognizerDelegate {
    
    func addGestureToNextButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalSharePageView.nextFinalNoteViewController(_:)))
        tapGesture.delegate = self
        nextButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func nextFinalNoteViewController(_ sender : UITapGestureRecognizer) {
        
        // if you dont stop location service, even if you remove view, because of no changes on location, update location service does not work
//        LocationManager.shared.stopUpdateLocation()
        
        delegate.directToSaySometingPages()
        
    }
    
    func addGestureToCloseButton() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FinalSharePageView.backToShareMenuViews(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func backToShareMenuViews(_ sender : UITapGestureRecognizer) {
        
        // if you dont stop location service, even if you remove view, because of no changes on location, update location service does not work
        LocationManager.shared.stopUpdateLocation()
        
        delegate.dismissViewController()
        
    }
}

extension FinalSharePageView : ShareDataProtocols {
    
    func selectedPostAttachmentAnimations(selectedAttachmentType : PostAttachmentTypes, completion : @escaping (_ finished : Bool) -> Void) {
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                
                if view.postAttachmentType != selectedAttachmentType {
                    
                    UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, animations: {
                        view.isHidden = true
                        view.alpha = 0
                        
                    }) { (result) in
                        
                        completion(true)
                        
                    }
                    
                }
                
            }
            
        }
        
        decideInformationText(postType: selectedAttachmentType)
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraintsOfStackViewForAttachments.isActive = false
            self.attachmentContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.1)
            self.informationLabel.alpha = 1

            self.layoutIfNeeded()

        }
        
    }
    
    func deselectPostAttachmentAnimations() {
        
        print("deselectPostAttachmentAnimations starts")
        
        for item in stackViewForPostAttachments.arrangedSubviews {
            
            if let view = item as? PostAttachmentView {
                
                view.isHidden = false
                view.alpha = 1
                
//                UIView.animate(withDuration: 0.3) {
//
//                }
                
            }
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraintsOfStackViewForAttachments.isActive = true
            self.attachmentContainerView.backgroundColor = UIColor.clear
            self.informationLabel.alpha = 0
            
            self.layoutIfNeeded()
            
        }
        
    }
    
}

