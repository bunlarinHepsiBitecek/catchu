//
//  OtherUserProfileViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

private let minimumSpacing: CGFloat = 1
private let itemPerLine: CGFloat = 3

class OtherUserProfileViewController: BaseCollectionViewController {
    
    // MARK: - Variables
    weak var headerView: OtherUserProfileViewHeader?
    weak var activityFooterView: CollectionFooterActivityView?
    var viewModel: OtherUserProfileViewModel!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupViewModel()
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserProfileViewPostCollectionCell.self, forCellWithReuseIdentifier: UserProfileViewPostCollectionCell.identifier)
        
        collectionView?.register(OtherUserProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OtherUserProfileViewHeader.identifier)
        collectionView?.register(CollectionFooterActivityView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFooterActivityView.identifier)
    }
    
    func setupViewModel() {
        viewModel.getUserInfo()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.headerState.bindAndFire { [unowned self] in
            self.headerView($0)
        }
        
        viewModel.state.bindAndFire { [unowned self] in
            self.setFooterView($0)
        }
        
        viewModel.changes.bind { [unowned self] in
            self.reloadableCollectionView($0)
        }
    }
    
    deinit {
        viewModel.headerState.unbind()
        viewModel.state.unbind()
        viewModel.changes.unbind()
    }
    
    private func headerView(_ state: TableViewState) {
        switch state {
        case .populate:
            headerViewDataUpdate()
        default:
            print("Headerview state erro occured")
        }
    }
    
    private func setFooterView(_ state: TableViewState) {
        switch state {
        case .suggest:
            startActivityIndicator()
        case .loading:
            startActivityIndicator()
        case .paging:
            startActivityIndicator()
        case .populate:
            stopActivityIndicator()
        case .empty:
            stopActivityIndicator()
        case .error:
            stopActivityIndicator()
        default:
            stopActivityIndicator()
        }
    }
    
    private func headerViewDataUpdate() {
        DispatchQueue.main.async {
            self.headerView?.configure(viewModelItem: self.viewModel.headerItem)
        }
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityFooterView?.startAnimating()
        }
    }
    
    private func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityFooterView?.stopAnimating()
        }
    }
    
    func reloadableCollectionView(_ cellChanges: CellChanges) {
        print("reloadableCollectionView itemCount: \(viewModel.items.count)")
        self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: cellChanges.inserts)
                self.collectionView?.deleteItems(at: cellChanges.deletes)
                self.collectionView?.reloadItems(at: cellChanges.reloads)
        }, completion: nil)
    }
}

extension OtherUserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sizeForItemAt: \(indexPath)")
        
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return CGSize(width: targetWidth, height: targetWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("referenceSizeForFooterInSection: \(viewModel.isMorePageExists)")
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return viewModel.isMorePageExists ? CGSize(width: targetWidth, height: targetWidth) : CGSize.zero
    }
}

extension OtherUserProfileViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection: \(viewModel.items.count)")
        return viewModel.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.items[indexPath.row]
        
        print("OtherUserProfileViewController cellForItemAt: \(indexPath)")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewPostCollectionCell.identifier, for: indexPath) as? UserProfileViewPostCollectionCell {
            cell.configure(viewModelItem: item)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelected: \(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("viewForSupplementaryElementOfKind kind: \(kind)")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OtherUserProfileViewHeader.identifier, for: indexPath) as! OtherUserProfileViewHeader

            headerView.configure(viewModelItem: viewModel.headerItem)
            self.headerView = headerView
            
            return headerView
        case UICollectionView.elementKindSectionFooter:
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
        if elementKind == UICollectionView.elementKindSectionFooter {
            viewModel.getUserPostsMore()
            viewModel.state.value = viewModel.state.value
        }
    }
}
