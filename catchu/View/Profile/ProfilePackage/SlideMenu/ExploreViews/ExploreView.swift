//
//  ExploreView.swift
//  catchu
//
//  Created by Erkut Baş on 11/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreView: UIView {
    
    private var exploreType : ExploreViewSlider?
    private var exploreMenus : ExploreMenus?
    
    weak var delegate : UserProfileViewProtocols!
    
    lazy var mainView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        
        return temp
    }()
    
    lazy var topView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var bodyView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initiateViewSettings()
    }
    
    init(frame: CGRect, delegate : UserProfileViewProtocols) {
        super.init(frame: frame)
        
        self.delegate = delegate
        
        initiateViewSettings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        addExploreMenusWithFrames()
//
//    }
    
}

// MARK: - major functions
extension ExploreView {
    
    func initiateViewSettings() {
        
        addViews()
        addExploreTypeViews()
        addExploreMenusWithFrames()

    }
    
    func addViews() {
        
        self.addSubview(mainView)
        self.mainView.addSubview(topView)
        self.mainView.addSubview(bodyView)
        
        let safe = self.safeAreaLayoutGuide
        let safeMain = self.mainView.safeAreaLayoutGuide
        let safeTopView = self.topView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            topView.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor),
            topView.topAnchor.constraint(equalTo: safeMain.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ConstraintValues.constraint_42),
            
            bodyView.leadingAnchor.constraint(equalTo: safeMain.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeMain.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeMain.bottomAnchor),
            
            ])
        
    }
    
    func addExploreTypeViews() {
        
        exploreType = ExploreViewSlider()
        exploreType?.translatesAutoresizingMaskIntoConstraints = false
        
        let safeTopView = self.topView.safeAreaLayoutGuide
        
        self.topView.addSubview(exploreType!)
        
        NSLayoutConstraint.activate([
            
            exploreType!.leadingAnchor.constraint(equalTo: safeTopView.leadingAnchor),
            exploreType!.trailingAnchor.constraint(equalTo: safeTopView.trailingAnchor),
            exploreType!.topAnchor.constraint(equalTo: safeTopView.topAnchor),
            exploreType!.bottomAnchor.constraint(equalTo: safeTopView.bottomAnchor),
            
            ])
        
    }
    
    func addExploreMenusWithFrames() {
        
        //exploreMenus = ExploreMenus(frame: .zero, delegate: exploreType!, delegateSlideMenu : delegate)
        
        exploreMenus = ExploreMenus(frame: .zero, delegate: exploreType!, delegateUserProfile: delegate)
        exploreMenus?.translatesAutoresizingMaskIntoConstraints = false
        
        let safeBodyView = self.bodyView.safeAreaLayoutGuide
        
        self.bodyView.addSubview(exploreMenus!)
        
        NSLayoutConstraint.activate([
            
            exploreMenus!.leadingAnchor.constraint(equalTo: safeBodyView.leadingAnchor),
            exploreMenus!.trailingAnchor.constraint(equalTo: safeBodyView.trailingAnchor),
            exploreMenus!.topAnchor.constraint(equalTo: safeBodyView.topAnchor),
            exploreMenus!.bottomAnchor.constraint(equalTo: safeBodyView.bottomAnchor),
            
            ])
        
    }
    
}

