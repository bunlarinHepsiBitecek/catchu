//
//  ExploreMenus.swift
//  catchu
//
//  Created by Erkut Baş on 11/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreMenus: UIView {

    private var selfFrameCalculated : Bool = false
    
    weak var delegate : SlideMenuProtocols!
    
    private var facebookContactList : FacebookContactList?
    private var contactList : ContactList?
    
    lazy var mainScrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isPagingEnabled = true
        temp.isScrollEnabled = true
        temp.delegate = self
        
        temp.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("ExploreMenus frame : \(self.frame)")
        
    }
    
    init(frame: CGRect, delegate : SlideMenuProtocols) {
        super.init(frame: frame)
        self.delegate = delegate
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        print("ExploreMenus frame : \(self.frame)")
        print("UIScreen frame : \(UIScreen.main.bounds)")

        if self.frame.height > 0 {
            if !selfFrameCalculated {

                initializeViewSettings()

                selfFrameCalculated = true
            }
        }
    }

}

// MARK: - major functions
extension ExploreMenus {
    
    func tata() {
        
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 300)
        
        facebookContactList = FacebookContactList()
        facebookContactList?.translatesAutoresizingMaskIntoConstraints = false
        
        contactList = ContactList()
        contactList?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainScrollView)
        self.mainScrollView.addSubview(facebookContactList!)
        self.mainScrollView.addSubview(contactList!)
        
        let safe = self.safeAreaLayoutGuide
        let safeScroll = self.mainScrollView.safeAreaLayoutGuide
        let safeFace = self.facebookContactList?.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainScrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            facebookContactList!.leadingAnchor.constraint(equalTo: safeScroll.leadingAnchor),
            facebookContactList!.topAnchor.constraint(equalTo: safeScroll.topAnchor),
            facebookContactList!.bottomAnchor.constraint(equalTo: safeScroll.bottomAnchor),
            facebookContactList!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            contactList!.leadingAnchor.constraint(equalTo: (safeFace?.trailingAnchor)!),
            contactList!.topAnchor.constraint(equalTo: safeScroll.topAnchor),
            contactList!.bottomAnchor.constraint(equalTo: safeScroll.bottomAnchor),
            contactList!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            ])
        
    }
    
    func displayFrame() {
        print("displayFrame starts")
        print("self.frame : \(self.frame)")
    }
    
    func initializeViewSettings() {
        addViews()
        configureScrollViewItems()
    }
    
    func addViews() {
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width * 2, height: self.frame.height)
        mainScrollView.contentSize = CGSize(width: self.frame.width * 2, height: self.frame.height)
        
        self.addSubview(mainScrollView)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainScrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
    func configureScrollViewItems() {
        
        addFacebookContactList()
        addContactList()
        
//        koko()
        
    }
    
    func addFacebookContactList() {
        
        facebookContactList = FacebookContactList(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
//        facebookContactList = FacebookContactList()
//        facebookContactList?.translatesAutoresizingMaskIntoConstraints = false
//        facebookContactList?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        mainScrollView.addSubview(facebookContactList!)
        
//        let safeMainScrollView = self.mainScrollView.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([
//
//            facebookContactList!.topAnchor.constraint(equalTo: safeMainScrollView.topAnchor),
//            facebookContactList!.bottomAnchor.constraint(equalTo: safeMainScrollView.bottomAnchor),
//            facebookContactList!.widthAnchor.constraint(equalToConstant: self.frame.width),
//
//
//            ])
        
    }
    
    func addContactList() {
        
        print("addContactList starts")
        print("self.frame.width : \(self.frame.width)")
        
        contactList = ContactList(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
//        contactList = ContactList()
//        contactList!.translatesAutoresizingMaskIntoConstraints = false
////        contactList!.frame = CGRect(x: self.frame.width, y: 0, width: 0, height: 0)

        mainScrollView.addSubview(contactList!)
        
//        let safeMainScrollView = self.mainScrollView.safeAreaLayoutGuide
//        let safeFacebookContactList = self.facebookContactList?.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([
//
//            contactList!.topAnchor.constraint(equalTo: safeMainScrollView.topAnchor),
//            contactList!.bottomAnchor.constraint(equalTo: safeMainScrollView.bottomAnchor),
//            contactList!.widthAnchor.constraint(equalToConstant: self.frame.width),
//            contactList!.leadingAnchor.constraint(equalTo: (safeFacebookContactList?.trailingAnchor)!)
//
//            ])
        
    }
    
    func koko() {
        
        facebookContactList = FacebookContactList()
        facebookContactList?.translatesAutoresizingMaskIntoConstraints = false
        
        contactList = ContactList()
        contactList!.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainScrollView.addSubview(facebookContactList!)
        self.mainScrollView.addSubview(contactList!)
        
        let safe = self.mainScrollView.safeAreaLayoutGuide
        let safeFacebookContactList = self.facebookContactList?.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            facebookContactList!.topAnchor.constraint(equalTo: safe.topAnchor),
            facebookContactList!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            facebookContactList!.widthAnchor.constraint(equalToConstant: self.frame.width),
            facebookContactList!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            
            contactList!.topAnchor.constraint(equalTo: safe.topAnchor),
            contactList!.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            contactList!.widthAnchor.constraint(equalToConstant: self.frame.width),
            contactList!.leadingAnchor.constraint(equalTo: safeFacebookContactList!.trailingAnchor),
            
            ])
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension ExploreMenus : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
        delegate.scrollStick(inputConstant: scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("scrollViewWillEndDragging")
        
        print("targetContentOffset : \(targetContentOffset.pointee.x)")
        
        let index = targetContentOffset.pointee.x / self.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        print("indexPath item : \(indexPath.item)")
        
//        delegate.selectSliderTypeCell(inputIndexPath: indexPath)
        
    }
    
    // scrollview tamamen scroll bitince çalışır
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / self.frame.width
        
        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
        print("scrollViewDidEndDecelerating")
        print("index :\(index)")
        
//        menuViewCoordination(activeIndex : Int(index))
        
    }*/
    
}
