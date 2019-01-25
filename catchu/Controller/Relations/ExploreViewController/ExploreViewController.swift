//
//  ExploreViewController.swift
//  catchu
//
//  Created by Erkut Baş on 1/22/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    private var exploreFacebookContactView: ExploreFacebookContactsView!
    private var exploreContactView: ExplorePhoneContactView!
    
    var exploreType: ExploreType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try prepareControllerSettings()
        } catch let error as ClientPresentErrors {
            if error == .missingUserid {
                print("\(Constants.ALERT) userid is required")
            }
        }
        catch {
            print("\(Constants.CRASH_WARNING)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}

// MARK: - major functions
extension ExploreViewController {
    
    private func prepareControllerSettings() throws {
        
//        guard let user = user else { throw ClientPresentErrors.missingUserid }
        exploreContactView = ExplorePhoneContactView()
        exploreFacebookContactView = ExploreFacebookContactsView()
        
        addViews()
    }
    
    private func addViews() {
        addDynamicPageView()
    }
    
    private func configureViewSettings() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = LocalizedConstants.TitleValues.LabelTitle.followInfo
    }
    
    private func addDynamicPageView() {
        
        var activePage = 0
        
        if let exploreType = exploreType {
            switch exploreType{
            case .facebook:
                activePage = 0
            case .contact:
                activePage = 1
            }
        }
        
        let viewArray : [UIView] = [exploreFacebookContactView, exploreContactView]
        
        let dynamicPageView = DynamicPageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewArray: viewArray, activePage: activePage)
        
        dynamicPageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(dynamicPageView)
        
        let safe = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            dynamicPageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            dynamicPageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            dynamicPageView.topAnchor.constraint(equalTo: safe.topAnchor),
            dynamicPageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            ])
        
    }
    
}
