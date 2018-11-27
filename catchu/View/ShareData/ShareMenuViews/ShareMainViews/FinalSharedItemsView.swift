//
//  FinalSharedItemsView.swift
//  catchu
//
//  Created by Erkut Baş on 10/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FinalSharedItemsView: UIView {
    
    private var imageArrayCount = 0
    private var videoArrayCount = 0
    
    private var imageArrayExists : Bool = false
    private var videoArrayExists : Bool = false
    
    private var pageControlAdded : Bool = false
    
    lazy var itemCollectionView: UICollectionView = {
        
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
        collectionView.layer.cornerRadius = 10
        
        collectionView.register(FinalSelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.selectedItemImageCell)
        collectionView.register(FinalSelectedVideoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.selectedItemVideoCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
        
    }()
    
    lazy var pageControlContainerView: UIView = {
        
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7)
        temp.layer.cornerRadius = 10
        
        return temp
        
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let temp = UIPageControl()
        temp.currentPageIndicatorTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        temp.pageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        temp.numberOfPages = 3
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = false
//        temp.addTarget(self, action: #selector(FinalSharedItemsView.changePageControlTrigger(_:)), for: .valueChanged)
        
        return temp
        
    }()
    
    lazy var informationLabel: UILabel = {
        
        let temp = UILabel()
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.text = LocalizedConstants.PostAttachmentInformation.thereIsNothingToPost
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.textAlignment = .center
        temp.alpha = 1
        
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        return temp
        
    }()
    
    lazy var itemCountContainerView: UIView = {
       
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.75)
        temp.layer.cornerRadius = 15
        
        return temp
        
    }()
    
    lazy var selectedItemNumber: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = false
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont.systemFont(ofSize: 12)
        temp.textAlignment = .right
//        temp.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        return temp
    }()
    
    lazy var totalItemNumber: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = false
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont.systemFont(ofSize: 12)
//        temp.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return temp
    }()
    
    lazy var itemNumberSeperator: UILabel = {
        
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = false
        temp.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.text = "/"
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        checkDataCount()
        
        print("FinalSharedItemsView starts")
        print("video COUNT : \(PostItems.shared.selectedVideoUrl?.count)")
        print("image COUNT : \(PostItems.shared.selectedImageArray?.count)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if !pageControlAdded {
//            setPageControllerContainerHeight()
//        }
//    }
    
}

// MARK: - major functions
extension FinalSharedItemsView {
    
    func setupViews() {
        
        addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(itemCollectionView)
        self.addSubview(informationLabel)
        self.addSubview(pageControlContainerView)
        self.itemCollectionView.addSubview(itemCountContainerView)
        self.pageControlContainerView.addSubview(pageControl)
        
        // itemContainer management
        self.itemCountContainerView.addSubview(selectedItemNumber)
        self.itemCountContainerView.addSubview(itemNumberSeperator)
        self.itemCountContainerView.addSubview(totalItemNumber)
        
        let safe = self.safeAreaLayoutGuide
        let safeCollectionView = self.itemCollectionView.safeAreaLayoutGuide
        let safePageControllerContainerView = self.pageControlContainerView.safeAreaLayoutGuide
        let safePageController = self.pageControl.safeAreaLayoutGuide
        let safeItemCountContainer = self.itemCountContainerView.safeAreaLayoutGuide
        let safeItemSeperator = self.itemNumberSeperator.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            itemCollectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            itemCollectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            informationLabel.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            informationLabel.heightAnchor.constraint(equalToConstant: 50),
            informationLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            pageControlContainerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            pageControlContainerView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -5),
            pageControlContainerView.heightAnchor.constraint(equalToConstant: 20),
            pageControlContainerView.widthAnchor.constraint(equalTo: safePageController.widthAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: safePageControllerContainerView.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: safePageControllerContainerView.centerYAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.widthAnchor.constraint(equalToConstant: 50),
            
            itemCountContainerView.trailingAnchor.constraint(equalTo: safeCollectionView.trailingAnchor, constant: -5),
            itemCountContainerView.topAnchor.constraint(equalTo: safeCollectionView.topAnchor, constant: 5),
            itemCountContainerView.heightAnchor.constraint(equalToConstant: 30),
            itemCountContainerView.widthAnchor.constraint(equalToConstant: 50),
            
            itemNumberSeperator.centerYAnchor.constraint(equalTo: safeItemCountContainer.centerYAnchor),
            itemNumberSeperator.centerXAnchor.constraint(equalTo: safeItemCountContainer.centerXAnchor),
            itemNumberSeperator.heightAnchor.constraint(equalToConstant: 20),
            itemNumberSeperator.widthAnchor.constraint(equalToConstant: 5),
            
            selectedItemNumber.trailingAnchor.constraint(equalTo: safeItemSeperator.leadingAnchor, constant: -2),
            selectedItemNumber.centerYAnchor.constraint(equalTo: safeItemSeperator.centerYAnchor),
            selectedItemNumber.heightAnchor.constraint(equalToConstant: 20),
            selectedItemNumber.widthAnchor.constraint(equalToConstant: 10),
            
            totalItemNumber.leadingAnchor.constraint(equalTo: safeItemSeperator.trailingAnchor, constant: 2),
            totalItemNumber.centerYAnchor.constraint(equalTo: safeItemSeperator.centerYAnchor),
            totalItemNumber.heightAnchor.constraint(equalToConstant: 20),
            totalItemNumber.widthAnchor.constraint(equalToConstant: 10),
            
            ])
        
    }
    
    /// return array counts based on section information
    ///
    /// - Parameter section: section of collectionView
    /// - Returns: total array item count
    func returnTotalItemCount(section : Int) -> Int {
        print("returnTotalItemCount starts")
        var totalCount = 0
        
        if section == 0 {
            
            if imageArrayExists {
                if let imagesArray = PostItems.shared.selectedImageArray {
                    totalCount += imagesArray.count
                    imageArrayCount = imagesArray.count
                }
                
            } else if videoArrayExists {
                if let videoArray = PostItems.shared.selectedVideoUrl {
                    totalCount += videoArray.count
                    videoArrayCount = videoArray.count
                }
            }
            
        } else if section == 1 {
            
            if let videoArray = PostItems.shared.selectedVideoUrl {
                totalCount += videoArray.count
                videoArrayCount = videoArray.count
            }
            
        }
        
        print("totalCount : \(totalCount)")
        
        return totalCount
    }
    
    /// return number of sections
    ///
    /// - Returns: section number
    func returnSectionCount() -> Int {
        print("returnSectionCount starts")
        var totalCount = 0
        
        if let imagesArray = PostItems.shared.selectedImageArray {
            if imagesArray.count > 0 {
                totalCount += 1
                imageArrayExists = true
            }
        }
        
        if let videoArray = PostItems.shared.selectedVideoUrl {
            if videoArray.count > 0 {
                totalCount += 1
                videoArrayExists = true
            }
        }
        
        print("totalCount : \(totalCount)")
        
        return totalCount
        
    }
    
    func checkDataCount() {
        
        if PostItems.shared.selectedImageArray != nil {
            if PostItems.shared.selectedImageArray!.count > 0 {
                activateInformationLabel(active: false)
            }
        }
        
        if PostItems.shared.selectedVideoUrl != nil {
            if PostItems.shared.selectedVideoUrl!.count > 0 {
                activateInformationLabel(active: false)
            }
        }
        
        pageControl.numberOfPages = totalNumberOfItemsInPostItems()
        setTotalItemCount(count: totalNumberOfItemsInPostItems())
        
        if totalNumberOfItemsInPostItems() > 0 {
            selectedItemNumber.text = "\(1)"
        }
        
    }
    
    func activateInformationLabel(active : Bool) {
        
        if active {
            informationLabel.alpha = 1
        } else {
            informationLabel.alpha = 0
        }
        
    }
    
    func totalNumberOfItemsInPostItems() -> Int {
        
        return PostItems.shared.returnTotalPostItems()
        
    }
    
    func setItemCounts(index : Int) {
        
        selectedItemNumber.text = "\(index)"
        
    }
    
    func setTotalItemCount(count : Int) {
        
        totalItemNumber.text = "\(count)"
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FinalSharedItemsView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return returnSectionCount()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnTotalItemCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            if imageArrayExists {
                guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.selectedItemImageCell, for: indexPath) as? FinalSelectedImageCollectionViewCell else { return UICollectionViewCell() }
                
                cell.setupCellSettings(image: PostItems.shared.returnImage(index: indexPath.row))
                
                return cell
                
            } else if videoArrayExists {
                guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.selectedItemVideoCell, for: indexPath) as? FinalSelectedVideoCollectionViewCell else { return UICollectionViewCell() }
                
                cell.setupCellSettings(url: PostItems.shared.returnVideoUrl(index: indexPath.row))
                
                return cell
                
            } else {
                return UICollectionViewCell()
            }
            
        } else if indexPath.section == 1 {
            
            guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.selectedItemVideoCell, for: indexPath) as? FinalSelectedVideoCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setupCellSettings(url: PostItems.shared.returnVideoUrl(index: indexPath.row))
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width, height: self.frame.height)
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension FinalSharedItemsView : UIScrollViewDelegate {
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        let index = scrollView.contentOffset.x / self.itemCollectionView.frame.width
//        
//        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
//            self.pageControl.currentPage = Int(index)
//        }
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / self.itemCollectionView.frame.width
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            self.pageControl.currentPage = Int(index)
            self.setItemCounts(index: Int(index) + 1)
            
        }
        
    }
    
}

