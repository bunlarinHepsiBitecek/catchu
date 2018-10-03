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
    
    var customFetchView : CustomFetchView?
    
//    lazy var customFetchView: CustomFetchView = {
//
//        let temp = CustomFetchView(progressInfo: CircleAnimationProcess.start, inputProgressValue: 0)
//        temp.translatesAutoresizingMaskIntoConstraints = false
//        temp.isUserInteractionEnabled = true
//        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
//
//        return temp
//    }()
    
    var fetchFromIcloud : Bool = false
    
    public var photos = [PHAsset]()

    // collectionView for galery sections
    lazy var collectionViewForImageManagement: UICollectionView = {
        
        /*
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true*/
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        initializeCustomCameraView()
        initializeCapturedImageView()
        initializeSelectedImageView()
        initializeCroppedImageView()
        
        getPhotosFromGallery()
        
//        setupFetchingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//
//        setupFetchingView()
//
//    }
    
    func setupFetchingView() {
        
        let x = self.center.x
        let y = self.center.y
        let position = CGPoint(x: x, y: y)
        
        customFetchView = CustomFetchView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        
        guard customFetchView != nil else {
            return
        }
        
        customFetchView!.center = position
        
        customFetchView!.layer.cornerRadius = 10
        customFetchView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        self.addSubview(customFetchView!)
        
        activationManagerOfFetchView(activate: false)
        
//        let safe = self.safeAreaLayoutGuide
//        
//        customFetchView!.centerYAnchor.constraint(equalTo: safe.centerYAnchor).isActive = true
//        customFetchView!.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        
    }
    
}

// MARK: - major functions
extension ImageManagementView {
    
    private func setupViews() {
        
        self.addSubview(collectionViewForImageManagement)
//        self.addSubview(customFetchView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            collectionViewForImageManagement.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionViewForImageManagement.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionViewForImageManagement.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionViewForImageManagement.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
//            customFetchView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
//            customFetchView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
//            customFetchView.heightAnchor.constraint(equalToConstant: 80),
//            customFetchView.widthAnchor.constraint(equalToConstant: 200)
            
            ])
        
        
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
        
        captureImageView = CustomCameraCapturedImageView()
        
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
            
            let cell = collectionViewForImageManagement.cellForItem(at: indexPath) as? ImageCollectionViewCell2
            
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
    
    func progressCustomProgressView(inputProgressValue: CGFloat) {
        
        print("progressCustomProgressView starts")
        print("inputProgressValue : \(inputProgressValue)")
        
        guard customFetchView != nil else {
            return
        }
        
        DispatchQueue.main.async {
            self.customFetchView!.setProgress(progress: inputProgressValue)
        }
        
        
    }
    
    func stopCustomProgressView() {
        
        print("stopCustomProgressView starts")
        
        guard customFetchView != nil else {
            return
        }
        
        customFetchView!.setProgress(progress: 100)
        activationManagerOfFetchView(activate: false)
        
    }
    
    func startCustomProgressView() {
        
        print("startCustomProgressView starts")
        
        UIView.transition(with: self, duration: Constants.AnimationValues.aminationTime_02, options: .transitionCrossDissolve, animations: {
            
            self.activationManagerOfFetchView(activate: true)
            
        })
        
    }
    
    func activationManagerOfFetchView(activate : Bool) {
        
        guard customFetchView != nil else {
            return
        }
        
        DispatchQueue.main.async {
            if activate {
                self.customFetchView!.alpha = 1
            } else {
                self.customFetchView!.alpha = 0
            }
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
        
        CustomPermissionViewController.shared.delegate = self
        
        switch permissionType {
        case .photoLibrary:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .photoLibrary)
        case .photoLibraryUnAuthorized:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .photoLibraryUnAuthorized)
        case .camera:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .camera)
        case .cameraUnathorized:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self, permissionType: .cameraUnathorized)
        default:
            return
        }
        
    }
    
}
