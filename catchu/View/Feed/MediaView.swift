//
//  SwipingView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MediaView: BaseView {
    
    var item: FeedViewModelItem? {
        didSet {
            self.configure()
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
    
    override func setupView() {
        //        self.addSubview(collectionView)
        
        //        let safeLayout = self.safeAreaLayoutGuide
        
        //        NSLayoutConstraint.activate([
        //            self.collectionView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
        //            self.collectionView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
        //            self.collectionView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
        //            self.collectionView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor)
        //            ])
        //
        //        // MARK: pagecontrol in a stack
        //        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl])
        //        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        //        bottomControlsStackView.distribution = .fillEqually
        //
        //        self.addSubview(bottomControlsStackView)
        //
        //        NSLayoutConstraint.activate([
        //            bottomControlsStackView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
        //            bottomControlsStackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
        //            bottomControlsStackView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
        //            ])
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [collectionView, pageControl])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fill
        bottomControlsStackView.alignment = .fill
        bottomControlsStackView.axis = .vertical
        
        self.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            pageControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            bottomControlsStackView.topAnchor.constraint(equalTo: safeTopAnchor),
            bottomControlsStackView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
        
    }
    
    func configure() {
        guard let item = item as? FeedViewModelPostItem, let post = item.post else { return }
        
        self.dataSource.populate(post: post)
        self.pageControl.numberOfPages = self.dataSource.items.count
        self.pageControl.currentPage = item.currentPage
        self.collectionView.reloadData()
        
        if self.dataSource.items.count > 0 {
            let indexPath = IndexPath(row: item.currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
}

extension MediaView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.frame.width)
        
        /// Store current scrolled page in referens Model
        if let item = self.item as? FeedViewModelPostItem {
            item.currentPage = pageControl.currentPage
        }
    }
    
}

extension MediaView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



