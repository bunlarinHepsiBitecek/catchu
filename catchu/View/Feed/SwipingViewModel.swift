//
//  SwipingViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/29/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

enum SwipingViewModelItemType {
    case image
    case video
}

protocol SwipingViewModelItem {
    var type: SwipingViewModelItemType { get }
}


class SwipingViewModel: NSObject {
    var items = [SwipingViewModelItem]()
    
    
    
    override init() {
        super.init()
    }
    
    init(share: Share) {
        if let videoUrl = share.videoUrl {
            let videoItem = SwipingViewModelVideoItem(videoUrl: videoUrl)
            items.append(videoItem)
        }
        
        if let imageUrl = share.imageUrl {
            let imageItem = SwipingViewModelImageItem(imageUrl: imageUrl)
            items.append(imageItem)
        }
    }
}

extension SwipingViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipingViewImageCell.identifier, for: indexPath) as? SwipingViewImageCell {
                cell.item = item
                return cell
            }
        case .video:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipingViewVideoCell.identifier, for: indexPath) as? SwipingViewVideoCell {
                cell.item = item
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
}


class SwipingViewModelImageItem: SwipingViewModelItem {
    
    var type: SwipingViewModelItemType {
        return .image
    }
    var imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
}

class SwipingViewModelVideoItem: SwipingViewModelItem {
    
    var type: SwipingViewModelItemType {
        return .video
    }
    var videoUrl: String
    
    init(videoUrl: String) {
        self.videoUrl = videoUrl
    }
    
}
