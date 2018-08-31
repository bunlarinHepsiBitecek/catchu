//
//  Profile4.swift
//  catchu
//
//  Created by Erkut Baş on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Profile4: UIView {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileUsername: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!

    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var middleView: UIView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var topViewTopConstraintsTop: NSLayoutConstraint!
    @IBOutlet var bottomViewHeightConstraints: NSLayoutConstraint!
    
    private let topViewOriginalTopConstraints: CGFloat = 0
    private let topViewMinimalVisibleHeight: CGFloat  = 54
    private let topViewMaximumVisibleHeightReverse: CGFloat  = -206
    private var imaginarBottomViewOffsetStartPositionY: CGFloat = 0.0
    
    private var bottomViewOriginalHeight: CGFloat = 0.0
    
    private var topViewBottomY: CGFloat  = 0.0
    private var dragStartPos: CGPoint = CGPoint.zero
    private let dragDifference: CGFloat = 10
    
    // reference objects
    lazy var referenceOfSlidingView4 = SlidingView4()
    lazy var referenceOfMenuBarView4 = MenuBar4()
    lazy var referenceOfProfile4ViewController = Profile4ViewController()
    
    private var contentOffset: CGFloat = 0.0
    
    private var changeCellFlowLayout : Bool!
    
    // Variables for calculating the position
    enum Direction {
        case SCROLL
        case STOP
        case UP
        case DOWN
    }
    
    var dragDirection = Direction.UP
 
}

extension Profile4: UIGestureRecognizerDelegate {
    
    func initialize() {
        
        self.middleView.backgroundColor = UIColor.clear
        
        let panGesturizeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Profile4.panProcessStarts(_:)))
        panGesturizeRecognizer.delegate = self
        self.bottomView.addGestureRecognizer(panGesturizeRecognizer)
        
        self.bottomViewOriginalHeight = self.bottomView.frame.height
        print("bottomViewOriginalHeight : \(bottomViewOriginalHeight)")
        
        setUserProfileInformation()
        addTapGestureRecognizerToProfilePicture()
    }
    
    func setProfileImageFromExternal(input : UIImage) {
        
        profileImage.image = input
        
    }
    
    func addTapGestureRecognizerToProfilePicture() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Profile4.startImagePickerProcess(_:)))
        
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func startImagePickerProcess(_ inputTapGestureRecognizer : UITapGestureRecognizer) {
        
        //ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        ImageVideoPickerHandler.shared.createActionSheetForImageChoiceProcess(inputRequest: .profilePicture)
        
    }
    
    
    /// APIGateway - read userProfile information from database
    func setUserProfileInformation() {
        
        LoaderController.shared.showLoader()
        
        APIGatewayManager.shared.getUserProfileInfo(userid: User.shared.userID) { (userProfileData, result) in
            
            if result {
                
                DispatchQueue.main.async {
                    
                    LoaderController.shared.removeLoader()
                    
                    User.shared.setUserProfileData(httpRequest: userProfileData)
                    
                    UIView.transition(with: self.profileUsername, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        
                        self.profileUsername.text = User.shared.name
                        
                    })
                    
                    UIView.transition(with: self.profileImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        
                        self.profileImage.setImagesFromCacheOrFirebaseForFriend(User.shared.profilePictureUrl)
                        
                    })
                    
                    UIView.transition(with: self.followersLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        
                        self.followersLabel.text = User.shared.userFollowerCount
                        
                    })
                    
                    UIView.transition(with: self.followingLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        
                        self.followingLabel.text = User.shared.userFollowingCount
                        
                    })
                    
                    // after getting userProfile information, make rightbutton enable for user interaction
                    self.referenceOfProfile4ViewController.navigationItem.rightBarButtonItem?.isEnabled = true
                    
                }
                
            } else {
                
                LoaderController.shared.removeLoader()
                
            }
            
        }
        
    }

    func findOutWhichPageIsActive() {
        
        print("findOutWhichPageIsActive starts")
        
//        let indexPaths = referenceOfSlidingView4.slidingCollectionView.indexPathsForSelectedItems
//        let indexPaths = referenceOfMenuBarView4.menuBarCollectionView.indexPathsForSelectedItems
        let indexPaths = referenceOfSlidingView4.slidingCollectionView.indexPathsForVisibleItems
        
        print("indexPaths : \(String(describing: indexPaths.first))")
        
        if indexPaths.first != nil {
            
            if let indexPath = indexPaths.first {
                
                if indexPath.row == 0 {
                    
                    estimateContentOffsetY(input: indexPath)
                    
                } else if indexPath.row == 1 {
                    
                    estimateContentOffsetY(input: indexPath)
                    
                } else if indexPath.row == 2 {
                    
                    estimateContentOffsetY(input: indexPath)
                    
                } else if indexPath.row == 3 {
                    
                    estimateContentOffsetY(input: indexPath)
                    
                } else {
                    return
                }
            }
            
        } else {
            return
        }
    }
    
    
    func estimateContentOffsetY(input : IndexPath) {
        
        print("estimateContentOffsetY starts")
        print("input : \(input)")
        
        createRefenceForCellDeepInSlidinPages(indexPath: input)
        
    }
    
    
    func invalidateLayoutOfMenuBased() {
        
        self.referenceOfSlidingView4.slidingCollectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    func createRefenceForCellDeepInSlidinPages(indexPath : IndexPath) {
        
        print("createRefenceForCellDeepInSlidinPages starts")
        print("indexPath.row : \(indexPath.row)")
        
        switch indexPath.row {
        case 0:
            guard let cell = referenceOfSlidingView4.slidingCollectionView.cellForItem(at: indexPath) as? DataPage1CollectionViewCell else { return }
            
            contentOffset = cell.item1CollectionView.contentOffset.y
            
        case 1:
            guard let cell = referenceOfSlidingView4.slidingCollectionView.cellForItem(at: indexPath) as? DataPage2CollectionViewCell else { return }
            
            contentOffset = cell.item2CollectionView.contentOffset.y
            
        case 2:
            guard let cell = referenceOfSlidingView4.slidingCollectionView.cellForItem(at: indexPath) as? DataPage3CollectionViewCell else { return }
            
            contentOffset = cell.item3CollectionView.contentOffset.y
        case 3:
            guard let cell = referenceOfSlidingView4.slidingCollectionView.cellForItem(at: indexPath) as? DataPage4CollectionViewCell else { return }
            
            contentOffset = cell.item4CollectionView.contentOffset.y
            
        default:
            return
        }
        
        print("contentOffset : \(contentOffset)")
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    @objc func panProcessStarts(_ sender : UIPanGestureRecognizer) {
        
        print("panProcessStarts starts")
        
        switch sender.state {
        case .began:
            panBeganProcess(sender)
            break
            
        case .changed:
            panChangedProcess(sender)
            break
            
        default:
            otherPanProcess(sender)
            print("do something")
        }
        
    }
    
    func panBeganProcess(_ sender : UIPanGestureRecognizer) {
        
        print("panBeganProcess starts")
        
        let view    = sender.view
        let location = sender.location(in: view)
        let subview = view?.hitTest(location, with: nil)
        
        if subview == topView && topViewTopConstraintsTop.constant == topViewOriginalTopConstraints {
            
            return
        }
        
        dragStartPos = sender.location(in: self)
        
        topViewBottomY = self.topView.frame.origin.y + self.topView.frame.height
        
//        print("dragStartPos : \(dragStartPos)")
//        print("topViewBottomY : \(topViewBottomY)")
        
        // Move
        if dragDirection == Direction.STOP {
            
            dragDirection = (topViewTopConstraintsTop.constant == topViewOriginalTopConstraints) ? Direction.UP : Direction.DOWN
        }
        
        // Scroll event of CollectionView is preferred.
        if (dragDirection == Direction.UP   && dragStartPos.y < topViewBottomY + dragDifference) ||
            (dragDirection == Direction.DOWN && dragStartPos.y > topViewBottomY) {
            
            dragDirection = Direction.STOP
            
        }
        
    }
    
    func panChangedProcess(_ sender : UIPanGestureRecognizer) {
        
        print("panChangedProcess starts")
        let currentPosition = sender.location(in: self)
        
        changeCellFlowLayout = false
        
//        print("currentPosition :\(currentPosition)")
//        print("dragDirection :\(dragDirection)")
//        print("dragDifference :\(dragDifference)")
//        print("topViewBottomY :\(topViewBottomY)")
//        print("topViewTopConstraintsTop.constant : \(topViewTopConstraintsTop.constant)")
        
        if dragDirection == Direction.UP && currentPosition.y < topViewBottomY - dragDifference {
            
            topViewTopConstraintsTop.constant = max(topViewMinimalVisibleHeight - self.topView.frame.height, currentPosition.y + dragDifference - topView.frame.height)
            
            bottomViewHeightConstraints.constant = min(self.frame.height - topViewMinimalVisibleHeight, self.frame.height - topViewTopConstraintsTop.constant - topView.frame.height)
            
//            print("topViewTopConstraintsTop :\(topViewTopConstraintsTop.constant)")
//            print("bottomViewHeightConstraints :\(bottomViewHeightConstraints.constant)")
            
            //referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
            
        } else if dragDirection == Direction.DOWN && currentPosition.y > topViewBottomY {
            print("DOWN")
            topViewTopConstraintsTop.constant = min(topViewOriginalTopConstraints, currentPosition.y - topView.frame.height)
            
            bottomViewHeightConstraints.constant = max(self.frame.height - topViewOriginalTopConstraints - topView.frame.height, self.frame.height - topViewTopConstraintsTop.constant - topView.frame.height)
            
            //referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
            
//        } else if dragDirection == Direction.STOP && bottomView.frame.origin.y < 0 {
//        } else if dragDirection == Direction.STOP {
        } else if dragDirection == Direction.STOP && contentOffset < 0{
            print("STOP")
            dragDirection = Direction.SCROLL
            imaginarBottomViewOffsetStartPositionY = currentPosition.y
            
        } else if dragDirection == Direction.SCROLL {
            
            print("SCROLL")
            
//            print("topViewTopConstraintsTop.constant : \(topViewTopConstraintsTop.constant)")
//            print("bottomViewHeightConstraints.constant : \(bottomViewHeightConstraints.constant)")
            
            if topViewTopConstraintsTop.constant < 0 {

                topViewTopConstraintsTop.constant = topViewMinimalVisibleHeight - self.topView.frame.height + currentPosition.y - imaginarBottomViewOffsetStartPositionY
                print("topViewTopConstraintsTop.constant : \(topViewTopConstraintsTop.constant)")

            }

            print("bottomViewHeightConstraints.constant : \(bottomViewHeightConstraints.constant)")

            if bottomViewHeightConstraints.constant < self.mainView.frame.height {

                bottomViewHeightConstraints.constant = max(self.frame.height - topViewOriginalTopConstraints - topView.frame.height, self.frame.height - topViewTopConstraintsTop.constant - topView.frame.height)

            }
            
            //referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
         
        }
        
        findOutWhichPageIsActive()
        invalidateLayoutOfMenuBased()
        
        
    }
    
    func otherPanProcess(_ sender : UIPanGestureRecognizer) {
        
        print("otherPanProcess starts")
        
        imaginarBottomViewOffsetStartPositionY = 0.0
//        print("gesture gidiii")
//        print("sender.state : \(sender.state)")
//        print("UIGestureRecognizerState.ended : \(UIGestureRecognizerState.ended)")
//        print("dragDirection : \(dragDirection)")
        
        
        if sender.state == UIGestureRecognizerState.ended &&
            dragDirection == Direction.STOP {
            
            return
        }
        
        let currentPosition = sender.location(in: self)
        
        if currentPosition.y < topViewBottomY - dragDifference &&
            topViewTopConstraintsTop.constant != topViewOriginalTopConstraints {
            
            print("buradayım1")
            
            topViewTopConstraintsTop.constant = topViewMinimalVisibleHeight - self.topView.frame.height
            
            bottomViewHeightConstraints.constant = self.frame.height - topViewMinimalVisibleHeight
            
            //referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            
                            self.layoutIfNeeded()
                            
            }, completion: nil)
            
            dragDirection = Direction.DOWN
            
            arrangeViewControllerTitle(inputDirection: .UP)
            
        } else {
            
            print("buradayım2")
            
            topViewTopConstraintsTop.constant = topViewOriginalTopConstraints
            bottomViewHeightConstraints.constant = self.frame.height - topViewOriginalTopConstraints - topView.frame.height
            
//            referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
            
//            if bottomViewHeightConstraints.constant !=  bottomViewOriginalHeight {
//                referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
//            }
            
            
            print("bottomViewHeightConstraints.constant : \(bottomViewHeightConstraints.constant)")
            print("bottomViewOriginalHeight : \(bottomViewOriginalHeight)")
            print("topViewTopConstraintsTop.constants : \(topViewTopConstraintsTop.constant)")
            
            print("changeCellFlowLayout : \(changeCellFlowLayout)")

//            if changeCellFlowLayout {
//                referenceOfSlidingView4.resizeFlowLayoutItem(inputSize: bottomViewHeightConstraints.constant)
//                changeCellFlowLayout = false
//            }
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            
                            self.layoutIfNeeded()
                            
            }, completion: nil)
            
            dragDirection = Direction.UP
            
            arrangeViewControllerTitle(inputDirection: .DOWN)
            
        }

        findOutWhichPageIsActive()
        invalidateLayoutOfMenuBased()
        
    }
    
    func arrangeViewControllerTitle(inputDirection : Direction) {
        
        switch inputDirection {
        case .UP:
            print("up")
            setTitle(inputTitle: User.shared.name)
            
        case .DOWN:
            print("down")
            setTitle(inputTitle: Constants.CharacterConstants.SPACE)
            
        default:
            return
        }
        
        
    }
    
    func setTitle(inputTitle : String) {
        
        UIView.animate(withDuration: 0.5) {
            self.referenceOfProfile4ViewController.title = inputTitle
        }
        
    }
}

    
    
    

