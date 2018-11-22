//
//  PostMainView.swift
//  catchu
//
//  Created by Erkut Baş on 11/20/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PostMainView: UIView {

    private var customMapView : CustomMapView?
    private var saySomethingView : SaySomethingView?
    private var postTopBarView : PostTopBarView?
    
    weak var delegate : PostViewProtocols!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        
    }
    
    init(frame: CGRect, delegate : PostViewProtocols) {
        super.init(frame: frame)
        self.delegate = delegate
        initializeView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - major functions
extension PostMainView {
    
    private func initializeView() {
        
        print("initializeView starts")
        print("keyboard height : \(KeyboardService.keyboardHeight())")
        print("keyboard size   : \(KeyboardService.keyboardSize())")
        
        addCustomMapView()
        addPostTopBarView()
        addSaySomethingView()
        
    }
    
    private func addCustomMapView() {
        
        customMapView = CustomMapView()
        customMapView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(customMapView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            customMapView!.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            customMapView!.heightAnchor.constraint(equalToConstant: KeyboardService.keyboardHeight() - Constants.StaticViewSize.ConstraintValues.constraint_10),
            
            ])
        
    }
    
    private func addPostTopBarView() {
        
        postTopBarView = PostTopBarView()
        postTopBarView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(postTopBarView!)
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            postTopBarView!.topAnchor.constraint(equalTo: safe.topAnchor),
            postTopBarView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            postTopBarView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            postTopBarView!.heightAnchor.constraint(equalToConstant: Constants.StaticViewSize.ViewSize.Height.height_100)
            
            ])
        
    }
    
    private func addSaySomethingView() {
        
        saySomethingView = SaySomethingView(frame: .zero, delegate: delegate)
        saySomethingView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(saySomethingView!)
        
        let safe = self.safeAreaLayoutGuide
        let safeCustomMapView = self.customMapView!.safeAreaLayoutGuide
        let safePostTopBarView = self.postTopBarView!.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            saySomethingView!.bottomAnchor.constraint(equalTo: safeCustomMapView.topAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_5),
            saySomethingView!.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10),
            saySomethingView!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -Constants.StaticViewSize.ConstraintValues.constraint_10),
            saySomethingView!.topAnchor.constraint(equalTo: safePostTopBarView.bottomAnchor, constant: Constants.StaticViewSize.ConstraintValues.constraint_10)
            
            ])
        
    }
    
}
