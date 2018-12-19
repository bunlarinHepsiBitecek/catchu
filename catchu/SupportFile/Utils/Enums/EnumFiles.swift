//
//  EnumFiles.swift
//  catchu
//
//  Created by Erkut Baş on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

enum ProviderType: String {
    case firebase
    case facebook
    case twitter
    case phone
}

enum ContactRequestType {
    case enableSettings
    case fetchContact
}

enum PostContentType {
    case camera
    case video
    case note
}

enum ActionControllerType {
    case camera
    case video
    case groupInformation

}

enum ActionControllerOperationType {
    case select
    case update
}

enum ActionButtonOperation {
    case cameraOpen
    case imageGalleryOpen
    case selectedImageDelete
    case selectedImageUpdate
    case videoOpen
    case videoGalleryOpen
    case selectedVideoDelete
}

enum MediaType: String {
    case image
    case video
}

enum PrivacyType: String {
    case everyone
    case allFollowers
    case custom
    case myself
    case group
    
    public var stringValue: String {
        switch self {
        case .everyone:
            return "EVERYONE"
        case .allFollowers:
            return "ALL_FOLLOWERS"
        case .custom:
            return "CUSTOM"
        case .myself:
            return "SELF"
        case .group:
            return "GROUP"
        }
    }
}

enum SchemeType: String {
    case hash
    case mention
}

enum IconManagement {
    case open
    case close
    case selected
    case deselected
}

enum SegmentedButtonChoise {
    case friends
    case groups
    case groupCreation
    case nothing
}

enum FriendRelationViewChoise {
    case friend
    case group
}

enum EnumContainerView {
    
    case containerViewFriend
    case containerViewGroup
    
}

enum RequestType : String {
    
    case followRequest = "followRequest"
    case acceptFollowRequest = "acceptRequest"
    case getRequestingFollowList = "requestingFollowList"
    case createFollowDirectly = "createFollowDirectly"
    case deleteFollow = "deleteFollow"
    case deletePendingFollowRequest = "deletePendingFollowRequest"
    case defaultRequest = "Nothing"
    case user_profile_update = "USER_PROFILE_UPDATE"
    case get_group_participant_list = "GET_GROUP_PARTICIPANT_LIST"
    case update_group_info = "UPDATE_GROUP_INFO"
    case add_participant_into_group = "ADD_PARTICIPANT_INTO_GROUP"
    case exit_group = "EXIT_GROUP"
    case create_group = "CREATE_GROUP"
    case userGroups = "GET_AUTHENTICATED_USER_GROUP_LIST"
    
 
}

enum CallerViewController {
    
    case EditProfile4View
    case Profile4ViewController
}

enum ButtonChoosen {
    case selected
    case deselected
}

enum PermissionFLows {
    case camera
    case photoLibrary
    case cameraUnathorized
    case photoLibraryUnAuthorized
    case microphone
    case microphoneUnAuthorizated
    case videoLibrary
    case videoLibraryUnauthorized
    case video
    case videoUnauthorized
}

enum CallerClass {
    case ImageVideoPickerHandler
    case MediaLibraryManager
}

enum CameraPosition {
    case front
    case rear
}

enum RecordStatus {
    case active
    case passive
}

enum ColorPalettes {
    case palette1
    case palette2
    case palette3
}

enum ApiGatewayClientErrors: Swift.Error {
    case missingUserId
    case missingGroupId
}

enum ClientPresentErrors: Swift.Error {
    case missingViewControllerPurpose
    case missingViewControllerChoise
    case missingGroupObject
    case missingGroupNameViewModel
    case missingGroupViewModel
    case missingGroupImageViewModel
    case missingGroupInfoEditViewModel
}

enum CastingErrors: Swift.Error {
    case groupObjectCastFailed
}

enum CustomVideoError: Swift.Error {
    case videoSessionAlreadyRunning
    case videoSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case noMicrophoneAvailable
    case unknown
    case previewLayerIsMissing
}

enum CustomCameraError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

enum DelegationErrors: Swift.Error {
    case ShareDataProtocolsDelegateIsNil
    case PermissionProtocolDelegateIsNil
    case CustomCameraViewIsNil
}

enum FacebookThrowableErrors: Swift.Error {
    case GraphRequestCreationFailed
}

enum CircleAnimationProcess {
    case start
    case stop
    case progress
}

enum PostAttachmentTypes {
    case publicPost
    case friends
    case group
    case onlyMe
    case allFollowers
}

enum TransitionDirection {
    case left
    case rigth
    case up
    case down
}

enum PanDirections {
    case left
    case rigth
    case up
    case down
}

enum NotificationIdentifiers : String {
    case tryAgain = "tryAgain"
    case allRigth = "allRigth"
    case mainCategory = "mainCategory"
}

enum SlideMenuViewTags {
    case explore
    case viewPendingFriendRequests
    case manageGroupOperations
    case settings
}

enum ExploreType {
    case facebook
    case contact
}

enum TableViewState: String {
    
    case suggest
    case loading
    case populate
    case empty
    case error
    
}

enum TableViewSectionTitle : String {
    case Friends
    case Groups
    case None = ""
    case SearchResult = "Search Result"
}

enum TableViewRowSelected : String {
    case selected
    case deSelected
}

enum CollectionViewActivation : String {
    case enable
    case disable
}

enum CollectionViewState: String {
    case suggest
    case loading
    case populate
    case empty
    case error
}

enum CollectionViewOperation {
    case insert
    case delete
    case none
}

enum SearchableModes {
    case searchable
    case unSearchable
}

enum SearcMode {
    case active
    case passive
}

enum FriendRelationViewPurpose {
    case post
    case groupManagement
}

enum GroupImageProcess {
    case exit
    case start
}

enum GroupDetailSectionTypes {
    case name
    case admin
    case participant
    case exit
}

enum CRUD_OperationStates {
    case processing
    case done
}
