//
//  MenuTabView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class MenuTabView: BaseView {
    
    public private(set) var viewModel = MenuTabViewModel()
    
    var selectAction = Dynamic(0)
    var barIndicatorViewLeadingConstraint: NSLayoutConstraint!
    var barIndicatorViewWidthConstraint: NSLayoutConstraint!
    
    let barIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = viewModel
        collectionView.delegate = self
        
        collectionView.register(MenuTabViewCell.self, forCellWithReuseIdentifier: MenuTabViewCell.identifier)
        
        return collectionView
    }()
    
    private var multiplier: CGFloat {
        let count = CGFloat(viewModel.items.count)
        return count == 0 ? 1 : 1 / count
    }
    
    override func setupView() {
        super.setupView()
        
        barIndicatorViewLeadingConstraint = barIndicatorView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor)
        barIndicatorViewWidthConstraint = barIndicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier)
        
        self.addSubview(barIndicatorView)
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            collectionView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            collectionView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            collectionView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            
            barIndicatorView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            barIndicatorViewLeadingConstraint!,
            barIndicatorViewWidthConstraint!,
            barIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    
    func configure(_ items: [(viewController: UIViewController, title: String, icon: UIImage?)]) {
        viewModel.items.removeAll()
        
        items.compactMap {$0}.forEach { (_, title, icon) in
            viewModel.items.append(MenuTabViewModelTitleItem(title: title, icon: icon))
        }
        
        /// when need update constraint multiplier then deactive, change and activate again
        barIndicatorViewWidthConstraint.isActive = false
        barIndicatorViewWidthConstraint = barIndicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier)
        
        barIndicatorViewWidthConstraint.isActive = true
    }
    
    func scrollBarIndicator(contentOffsetX: CGFloat, currentIndex: Int) {
        var lastContentOffsetX = contentOffsetX * multiplier
        
        if lastContentOffsetX > frame.width {
            lastContentOffsetX = frame.width
        }
        
        let maxIndex = viewModel.items.count - 1
        let minIndex = 0
        
        barIndicatorViewLeadingConstraint.constant = lastContentOffsetX
        
//        print("midx: \(barIndicatorView.frame.midX) - frameWidth: \(frame.width * multiplier) - currentIndex: \(currentIndex)")
        
        var selectIndex = Int(barIndicatorView.frame.midX / (frame.width * multiplier))
        
        if selectIndex > maxIndex {
            selectIndex = maxIndex
        }
        
        if selectIndex < minIndex {
            selectIndex = minIndex
        }
        
        selectTabViewCollectionCell(selectIndex)
    }
    
    func selectTabViewCollectionCell(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension MenuTabView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = self.frame.width / CGFloat(viewModel.items.count)
        
        return CGSize(width: width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectAction.value != indexPath.row {
            collectionView.deselectItem(at: indexPath, animated: false)
            selectAction.value = indexPath.row
        }
    }
    
}

extension MenuTabView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
