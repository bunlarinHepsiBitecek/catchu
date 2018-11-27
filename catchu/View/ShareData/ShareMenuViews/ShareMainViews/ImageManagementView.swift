//
//  ImageManagementView.swift
//  catchu
//
//  Created by Erkut Baş on 9/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ImageManagementView: UIView {
    
//    private var customCameraView : CustomCameraView?
    var customCameraView : CustomCameraView?
    var captureImageView : CustomCameraCapturedImageView?
    var customSelectedImageContainer : CustomScrollViewContainer?
    var croppedImage : CustomCroppedImage?
    
    weak var delegate : ShareDataProtocols!
    
    /// iCloud fetching
    var progressBar : CustomProgressBarLayer2?
    private var progressBarAdded : Bool = false
    
    /// photos from gallery
    public var photos = [PHAsset]()

    // collectionView for galery sections
    lazy var collectionViewForImageManagement: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.minimumInteritemSpacing = Constants.Cell.imageCollectionViewMinLineSpacing_01
        layout.sectionInset = UIEdgeInsets(top: Constants.Cell.imageCollectionViewEdgeInsets_02, left: Constants.Cell.imageCollectionViewEdgeInsets_02, bottom: Constants.Cell.imageCollectionViewEdgeInsets_02, right: Constants.Cell.imageCollectionViewEdgeInsets_02)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        
//        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(PhotoLibraryCollectionViewCell2.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.photoLibraryCell)
        collectionView.register(PhotoCollectionViewCell2.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.photoCell)
        collectionView.register(ImageCollectionViewCell2.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.imageCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    lazy var progressViewContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        temp.layer.cornerRadius = 10
        temp.alpha = 0
        
        return temp
    }()
    
    lazy var labelContainer: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var iCloudFetchingInformation: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = LocalizedConstants.Cloud.cloudFetching
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        temp.contentMode = .center
        temp.textAlignment = .center
        
        return temp
    }()
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        initializeCustomCameraView()
        initializeCapturedImageView()
        initializeSelectedImageView()
        initializeCroppedImageView()
        
        getPhotosFromGallery()
        
    }*/
    
    init(frame: CGRect, inputDelegate : ShareDataProtocols) {
        super.init(frame: frame)
       
        self.delegate = inputDelegate
        
        setupViews()
        initializeCustomCameraView()
        initializeCapturedImageView()
        initializeSelectedImageView()
        initializeCroppedImageView()
        
        getPhotosFromGallery()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupProgressBar()
        
    }
    
}

// MARK: - major functions
extension ImageManagementView {
    
    private func setupViews() {
        
        self.addSubview(collectionViewForImageManagement)
        self.addSubview(progressViewContainer)
        self.progressViewContainer.addSubview(labelContainer)
        self.labelContainer.addSubview(iCloudFetchingInformation)
        
        let safe = self.safeAreaLayoutGuide
        let safeProgressViewContainer = self.progressViewContainer.safeAreaLayoutGuide
        let safeLabelContainer = self.labelContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            collectionViewForImageManagement.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionViewForImageManagement.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionViewForImageManagement.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionViewForImageManagement.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            progressViewContainer.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            progressViewContainer.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            progressViewContainer.heightAnchor.constraint(equalToConstant: 100),
            progressViewContainer.widthAnchor.constraint(equalToConstant: 200),
            
            labelContainer.leadingAnchor.constraint(equalTo: safeProgressViewContainer.leadingAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: safeProgressViewContainer.trailingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: safeProgressViewContainer.bottomAnchor),
            labelContainer.heightAnchor.constraint(equalToConstant: 25),
            
            iCloudFetchingInformation.leadingAnchor.constraint(equalTo: safeLabelContainer.leadingAnchor),
            iCloudFetchingInformation.trailingAnchor.constraint(equalTo: safeLabelContainer.trailingAnchor),
            iCloudFetchingInformation.topAnchor.constraint(equalTo: safeLabelContainer.topAnchor),
            iCloudFetchingInformation.bottomAnchor.constraint(equalTo: safeLabelContainer.bottomAnchor),
   
            ])
        
    }
    
    func setupProgressBar() {
        if !progressBarAdded {
            
            if progressViewContainer.frame.height > 0 && progressViewContainer.frame.width > 0 {
                
                let x = progressViewContainer.frame.width / 2
                let y = progressViewContainer.frame.height / 2
                let position = CGPoint(x: x, y: y)
                
                progressBar = CustomProgressBarLayer2(radius: 20, position: position, innerColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), outerColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), lineWidth: 7)
                progressViewContainer.layer.addSublayer(progressBar!)
                
                progressBarAdded = true
                
            }
        }
    }
    
    private func getPhotosFromGallery() {
        
        //        MediaLibraryManager.shared.success = nil
        
        MediaLibraryManager.shared.delegateForGalleryPermission = self
        MediaLibraryManager.shared.delegateForShareDataProtocols = self
        MediaLibraryManager.shared.loadPhotos { (phAssetResult) in
            
            //            print("phAssetResult.count : \(String(describing: phAssetResult))")
            
            if phAssetResult.count > 0 {
                
                self.photos = phAssetResult
                
                DispatchQueue.main.async {
                    self.collectionViewForImageManagement.reloadData()
                }
                
            }
        }
    }
    
    /// start camera session
    func initializeCustomCameraView() {
        
        customCameraView = CustomCameraView(delegateShareDataProtocols: self, delegatePermissionProtocol: self)
        
        customCameraView!.customCameraViewActivationManager(active: false)
        
        self.addSubview(customCameraView!)
        customCameraView!.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customCameraView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            customCameraView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            customCameraView!.topAnchor.constraint(equalTo: safe.topAnchor),
            customCameraView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
            
            ])
        
    }
    
    func initializeCapturedImageView() {
        
        captureImageView = CustomCameraCapturedImageView(inputDelegate: delegate)
        
        captureImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            
            self.addSubview(self.captureImageView!)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.captureImageView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                self.captureImageView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                self.captureImageView!.topAnchor.constraint(equalTo: safe.topAnchor),
                self.captureImageView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
                
                ])
        })
        
    }
    
    func initializeSelectedImageView() {
        
        customSelectedImageContainer = CustomScrollViewContainer()
        customSelectedImageContainer!.setDelegate(delegate: self)
        
        customSelectedImageContainer!.translatesAutoresizingMaskIntoConstraints = false
        customSelectedImageContainer!.clipsToBounds = true
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            
            self.addSubview(self.customSelectedImageContainer!)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.customSelectedImageContainer!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                self.customSelectedImageContainer!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                self.customSelectedImageContainer!.topAnchor.constraint(equalTo: safe.topAnchor),
                self.customSelectedImageContainer!.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
                
                ])
        })
        
    }
    
    func initializeCroppedImageView() {
        
        croppedImage = CustomCroppedImage()
        
        croppedImage!.delegate = self.delegate
        
        croppedImage!.translatesAutoresizingMaskIntoConstraints = false
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            
            self.addSubview(self.croppedImage!)
            
            let safe = self.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                self.croppedImage!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                self.croppedImage!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                self.croppedImage!.topAnchor.constraint(equalTo: safe.topAnchor),
                self.croppedImage!.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
                
                ])
        })
        
    }
    
    func startCropImageView(inputImage : UIImage) {
        
        guard customSelectedImageContainer != nil else {
            return
        }
        
        customSelectedImageContainer!.setImage(inputImage: inputImage)
        
    }
    
    func createNewImageWithStickers() {
        
        guard let captureImageView = captureImageView else { return }
        
        if let stickerArray = Stickers.shared.stickerArray {
            if !stickerArray.isEmpty {
                captureImageView.menuFooterHiddenManagement(hidden: true)
                
                UIGraphicsBeginImageContextWithOptions(captureImageView.bounds.size, captureImageView.isOpaque, 0.0)
                
                captureImageView.drawHierarchy(in: captureImageView.bounds, afterScreenUpdates: true)
                let snapShot = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                captureImageView.menuFooterHiddenManagement(hidden: false)
                captureImageView.saveCapturedImagesToSelectedItems(image: snapShot!)
                
            } else {
                captureImageView.saveCapturedImagesToSelectedItems(image: captureImageView.returnCapturedImage())
            }
            
        } else {
            captureImageView.saveCapturedImagesToSelectedItems(image: captureImageView.returnCapturedImage())
            
        }
        
    }
    
    func saveSelectedImageFromCroppedImage() {
        
        if let croppedImage = croppedImage {
            
            if PostItems.shared.selectedImageArray == nil {
                PostItems.shared.selectedImageArray = Array<UIImage>()
            }
            
            PostItems.shared.selectedImageArray!.append(croppedImage.returnImage())
            
        }
        
    }
    
    func saveSelectedImageFromZoomView() {
        
        if let customSelectedImageContainer = customSelectedImageContainer {
            
            if PostItems.shared.selectedImageArray == nil {
                PostItems.shared.selectedImageArray = Array<UIImage>()
            }
            
            PostItems.shared.selectedImageArray!.append(customSelectedImageContainer.returnImage())
            
        }
        
    }
    
}

// MARK: - progressBar animation functions
extension ImageManagementView {
    
    // MARK: icloud fetching management functions
    func progressCustomProgressView(inputProgressValue: CGFloat) {
        
        print("progressCustomProgressView starts")
        print("inputProgressValue : \(inputProgressValue)")
        
        if progressBar != nil {
            
            DispatchQueue.main.async {
                self.progressBar!.progress = inputProgressValue
            }
            
        }
        
    }
    
    func startCustomProgressView() {
        
        print("startCustomProgressView starts")
        
        if progressBar != nil {
            activationManagerOfProgressContainerView(activate: true)
        }
        
    }
    
    func stopCustomProgressView() {
        
        print("stopCustomProgressView starts")
        
        if progressBar != nil {
            activationManagerOfProgressContainerView(activate: false)
        }
        
    }
    
    func activationManagerOfProgressContainerView(activate : Bool) {
        
        if progressBar != nil {

            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.3, animations: {
                    if activate {
                        self.progressViewContainer.alpha = 1
                    } else {
                        self.progressViewContainer.alpha = 0
                    }
                })
                
            }
            
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ImageManagementView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        return fetchResult.count - 2
        print("photos.count : \(photos.count)")
        return photos.count - 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = collectionViewForImageManagement.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.photoLibraryCell, for: indexPath) as? PhotoLibraryCollectionViewCell2 else { return UICollectionViewCell() }
            
            cell.delegate = self
            
            return cell
            
        } else if indexPath.row == 1 {
            
            guard let cell = collectionViewForImageManagement.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.photoCell, for: indexPath) as? PhotoCollectionViewCell2 else { return UICollectionViewCell() }
            
            cell.delegate = self
            cell.delegatePermissionControl = self
//            cell.setConstraints(inputSize: cell.frame.width)
            
            return cell
            
        } else {
            
            guard let cell = collectionViewForImageManagement.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.imageCell, for: indexPath) as? ImageCollectionViewCell2 else { return UICollectionViewCell() }

            cell.setImage(asset: photos[indexPath.item])

            return cell

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // we need to pass first two cell
        if indexPath.row > 1 {
            
            if let cell = collectionViewForImageManagement.cellForItem(at: indexPath) as? ImageCollectionViewCell2 {
                
                selectedCellAnimation(cell: cell)
                
                let asset = self.photos[indexPath.item]
                MediaLibraryManager.shared.imageFrom(asset: asset, size: PHImageManagerMaximumSize) { (image) in
                    DispatchQueue.main.async {
                        
                        UIView.animate(withDuration: 0.4) {
                            
                            self.startCropImageView(inputImage : image)
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    func selectedCellAnimation(cell : UICollectionViewCell) {
        
        cell.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03, delay: 0, usingSpringWithDamping: 0.20, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            
            cell.transform = CGAffineTransform.identity
            
        })
        
        cell.layoutIfNeeded()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let majorLineEdges = Constants.Cell.imageCollectionViewMinLineSpacing_01 * (Constants.Cell.imageCollectionViewMaxCellCount - 1) + Constants.Cell.imageCollectionViewMaxCellCount
        print("majorLineEdges : \(majorLineEdges)")
        
        let dynamicSize = (self.bounds.size.width - majorLineEdges) / Constants.Cell.imageCollectionViewMaxCellCount
        print("dynamicSize : \(dynamicSize)")
        
        return CGSize(width: dynamicSize, height: dynamicSize)
        
    }
    
}

// MARK: - ShareDataProtocols
extension ImageManagementView : ShareDataProtocols {

    func setCroppedImage(inputImage: UIImage) {
        
        guard croppedImage != nil else {
            return
        }
        
        croppedImage!.setImage(inputImage: inputImage)
        
    }
    
    func initiateCustomCamera() throws {
        
        guard customCameraView != nil else {
            throw DelegationErrors.CustomCameraViewIsNil
        }
        
        customCameraView!.enableCustomCameraProcess()
        
    }
    
    func setCapturedImage(inputImage: UIImage, cameraPosition: CameraPosition) {
        
        guard captureImageView != nil else {
            return
        }
        
        captureImageView!.activationManagerWithImageCameraPositionInfo(granted: true, inputImage: inputImage, cameraPosition: cameraPosition)
        
    }
    
    func startingICloudDownloadAnimation(animation: CircleAnimationProcess, inputProgressValue: CGFloat) {
        
        switch animation {
        case .start:
            print("start")
            startCustomProgressView()
        case .stop:
            print("stop")
            stopCustomProgressView()
        case .progress:
            print("progress")
            progressCustomProgressView(inputProgressValue: inputProgressValue)
        }
        
    }
    
}

// MARK: - PermissionProtocol
extension ImageManagementView : PermissionProtocol {
    
    func returnPermissionResult(status: PHAuthorizationStatus) {
        
        print("returnPermissionResult starts in cameraGalleryCollectionViewCell")
        print("status : \(status)")
        
        getPhotosFromGallery()
        
    }
    
    func returnPermissinResultBoolValue(result: Bool) {
        
        print("returnPermissinResultBoolValue starts in cameraGalleryCollectionViewCell")
        print("result : \(result)")
        if result {
            
            guard customCameraView != nil else {
                return
            }
            
            customCameraView!.initiateCustomCameraView()
            
        }
        
    }
    
    func requestPermission(permissionType : PermissionFLows) {
        
        
        switch permissionType {
        case .photoLibrary:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .photoLibrary, delegate: self)
        case .photoLibraryUnAuthorized:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .photoLibraryUnAuthorized, delegate: self)
        case .camera:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .camera, delegate: self)
        case .cameraUnathorized:
            CustomPermissionViewManager.shared.createAuthorizationView(inputView: self, permissionType: .cameraUnathorized, delegate: self)
        default:
            return
        }
        
    }
    
}

// MARK: - ImageHandlerProtocol
extension ImageManagementView : ImageHandlerProtocol {
    
    func returnImage(inputImage: UIImage) {
        
        UIView.animate(withDuration: 0.4) {
            
            self.startCropImageView(inputImage : inputImage)
            
        }
        
    }
    
}
