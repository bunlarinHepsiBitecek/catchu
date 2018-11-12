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
    
    init(post: Post?) {
        guard let post = post else { return }
        guard let attachments = post.attachments else { return }

        for media in attachments {
            let mediaItem = MediaViewModelMediaItem(media: media)
            items.append(mediaItem)
        }
    }
    
    func populate(post: Post?) {
        guard let post = post else { return }
        guard let attachments = post.attachments else { return }
        
        items.removeAll()
        
        for media in attachments {
            let mediaItem = MediaViewModelMediaItem(media: media)
            items.append(mediaItem)
            
            print("media: \(mediaItem.type) url: \(mediaItem.media?.url)")
        }
    }
    
}

enum MediaViewModelItemType: String {
    case image
    case video
    case none
}

protocol MediaViewModelItem {
    var type: MediaViewModelItemType { get }
}

class MediaViewModelMediaItem: MediaViewModelItem {
    
    var type: MediaViewModelItemType {
        guard let media = self.media else { return .none }
        guard let mediaType = media.type else { return .none }
        
        switch mediaType {
        case MediaViewModelItemType.image.rawValue:
            return .image
        case MediaViewModelItemType.video.rawValue:
            return .video
        default:
            return .none
        }
    }
    
    var media: Media?
    
    init(media: Media?) {
        self.media = media
    }
    
    
}


extension MediaViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        print("collectionView: \(indexPath)")
        
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
        case .none:
            print("Media type cann't find type: \(item.type.rawValue)")
        }
        return UICollectionViewCell()
    }
    
}
