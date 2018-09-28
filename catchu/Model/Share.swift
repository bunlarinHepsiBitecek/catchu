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
    
    private var _tempImageView = UIImageView()
    
    private var _image : UIImage
    private var _imageSmall : UIImage
    private var _text: String
    private var _textScreenShot : UIImage
    private var _videoScreenShot : UIImage
    private var _location : CLLocation
    private var _shareid : String
    private var _privacyType: String
    private var _distance: Double
    private var _user: User
    
    var imageUrl : String?
    private var _imageUrlSmall : String
    private var _textScreenShotUrl : String
    private var _videoScreenShotUrl : String
    var videoUrl: String?
    
    private var _sharedDataDictionary : Dictionary<String, String> = [:]
    private var _shareQueryResultDictionary : Dictionary<String, Share> = [:]
    
    init() {
        
        _image = UIImage()
        _imageSmall = UIImage()
        _text = Constants.CharacterConstants.SPACE
        _textScreenShot = UIImage()
        _videoScreenShot = UIImage()
        _location = CLLocation()
        _shareid = Constants.CharacterConstants.SPACE
        _imageUrlSmall = Constants.CharacterConstants.SPACE
        _textScreenShotUrl = Constants.CharacterConstants.SPACE
        _videoScreenShotUrl = Constants.CharacterConstants.SPACE
        _privacyType = Constants.CharacterConstants.SPACE
        _distance = Constants.NumericConstants.DOUBLE_ZERO
        _user = User()
    }
    
    var image : UIImage {
        get {
            return _image
        }
        set {
            _image = newValue
        }
    }
    
    var imageSmall : UIImage {
        get {
            return self._imageSmall
        }
        set {
            self._imageSmall = newValue
        }
    }
    
    var text: String {
        get {
            return self._text
        }
        set {
            self._text = newValue
        }
    }
    
    var textScreenShot : UIImage {
        get {
            return _textScreenShot
        }
        set {
            _textScreenShot = newValue
        }
    }
    
    var videoScreenShot : UIImage {
        get {
            return _videoScreenShot
        }
        set {
            _videoScreenShot = newValue
        }
    }
    
    var location: CLLocation {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    
    var shareId: String {
        get {
            return _shareid
        }
        set {
            _shareid = newValue
        }
    }
    var privacyType: String {
        get {
            return _privacyType
        }
        set {
            _privacyType = newValue
        }
    }
    
    var distance: Double {
        get {
            return _distance
        }
        set {
            _distance = newValue
        }
    }
    
    var user: User {
        get {
            return self._user
        }
        set {
            self._user = newValue
        }
    }
    
    var imageUrlSmall: String {
        get {
            return _imageUrlSmall
        }
        set {
            _imageUrlSmall = newValue
        }
    }
    
    
    var tempImageView: UIImageView {
        get {
            return _tempImageView
        }
        set {
            _tempImageView = newValue
        }
    }
    
    var shareQueryResultDictionary: Dictionary<String, Share> {
        get {
            return _shareQueryResultDictionary
        }
        set {
            _shareQueryResultDictionary = newValue
        }
    }
    
    func appendElementIntoShareQueryResultDictionary(key : String, value : Share) {
        
        self._shareQueryResultDictionary[key] = value
        
    }
    
    func appendElementIntoDictionary(key : String, value : String) {
        
        self._sharedDataDictionary[key] = value
        
    }
    
    func parseShareData(dataDictionary : [String : AnyObject]) {
        
    }
    
    func createSharedDataDictionary() -> Dictionary<String, String> {
        
        return _sharedDataDictionary
        
    }
    
    
}
