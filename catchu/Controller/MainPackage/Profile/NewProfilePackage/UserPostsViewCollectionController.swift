//
//  UserPostsViewCollectionController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 1/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

class UserPostsViewCollectionController: BaseCollectionViewController {
    
    // MARK: - Variables
    var viewModel: UserPostsViewModel!
    private let minimumSpacing: CGFloat = 1
    private let itemPerLine: CGFloat = 3
    
    // MARK: - Views
    weak var activityFooterView: CollectionFooterActivityView?
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        setupCollectionView()
        setupViewModel()
    }
    
    private func setupCollectionView() {
        view.backgroundColor = UIColor.white
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(UserProfileViewPostCollectionCell.self, forCellWithReuseIdentifier: UserProfileViewPostCollectionCell.identifier)
        
        collectionView?.register(CollectionFooterActivityView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionFooterActivityView.identifier)
    }
 
    private func setupViewModel() {
        viewModel.getUserPosts()
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
        
        viewModel.changes.bind { [unowned self] in
            self.reloadCollectionView($0)
        }
    }
    
    private func stateAnimate(_ state: TableViewState) {
        switch state {
        case .suggest:
            activityFooterView?.startAnimating()
        case .loading:
            activityFooterView?.startAnimating()
        case .paging:
            activityFooterView?.startAnimating()
        case .populate:
            activityFooterView?.stopAnimating()
        case .empty:
            activityFooterView?.stopAnimating()
        case .error:
            activityFooterView?.stopAnimating()
        default:
            activityFooterView?.stopAnimating()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func reloadCollectionView(_ changes: CellChanges) {
        print("reloadableCollectionView itemCount: \(viewModel.items.count)")
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: changes.inserts)
            self.collectionView?.deleteItems(at: changes.deletes)
            self.collectionView?.reloadItems(at: changes.reloads)
        }, completion: nil)
    }
}

extension UserPostsViewCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return CGSize(width: targetWidth, height: targetWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("referenceSizeForFooterInSection: \(viewModel.state.value)")
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return viewModel.state.value  == .paging ? CGSize(width: targetWidth, height: targetWidth) : CGSize.zero
    }
}

extension UserPostsViewCollectionController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.items[indexPath.row]
        print("UserPostsViewCollectionController cellForItemAt: \(indexPath)")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewPostCollectionCell.identifier, for: indexPath) as? UserProfileViewPostCollectionCell {
            cell.configure(viewModelItem: item)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItem: \(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("viewForSupplementaryElementOfKind kind: \(kind)")
        switch kind {
        case UICollectionElementKindSectionFooter:
            let activityFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFooterActivityView.identifier, for: indexPath) as! CollectionFooterActivityView
            self.activityFooterView = activityFooterView
            
            return activityFooterView
        default:
            print("Error Case At \(#function)-\(String(describing: self))")
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        print("willDisplaySupplementaryView: \(elementKind) - \(indexPath)")
        if elementKind == UICollectionElementKindSectionFooter {
            viewModel.getUserPostsMore()
        }
    }
    
}
