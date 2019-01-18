//
//  Constants.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/26/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

struct Constants {
    // https://picsum.photos/45/45/?random
    static let LOCALTEST = true
    static let CATCHU = "CatchU"
    static let TWITTER_CUSTOMER_KEY = "qSautcd7v9cuWd3FlH55HLBN6"
    static let TWITTER_CUSTOMER_SECRETKEY = "UQuANLyZKPCW3lRoagkc5VHGrLEYyLbMsXf0UVnkrcEThaJyEl"
    static let AWS_PATH_EMPTY = "empty" // used for aws lambda path param empty
    static let ALERT = "ALERT\t"
    static let CRASH_WARNING = "Something goes terribly wrong!"
    static let DEFAULT_PATH_EXT_JPG = "jpg"
    
    static let ScreenBounds = UIScreen.main.bounds
    
    struct Bundle {
        struct Path {
            static let Country = "Catchu.bundle/Data/countryCodes"
        }
        struct FileType {
            static let Json = "json"
        }
    }
    
    struct UIDesignConstant {
        static let PlaceHolderColor: UIColor = UIColor.lightGray
    }
    
    struct CharacterConstants {
        static let SPACE: String = " "
        static let EMPTY: String = ""
    }
    struct NumericConstants {
        static let INTEGER_ZERO: Int   = 0
        static let INTEGER_ONE : Int = 1
        static let INTEGER_TWO : Int = 2
        static let INTEGER_FOUR : Int = 4
        static let DOUBLE_ZERO: Double = 0.0
        static let DOUBLE_ONE: Double = 1.0
        static let FLOAT_ZERO: Float   = 0.0
        static let MAX_LETTER_COUNT_25 = 25
        
        struct GeoFireUnits {
            static let GEOFIRE_QUERY_RADIUS : Double = 0.05
        }
        
    }
    
    struct TableViewEditingStyleButtons {
        
        static let Info = "Info"
        static let Delete = "Delete"
        static let More = "More..."
        
    }
    
    struct AlertControllerConstants {
        
        struct Titles {
            
            static let titleSpace = " "
            static let titleGroupInfo = "Group Info"
            static let titleExitGroup = "Exit Group"
            static let titleCancel = "Cancel"
            
        }
        
    }
    
    struct StaticViewSize {
        struct ImageViewSize {
            static let profilePicture_150 : CGFloat = 150
            static let profilePicture_100 : CGFloat = 100
        }
        
        struct BorderWidth {
            static let borderWidth_1 : CGFloat = 1
            static let borderWidth_2 : CGFloat = 2
            static let borderWidth_4 : CGFloat = 4
            static let borderWidth_5 : CGFloat = 5
        }
        
        struct CorderRadius {
            static let cornerRadius_75 : CGFloat = 75
            static let cornerRadius_61 : CGFloat = 61
            static let cornerRadius_51 : CGFloat = 51
            static let cornerRadius_50 : CGFloat = 50
            static let cornerRadius_40 : CGFloat = 40
            static let cornerRadius_35 : CGFloat = 35
            static let cornerRadius_30 : CGFloat = 30
            static let cornerRadius_28 : CGFloat = 28
            static let cornerRadius_25 : CGFloat = 25
            static let cornerRadius_23 : CGFloat = 23
            static let cornerRadius_20 : CGFloat = 20
            static let cornerRadius_18 : CGFloat = 18
            static let cornerRadius_15 : CGFloat = 15
            static let cornerRadius_12 : CGFloat = 12
            static let cornerRadius_11 : CGFloat = 11
            static let cornerRadius_10 : CGFloat = 10
            static let cornerRadius_8 : CGFloat = 8
            static let cornerRadius_5 : CGFloat = 5
            static let cornerRadius_4 : CGFloat = 4
        }
        
        struct ViewSize {
            struct Width {
                static let width_300 : CGFloat = 300
                static let width_250 : CGFloat = 250
                static let width_200 : CGFloat = 200
                static let width_180 : CGFloat = 180
                static let width_150 : CGFloat = 150
                static let width_102 : CGFloat = 102
                static let width_100 : CGFloat = 100
                static let width_90 : CGFloat = 90
                static let width_80 : CGFloat = 80
                static let width_70 : CGFloat = 70
                static let width_60 : CGFloat = 60
                static let width_56 : CGFloat = 56
                static let width_50 : CGFloat = 50
                static let width_48 : CGFloat = 48
                static let width_44 : CGFloat = 44
                static let width_40 : CGFloat = 40
                static let width_36 : CGFloat = 36
                static let width_30 : CGFloat = 30
                static let width_24 : CGFloat = 24
                static let width_22 : CGFloat = 22
                static let width_20 : CGFloat = 20
                static let width_16 : CGFloat = 16
                static let width_10 : CGFloat = 10
            }
            struct Height {
                static let height_300 : CGFloat = 300
                static let height_250 : CGFloat = 250
                static let height_220 : CGFloat = 220
                static let height_200 : CGFloat = 200
                static let height_180 : CGFloat = 180
                static let height_150 : CGFloat = 150
                static let height_110 : CGFloat = 110
                static let height_105 : CGFloat = 105
                static let height_102 : CGFloat = 102
                static let height_100 : CGFloat = 100
                static let height_90 : CGFloat = 90
                static let height_80 : CGFloat = 80
                static let height_75 : CGFloat = 75
                static let height_70 : CGFloat = 70
                static let height_60 : CGFloat = 60
                static let height_56 : CGFloat = 56
                static let height_50 : CGFloat = 50
                static let height_48 : CGFloat = 48
                static let height_44 : CGFloat = 44
                static let height_40 : CGFloat = 40
                static let height_36 : CGFloat = 36
                static let height_30 : CGFloat = 30
                static let height_25 : CGFloat = 25
                static let height_24 : CGFloat = 24
                static let height_22 : CGFloat = 22
                static let height_20 : CGFloat = 20
                static let height_16 : CGFloat = 16
                static let height_15 : CGFloat = 15
                static let height_10 : CGFloat = 10
                static let height_5 : CGFloat = 5
                static let height_3 : CGFloat = 3
                static let height_2 : CGFloat = 2
                static let height_1 : CGFloat = 1
                static let height_0 : CGFloat = 0
            }
        }
        
        struct ConstraintValues {
            static let constraint_250 : CGFloat = 250
            static let constraint_200 : CGFloat = 200
            static let constraint_150 : CGFloat = 150
            static let constraint_100 : CGFloat = 100
            static let constraint_90 : CGFloat = 90
            static let constraint_85 : CGFloat = 85
            static let constraint_80 : CGFloat = 80
            static let constraint_70 : CGFloat = 70
            static let constraint_60 : CGFloat = 60
            static let constraint_51 : CGFloat = 51
            static let constraint_50 : CGFloat = 50
            static let constraint_44 : CGFloat = 44
            static let constraint_42 : CGFloat = 42
            static let constraint_40 : CGFloat = 40
            static let constraint_30 : CGFloat = 30
            static let constraint_25 : CGFloat = 25
            static let constraint_20 : CGFloat = 20
            static let constraint_15 : CGFloat = 15
            static let constraint_10 : CGFloat = 10
            static let constraint_5 : CGFloat = 5
            static let constraint_1 : CGFloat = 1
            static let constraint_0 : CGFloat = 0
        }
        
    }
    
    
    
    struct colorPaletteCellSize {
        
        static let colorPaletteContainerCellHeigth : CGFloat = 30
        static let colorCellWidth : CGFloat = 24
        static let colorCellHeigth : CGFloat = 24
        static let innerCellMinimumInteritemSpacing : CGFloat = 2
        
    }
    
    struct AnimationValues {
        
        static let aminationTime_07 : TimeInterval = 0.7
        static let aminationTime_05 : TimeInterval = 0.5
        static let aminationTime_03 : TimeInterval = 0.3
        static let aminationTime_02 : TimeInterval = 0.2
        static let aminationTime_01 : TimeInterval = 0.1
        static let timeInterval_1 : TimeInterval = 1
     
    }
    
    struct CameraZoomScale {
        
        static let deviceInitialZoomScale_01 : CGFloat = 1.0
        static let maximumZoomScale_05 : CGFloat = 5.0
        
    }
    
    struct MediaLibrary {
        static let ImageFetchLimit = 11
        static let ImageFetchLimit20 = 20
        static let ImageFetchLimit100 = 100
        static let ImageHolderSize: CGSize    = CGSize(width: 50.0, height: 50.0)
        static let ImageSmallSize: CGSize = CGSize(width: 200.0, height: 200.0)
    }
    
    struct Map {
        static let DistanceFilter: Double = 10.0
        static let ZoomDegree: Double = 0.02
        static let ZoomDegree_0_0025: Double = 0.0025
        static let Radius: Double = 0.10
    }
    
    struct Feed {
        static let Padding: CGFloat = 10.0
        static let ImageWidthHeight: CGFloat = 50
        static let ReadMoreCaracterCount: Int = 120
        static let ReadMoreFont: UIFont = UIFont.systemFont(ofSize: 14)
        static let ReadMoreColor: UIColor = UIColor.lightGray
        static let ReadMoreUnderlineColor: UIColor = UIColor.clear
        static let DefaultImageExtension: String = "jpg"
        static let DefaultVideoExtension: String = "mov"
    }
    
    struct Profile {
        static let Padding: CGFloat = 20.0
        static let ImageWidthHeight: CGFloat = 50
        static let GroupTableWidth: CGFloat = 136
        static let GroupTableHeight: CGFloat = 176
        static let CollectionMinimumLineSpacing: CGFloat = 1
        static let CollectionItemPerLine: CGFloat = 3
    }
    
    struct Relation {
        static let Follow = "FOLLOW"
        static let Following = "FOLLOWING"
        static let Pending = "PENDING"
        static let Own = "OWN"
    }
    
    struct Segue {
        static let RegisterView = "segueToRegisterView"
        static let PasswwordResetView = "segueToPasswordResetView"
        static let SegueToFriend = "segueToFriend"
        static let SegueToGroup = "segueToGroup"
        static let confirmSignUpSegue = "confirmSignUpSegue"
        static let SegueToSearch = "SegueToSearch"
    }
    
    struct Storyboard {
        struct ID {
            static let MainTabBarViewController = "MainTabBarViewController"
        }
        
        struct Name {
            static let Login = "Login"
            static let Main  = "Main"
            static let Contact = "Contact"
            static let Profile = "Profile"
        }
        
    }
    
    struct Cell {
        static let ShareCollectionViewCell        = "ShareCollectionViewCell"
        static let ShareCollectionViewItemPerLine = CGFloat(4)
        static let ShareCollectionViewItemSpace   = CGFloat(1)
        static let imageCollectionViewCellWidth = CGFloat(92)
        static let imageCollectionViewCellHeigth = CGFloat(92)
        static let imageCollectionViewMinLineSpacing_01 : CGFloat = 1
        static let imageCollectionViewEdgeInsets_02 : CGFloat = 2
        static let imageCollectionViewMaxCellCount : CGFloat = 4
        static let minimumLineSpacing_Zero : CGFloat = 0
        static let minimumLineSpacing_10 : CGFloat = 10
        static let minimumLineSpacing_5 : CGFloat = 5
        static let numberOfItemPerRow_3 : Int = 3
    }
    
    struct FirebaseCallableFunctions {
        
        static let createUserProfile = "createUserProfile"
        static let updateUserProfile = "updateUserProfile"
        static let getFriends = "getFriends"
        static let setNewShareData = "setNewShareData"
        static let getShareDataByUserNameAndShareID = "getShareDataByUserNameAndShareID"
        static let getShareDataByShareID = "getShareDataByShareID"
    }
    
    struct FirebaseModelConstants {
        
        struct UserModelConstants {
            
            static let userID: String = "userId"
            static let userName: String = "userName"
            static let email: String = "email"
            
        }
        
        struct ShareModelConstants {
            
            static let shareId: String = "shareId"
            static let imageUrl : String = "imageUrl"
            static let textScreenShotUrl : String = "textScreenShotUrl"
            static let videoScreenShotUrl : String = "videoScreenShotUrl"
            static let Text: String = "text"
            static let imageUrlSmall : String = "imageUrlSmall"
        }
        
        struct PathNames {
            
            static let Media = "Media"
            static let Share = "Share"
            static let TextScreenShots = "TextScreenShots"
            static let Images = "Images"
            
        }
        
        struct ModelNames {
            
            static let GeoFire = "GeoFire"
            static let GeoFireModel = "GeoFireModel"
            static let ShareData    = "ShareData"
        }
        
    }
    
//    struct FirebaseCallableFunctions {
//
//        static let createUserProfile = "createUserProfile"
//        static let updateUserProfile = "updateUserProfile"
//        static let getFriends = "getFriends"
//        static let setNewShareData = "setNewShareData"
//        static let getShareDataByUserNameAndShareID = "getShareDataByUserNameAndShareID"
//        static let getShareDataByShareID = "getShareDataByShareID"
//    }
    
//    struct FirebaseModelConstants {
//
//        struct UserModelConstants {
//
//            static let userID: String = "userId"
//            static let userName: String = "userName"
//            static let email: String = "email"
//
//        }
//
//        struct ShareModelConstants {
//
//            static let shareId: String = "shareId"
//            static let imageUrl : String = "imageUrl"
//            static let textScreenShotUrl : String = "textScreenShotUrl"
//            static let videoScreenShotUrl : String = "videoScreenShotUrl"
//            static let Text: String = "text"
//            static let imageUrlSmall : String = "imageUrlSmall"
//        }
        
//        struct PathNames {
//
//            static let Media = "Media"
//            static let Share = "Share"
//            static let TextScreenShots = "TextScreenShots"
//            static let Images = "Images"
//
//        }
//
//        struct ModelNames {
//
//            static let GeoFire = "GeoFire"
//            static let GeoFireModel = "GeoFireModel"
//            static let ShareData    = "ShareData"
//        }
//
//    }
    
    struct StoryBoardID {
        
        static let Contact: String = "Contact"
        static let Main: String = "Main"
        static let Login: String = "Login"
        
    }
    
    struct ViewControllerIdentifiers {
        
        static let ContactViewController: String = "ContactViewController"
        static let ContactViewController2: String = "ContactViewController2"
        static let FeedViewController: String = "FeedViewController"
        static let SearchViewController: String = "SearchViewController"
        static let GroupInformationViewController: String = "GroupInformationViewController"
        static let GroupImageViewController: String = "GroupImageViewController"
        static let SubjectChangeViewController: String = "SubjectChangeViewController"
        static let GroupCreateViewController: String = "GroupCreateViewController"
        static let ShareDataViewController: String = "ShareDataViewController"
        static let ShareDataViewController2: String = "ShareDataViewController2"
        static let FinalShareInfoViewController: String = "FinalShareInfoViewController"
        static let FinalNoteViewController: String = "FinalNoteViewController"
        static let ExplorePeopleViewController: String = "ExplorePeopleViewController"
        static let PostViewController: String = "PostViewController"
        
    }
    
    struct Collections {
        
        struct CollectionView {
            
            static let collectionViewCellFriend: String = "collectionViewCellFriend"
            static let collectionViewCellProfileView: String = "collectionViewCellProfileView"
            static let collectionViewCellProfileViewChoise: String = "collectionViewCellProfileViewChoise"
            static let collectionViewDataPageCell1: String = "dataPageCell1"
            static let collectionViewDataPageCell2: String = "dataPageCell2"
            static let collectionViewDataPageCell3: String = "dataPageCell3"
            static let collectionViewDataPageCell4: String = "dataPageCell4"
            static let collectionViewDataItemCell1: String = "itemCell1"
            static let collectionViewDataItemCell2: String = "itemCell2"
            static let collectionViewDataItemCell3: String = "itemCell3"
            static let collectionViewDataItemCell4: String = "itemCell4"
            static let groupCreateSelectedParticipantCell: String = "groupCreateSelectedParticipantCell"
            static let sliderShareTypeCell : String = "sliderShareTypeCell"
            static let shareFunctionCell : String = "shareFunctionCell"
            static let textCell : String = "textCell"
            static let cameraGalleryCell : String = "cameraGalleryCell"
            static let videoCell : String = "videoCell"
            static let imageCell : String = "imageCell"
            static let photoCell : String = "photoCell"
            static let photoLibraryCell : String = "photoLibraryCell"
            static let permissinWarningCell : String = "permissinWarningCell"
            static let colorPaletteCell : String = "colorPaletteCell"
            static let colorContainerCell : String = "colorContainerCell"
            static let selectedItemImageCell: String = "selectedItemImageCell"
            static let selectedItemVideoCell : String = "selectedItemVideoCell"
            static let filterColorCell : String = "filterColorCell"
            static let exploreChoiseCollectionViewCell : String = "exploreChoiseCollectionViewCell"
            
        }
        
        struct TableView {
            
            static let tableViewCellFriend: String = "tableViewCellFriend"
            static let tableViewCellGroup: String = "tableViewCellGroup"
            static let tableViewCellSearchResult: String = "tableViewCellSearchResult"
            static let tableViewCellSearchProcess: String = "tableViewCellSearchProcess"
            static let tableViewCellProfileView: String = "tableViewCellProfileView"
            static let tableViewCellProfileViewChoise: String = "tableViewCellProfileViewChoise"
            static let participantListCell: String = "participantListCell"
            static let groupInfoCell: String = "groupInfoCell"
            static let groupCreateCell: String = "groupCreateCell"
            static let groupCreateHeaderCell: String = "groupCreateHeaderCell"
            static let slideMenuTableViewCell : String = "slideMenuTableViewCell"
            static let facebookContactTableViewCell : String = "facebookContactTableViewCell"
            static let contactSyncedTableViewCell : String = "contactSyncedTableViewCell"
            static let contactTableViewCell : String = "contactTableViewCell"
            
        }
        
    }
    
    struct NumericValues {
        
        static let rowHeight : CGFloat = 60.0
        static let rowHeight50 : CGFloat = 50.0
        static let rowHeightSearch : CGFloat = 80.0
        
    }
    
    struct NotificationCenterConstants {
        
        static let refreshCounterValues : String = "refreshCounterValues"
        
    }
    
    struct searchBarProperties {
        
        static let searchField : String = "searchField"
        
    }
    
    struct NotificationConstants {
        
        static let requestIdentifier : String = "LocalNotificationRequest"
        
    }
    
    struct AwsApiGatewayHttpRequestParameters {
        
        struct RequestOperationTypes {
            
            struct Friends {
                static let followRequest : String = "followRequest"
                static let acceptRequest : String = "acceptRequest"
                static let requestingFollowList : String = "requestingFollowList"
                static let createFollowDirectly : String = "createFollowDirectly"
                static let deleteFollow : String = "deleteFollow"
                static let deletePendingFollowRequest : String = "deletePendingFollowRequest"
            }
            
            struct Groups {
                static let GET_AUTHENTICATED_USER_GROUP_LIST : String = "GET_AUTHENTICATED_USER_GROUP_LIST"
            }
            
        }
        
    }
    
    struct CognitoConstants {
        
//        static let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast1
//        static let CognitoIdentityUserPoolId = "us-east-1_8vIETg4na"
//        static let CognitoIdentityUserPoolAppClientId = "6suvju4eei3rl04coscm3aseqf"
//        static let CognitoIdentityUserPoolAppClientSecret = "1e3hjodip2bcosarvvh0qsnks0jj46m12orlu3piieof2qeki9rd"
//        
//        static let AWSCognitoUserPoolsSignInProviderKey = "UserPool"
        
    }
    
    struct NumberOrSections {
        
        static let section0 = 0
        static let section1 = 1
        static let section2 = 2
        static let section3 = 3
        static let section4 = 4
        static let section5 = 5
        static let section6 = 6
        static let section7 = 7
        static let section8 = 8
        static let section9 = 9
        static let section10 = 10
        static let section11 = 11
        static let section12 = 12
        static let section13 = 13
        static let section14 = 14
        static let section15 = 15
        static let section16 = 16
        static let section17 = 17
        static let section18 = 18
        static let section19 = 19
        static let section20 = 20
        static let section21 = 21
        static let section22 = 22
        static let section23 = 23
        static let section24 = 24
        static let section25 = 25
        static let section26 = 26
        static let section27 = 27
        static let section28 = 28
        static let section29 = 29
        static let section30 = 30
        
    }

    struct LetterConstants {
        
        static let A = "A"
        static let B = "B"
        static let C = "C"
        static let D = "D"
        static let E = "E"
        static let F = "F"
        static let G = "G"
        static let H = "H"
        static let I = "I"
        static let J = "J"
        static let K = "K"
        static let L = "L"
        static let M = "M"
        static let N = "N"
        static let O = "O"
        static let P = "P"
        static let Q = "Q"
        static let R = "R"
        static let S = "S"
        static let T = "T"
        static let U = "U"
        static let V = "V"
        static let W = "W"
        static let X = "X"
        static let Y = "Y"
        static let Z = "Z"
        
    }
    
    struct Login {
        static let Padding: CGFloat = 20
        static let Height: CGFloat = 50
    }
    
    struct ImageResizeValues {
        struct Height {
            static let height_1080 : CGFloat = 1080
            static let height_1440 : CGFloat = 1440
        }
        
        struct Width {
            static let width_1080 : CGFloat = 1080
            static let width_1440 : CGFloat = 1440
        }
    }
}
