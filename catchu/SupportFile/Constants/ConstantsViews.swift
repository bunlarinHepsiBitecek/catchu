//
//  ConstantsViews.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//


struct ConstanstViews {
    struct Labels {
        static let NoDataFoundLabel: UILabel = {
            let label = UILabel()
            label.text = LocalizedConstants.Feed.NoPostFound
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            label.numberOfLines = 0
            label.sizeToFit()
            return label
        }()
    }
    
    struct PageView {
        struct TabView {
            static let DefaultColor =  UIColor.gray
            static let CurrentColor =  UIColor.black
            static let Font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
}

