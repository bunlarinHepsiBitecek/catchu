//
//  LocalizedConstants.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

struct LocalizedConstants {
    static let Ok = NSLocalizedString("OK", comment: "")
    static let UnknownError = NSLocalizedString("UnknownError", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Warning = NSLocalizedString("Warning", comment: "")
    static let DefaultError = NSLocalizedString("DefaultError", comment: "")
    
    struct Network {
        static let NoInternetConnection        = NSLocalizedString("NoInternetConnection", comment: "")
        static let NoInternetConnectionMessage = NSLocalizedString("NoInternetConnectionMessage", comment: "")
    }
    
    struct Login {
        static let Email           = NSLocalizedString("Email", comment: "")
        static let Password        = NSLocalizedString("Password", comment: "")
        static let Login           = NSLocalizedString("Login", comment: "").uppercased(with: NSLocale.current)
        static let ForgotPassword  = NSLocalizedString("ForgotPassword", comment: "")
        static let Register        = NSLocalizedString("Register", comment: "")
        static let DontHaveAccount = NSLocalizedString("DontHaveAccount", comment: "")
        
        static let EmptyEmail      = NSLocalizedString("EmptyEmail", comment: "")
        static let EmptyPassword   = NSLocalizedString("EmptyPassword", comment: "")
        static let InvalidEmail    = NSLocalizedString("InvalidEmail", comment: "")
        static let InvalidPassword = NSLocalizedString("InvalidPassword", comment: "")
    }
    
    struct PasswordReset {
        static let PasswordResetMailSend = NSLocalizedString("PasswordResetMailSend", comment: "")        
    }
    
    struct Register {
        static let UserName        = NSLocalizedString("UserName", comment: "")
        static let Email           = NSLocalizedString("Email", comment: "")
        static let Password        = NSLocalizedString("Password", comment: "")
        static let Register        = NSLocalizedString("Register", comment: "")
        
        static let EmptyUserName   = NSLocalizedString("EmptyUserName", comment: "")
    }
    
    struct FirebaseError {
        
        static let accountExistsWithDifferentCredential =   
            NSLocalizedString("accountExistsWithDifferentCredential", comment: "")
        static let credentialAlreadyInUse =
            NSLocalizedString("credentialAlreadyInUse", comment: "")
        static let emailAlreadyInUse =
            NSLocalizedString("emailAlreadyInUse", comment: "")
        static let invalidCredential =
            NSLocalizedString("invalidCredential", comment: "")
        static let invalidEmail =
            NSLocalizedString("invalidEmail", comment: "")
        static let userNotFound =
            NSLocalizedString("userNotFound", comment: "")
        static let unknownError = NSLocalizedString("unknownError", comment: "")
    
    }
    
    struct AWSError {
        
        static let confirmationCodeRequired = NSLocalizedString("confirmationCodeRequired", comment: "")
        static let confirmationFailed = NSLocalizedString("confirmationFailed", comment: "")
        
    }
    
    struct TitleValues {
        
        struct ButtonTitle {
            
            static let cancel = NSLocalizedString("cancel", comment: "")
            static let next = NSLocalizedString("next", comment: "")
            static let createGroup = NSLocalizedString("createGroup", comment: "")
            static let friend = NSLocalizedString("Friends", comment: "")
            static let group = NSLocalizedString("Groups", comment: "")
            static let newGroup = NSLocalizedString("New Group", comment: "")
            static let add = NSLocalizedString("Add", comment: "")
            static let makeGroupAdmin = NSLocalizedString("makeGroupAdmin", comment: "")
            static let RemoveFromGroup = NSLocalizedString("RemoveFromGroup", comment: "")
            static let gotoInfo = NSLocalizedString("gotoInfo", comment: "")
            static let notNow = NSLocalizedString("notNow", comment: "")
            static let giveAccess = NSLocalizedString("giveAccess", comment: "")
            static let enableAccessGallery = NSLocalizedString("enableAccessGallery", comment: "")
            static let enableAccessCamera = NSLocalizedString("enableAccessCamera", comment: "")
            static let enableAccessMicrophone = NSLocalizedString("enableAccessMicrophone", comment: "")
            
        }
        
        struct LabelTitle {

            static let addParticipantOrGroup = NSLocalizedString("addParticipantOrGroup", comment: "")
            static let addParticipant = NSLocalizedString("addParticipant", comment: "")
            static let groupInformation = NSLocalizedString("groupInformation", comment: "")
            static let createGroupName = NSLocalizedString("createGroupName", comment: "")
            static let saved = NSLocalizedString("saved", comment: "")
            static let failed = NSLocalizedString("failed", comment: "")
            
        }
    }
    
    struct Location {
        static let LocationServiceDisableTitle = NSLocalizedString("LocationServiceDisableTitle", comment: "")
        static let LocationServiceDisable      = NSLocalizedString("LocationServiceDisable", comment: "")
        static let Settings                    = NSLocalizedString("Settings", comment: "")
        static let Ok                          = NSLocalizedString("OK", comment: "")
    }
    
    struct SearchBar {
        static let searchResult = NSLocalizedString("Search Result", comment: "")
        static let searching = NSLocalizedString("searching", comment: "")
        static let searchingFor = NSLocalizedString("searchingFor", comment: "")
    }
    
    struct Library {
        static let AccessLibraryDisableTitle   = NSLocalizedString("AccessLibraryDisableTitle", comment: "")
        static let AccessLibraryDisable        = NSLocalizedString("AccessLibraryDisable", comment: "")
        static let Settings                    = NSLocalizedString("Settings", comment: "")
        static let Ok                          = NSLocalizedString("OK", comment: "")
        static let CameraNotAvaliableTitle     = NSLocalizedString("CameraNotAvaliableTitle", comment: "")
        static let CameraNotAvaliable          = NSLocalizedString("CameraNotAvaliable", comment: "")
    }
    
    struct Share {
        static let MissingData = NSLocalizedString("MissingData", comment: "")
        static let NoShareData = NSLocalizedString("NoShareData", comment: "")
        static let Ok = NSLocalizedString("OK", comment: "")
    }
    
    struct PermissionStatements {
    
        static let topicLabelForCamera = NSLocalizedString("topicLabelForCamera", comment: "")
        static let detailLabelForCamera = NSLocalizedString("detailLabelForCamera", comment: "")
        static let topicLabelForPhotos = NSLocalizedString("topicLabelForPhotos", comment: "")
        static let detailLabelForPhotos = NSLocalizedString("detailLabelForPhotos", comment: "")
        static let topicLabelForMicrophone = NSLocalizedString("topicLabelForMicrophone", comment: "")
        static let detailLabelForMicrophone = NSLocalizedString("detailLabelForMicrophone", comment: "")
    
    }
    
    struct Feed {
        static let Loading = NSLocalizedString("Loading", comment: "")
        static let More = NSLocalizedString("More", comment: "")
        static let Comments = NSLocalizedString("Comments", comment: "")
        static let AddComment = NSLocalizedString("AddComment", comment: "")
        static let Send = NSLocalizedString("Send", comment: "")
        static let Reply = NSLocalizedString("Reply", comment: "")
        
    }
    
    struct Notification {
        
        static let CatchSomething = NSLocalizedString("CatchSomething", comment: "")
        
    }
    
    struct Contact {
        
        static let addFriend = NSLocalizedString("addFriend", comment: "")
        static let friends = NSLocalizedString("friends", comment: "")
        static let requested = NSLocalizedString("requested", comment: "")
        
    }
    
    struct PickerControllerStrings {
        
        static let chooseProfilePicture = NSLocalizedString("chooseProfilePicture", comment: "")
        static let takePhoto = NSLocalizedString("takePhoto", comment: "")
        static let chooseFromLibrary = NSLocalizedString("chooseFromLibrary", comment: "")
        static let helpCatchU = NSLocalizedString("helpCatchU", comment: "")
        
    }
    
    struct EditableProfileView {
        
        static let Name = NSLocalizedString("Name", comment: "")
        static let Username = NSLocalizedString("Username", comment: "")
        static let Website = NSLocalizedString("Website", comment: "")
        static let Bio = NSLocalizedString("Bio", comment: "")
        static let Birthday = NSLocalizedString("Birthday", comment: "")
        static let Email = NSLocalizedString("Email", comment: "")
        static let Phone = NSLocalizedString("Phone", comment: "")
        static let Gender = NSLocalizedString("Gender", comment: "")
        
    }
    
    
    
}
