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
    var privacyType: PrivacyType?
    var groupid: String?
    // MARK:
    
    var tempImageView = UIImageView() // use for notification
    
    var image: UIImage?
    var imageSmall: UIImage?
    var textScreenShot: UIImage?
    var videoScreenShot: UIImage?
    var location: CLLocation?
    var shareid: String?
    var distance: Double?
    var user: User?
    
    init() {}
}
