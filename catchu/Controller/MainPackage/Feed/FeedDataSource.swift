//
//  FeedDataSource.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/14/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class FeedDataSource: NSObject {
    static let shared = FeedDataSource()
    
    var feeds = [Share]() {
        didSet{
//            NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: true)
        }
    }
    
    func loadData() {
        var count = 0
        REAWSManager.shared.getGeolocationData(radius: Constants.Map.Radius) { (shareList) in
            for shareItem in shareList.items! {
                print("Dongu count: \(count)")
                count += 1
                let share = Share.convert(shareDTO: shareItem)
                self.feeds.append(share)
            }
        }
    }
}

