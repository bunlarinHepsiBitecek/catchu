//
//  ShareView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Photos

class ShareView: UIView {
    
    //MARK: outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: variable
    public var masterMapShareView: MapShareView!
    public var photos = [PHAsset]()
    public var cameraImagePicked = UIImageView()
    private var selectedCell = IndexPath()
    
    //MARK: View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    private func customization() {
        self.textField.delegate = self
    }
    
    private func accessPhotos() {
        MediaLibraryManager.shared.loadPhotos { (assets) in
            
            if assets.count > 0 {
                self.photos = assets
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            }        }
    }
    
    // MARK: selected first image
    private func selectDefaultImage(){
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    @IBAction func photosButtonClicked(_ sender: UIButton) {
        self.accessPhotos()
        
        // MARK: close keyboard
        self.textField.resignFirstResponder()
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        self.openCamera()
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.masterMapShareView.showHideShareView()
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        self.populateShareViewData()
    }
    
    
}

// MARK: Keyboard Setting
extension ShareView: UITextFieldDelegate {
    // to close keyboard when touches somewhere else but keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // to close keyboard when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ShareView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: ShareCollectionViewCell = collectionView.cellForItem(at: indexPath) as! ShareCollectionViewCell
        
        if selectedCell == indexPath {
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedCell = IndexPath()
        } else {
            selectedCell = indexPath
            cell.getOriginalImageFromLibrary(asset: self.photos[indexPath.item])
        }
    }
    
}

extension ShareView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShareCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.ShareCollectionViewCell, for: indexPath) as! ShareCollectionViewCell
        cell.populateDataWith(asset: self.photos[indexPath.item])
        
        return cell
    }
}

extension ShareView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // MARK: decreace item size up to space
        let itemSize = collectionView.contentSize.width / Constants.Cell.ShareCollectionViewItemPerLine - Constants.Cell.ShareCollectionViewItemSpace
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Cell.ShareCollectionViewItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Cell.ShareCollectionViewItemSpace
    }
}

// MARK: Camera
extension ShareView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            LoaderController.shared.currentViewController().present(imagePicker, animated: true, completion: nil)
        } else {
            AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Library.CameraNotAvaliableTitle, message: LocalizedConstants.Library.CameraNotAvaliable, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        cameraImagePicked.image = nil
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            cameraImagePicked.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraImagePicked.image = originalImage
        }
        
        if let image = cameraImagePicked.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.accessPhotos()
        }
        
        LoaderController.shared.currentViewController().dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        LoaderController.shared.currentViewController().dismiss(animated: true, completion: nil)
    }
}

// MARK:
extension ShareView {
    
    func populateShareViewData_Old() {
        if (self.textField.text?.isEmpty)! && self.selectedCell.count == 0 {
            AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Share.MissingData, message: LocalizedConstants.Share.NoShareData, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
            return
        }
        
//        Share.shared.text = self.textField.text ?? Constants.CharacterConstants.SPACE
//        Share.shared.location = LocationManager.shared.currentLocation
//        //        Share.shared.shareId = UUID().uuidString
//
//        if selectedCell.count > 0 {
//            let cell: ShareCollectionViewCell = collectionView.cellForItem(at: selectedCell) as! ShareCollectionViewCell
//
//            // MARK: for Small Image
//            Share.shared.imageSmall = cell.originalImageSmall
//
//        } else {
//            self.insertFirebase()
//        }
    }
    
    func insertFirebase() {
        User.shared.createSortedUserArray() // for selectedFriends
        let selectedFriends = User.shared.sortedFriendArray
    }
    
    
    
    func populateShareViewData() {
        if (self.textField.text?.isEmpty)! && self.selectedCell.count == 0 {
            AlertViewManager.shared.createAlert_2(title: LocalizedConstants.Share.MissingData, message: LocalizedConstants.Share.NoShareData, preferredStyle: .alert, actionTitle: LocalizedConstants.Location.Ok, actionStyle: .default, selfDismiss: true, seconds: 3, completionHandler: nil)
            return
        }
        
//        Share.shared.imageUrl = Constants.CharacterConstants.SPACE
//        Share.shared.text = self.textField.text ?? Constants.CharacterConstants.SPACE
//        Share.shared.location = LocationManager.shared.currentLocation
//        
//        var imageExist = false
//        if selectedCell.count > 0 {
//            let cell: ShareCollectionViewCell = collectionView.cellForItem(at: selectedCell) as! ShareCollectionViewCell
//            
//            Share.shared.image = cell.originalImage
//            imageExist = true
//        }
//        
        // TODO: change
//        REAWSManager.shared.shareData(imageExist: imageExist)
        
    }
}
