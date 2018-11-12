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
        view.backgroundColor = .blue
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
            barIndicatorView.heightAnchor.constraint(equalToConstant: 4),
            ])
    }
    
    func configure(_ items: [UIViewController]) {
        viewModel.items.removeAll()
        
        items.compactMap({$0}).forEach { (viewController) in
            let title = viewController.title ?? "No Title"
            viewModel.items.append(MenuTabViewModelTitleItem(title: title))
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
        
        print("lastContentOffsetX: \(lastContentOffsetX) - \(barIndicatorView.frame.midX)")
        barIndicatorViewLeadingConstraint.constant = lastContentOffsetX
        
        print("frame.width: \(frame.width)- multi: \(multiplier)")
        print("midx: \(barIndicatorView.frame.midX) - frameWidth: \(frame.width * multiplier) - currentIndex: \(currentIndex)")
        
        let selectIndex = Int(barIndicatorView.frame.midX / (frame.width * multiplier))
        
        print("selectIndex: \(selectIndex)")
        selectTabViewCell(index: selectIndex)
    }
    
    func selectTabViewCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension MenuTabView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = self.frame.width / CGFloat(viewModel.items.count)
        
        return CGSize(width: width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAction.value = indexPath.row
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
