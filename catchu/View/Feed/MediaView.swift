//
//  SwipingView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MediaView: UIView {
    
    var post: Post? {
        didSet {
            self.dataSource.populate(post: post)
//            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.dataSource.items.count
        }
    }
    
    private let dataSource = MediaViewModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        collectionView.register(MediaViewImageCell.self, forCellWithReuseIdentifier:
            MediaViewImageCell.identifier)
        collectionView.register(MediaViewVideoCell.self, forCellWithReuseIdentifier:
            MediaViewVideoCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = dataSource.items.count
        pc.currentPageIndicatorTintColor = UIColor.blue
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        pc.isEnabled = false
        return pc
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customization() {
        self.addSubview(collectionView)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
            ])
        
        // MARK: pagecontrol in a stack
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        self.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
}

extension MediaView: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / self.frame.width)
    }
}

extension MediaView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}



