//
//  DenemeCollectionViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

private let reuseIdentifier = "Cell"
private let minimumSpacing: CGFloat = 1
private let itemPerLine: CGFloat = 3

class DenemeCollectionViewController: BaseCollectionViewController {
    
    weak var activityFooterView: CollectionFooterActivityView?
    
    let viewModel = DenemeViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DenemeCollection size: \(view.frame) contentsize: \(collectionView?.contentSize)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.register(CollectionFooterActivityView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionFooterActivityView.identifier)
    }
}

//extension DenemeCollectionViewController {
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let total = scrollView.contentOffset.y + scrollView.frame.size.height
//        print("scrollViewContentOfset: \(scrollView.contentOffset.y) + height: \(scrollView.frame.size.height) - total: \(total) - contentSize: \(scrollView.contentSize.height)")
//        
//    }
//}

extension DenemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return CGSize(width: targetWidth, height: targetWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("referenceSizeForFooterInSection: \(viewModel.isMoreDataExists)")
        if !viewModel.isMoreDataExists {
            return CGSize.zero
        }
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return CGSize(width: targetWidth, height: targetWidth)
    }
}

extension DenemeCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("DenemeCollection cellForItemAt: \(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("viewForSupplementaryElementOfKind")
        switch kind {
        case UICollectionElementKindSectionFooter:
            let activityView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFooterActivityView.identifier, for: indexPath) as! CollectionFooterActivityView
            self.activityFooterView = activityView
            
            return activityView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        print("willDisplaySupplementaryView: \(elementKind) - \(indexPath)")
        if viewModel.isMoreDataExists {
            loadMoreData()
            activityFooterView?.startAnimating()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        print("didEndDisplayingSupplementaryView: \(elementKind) - \(indexPath)")
        if !viewModel.isMoreDataExists {
            activityFooterView?.stopAnimating()
        }
    }
    
    func loadMoreData() {
        if !viewModel.isMoreDataExists {
            return
        }
        activityFooterView?.startAnimating()
        let insertIndexPath = viewModel.loadMore()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
            self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: insertIndexPath)
            }, completion: nil)
            
        })
    }
}



class DenemeViewModel: BaseViewModel, ViewModel {
    var items: [[String]] = [[]]
    var isMoreDataExists = true
    
    override func setup() {
        super.setup()
        
        for index in 0...20 {
            items[0].append("\(index)")
        }
    }
    
    func loadMore() -> [IndexPath] {
        var indexPath = [IndexPath]()
        for index in items[0].count...items[0].count + 20 {
            items[0].append("\(index)")
            indexPath.append(IndexPath(item: index, section: 0))
        }
        isMoreDataExists = items[0].count < 63
        return indexPath
    }
    
}
