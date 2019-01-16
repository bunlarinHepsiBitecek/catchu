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
    static let Cancel = NSLocalizedString("Cancel", comment: "")
    static let UnknownError = NSLocalizedString("UnknownError", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Warning = NSLocalizedString("Warning", comment: "")
    static let DefaultError = NSLocalizedString("DefaultError", comment: "")
    static let Loading = NSLocalizedString("Loading", comment: "")
    
    struct Network {
        static let NoInternetConnection        = NSLocalizedString("NoInternetConnection", comment: "")
        static let NoInternetConnectionMessage = NSLocalizedString("NoInternetConnectionMessage", comment: "")
    }
    
    struct Login {
        static let UserName         = NSLocalizedString("UserName", comment: "")
        static let Email            = NSLocalizedString("Email", comment: "")
        static let Password         = NSLocalizedString("Password", comment: "")
        static let Login            = NSLocalizedString("Login", comment: "")
        static let ForgotPassword   = NSLocalizedString("ForgotPassword", comment: "")
        static let DontHaveAccount  = NSLocalizedString("DontHaveAccount", comment: "")
        static let Register         = NSLocalizedString("Register", comment: "")
        static let Reset            = NSLocalizedString("Reset", comment: "")
        static let Confirm          = NSLocalizedString("Confirm", comment: "")
        static let ConfirmationCode = NSLocalizedString("ConfirmationCode", comment: "")
        static let ResendConfirmationCode = NSLocalizedString("ResendConfirmationCode", comment: "")
        
        static let EmptyEmail       = NSLocalizedString("EmptyEmail", comment: "")
        static let EmptyPassword    = NSLocalizedString("EmptyPassword", comment: "")
        static let InvalidEmail     = NSLocalizedString("InvalidEmail", comment: "")
        static let InvalidPassword  = NSLocalizedString("InvalidPassword", comment: "")
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
        
        static let unknownError = NSLocalizedString("UnknownError", comment: "")
        static let SocialLoginError = NSLocalizedString("SocialLoginError", comment: "")
        static let AccountExistsWithDifferentCredential =
            NSLocalizedString("AccountExistsWithDifferentCredential", comment: "")
        static let CredentialAlreadyInUse =
            NSLocalizedString("CredentialAlreadyInUse", comment: "")
        static let EmailAlreadyInUse =
            NSLocalizedString("EmailAlreadyInUse", comment: "")
        static let InvalidCredential =
            NSLocalizedString("InvalidCredential", comment: "")
        static let InvalidEmail =
            NSLocalizedString("InvalidEmail", comment: "")
        static let UserNotFound =
            NSLocalizedString("UserNotFound", comment: "")
        
        static let InvalidPhoneNumber =
            NSLocalizedString("InvalidPhoneNumber", comment: "")
        static let InvalidVerificationID =
            NSLocalizedString("InvalidVerificationID", comment: "")
        static let InvalidVerificationCode =
            NSLocalizedString("InvalidVerificationCode", comment: "")
        static let SessionExpiredForVerificationCode =
            NSLocalizedString("SessionExpiredForVerificationCode", comment: "")
    }
    
    struct AWSError {
        
        static let confirmationCodeRequired = NSLocalizedString("confirmationCodeRequired", comment: "")
        static let confirmationFailed = NSLocalizedString("confirmationFailed", comment: "")
        
    }
    
    struct TitleValues {
        
        struct ButtonTitle {
            
            static let cancel = NSLocalizedString("Cancel", comment: "")
            static let next = NSLocalizedString("next", comment: "")
            static let createGroup = NSLocalizedString("createGroup", comment: "")
            static let friend = NSLocalizedString("Friends", comment: "")
            static let group = NSLocalizedString("Groups", comment: "")
            static let newGroup = NSLocalizedString("New Group", comment: "")
            static let add = NSLocalizedString("Add", comment: "")
            static let done = NSLocalizedString("done", comment: "")
            static let makeGroupAdmin = NSLocalizedString("makeGroupAdmin", comment: "")
            static let RemoveFromGroup = NSLocalizedString("RemoveFromGroup", comment: "")
            static let gotoInfo = NSLocalizedString("gotoInfo", comment: "")
            static let notNow = NSLocalizedString("notNow", comment: "")
            static let giveAccess = NSLocalizedString("giveAccess", comment: "")
            static let enableAccessGallery = NSLocalizedString("enableAccessGallery", comment: "")
            static let enableAccessCamera = NSLocalizedString("enableAccessCamera", comment: "")
            static let enableAccessMicrophone = NSLocalizedString("enableAccessMicrophone", comment: "")
            static let tryAgain = NSLocalizedString("tryAgain", comment: "")
            static let connectToFacebook = NSLocalizedString("connectToFacebook", comment: "")
            
        }
        
        struct LabelTitle {

            static let addParticipantOrGroup = NSLocalizedString("addParticipantOrGroup", comment: "")
            static let addParticipant = NSLocalizedString("addParticipant", comment: "")
            static let groupInformation = NSLocalizedString("groupInformation", comment: "")
            static let createGroupName = NSLocalizedString("createGroupName", comment: "")
            static let saved = NSLocalizedString("saved", comment: "")
            static let failed = NSLocalizedString("failed", comment: "")
            static let fetched = NSLocalizedString("fetched", comment: "")
            static let fetching = NSLocalizedString("fetching", comment: "")
            static let followers = NSLocalizedString("followers", comment: "")
            static let following = NSLocalizedString("following", comment: "")
            
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
        static let NoPostFound = NSLocalizedString("NoPostFound", comment: "")
        static let NoResultFound = NSLocalizedString("NoResultFound", comment: "")
        static let CatchU = NSLocalizedString("CatchU", comment: "")
        static let Loading = LocalizedConstants.Loading + "..."
        static let More = NSLocalizedString("More", comment: "")
        static let Comments = NSLocalizedString("Comments", comment: "")
        static let AddComment = NSLocalizedString("AddComment", comment: "")
        static let Send = NSLocalizedString("Send", comment: "")
        static let Reply = NSLocalizedString("Reply", comment: "")
        static let Report = NSLocalizedString("Report", comment: "")
        static let ItSpam = NSLocalizedString("ItSpam", comment: "")
        static let ItInappropriate = NSLocalizedString("ItInappropriate", comment: "")
        static let TurnOnComments = NSLocalizedString("TurnOnComments", comment: "")
        static let TurnOffComments = NSLocalizedString("TurnOffComments", comment: "")
        static let Delete = NSLocalizedString("Delete", comment: "")
    }
    
    struct Like {
        static let Loading = LocalizedConstants.Loading + "..."
        static let Likes = NSLocalizedString("Likes", comment: "")
        static let Follow = NSLocalizedString("Follow", comment: "")
        static let Following = NSLocalizedString("Following", comment: "")
        static let Requested = NSLocalizedString("Requested", comment: "")
        static let Unfollow = NSLocalizedString("Unfollow", comment: "")
    }
    
    struct Profile {
        static let Loading = LocalizedConstants.Loading + "..."
        static let SendMessage = NSLocalizedString("Profile_Send_Message", comment: "")
        static let Followers = NSLocalizedString("Profile_Followers", comment: "")
        static let Following = NSLocalizedString("Profile_Following", comment: "")
        static let Posts = NSLocalizedString("Profile_Posts", comment: "")
        static let CaughtPosts = NSLocalizedString("Profile_Caught_Posts", comment: "")
        static let Groups = NSLocalizedString("Profile_Groups", comment: "")
        
        static let ChangePhoto = NSLocalizedString("Profile_Change_Photo", comment: "")
        static let Name = NSLocalizedString("Profile_Name", comment: "")
        static let Username = NSLocalizedString("Profile_Username", comment: "")
        static let Website = NSLocalizedString("Profile_Website", comment: "")
        static let Bio = NSLocalizedString("Profile_Bio", comment: "")
        static let Email = NSLocalizedString("Profile_Email", comment: "")
        static let Phone = NSLocalizedString("Profile_Phone", comment: "")
        static let Gender = NSLocalizedString("Profile_Gender", comment: "")
        static let Birthday = NSLocalizedString("Profile_Birthday", comment: "")
        static let GenderMale = NSLocalizedString("Profile_Gender_Male", comment: "")
        static let GenderFemale = NSLocalizedString("Profile_Gender_Female", comment: "")
        static let GenderUnspecified = NSLocalizedString("Profile_Gender_Unspecified", comment: "")
    }
    
    struct Notification {
        
        static let CatchSomething = NSLocalizedString("CatchSomething", comment: "")
        static let postSuccessMessage = NSLocalizedString("postSuccessMessage", comment: "")
        static let postTitle = NSLocalizedString("postTitle", comment: "")
        static let postFailedMessage = NSLocalizedString("postFailedMessage", comment: "")
        
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
        static let Next = NSLocalizedString("Next", comment: "")
        static let SelectCountry = NSLocalizedString("SelectCountry", comment: "")
        static let AllCountries = NSLocalizedString("AllCountries", comment: "")
        static let WillReceiveSMS = NSLocalizedString("WillReceiveSMS", comment: "")
        static let Confirm          = NSLocalizedString("Confirm", comment: "")
        static let ConfirmationCode = NSLocalizedString("ConfirmationCode", comment: "")
        static let ResendConfirmationCode = NSLocalizedString("ResendConfirmationCode", comment: "")
    }
    
    struct PostAttachments {

        static let friends = NSLocalizedString("friends", comment: "")
        static let group = NSLocalizedString("group", comment: "")
        static let publicInfo = NSLocalizedString("public", comment: "")
        static let onlyMe = NSLocalizedString("onlyMe", comment: "")
        
    }
    
    struct PostAttachmentInformation {
        
        static let publicInformation = NSLocalizedString("publicInformation", comment: "")
        static let onlyMeInformation = NSLocalizedString("onlyMeInformation", comment: "")
        static let gettingGroup = NSLocalizedString("gettingGroup", comment: "")
        static let gettingFriends = NSLocalizedString("gettingFriends", comment: "")
        static let thereIsNothingToPost = NSLocalizedString("thereIsNothingToPost", comment: "")
        static let saySomething = NSLocalizedString("saySomething", comment: "")
        
    }
    
    struct Cloud {
        static let cloudFetching = NSLocalizedString("cloudFetching", comment: "")
    }
    
    struct SlideMenu {
        static let explorePeople = NSLocalizedString("explorePeople", comment: "")
        static let facebook = NSLocalizedString("facebook", comment: "")
        static let contacts = NSLocalizedString("contacts", comment: "")
        static let facebookFriendRequest = NSLocalizedString("facebookFriendRequest", comment: "")
        static let findFriendSuggestion = NSLocalizedString("findFriendSuggestion", comment: "")
        
    }
    
}
