//
//  FollowingsView.swift
//  catchu
//
//  Created by Erkut Baş on 1/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FollowingsView: UIView {
    
    init(frame: CGRect, active: Bool) {
        super.init(frame: frame)
        self.active = active
        initializeViewSettings()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - major functions
extension FollowingsView {
    
    private func initializeViewSettings() {
        self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
    
}

// MARK: - MenuSlideItems
extension FollowingsView: PageItems {
    var active: Bool {
        get {
            return false
        }
        set {
            _ = newValue
        }
    }
    
    var title: String {
        get {
            return "500"
        }
        set {
            _ = newValue
        }
    }
    
    var subTitle: String {
        get {
            return LocalizedConstants.TitleValues.LabelTitle.following
        }
        set {
            _ = newValue
        }
    }
    
}
