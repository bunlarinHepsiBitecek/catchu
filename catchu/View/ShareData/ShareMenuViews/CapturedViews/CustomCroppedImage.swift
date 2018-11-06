//
//  CustomCroppedImage.swift
//  catchu
//
//  Created by Erkut Baş on 9/28/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class CustomCroppedImage: UIView {
    
    weak var delegate : ShareDataProtocols!

    private var isFlipped : Bool = false
    private var isLayoutSet : Bool = false
    
    private var selectedIndexPath : IndexPath?
    
    /// constraints
    private var heightConstraintOfFilterContainer = NSLayoutConstraint()
    private var heightConstraintOfMainContainerView = NSLayoutConstraint()
    private var topConstraintOfimageView = NSLayoutConstraint()
    
    lazy var mainContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
//        temp.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return temp
    }()
    
    lazy var imageContainerView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.layer.cornerRadius = 10
        temp.clipsToBounds = true
//        temp.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return temp
    }()
    
    lazy var imageView: UIImageView = {
        
        let temp = UIImageView()
        temp.isUserInteractionEnabled = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layer.cornerRadius = 10
        
        // it is required after transform
        temp.clipsToBounds = true
        
        return temp
        
    }()
    
    lazy var filterContainer: UIView = {
    
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return temp
        
    }()
    
    lazy var navigationViewUp: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "navigate-up")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isHidden = false
        
        return temp
        
    }()
    
    lazy var navigationViewDown: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "navigate-down")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isHidden = true
        
        return temp
        
    }()
    
    lazy var closeButton: UIImageView = {
        
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: "cancel_black")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return temp
        
    }()
    
    lazy var filterColorCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 4
//        layout.minimumInteritemSpacing = 4
        layout.sectionInset.left = 8
        layout.sectionInset.top = 8
        layout.sectionInset.bottom = 8
        layout.sectionInset.right = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 5
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
//        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(FilterColorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Collections.CollectionView.filterColorCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    private var filteredImageArray = [UIImage]()
    
    private var context = CIContext(options: nil)
    
    private let filterNameList = [
//        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    let filterDisplayNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear"
    ]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setupViews()
        setupCloseButtonGesture()
        
        setupNavigationUpButtonGesture()
        
        activationManagement(granted : false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayoutSet {
            setContainerHeightWidth()
        }
        
    }
    
}

// MARK: - major functions
extension CustomCroppedImage {
    
    func viewSettings() {
        
        self.layer.cornerRadius = 10
        
    }
    
    func setupViews() {
        
        viewSettings()
        
        self.addSubview(mainContainerView)
        
        self.mainContainerView.addSubview(imageContainerView)
        self.imageContainerView.addSubview(imageView)
        self.mainContainerView.addSubview(closeButton)
        self.mainContainerView.addSubview(navigationViewUp)
        self.addSubview(filterContainer)
        self.filterContainer.addSubview(filterColorCollectionView)
        
        let selfSafe = self.safeAreaLayoutGuide
        let safe = self.mainContainerView.safeAreaLayoutGuide
        let safeMainContainer = self.imageContainerView.safeAreaLayoutGuide
        let safeFilterContainer = self.filterContainer.safeAreaLayoutGuide
        
        heightConstraintOfFilterContainer = filterContainer.heightAnchor.constraint(equalToConstant: 110)
        heightConstraintOfMainContainerView = mainContainerView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            
            mainContainerView.leadingAnchor.constraint(equalTo: selfSafe.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: selfSafe.trailingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: selfSafe.topAnchor),
            
            imageContainerView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: safeMainContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeMainContainer.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: safeMainContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeMainContainer.bottomAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            filterContainer.leadingAnchor.constraint(equalTo: selfSafe.leadingAnchor),
            filterContainer.trailingAnchor.constraint(equalTo: selfSafe.trailingAnchor),
            filterContainer.bottomAnchor.constraint(equalTo: selfSafe.bottomAnchor),
            
            navigationViewUp.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            navigationViewUp.heightAnchor.constraint(equalToConstant: 30),
            navigationViewUp.widthAnchor.constraint(equalToConstant: 60),
            navigationViewUp.bottomAnchor.constraint(equalTo: safeFilterContainer.topAnchor),
            
            filterColorCollectionView.leadingAnchor.constraint(equalTo: safeFilterContainer.leadingAnchor),
            filterColorCollectionView.trailingAnchor.constraint(equalTo: safeFilterContainer.trailingAnchor),
            filterColorCollectionView.topAnchor.constraint(equalTo: safeFilterContainer.topAnchor),
            filterColorCollectionView.bottomAnchor.constraint(equalTo: safeFilterContainer.bottomAnchor),
            
            ])
        
    }
    
    func setContainerHeightWidth() {
        print("setContainerHeightWidth starts")
        
        print("self.frame.size : \(self.frame.size)")
        print("heightConstraintOfMainContainerView.constant : \(heightConstraintOfMainContainerView.constant)")
        
        imageContainerView.heightAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        
        heightConstraintOfMainContainerView.constant = self.frame.size.height
        heightConstraintOfMainContainerView.isActive = true
        
        print("heightConstraintOfMainContainerView.constant : \(heightConstraintOfMainContainerView.constant)")
        
        isLayoutSet = true
        
    }
    
    func activationManagement(granted : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            if granted {
                self.alpha = 1
            } else {
                self.alpha = 0
            }
        }
        
    }
    
    public func setImage(inputImage : UIImage) {
        
        print("setImage starts")
        print("input image size : \(inputImage.size)")
        
        imageView.image = inputImage
        activationManagement(granted: true)
        
        createFilteredImageArray()
        
    }
    
    func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        return filteredImage
    }
    
    func createFilteredImageArray() {
        
        guard let image = imageView.image else { return }
        
        filteredImageArray.append(image)
        
        for item in filterNameList {
            
            let tempImage = createFilteredImage(filterName: item, image: image)
            filteredImageArray.append(tempImage)
            
        }
        
    }
    
    func deleteFilteredImageArray() {
        
        filteredImageArray.removeAll()
        
    }

    func imageViewTranstionManagement() {
        
        UIView.transition(with: imageView, duration: Constants.AnimationValues.aminationTime_05, options: [.transitionCrossDissolve], animations: {
            
            if !self.isFlipped {
                self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } else {
                self.imageView.transform = .identity
            }
            
        })
        
    }
    
    func heigthConstraintsManagement() {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_05) {
            
            if !self.isFlipped {
                self.heightConstraintOfFilterContainer.isActive = true
                self.heightConstraintOfMainContainerView.constant -= self.heightConstraintOfFilterContainer.constant
                
            } else {
                self.heightConstraintOfFilterContainer.isActive = false
                self.heightConstraintOfMainContainerView.constant += self.heightConstraintOfFilterContainer.constant
            }
            
            self.layoutIfNeeded()
            
        }
        
    }
    
    func navigationButtonManagement() {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_03) {
            
            if !self.isFlipped {
                self.navigationViewUp.transform = CGAffineTransform(scaleX: 1, y: -1)
                self.isFlipped = true
                
            } else {
                self.navigationViewUp.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.isFlipped = false
            }
            
        }
        
    }
    
    func setFirstFilterSelected() {
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        selectedIndexPath = indexPath
        
    }
    
    func returnImage() -> UIImage {
        
        return imageView.image!
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CustomCroppedImage : UIGestureRecognizerDelegate {
    
    func setupCloseButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCroppedImage.dismissCustomScrollView(_:)))
        tapGesture.delegate = self
        closeButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissCustomScrollView(_ sender : UITapGestureRecognizer) {
        
        delegate.scrollableManagement(enabled: true)
        
        // to reset all view animations
        self.isFlipped = true
        imageViewTranstionManagement()
        heigthConstraintsManagement()
        navigationButtonManagement()
        
        setFirstFilterSelected()
        
        deleteFilteredImageArray()
        
        activationManagement(granted: false)
        
    }
    
    func setupNavigationUpButtonGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomCroppedImage.openFilterColorCollection(_:)))
        tapGesture.delegate = self
        navigationViewUp.addGestureRecognizer(tapGesture)
        
    }
    
    // navigation button flip functions
    @objc func openFilterColorCollection(_ sender : UITapGestureRecognizer) {
        
        print("openFilterColorCollection starts")
        print("heightConstraintOfFilterContainer : \(heightConstraintOfFilterContainer.constant)")
        print("heightConstraintOfMainContainerView : \(heightConstraintOfMainContainerView.constant)")
        
        imageViewTranstionManagement()
        heigthConstraintsManagement()
        navigationButtonManagement()
        
        if self.isFlipped {
            delegate.scrollableManagement(enabled: false)
        } else {
            delegate.scrollableManagement(enabled: true)
        }
        
        print("heightConstraintOfMainContainerView : \(heightConstraintOfMainContainerView.constant)")
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CustomCroppedImage : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = filterColorCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Collections.CollectionView.filterColorCell, for: indexPath) as? FilterColorCollectionViewCell else { return UICollectionViewCell() }
        
        initiateCellSettings(inputCell : cell)
        
        // if selectedIndexPath is defined
        if let selectedIndexPath = selectedIndexPath {
            
            if selectedIndexPath == indexPath {
                cell.activateselectedIcon(active: true)
                selectedCellAnimation(cell: cell, enlarge: true)
                
            }
            
        }
        
        cell.setupCells(image: filteredImageArray[indexPath.row], name: filterDisplayNameList[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedIndexPath = selectedIndexPath {
            
            if let cell = filterColorCollectionView.cellForItem(at: selectedIndexPath) as? FilterColorCollectionViewCell {
                
                cell.activateselectedIcon(active: false)
                selectedCellAnimation(cell: cell, enlarge: false)
                
            }
            
        }
        
        if let cell = filterColorCollectionView.cellForItem(at: indexPath) as? FilterColorCollectionViewCell {

            cell.activateselectedIcon(active: true)
            selectedCellAnimation(cell: cell, enlarge: true)
            
            imageView.image = cell.filterImage.image
            
            selectedIndexPath = indexPath
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 90)
        
    }
    
    // EXTERNAL collectionView functions
    
    /// cell animation
    ///
    /// - Parameter cell: input collectionViewCell
    func selectedCellAnimation(cell : UICollectionViewCell, enlarge : Bool) {
        
        UIView.animate(withDuration: Constants.AnimationValues.aminationTime_02, animations: {
            
            if enlarge {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            } else {
                cell.transform = .identity
            }

            
        })
        
    }
    
    func initiateCellSettings(inputCell : UICollectionViewCell) {
        
        guard let cell = inputCell as? FilterColorCollectionViewCell else { return }
        
        cell.activateselectedIcon(active: false)
        cell.transform = .identity
        
    }
    
    
}
