//
//  APIClientModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import MapKit

class Location {
    var locationid: String?
    var latitude: Double?
    var longitude: Double?
    var radius: Double?
    
    init() {}
    
    init(location: RELocation?) {
        guard let location = location else { return }
        
        if let locationid = location.locationid {
            self.locationid = locationid
        }
        if let latitude = location.latitude {
            self.latitude = latitude.doubleValue
        }
        if let longitude = location.longitude {
            self.longitude = longitude.doubleValue
        }
        if let radius = location.radius {
            self.radius = radius.doubleValue
        }
    }
    
    func convertToCLLocation() -> CLLocationCoordinate2D? {
        let location: CLLocationCoordinate2D? = nil
        guard let latitude = self.latitude else { return location}
        guard let longitude = self.longitude else { return location}
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class Media {
    var mediaid: String?
    var type: String?
    var url: String?
    var thumbnail: String?
    var height: Int?
    var width: Int?
    var _extension: String?
    
    init() {}
    
    init(media: REMedia?) {
        guard let media = media else { return }
        
        if let mediaid = media.mediaid {
            self.mediaid = mediaid
        }
        if let type = media.type {
            self.type = type
        }
        if let url = media.url {
            self.url = url
        }
        if let thumbnail = media.thumbnail {
            self.thumbnail = thumbnail
        }
        if let height = media.height {
            self.height = height.intValue
        }
        if let width = media.width {
            self.width = width.intValue
        }
        if let _extension = media._extension {
            self._extension = _extension
        }
    }
    
    init(inputExtension : String) {
        self._extension = inputExtension
    }
}

extension User: CustomStringConvertible {
    var description: String {
        var description = ""
        guard let userid = self.userid else { return description }
        guard let name = self.name else { return description }
        guard let username = self.username else { return description }
        guard let profilePictureUrl = self.profilePictureUrl else { return description }
        
        description = "\(userid), \(name), \(username), \(profilePictureUrl)"
        return description
    }
}

class Post {
    var postid: String?
    var groupid: String?
    var message: String?
    var attachments: [Media]?
    var location: Location?
    var distance: Double?
    var isLiked: Bool?
    var likeCount: Int?
    var isCommentAllowed: Bool?
    var isShowOnMap: Bool?
    var commentCount: Int?
    var createAt: String?
    var user: User?
    var privacyType: String?
    var allowList: [User]?
    var comments: [Comment]?
    
    init() {}
    
    init(post: REPost?) {
        guard let post = post else { return }
        
        if let postid = post.postid {
            self.postid = postid
        }
        if let groupid = post.groupid {
            self.groupid = groupid
        }
        if let message = post.message {
            self.message = message
        }
        if let attachments = post.attachments {
            self.attachments = []
            for media in attachments {
                self.attachments?.append(Media(media: media))
            }
        }
        if let location = post.location {
            self.location = Location(location: location)
        }
        if let distance = post.distance {
            self.distance = distance.doubleValue
        }
        if let isLiked = post.isLiked {
            self.isLiked = isLiked.boolValue
        }
        if let likeCount = post.likeCount {
            self.likeCount = likeCount.intValue
        }
        if let isCommentAllowed = post.isCommentAllowed {
            self.isCommentAllowed = isCommentAllowed.boolValue
        }
        if let isShowOnMap = post.isShowOnMap {
            self.isShowOnMap = isShowOnMap.boolValue
        }
        if let commentCount = post.commentCount {
            self.commentCount = commentCount.intValue
        }
        if let createAt = post.createAt {
            self.createAt = createAt
        }
        if let user = post.user {
            self.user = User(user: user)
        }
        if let privacyType = post.privacyType {
            self.privacyType = privacyType
        }
        if let allowList = post.allowList {
            self.allowList = []
            for user in allowList {
                self.allowList?.append(User(user: user))
            }
        }
        if let comments = post.comments {
            self.comments = []
            for comment in comments {
                self.comments?.append(Comment(comment: comment))
            }
        }
    }
    
    public func distanceFormatter() -> String {
        let multipler: Double = 1000
        var meauser = "m"
        var roundedDistance: Double = 0
        
        /// distance is km format
        if let distance = self.distance {
            var distanceCalculated = distance
            if distanceCalculated < 1.0 {
                distanceCalculated = distanceCalculated * multipler
            } else {
                meauser = "km"
            }
            roundedDistance = rounded(distance: distanceCalculated, toPlaces: 1)
        }
        return "\(roundedDistance) \(meauser)"
    }
    
    private func rounded(distance: Double, toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (distance * divisor).rounded() / divisor
    }
    
    func isOwnPost() -> Bool {
        let isOwnPost = false
        guard let postOwner = self.user else { return isOwnPost}
        guard let postOwnerUserid = postOwner.userid else { return isOwnPost}
        guard let loginUserid = User.shared.userid else { return isOwnPost}
        
        return loginUserid == postOwnerUserid
    }
    
}

class Comment {
    var commentid: String?
    var message: String?
    var likeCount: Int?
    var isLiked: Bool?
    var replies: [Comment]?
    var createAt: String?
    var user: User?
    
    init() {}
    
    init(message: String?, user: User?) {
        guard let message = message else { return }
        guard let user = user else { return }
        
        self.message = message
        self.user = user
        
        self.commentid = UUID().uuidString
        self.likeCount = 0
        self.isLiked = false
        self.createAt = ""
    }
    
    init(comment: REComment?) {
        guard let comment = comment else { return }
        
        if let commentid = comment.commentid {
            self.commentid = commentid
        }
        if let message = comment.message {
            self.message = message
        }
        if let likeCount = comment.likeCount {
            self.likeCount = likeCount.intValue
        }
        if let isLiked = comment.isLiked {
            self.isLiked = isLiked.boolValue
        }
        if let replies = comment.replies {
            self.replies = []
            for reply in replies {
                self.replies?.append(Comment(comment: reply))
            }
        }
        if let createAt = comment.createAt {
            self.createAt = createAt
        }
        if let user = comment.user {
            self.user = User(user: user)
        }
    }
    
    init(comment: REComment_replies_item) {
        if let commentid = comment.commentid {
            self.commentid = commentid
        }
        if let message = comment.message {
            self.message = message
        }
        if let likeCount = comment.likeCount {
            self.likeCount = likeCount.intValue
        }
        if let isLiked = comment.isLiked {
            self.isLiked = isLiked.boolValue
        }
        if let user = comment.user {
            self.user = User(user: user)
        }
    }
}

extension Comment: CustomStringConvertible {
    var description: String {
        var description = ""
        guard let commentid = self.commentid else { return description }
        guard let message = self.message else { return description }
        guard let likeCount = self.likeCount else { return description }
        guard let isLiked = self.isLiked else { return description }
        guard let replies = self.replies else { return description }
        guard let user = self.user else { return description }
        
        description = "\(commentid), \(message), \(likeCount), \(isLiked), \(replies.count), \(user.description)"
        return description
    }
}


class Phone {
    var countryCode: String?
    var dialCode: String?
    var phoneNumber: Int?
    
    init(phone: REPhone?) {
        guard let phone = phone else { return }
        self.countryCode = phone.countryCode
        self.dialCode = phone.dialCode
        if let phoneNumber = phone.phoneNumber {
            self.phoneNumber = phoneNumber.intValue
        }
    }
    
    func getPhone() -> REPhone? {
        guard let phone = REPhone() else { return nil }
        phone.countryCode = self.countryCode
        phone.dialCode = self.dialCode
        if let phoneNumber = self.phoneNumber {
            phone.phoneNumber = NSNumber(value: phoneNumber)
        }
        return phone
    }
    
    func getPhoneNumber() -> String {
        let dialCode = self.dialCode ?? ""
        let phoneNumber = self.phoneNumber ?? 0
        return dialCode + "\(phoneNumber)"
    }
}

class Provider {
    var providerid: String?
    var providerType: String?
    
    init(provider: REProvider?) {
        guard let provider = provider else { return }
        self.providerid = provider.providerid
        self.providerType = provider.providerType
    }
}
