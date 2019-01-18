//
//  UserProfileViewGroupsCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileViewGroupsCell: BaseTableCell, ConfigurableCell {
    
    var viewModelItem: UserProfileViewModelItemGroups!
    
    private let padding: CGFloat = 10
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UserProfileViewGroupCollectionCell.self, forCellWithReuseIdentifier:
            UserProfileViewGroupCollectionCell.identifier)
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            collectionView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            collectionView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            collectionView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileViewModelItemGroups else { return }
        self.viewModelItem = viewModelItem
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
}

//extension UserProfileViewGroupsCell {
//    func setCollectionViewDataSourceDelegate<T: UICollectionViewDelegate & UICollectionViewDataSource>(dataSourceDelegate: T, forRow row: Int) {
//        collectionView.delegate = dataSourceDelegate
//        collectionView.dataSource = dataSourceDelegate
//        collectionView.tag = row
//        collectionView.reloadData()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
//}

extension UserProfileViewGroupsCell: UICollectionViewDelegateFlowLayout {
    /// item size height must be less then collection view height. So, -top inset and -bottom inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = Constants.Profile.GroupTableWidth - collectionView.layoutMargins.left - collectionView.layoutMargins.right
        let height = Constants.Profile.GroupTableHeight - collectionView.layoutMargins.top - collectionView.layoutMargins.bottom

        return CGSize(width: width, height: height)
    }
}

extension UserProfileViewGroupsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelItem.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModelItem.items[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewGroupCollectionCell.identifier, for: indexPath) as? UserProfileViewGroupCollectionCell {
            cell.configure(item: item)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
