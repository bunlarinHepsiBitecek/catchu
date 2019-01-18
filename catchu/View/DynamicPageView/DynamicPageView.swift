//
//  DynamicPageView.swift
//  catchu
//
//  Created by Erkut Baş on 1/12/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

/// Description: PageView, view array is requeired
class DynamicPageView: UIView {
    
    private var dynamicPageViewModel = DynamicPageViewModel()
    
    private var pageSliderView: PageSliderView!
    private var totalPageSliderHeight : CGFloat = 0
    private var activePage: Int = 0
    private var userScrollBegin: Bool = false
    private var scrollViewPagesAdded: Bool = false
    
    lazy var containerScrollView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return temp
    }()
    
    lazy var pageContentView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        return temp
    }()
    
    lazy var pageItemsScrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.contentSize = CGSize(width: self.frame.width * CGFloat(dynamicPageViewModel.returnPageItemsCount()), height: 0)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.isPagingEnabled = true
        temp.isScrollEnabled = true
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        temp.delegate = self
        return temp
    }()
    
    lazy var pageItemCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Cell.minimumLineSpacing_Zero
        layout.minimumInteritemSpacing = Constants.Cell.minimumLineSpacing_Zero
        
        //layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: Constants.StaticViewSize.ViewSize.Height.height_10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(PageItemCollectionViewCell.self, forCellWithReuseIdentifier: PageItemCollectionViewCell.identifier)
        
        return collectionView
        
    }()
    
    init(frame: CGRect, viewArray: [UIView], activePage: Int? = nil) {
        super.init(frame: frame)
        
        if viewArray.count <= 0 {
            print("\(Constants.ALERT) view array is requeired!")
            return
        }
        
        if let activePage = activePage {
            self.activePage = activePage
        }
        
        self.dynamicPageViewModel.viewArray = viewArray
        
        initializeViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("******* : \(containerScrollView.frame)")
        addPageViewIntoScrollView()
        
    }
    
}

// MARK: - major functions
extension DynamicPageView {
    
    private func initializeViewSettings() {
        
        addViews()
        addPageSliderView()
        addContainerScrollView()
        //addPageViewIntoScrollView()
        
    }
    
    private func addViews() {
        self.addSubview(pageItemCollectionView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            pageItemCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            pageItemCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            pageItemCollectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_5),
            pageItemCollectionView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_40)
            
            ])
        
        totalPageSliderHeight += Constants.StaticViewSize.ViewSize.Height.height_50
    }
    
    private func addPageSliderView() {
        
        pageSliderView = PageSliderView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: Constants.StaticViewSize.ViewSize.Height.height_1), pageCount: dynamicPageViewModel.returnPageItemsCount(), activePage: self.activePage)
        pageSliderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(pageSliderView)
        
        let safe = self.safeAreaLayoutGuide
        let safePageItemCollectionView = self.pageItemCollectionView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            pageSliderView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            pageSliderView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            pageSliderView.topAnchor.constraint(equalTo: safePageItemCollectionView.bottomAnchor),
            pageSliderView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_1)
            
            ])
        
        totalPageSliderHeight += Constants.StaticViewSize.ViewSize.Height.height_1
    }
    
    func addContainerScrollView()  {
        self.addSubview(containerScrollView)
        self.containerScrollView.addSubview(pageItemsScrollView)
        
        let safe = self.safeAreaLayoutGuide
        let safePageSliderView = self.pageSliderView.safeAreaLayoutGuide
        let safeContainerScrollView = self.containerScrollView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerScrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            containerScrollView.topAnchor.constraint(equalTo: safePageSliderView.bottomAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            pageItemsScrollView.leadingAnchor.constraint(equalTo: safeContainerScrollView.leadingAnchor),
            pageItemsScrollView.trailingAnchor.constraint(equalTo: safeContainerScrollView.trailingAnchor),
            pageItemsScrollView.topAnchor.constraint(equalTo: safeContainerScrollView.topAnchor),
            pageItemsScrollView.bottomAnchor.constraint(equalTo: safeContainerScrollView.bottomAnchor),
            
            ])
        
    }
    
    private func addPageViewIntoScrollView() {
        print("containerScrollView : \(containerScrollView.frame)")
        print("self.frame : \(self.frame)")

        var xCoordinate : CGFloat = 0
        
        for item in dynamicPageViewModel.viewArray {
            item.frame = CGRect(x: xCoordinate, y: CGFloat(0), width: containerScrollView.frame.width, height: containerScrollView.frame.height)
            self.pageItemsScrollView.addSubview(item)
            
            xCoordinate += self.frame.width
            
        }
        
        self.arrangeActivePageSettings(activePage: activePage)
        
    }
    
    private func animateSlider(inputConstant: CGFloat) {
        self.pageSliderView.animateSlider(inputConstant: inputConstant)
    }
    
    private func arrangeActivePageSettings(activePage : Int) {
        print("\(#function)")
        self.scrollToSelectedPage(selectedIndex: activePage)
    }
    
    private func scrollToSelectedPage(selectedIndex: Int) {
        print("pageItemsScrollView.frame.width : \(pageItemsScrollView.frame.width)")
        pageItemsScrollView.setContentOffset(CGPoint(x: self.frame.width * CGFloat(selectedIndex), y: pageItemsScrollView.frame.origin.y), animated: true)
        self.selectPageItem(selectedIndex: selectedIndex)
    }
    
    private func selectPageItem(selectedIndex: Int? = nil, selectedIndexPath: IndexPath? = nil) {
        
        var targetIndexPath = IndexPath()
        
        if let selectedIndex = selectedIndex {
            targetIndexPath = IndexPath(row: selectedIndex, section: 0)
        } else if let indexPath = selectedIndexPath {
            targetIndexPath = indexPath
        }
        
        pageItemCollectionView.selectItem(at: targetIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func addPageViewsIntoScrollView() {
        print("containerScrollView frame : \(containerScrollView.frame)")
        if containerScrollView.frame.height > 0 {
            if !scrollViewPagesAdded {
                addPageViewIntoScrollView()
                scrollViewPagesAdded = true
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DynamicPageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicPageViewModel.returnPageItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = pageItemCollectionView.dequeueReusableCell(withReuseIdentifier: PageItemCollectionViewCell.identifier, for: indexPath) as? PageItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(pageItem: dynamicPageViewModel.returnPageItem(index: indexPath.row)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / CGFloat(dynamicPageViewModel.returnPageItemsCount()), height: Constants.StaticViewSize.ViewSize.Height.height_50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scrollToSelectedPage(selectedIndex: indexPath.row)
    }
    
}

// MARK: - UIScrollViewDelegate
extension DynamicPageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(#function)")
        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
        if userScrollBegin {
            self.animateSlider(inputConstant: scrollView.contentOffset.x)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("\(#function)")
        userScrollBegin = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("\(#function)")
        self.animateSlider(inputConstant: scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / self.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        self.selectPageItem(selectedIndex: nil, selectedIndexPath: indexPath)
    }
}
