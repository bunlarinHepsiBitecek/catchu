//
//  Share.swift
//  catchu
//
//  Created by Erkut Baş on 6/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import MapKit

struct ShareMedia {
    let media: Media
    let type: MediaType
    let image: UIImage
    let localUrl: URL
    
    func toData() -> Data? {
        switch self.type {
        case .image:
            return UIImageJPEGRepresentation(self.image, CGFloat(integerLiteral: Constants.NumericConstants.INTEGER_ONE))
        case .video:
            do {
                return try Data(contentsOf: self.localUrl)
            } catch {
                print("VideoShare object cann't convert video url to Data")
                return nil
            }
        }
    }
}

class Share {
    
    public static var shared = Share()
    // MARK: Remzi
    var images: [ShareMedia]?
    var videos: [ShareMedia]?
    var message: String?
    // MARK:
    
    private var tempImageView = UIImageView()
    
    private var image : UIImage?
    private var imageSmall : UIImage?
    private var text: String?
    private var textScreenShot : UIImage?
    private var videoScreenShot : UIImage?
    private var location : CLLocation?
    private var shareid : String?
    private var privacyType: String?
    private var distance: Double?
    private var user: User?
    
    var imageUrl : String?
    private var imageUrlSmall : String?
    private var textScreenShotUrl : String?
    private var videoScreenShotUrl : String?
    var videoUrl: String?
    
    private var sharedDataDictionary : Dictionary<String, String> = [:]
    private var shareQueryResultDictionary : Dictionary<String, Share> = [:]
    
    
}
