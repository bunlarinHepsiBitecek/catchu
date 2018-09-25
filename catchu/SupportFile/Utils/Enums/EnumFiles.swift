//
//  EnumFiles.swift
//  catchu
//
//  Created by Erkut Baş on 6/9/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

enum PrivacyType: String {
    case everyone
    case allFollowers
    case custom
    case myself
    
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

