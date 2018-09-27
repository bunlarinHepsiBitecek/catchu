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
    
    private var customCameraView : CustomCameraView?
    
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
        
        getPhotosFromGallery()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ImageManagementView {
    
    private func setupViews() {
        
        self.addSubview(collectionViewForImageManagement)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            collectionViewForImageManagement.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionViewForImageManagement.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionViewForImageManagement.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionViewForImageManagement.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    private func getPhotosFromGallery() {
        
        //        MediaLibraryManager.shared.success = nil
        
        MediaLibraryManager.shared.delegateForGalleryPermission = self
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
            
            let cell = collectionViewForImageManagement.cellForItem(at: indexPath) as? ImageCollectionViewCell
            
            let asset = self.photos[indexPath.item]
            MediaLibraryManager.shared.imageFrom(asset: asset, size: PHImageManagerMaximumSize) { (image) in
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.4) {
                        
                        //                        self.initiateSelectedImageView2()
                        //                        self.selectedSpecialView.setImage(input: image)
                        
//                        self.initiateSelectedImageView4(input: image)
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

    func initiateCustomCamera() throws {
        
        guard customCameraView != nil else {
            throw DelegationErrors.CustomCameraViewIsNil
        }
        
        customCameraView!.enableCustomCameraProcess()
        
    }
    
//    func initiateCustomCamera() {
//
//        guard customCameraView != nil else {
//            return
//        }
//
//        customCameraView!.startCustomCameraProcess()
////        customCameraViewActivationManager(active: true)
//
//    }
    
}

// MARK: - PermissionProtocol
extension ImageManagementView : PermissionProtocol {
    
    func returnPermissionResult(status: PHAuthorizationStatus) {
        
        print("returnPermissionResult starts in cameraGalleryCollectionViewCell")
        print("status : \(status)")
        
        getPhotosFromGallery()
        
        //        DispatchQueue.main.async {
        //            self.containerView.removeFromSuperview()
        //            self.photoCollectionView.alpha = 1
        //        }
        
    }
    
    func returnPermissinResultBoolValue(result: Bool) {
        
        print("returnPermissinResultBoolValue starts in cameraGalleryCollectionViewCell")
        print("result : \(result)")
        if result {
            
//            initializeCustomCameraView()
            
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
