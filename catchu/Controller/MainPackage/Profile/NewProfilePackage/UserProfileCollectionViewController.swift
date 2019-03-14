//
//  UserProfileCollectionViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIdentifierHeader = "CellHeader"
private let reuseIdentifierFooter = "ActivityFooter"

private let itemPerLine: CGFloat = 3
private let minimumSpacing: CGFloat = 1

private var numberOfItems: Int = 25

class UserProfileCollectionViewController: UICollectionViewController {
    
    lazy var activityIndicatorView: UIView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20),
            activityIndicatorView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 20),
            ])
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        collectionView!.backgroundColor = .white
        
        setupCollectionView()
    }
    
    func setupCollectionView() {

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(UserProfileViewInfoCell.self, forCellWithReuseIdentifier: UserProfileViewInfoCell.identifier)
        self.collectionView!.register(ActivityIndicatorFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifierFooter)
        
        self.collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
        
        collectionView?.register(UserProfileViewPostCollectionCell.self, forCellWithReuseIdentifier: UserProfileViewPostCollectionCell.identifier)
        
        collectionView!.refreshControl = UIRefreshControl()
        collectionView!.refreshControl!.addTarget(self, action: .pullToRefresh, for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
//            self.viewModel.refreshData()
            self.collectionView!.refreshControl!.endRefreshing()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return 1
//        }
        return numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("collection cellForItemAt: \(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = .red
        
        if indexPath.row == numberOfItems - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                
                collectionView.reloadData()
                
//                self.collectionView?.performBatchUpdates({
//                    let start = numberOfItems
//                    numberOfItems += 25
//                    var indexPath = Array<IndexPath>()
//                    for i in start..<numberOfItems {
//                        indexPath.append(IndexPath(row: i, section: 1))
//                    }
//                    self.collectionView?.insertItems(at: indexPath)
//                }, completion: nil)
            })
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

//        let headerView = DenemeHeaderView()
//        let headerSize = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        print("referenceSize: \(headerSize)")
//        return CGSize(width: self.view.frame.width, height: headerSize.height)
        return CGSize(width: self.view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.width, height: 200)
        }
        return CGSize(width: self.view.frame.width, height: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierHeader, for: indexPath)

            headerView.backgroundColor = .gray

            return headerView
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierFooter, for: indexPath)
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension UserProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if indexPath.section == 0 {
//            return CGSize(width: self.view.frame.width, height: 200)
//        }
        
        let targetWidth = ( self.view.frame.width / itemPerLine ) - minimumSpacing
        
        print("targetWidth: \(targetWidth)")
        
        return CGSize(width: targetWidth, height: targetWidth)
    }
    
    
}


fileprivate extension Selector {
    static let pullToRefresh = #selector(UserProfileCollectionViewController.refreshData(_:))
}


class UserProfileViewInfoCell: BaseCollectionCell {
    
    private let padding = Constants.Profile.Padding
    private let dimension = 80
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.text = "catchuname"
        label.numberOfLines = 1
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.black
        label.text = "Deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio deneme bio"
        label.numberOfLines = 3
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        let layoutMargin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let nameBioStackView = UIStackView(arrangedSubviews: [nameLabel, bioLabel])
        nameBioStackView.axis = .vertical
        nameBioStackView.alignment = .fill
        nameBioStackView.distribution = .fill
        nameBioStackView.spacing = 10
        
        let profileStackView = UIStackView(arrangedSubviews: [profileImageView, nameBioStackView])
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.alignment = .center
        profileStackView.distribution = .fillProportionally
        profileStackView.spacing = 15
        profileStackView.layoutMargins = layoutMargin
        profileStackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(profileStackView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            profileStackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            profileStackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
            profileStackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
            profileStackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            ])
    }
}


class ActivityIndicatorFooterView: UICollectionReusableView {
    
    lazy var activityIndicatorView: UIView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: safeCenterXAnchor),
        activityIndicatorView.safeCenterYAnchor.constraint(equalTo: safeCenterYAnchor),
        ])
    }
    
}

