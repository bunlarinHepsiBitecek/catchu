//
//  SwipingView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SwipingView: UIView {
    
    let dataSource: SwipingViewModel = {
        let share = Share()
        share.videoUrl = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        share.imageUrl = "https://s3.amazonaws.com/catchumobilebucket/16d6b807-6de2-4143-910d-11d011208292.jpg"
        return SwipingViewModel(share: share)
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.isPagingEnabled = true
        cv.dataSource = self.dataSource
//        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = dataSource.items.count
        pc.currentPageIndicatorTintColor = UIColor.blue
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customization()
    }
    
    func customization() {
        print("Customization Yapildi")
        
        collectionView.register(SwipingViewImageCell.self, forCellWithReuseIdentifier:
            SwipingViewImageCell.identifier)
        collectionView.register(SwipingViewVideoCell.self, forCellWithReuseIdentifier:
            SwipingViewVideoCell.identifier)
        
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let x = targetContentOffset.pointee.x

        pageControl.currentPage = Int(x / self.frame.width)
    }
}

extension SwipingView: UICollectionViewDelegate {
    
}

extension SwipingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}



