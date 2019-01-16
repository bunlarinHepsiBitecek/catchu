//
//  OtherUserProfileViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

private let reuseIdentifier = "Cell"
private let minimumSpacing: CGFloat = 1
private let itemPerLine: CGFloat = 3

class OtherUserProfileViewController: BaseCollectionViewController {
    
    // MARK: - Variables
    private var headerView: OtherUserProfileViewHeader!
    weak var activityFooterView: CollectionFooterActivityView?
    var viewModel: OtherUserProfileViewModel!
    
    // MARK: - View
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1).cgColor]
        gradient.frame = self.view.bounds
        return gradient
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
    }
    
    private func setupCollectionView() {
        headerView = OtherUserProfileViewHeader(frame: self.view.frame)
        
        let tempView = UIView()
        tempView.layer.insertSublayer(gradientLayer, at: 0)
        collectionView?.backgroundView = tempView
        collectionView?.backgroundColor = .clear
        
//        view.backgroundColor = .white
        
        collectionView?.register(UserProfileViewPostCollectionCell.self, forCellWithReuseIdentifier: UserProfileViewPostCollectionCell.identifier)
        
        collectionView?.register(OtherUserProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: OtherUserProfileViewHeader.identifier)
        collectionView?.register(CollectionFooterActivityView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionFooterActivityView.identifier)
    }
    
    func setupViewModel() {
        viewModel.getUserInfo()
        viewModel.getUserPosts()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state.bindAndFire { [unowned self] in
            self.setFooterView($0)
        }
        
        viewModel.changes.bind { [unowned self] in
            self.reloadableCollectionView($0)
        }
    }
    
    func setFooterView(_ state: TableViewState) {
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
        
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        return CGSize(width: targetWidth, height: targetWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("referenceSizeForHeaderInSection: \(headerView.systemLayoutSizeFitting(UILayoutFittingExpandedSize))")
        return headerView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
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
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OtherUserProfileViewHeader.identifier, for: indexPath) as! OtherUserProfileViewHeader

            headerView.configure(viewModel.userHeaderItem)
            self.headerView = headerView
            
            return headerView
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
            viewModel.state.value = viewModel.state.value
        }
    }
}
