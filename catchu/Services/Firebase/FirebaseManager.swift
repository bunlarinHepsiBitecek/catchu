//
//  FirebaseManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 5/27/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import MapKit
import GeoFire

class FirebaseManager {
    
    public static let shared = FirebaseManager()
    
    func logout() {
        do
        {
            try Auth.auth().signOut()
            userSignOut()
            print("logout is ok")
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            print("logout is failed")
        }
    }
    
    // MARK: if user not sigin, redirect loginVC
    func userSignOut() {
        if (Auth.auth().currentUser == nil) {
            User.shared = User()
            LoaderController.shared.goToLoginViewController()
        }
    }
    
    func checkUserLoggedIn() {
        
        if Auth.auth().currentUser != nil {
            
            User.shared.userID = (Auth.auth().currentUser?.uid)!
            
            CloudFunctionsManager.shared.getFriends()
            
            // MARK: direct to MainVC
            LoaderController.shared.goToMainViewController()
            
        } else {
            
            LoaderController.shared.goToLoginViewController()
            
        }
    }
    
  
    
    // MARK: push mainVC
    func userSigned() {
//        if (Auth.auth().currentUser != nil) {
            LoaderController.shared.appDelegate().window?.rootViewController = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.ID.MainTabBarViewController)
            LoaderController.shared.appDelegate().window?.rootViewController?.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    func loginUser(user: User) {
        LoaderController.shared.showLoader()
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (userData, error) in
            if let error = error {
                self.handleError(error: error)
                LoaderController.shared.removeLoader()
                return
            }
            
            if let userData = userData {
                print("user successfully login uid: \(userData.user.uid)")
                print("REMZI: full:\(userData.user)")
                User.shared.userID = userData.user.uid
                User.shared.email = userData.user.email ?? Constants.CharacterConstants.SPACE
                User.shared.userName = userData.user.displayName ?? Constants.CharacterConstants.SPACE
                User.shared.providerID = userData.user.providerID
                User.shared.provider = ProviderType.firebase.rawValue
                LoaderController.shared.goToMainViewController()
            }
            LoaderController.shared.removeLoader()
        }
    }
    
    func loginWithFacebookAccount() {
        let currentVC = getPresentViewController()
        
        let facebookLogin = FBSDKLoginManager()
        let permissions = [FacebookPermissions.email,
                           FacebookPermissions.public_profile,
                           FacebookPermissions.user_friends]
        
        facebookLogin.logIn(withReadPermissions: permissions, from: currentVC) { (result, error) in
            if let error = error {
                self.handleError(error: error)
                return
            }
            if (result?.isCancelled)! {
                print("Remzi: User cancel facebook login")
                return
            } else {
                print("***** Token: \(FBSDKAccessToken.current().tokenString)")
                guard let accessToken = FBSDKAccessToken.current().tokenString else {return}
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, short_name, email"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                let connection = FBSDKGraphRequestConnection()
                
                connection.add(request, completionHandler: { (connection, result, error) in
                    if(error != nil) {
                        print("GET request error: \(String(describing: error))")
                    } else {
                        print("GET request success result: \(String(describing: result))")
                        
                        let data = result as! NSDictionary
                        
                        print("result as a data form: \(data)")
                        
                        self.parseFacebookGraph(data: data, provider: .facebook)
                        // aşağıdaki FacebookAuthProvider firebase'e ait bir kütüphane
                        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                        self.firebaseAuth(credential)
                        
                    }
                })
                connection.start()
                
                
            }
        }
    }
    
    // MARK: Handle event with twitter button
    func loginWithTwitterAccount() {
        let twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
            if let error = error {
                self.handleError(error: error)
                return
            }
            
            if let session = session {
                print("REMZİ Twitter dönen session: \(String(describing: session))")
                print("signed in as \(String(describing: session.userName))");
                
                TWTRAPIClient.withCurrentUser().requestEmail { email, error in
                    if (email != nil) {
                        print("get email user: \(String(describing: session.userName)) and email: \(String(describing: email))");
                        let credential = TwitterAuthProvider.credential(withToken: (session.authToken), secret: (session.authTokenSecret))
                        User.shared.userName = session.userName
                        self.firebaseAuth(credential)
                        
                        
                    } else {
                        print("get email error: \(String(describing: error?.localizedDescription))");
                    }
                }
                
            }
        })
        twitterLoginButton.sendActions(for: .touchUpInside)
    }
    
    private func firebaseAuth(_ credential: AuthCredential) {
        LoaderController.shared.showLoader()
        Auth.auth().signInAndRetrieveData(with: credential) { (userInfo, error) in
            if let error = error {
                print("REMZİ: Unable to authenticate with Firebase")
                print(error)
            } else {
                print("REMZİ: Successfullty authenticate with Firebase")
                if let user = userInfo?.user {
                    print("REMZI1: \(user.providerID)")
                    print("REMZI2: \(user.uid)")
                    print("REMZI3: \(user.email)")
                    print("REMZI4: \(user.displayName)")
                    print("REMZI5: \(user.isEmailVerified)")
                    User.shared.userID = user.uid
                    User.shared.provider = user.providerID
                    LoaderController.shared.goToMainViewController()
                }
            }
        }
        LoaderController.shared.removeLoader()
    }
    
    
    func parseFacebookGraph(data: NSDictionary, provider: ProviderType) {
        User.shared.provider = provider.rawValue
        
        if let email = data["email"]  as? String {
            User.shared.email = email
        }
        if let name = data["name"]  as? String {
            User.shared.name = name
        }
        
        if let providerID = data["id"]  as? String {
            User.shared.providerID = providerID
        }
    }
    
    // MARK: find current VC
    private func getPresentViewController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    
    func registerFirebase(user: User) {
        
        user.toString()
        
        LoaderController.shared.showLoader()
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (userData, error) in
            
            if error != nil {
                
                if let errorCode = error as NSError? {
                    
                    if let firebaseErrorCode = Firebase.AuthErrorCode(rawValue: errorCode.code){
                        let functionName = String(#function.split(separator: "(")[0])
                        self.handleFirebaseErrorCodes(errorCode: firebaseErrorCode, functionName)
                    }
                    
                }
                
            } else {
                
                if let userData = userData {
                    
                    if let userID = userData.user.uid as String? {
                        
                        print("userID : \(userID)")
                        User.shared.userID = userID
                        CloudFunctionsManager.shared.createUserProfileModel()
                        
                    }
                    
                }
                
            }
            
            LoaderController.shared.removeLoader()
        }
    }
    
    func handleError(error: Error) {
        print("error: \(String(describing: error.localizedDescription))");
        if let errorCode = error as NSError? {
            if let firebaseErrorCode = Firebase.AuthErrorCode(rawValue: errorCode.code){
                let functionName = String(#function.split(separator: "(")[0])
                self.handleFirebaseErrorCodes(errorCode: firebaseErrorCode, functionName)
            }
        }
    }
    
    func handleFirebaseErrorCodes(errorCode: AuthErrorCode,_ callerFunctionName: String) {
        
        switch errorCode {
        case .accountExistsWithDifferentCredential:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.accountExistsWithDifferentCredential, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        case .credentialAlreadyInUse:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.credentialAlreadyInUse, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        case .emailAlreadyInUse:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.emailAlreadyInUse, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        case .invalidCredential:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.invalidCredential, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        case .invalidEmail:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.invalidEmail, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        case .userNotFound:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.userNotFound, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
            
        default:
            AlertViewManager.shared.createAlert(title: LocalizedConstants.Error, message: LocalizedConstants.FirebaseError.unknownError, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
//            let className = type(of: self)
            let className = ""
            let eventName = className + "_" + callerFunctionName
            Analytics.logEvent(eventName, parameters: [
                "email": User.shared.email,
                "password": User.shared.password])
        }
        
    }
    
    func uploadImages(image : UIImage, completion : @escaping (_ downloadUrl : URL) -> Void) {
        LoaderController.shared.startProgressView(progressViewStyle: .bar)
        
        let imageId = NSUUID().uuidString
        
        let storageReference = Storage.storage().reference().child(Constants.FirebaseModelConstants.PathNames.Share).child(Constants.FirebaseModelConstants.PathNames.Media).child(Constants.FirebaseModelConstants.PathNames.Images).child("\(imageId).png")
        
        if let uploadData = UIImagePNGRepresentation(image) {
            
            let uploadTask = storageReference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                LoaderController.shared.removeProgressView()
                
                // check metadata exists
                guard metadata != nil else {
                    return
                }
                
                if error != nil {
                    
                    if let errorMessage = error as NSError? {
                        
                        print("loadPinImageToStorage error")
                        print("errorMessage : \(errorMessage.localizedDescription)")
                        print("errorMessage : \(errorMessage.userInfo)")
                    }
                    
                } else {
                    
                    storageReference.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            return
                        }
                        
                        completion(downloadURL)
                    }
                }
                
            })
            
            uploadTask.observe(.progress) { snapshot in
                // Upload reported progress
                let progress = Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                let percentComplete = 100.0 * progress
                print("percentComplete: \(percentComplete) progresss: \(progress)")
                LoaderController.shared.progressCounter = percentComplete
            }
        }
        
    }
    
    func createGeofireData(selectedUserArray : [User]) {
        for item in selectedUserArray {
            
            let geofireReference = GeoFire(firebaseRef: Database.database().reference().child(Constants.FirebaseModelConstants.ModelNames.GeoFireModel).child(item.userID))
            
            // key value is getting as an input, in this case it must be shareId
            geofireReference.setLocation(Share.shared.location, forKey: Share.shared.shareId)
        }
    }
    
    func getGeoFireData(currentLocation : CLLocation, completion : @escaping (_ result : Bool) -> Void) {
    
        print("getGeoFireData starts")
        
        let firebaseReference = Database.database().reference().child(Constants.FirebaseModelConstants.ModelNames.GeoFireModel).child(User.shared.userID)
        
        let geoFire = GeoFire(firebaseRef: firebaseReference)
        
        let regionQuery = geoFire.query(at: currentLocation, withRadius: Constants.NumericConstants.GeoFireUnits.GEOFIRE_QUERY_RADIUS)
        
        regionQuery.observe(.keyEntered) { (key, location) in
            
            print("key : \(key)")
            print("location : \(location)")
            
            GeoFireData.shared.locationID = key
            GeoFireData.shared.coordinateData = location
            
            GeoFireData.shared.appendElementToGeoFireDictionary(key: key, value: GeoFireData.shared)
            
        }
        
        regionQuery.observeReady {

            print("kakakakakakakakakakakakakakakakakakakakakakakk")
            completion(true)

//            if GeoFireData.shared.geofireDictionary.count > 0 {
//
//                completion(true)
//
//            }

        }
    }
}


struct FacebookPermissions {
    static let email = "email"
    static let public_profile = "public_profile"
    static let user_friends = "user_friends"
}

public enum ProviderType: String  {
    case facebook, twitter, firebase
}

struct DenemeObject: Decodable {
    let name: String?
    let surname: String?
    let age: Int?
}
