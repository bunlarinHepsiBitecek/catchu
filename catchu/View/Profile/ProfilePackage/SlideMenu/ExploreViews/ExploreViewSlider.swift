//
//  ExploreViewSlider.swift
//  catchu
//
//  Created by Erkut Baş on 11/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreViewSlider: UIView {
    
    private var cellTitle : [String] = [LocalizedConstants.SlideMenu.facebook, LocalizedConstants.SlideMenu.contacts]
    
    private var stickLeadingConstraint = NSLayoutConstraint()
    private var stickWidthConstraint = NSLayoutConstraint()
    
    lazy var collectionViewSlider: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.minimumLineSpacing_Zero
        layout.minimumInteritemSpacing = Constants.Cell.minimumLineSpacing_Zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        collectionView.register(ExploreChoiseCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.exploreChoiseCollectionViewCell)
        
        return collectionView

    }()
    
    lazy var stickView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViews()
        
        print("1 self.frame.height :\(self.frame.height)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension ExploreViewSlider {
    
    func initializeViews() {
        
        addViews()
        didSelectFirstCellForInitial()
        
    }
    
    func addViews() {
        
        print("addViews starts")
        print("self.frame : \(self.frame)")
        
        self.addSubview(collectionViewSlider)
        self.addSubview(stickView)
        
        let safe = self.safeAreaLayoutGuide
        
        stickLeadingConstraint = stickView.leadingAnchor.constraint(equalTo: safe.leadingAnchor)
        
        NSLayoutConstraint.activate([
            
            collectionViewSlider.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionViewSlider.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionViewSlider.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionViewSlider.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40),
            
            stickLeadingConstraint,
            stickView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            stickView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_2),
            stickView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 2),
            
            ])
        
    }
    
    func didSelectFirstCellForInitial() {
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        collectionViewSlider.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
    func animateStick(constant : CGFloat) {
        
        stickLeadingConstraint.constant = constant / 2
        
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ExploreViewSlider : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellTitle.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionViewSlider.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.exploreChoiseCollectionViewCell, for: indexPath) as? ExploreChoiseCollectionViewCell else { return UICollectionViewCell() }
        
        cell.choiseLabel.text = cellTitle[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("2 self.frame.height :\(self.frame.width)")
        
        let width = self.frame.width / CGFloat(cellTitle.count)
        return CGSize(width: width, height: Constants.StaticViewSize.ViewSize.Height.height_40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //let cell = collectionViewSlider.cellForItem(at: indexPath)
    }
    
}

// MARK: - SlideMenuProtocols
extension ExploreViewSlider : SlideMenuProtocols {
    
    func scrollStick(inputConstant: CGFloat) {
        
        animateStick(constant: inputConstant)
        
    }
    
}
