//
//  ColorPaletteView.swift
//  catchu
//
//  Created by Erkut Baş on 9/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {

    private let colorArray1 = [ #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.462745098, green: 0.8392156863, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) ]
    private let colorArray2 = [ #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1) ]
    private let colorArray3 = [ #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1) ]
    
    weak var delegate : ShareDataProtocols!
    
    lazy var containerView: UIView = {
    
        let temp = UIView()
        temp.layer.cornerRadius = 7
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = UIColor.clear
        
        return temp
    }()
    
    lazy var selectedColorImageContainer: UIView = {
        
        let temp = UIView()
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.layer.cornerRadius = 18
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
        
    }()
    
    lazy var selectedColorImage: UIImageView = {
        
        let temp = UIImageView()
        temp.image = UIImage(named: "pipette-3")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.contentMode = .center
        temp.layer.cornerRadius = 17
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let temp = UIPageControl()
        temp.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        temp.numberOfPages = 3
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var collectionViewColorPallette: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.01
        layout.sectionInset.left = 40
        layout.minimumLineSpacing = 40
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(ColorPaletteCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.colorPaletteCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupMajorViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ColorPaletteView {
    
    func setupMajorViews() {
        
        self.addSubview(containerView)
        self.containerView.addSubview(selectedColorImageContainer)
        self.selectedColorImageContainer.addSubview(selectedColorImage)
        self.containerView.addSubview(pageControl)
        self.containerView.addSubview(collectionViewColorPallette)
        
        self.containerView.bringSubviewToFront(selectedColorImageContainer)
        
        let safe = self.safeAreaLayoutGuide
        let safeContainerView = self.containerView.safeAreaLayoutGuide
        let safeSelectedColorContainer = self.selectedColorImageContainer.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            selectedColorImageContainer.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor, constant : 5),
            selectedColorImageContainer.bottomAnchor.constraint(equalTo: safeContainerView.bottomAnchor, constant: -7),
            selectedColorImageContainer.heightAnchor.constraint(equalToConstant: 36),
            selectedColorImageContainer.widthAnchor.constraint(equalToConstant: 36),
            
            selectedColorImage.centerXAnchor.constraint(equalTo: safeSelectedColorContainer.centerXAnchor),
            selectedColorImage.centerYAnchor.constraint(equalTo: safeSelectedColorContainer.centerYAnchor),
            selectedColorImage.heightAnchor.constraint(equalToConstant: 34),
            selectedColorImage.widthAnchor.constraint(equalToConstant: 34),
            
            collectionViewColorPallette.leadingAnchor.constraint(equalTo: safeContainerView.leadingAnchor, constant: 5),
            collectionViewColorPallette.topAnchor.constraint(equalTo: safeContainerView.topAnchor, constant: 10),
            collectionViewColorPallette.trailingAnchor.constraint(equalTo: safeContainerView.trailingAnchor, constant: -5),
            collectionViewColorPallette.heightAnchor.constraint(equalToConstant: 30),
            
            pageControl.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10),
            pageControl.widthAnchor.constraint(equalToConstant: 60)
            
            ])
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ColorPaletteView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionViewColorPallette.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.colorPaletteCell, for: indexPath) as? ColorPaletteCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupCell(inputColorArray: returnActiveArray(indexPath: indexPath), delegate: self)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("collectionViewColorPallette.frame.width : \(collectionViewColorPallette.frame.width)")
        print("collectionView.frame.width : \(collectionView.frame.width)")
        
        return CGSize(width: collectionViewColorPallette.frame.width - 40, height: Constants.colorPaletteCellSize.colorPaletteContainerCellHeigth)
        
    }
    
    func returnActiveArray(indexPath : IndexPath) -> Array<UIColor> {
        
        if indexPath.row == 0 {
            return colorArray1
        } else if indexPath.row == 1 {
            return colorArray2
        } else if indexPath.row == 2 {
            return colorArray3
        } else {
            return colorArray1
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension ColorPaletteView : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("targetContentOffset : \(targetContentOffset.pointee.x)")
        
        pageControl.currentPage = Int(targetContentOffset.pointee.x / collectionViewColorPallette.frame.width)
        
    }
    
}

extension ColorPaletteView : ShareDataProtocols {
    
    func updateSelectedColorFromPalette(inputView : UIView) {
        
        guard let inputViewBackgroundColor = inputView.backgroundColor else { return }
        
        selectedColorImage.backgroundColor = inputViewBackgroundColor
        
        if inputViewBackgroundColor.isEqual(UIColor.white) {
            selectedColorImage.tintColor = UIColor.black
        } else if inputViewBackgroundColor.isEqual(UIColor.black) {
            selectedColorImage.tintColor = UIColor.white
        }
        
        guard delegate != nil else {
            return
        }
        
        delegate.updateSelectedColorFromPalette(inputView: inputView)
        
    }
    
}



