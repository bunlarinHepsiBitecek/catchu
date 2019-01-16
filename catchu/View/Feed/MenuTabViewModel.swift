//
//  MenuTabViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

protocol MenuTabViewModelItem {
    var icon: UIImage? {get set}
    var title: String {get set}
}

class MenuTabViewModelTitleItem: MenuTabViewModelItem {
    var icon: UIImage?
    var title: String
    
    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
}

class MenuTabViewModel: BaseViewModel {
    let sectionCount = 1
    var items = [MenuTabViewModelItem]()
    
    override func setup() {
        super.setup()
    }
    
}

extension MenuTabViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView itemCount: \(items.count) indexPath: \(indexPath)")
        let item = items[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuTabViewCell.identifier, for: indexPath) as? MenuTabViewCell {
            cell.configure(item: item)
            return cell
        }
        return UICollectionViewCell()
    }
}
