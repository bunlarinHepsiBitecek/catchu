//
//  ContentViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class MediaViewModel: NSObject {
    var items = [MediaViewModelItem]()
    
    override init() {
        super.init()
    }
    
    init(share: Share) {
        if let videoUrl = share.videoUrl {
            let videoItem = MediaViewModelVideoItem(videoUrl: videoUrl)
            items.append(videoItem)
        }
        
        if let imageUrl = share.imageUrl {
            let imageItem = MediaViewModelImageItem(imageUrl: imageUrl)
            items.append(imageItem)
        }
    }
}

enum MediaViewModelItemType {
    case image
    case video
}

protocol MediaViewModelItem {
    var type: MediaViewModelItemType { get }
}

class MediaViewModelImageItem: MediaViewModelItem {
    
    var type: MediaViewModelItemType {
        return .image
    }
    var imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
}

class MediaViewModelVideoItem: MediaViewModelItem {
    
    var type: MediaViewModelItemType {
        return .video
    }
    var videoUrl: String
    
    init(videoUrl: String) {
        self.videoUrl = videoUrl
    }
    
}


extension MediaViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .image:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaViewImageCell.identifier, for: indexPath) as? MediaViewImageCell {
                cell.item = item
                return cell
            }
        case .video:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaViewVideoCell.identifier, for: indexPath) as? MediaViewVideoCell {
                cell.item = item
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
}
