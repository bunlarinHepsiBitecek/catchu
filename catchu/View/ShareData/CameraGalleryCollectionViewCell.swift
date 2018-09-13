//
//  CameraGalleryCollectionViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 9/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class CameraGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var photoCollectionView: UICollectionView!
    
    public var photos = [PHAsset]()
    
    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult()

    weak var delegate : ShareDataProtocols!
    weak var delegateForShareType : ShareDataProtocols!
    
    var selectedCell : IndexPath!
    var collectionViewCellSelected : Bool!
    
    var customPermissionViewForGallery : CustomPermissionView?

    let selectedSpecialView : SelectedImageManager = {
        
        let temp = SelectedImageManager(frame: .zero)
        return temp
        
    }()
    
//    let containerView : UIView = {
//
//        let temp = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        temp.translatesAutoresizingMaskIntoConstraints = false
//        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        temp.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        temp.layer.borderWidth = 3
//        temp.layer.cornerRadius = 7
//
//        temp.isUserInteractionEnabled = true
//
//        return temp
//
//    }()
    
    let detailLable : UILabel = {
        
        let temp = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        temp.layer.cornerRadius = 10
        //            temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        temp.textAlignment = .center
        temp.lineBreakMode = .byWordWrapping
        temp.numberOfLines = 0
        temp.text = LocalizedConstants.PickerControllerStrings.helpCatchU
        temp.font = UIFont(name: "System", size: 25)
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    
    /// awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("CameraGalleryCollectionViewCell starts")
        mainView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.allowsMultipleSelection = false
        photoCollectionView.isMultipleTouchEnabled = false
        
        collectionViewCellSelected = false
        
        getPhotosFromGallery()
//        initiateSelectedImageView2()
        
    }
    
    
}

// MARK: - Major functions
extension CameraGalleryCollectionViewCell {

    private func getPhotosFromGallery() {
        
//        MediaLibraryManager.shared.success = nil
        
        MediaLibraryManager.shared.delegateForGalleryPermission = self
        MediaLibraryManager.shared.loadPhotos { (phAssetResult) in
            
            print("phAssetResult.count : \(String(describing: phAssetResult))")
            
            if phAssetResult.count > 0 {
                
                self.photos = phAssetResult
                
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadData()
                }
                
            }
        }
    }
    
    func initiateSelectedImageView4(input : UIImage) {
        
        let scrollView = CustomScrollView2(image: input)
        
        contentView.addSubview(scrollView)
        
        scrollView.frame = contentView.frame
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func initializeCustomCameraView() {
        
        let customCamera = CustomCamereView()
        
        UIView.transition(with: contentView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            self.contentView.addSubview(customCamera)
            
            customCamera.translatesAutoresizingMaskIntoConstraints = false
            
            let safe = self.contentView.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                
                customCamera.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
                customCamera.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
                customCamera.topAnchor.constraint(equalTo: safe.topAnchor),
                customCamera.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
                
                ])
            
        })
        
    }
    
}

// MARK: - collectionView operations
extension CameraGalleryCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return fetchResult.count - 2
        print("photos.count : \(photos.count)")
        return photos.count - 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.photoLibraryCell, for: indexPath) as? PhotoLibraryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setConstraints(inputSize: cell.frame.width)
            
            return cell
            
        } else if indexPath.row == 1 {
            
            guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.photoCell, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            cell.delegatePermissionControl = self
            cell.setConstraints(inputSize: cell.frame.width)
            
            return cell
            
        } else {
            
            guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.imageCell, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setConstraints(inputSize: cell.frame.width)
//            let asset = fetchResult.object(at: indexPath.row)
            
            cell.setImage(asset: photos[indexPath.item])
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // we need to pass first two cell
        if indexPath.row > 1 {
            
            let cell = photoCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
            
            let asset = self.photos[indexPath.item]
            MediaLibraryManager.shared.imageFrom(asset: asset, size: PHImageManagerMaximumSize) { (image) in
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.4) {
                        
//                        self.initiateSelectedImageView2()
//                        self.selectedSpecialView.setImage(input: image)
                        
                        self.initiateSelectedImageView4(input: image)
                    }
                    
                }
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        photoCollectionView.deselectItem(at: indexPath, animated: true)
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = delegate.returnSliderWidth() / 4
        
        return CGSize(width: size, height: size)
        
    }
    
}


// MARK: - ShareDataProtocols
extension CameraGalleryCollectionViewCell : ShareDataProtocols {
    
    func initiateCustomCamera() {
        
        initializeCustomCameraView()
        
    }
    
}


// MARK: - PermissionProtocol
extension CameraGalleryCollectionViewCell : PermissionProtocol {
    
//    func initiateSpecificActions() {
//        
//        mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        
//        mainView.addSubview(View)
//        containerView.addSubview(detailLable)
//        
//        let safeAreaLayout = mainView.safeAreaLayoutGuide
//        let safeAreForLabel = containerView.safeAreaLayoutGuide
//        
//        print("safeAreaLayout : \(safeAreaLayout)")
//        
//        NSLayoutConstraint.activate([
//            
//            containerView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant: 0),
//            containerView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor, constant: 0),
//            containerView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor, constant: 0),
//            containerView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 0),
//            
//            detailLable.centerYAnchor.constraint(equalTo: safeAreForLabel.centerYAnchor),
//            detailLable.centerXAnchor.constraint(equalTo: safeAreForLabel.centerXAnchor),
//            detailLable.heightAnchor.constraint(equalToConstant: 100),
//            detailLable.widthAnchor.constraint(equalToConstant: 300)
//            
//            ])
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraGalleryCollectionViewCell.startPermissionFlow(_:)))
//        tapGestureRecognizer.delegate = self
//        containerView.addGestureRecognizer(tapGestureRecognizer)
//        
//        self.photoCollectionView.alpha = 0
//        
//    }
    
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
        
        if result {
            
            initializeCustomCameraView()
            
        }
        
    }
    
    func requestPermission(permissionType : PermissionFLows) {
        
        CustomPermissionViewController.shared.delegate = self
        
        switch permissionType {
        case .photoLibrary:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self.mainView, permissionType: .photoLibrary)
        case .photoLibraryUnAuthorized:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self.mainView, permissionType: .photoLibraryUnAuthorized)
        case .camera:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self.mainView, permissionType: .camera)
        case .cameraUnathorized:
            CustomPermissionViewController.shared.createAuthorizationView(inputView: self.mainView, permissionType: .cameraUnathorized)
        default:
            return
        }
        
    }
    
}

extension CameraGalleryCollectionViewCell : UIGestureRecognizerDelegate {
    
    @objc func startPermissionFlow(_ sender : UITapGestureRecognizer) {
        
        PermissionHandler.shared.delegate = self
        PermissionHandler.shared.gotoRequestProcessViewControllers(inputPermissionType: .photoLibrary)
        
    }
    
}

