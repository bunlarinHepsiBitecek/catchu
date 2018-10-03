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

class FirebaseManager {
    
    public static let shared = FirebaseManager()
    
    typealias TokenCompletion = (_ tokenResult : AuthTokenResult, _ finished : Bool) -> Void
    
    func logout() {
        do
        {
            try Auth.auth().signOut()
            redirectSignin()
        } catch let error as NSError {
            print(error.localizedDescription)
            print("logout is failed")
        }
    }
    
    // MARK: if user not sigin, redirect loginVC
    func redirectSignin() {
        if (Auth.auth().currentUser == nil) {
            User.shared = User()
            LoaderController.changeRootNavigationController(controller: LoginViewController())
        }
    }
    
    // MARK: push mainVC
    func redirectSigned() {
        if (Auth.auth().currentUser != nil) {
            LoaderController.changeRootMainTabBarController()
        }
    }
    
    func loginFirebase(user: User) {
        LoaderController.shared.showLoader(style: .gray)
        
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (userData, error) in
            if let error = error {
                self.handleError(error: error)
                LoaderController.shared.removeLoader()
                return
            }
            
            if let userData = userData {
                print("REMZI Login Success: full:\(userData.user)")
                if let email = userData.user.email {
                    User.shared.email = email
                }
                User.shared.userID = userData.user.uid
                let providerData = userData.user.providerData[0]
                User.shared.providerID = userData.user.uid
                User.shared.provider = providerData.providerID
            }
            LoaderController.shared.removeLoader()
        }
    }
    
    func loginWithFacebookAccount() {
        guard let currentVC = LoaderController.currentViewController() else {
            print("Current View controller can not be found for \(String(describing: self))")
            return
        }
        
        let facebookLogin = FBSDKLoginManager()
        let permissions = [FacebookPermissions.email,
                           FacebookPermissions.public_profile,
                           FacebookPermissions.user_friends]
        let parameterKey = FacebookPermissions.parameter_key
        let parameterValue = FacebookPermissions.parameter_value
        let method = FacebookPermissions.method
        
        facebookLogin.logIn(withReadPermissions: permissions, from: currentVC) { (result, error) in
            if let error = error {
                self.handleError(error: error)
                return
            }
            if (result?.isCancelled)! {
                return
            } else {
                guard let accessToken = FBSDKAccessToken.current().tokenString else {return}
                
                let req = FBSDKGraphRequest(graphPath: "me", parameters: [parameterKey: parameterValue], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: method)
                
                req?.start(completionHandler: { (connection, result, error) in
                    if let error = error {
                        self.handleError(error: error)
                    } else {
                        print("GET request success result: \(String(describing: result))")
                        
                        if let data = result as? NSDictionary {
                            self.parseFacebookGraph(data: data)
                            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                            self.firebaseSocialAuth(credential)
                        }
                    }
                })
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
                let credential = TwitterAuthProvider.credential(withToken: (session.authToken), secret: (session.authTokenSecret))
                User.shared.userName = session.userName
                self.firebaseSocialAuth(credential)
            } else {
                AlertViewManager.show(type: .error, placement: .top, title: LocalizedConstants.Error, body: LocalizedConstants.FirebaseError.SocialLoginError)
            }
        })
        twitterLoginButton.sendActions(for: .touchUpInside)
    }
    
    private func firebaseSocialAuth(_ credential: AuthCredential) {
        LoaderController.shared.showLoader(style: .gray)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authData, error) in
            if let error = error {
                self.handleError(error: error)
            } else {
                self.signidUserSync(authData: authData)
            }
            LoaderController.shared.removeLoader()
        }
    }
    
    private func signidUserSync(authData: AuthDataResult?) {
        if let user = authData?.user {
            User.shared.userID = user.uid
            if let displayName = user.displayName {
                User.shared.name = displayName
            }
            let providerData = user.providerData[0]
            User.shared.providerID = providerData.uid
            User.shared.provider = providerData.providerID
            if let email = providerData.email {
                User.shared.email = email
            }
            if let photoUrl = providerData.photoURL {
                // in twitter image url return
                // https://pbs.twimg.com/profile_images/1029101800446672896/rhgFoAYM_normal.jpg
                // https://graph.facebook.com/10155522219482546/picture?type=large
                
                var orginalUrl = photoUrl.absoluteString
                if (providerData.providerID.contains("facebook")) {
                    orginalUrl = orginalUrl + "?type=large"
                } else {
                    orginalUrl = orginalUrl.replacingOccurrences(of: "_normal", with: "")
                }
                
                User.shared.profilePictureUrl = orginalUrl
                print("profile image url: \(orginalUrl)")
                print("provider: \(User.shared.provider)")
                print("providerId: \(User.shared.providerID)")
            }
            REAWSManager.shared.loginSync(user: User.shared) { [weak self] result in
                self?.handleResult(result)
            }
            
        }
    }
        
    func handleResult(_ result: NetworkResult<REBaseResponse>) {
        switch result {
        case .success(let response):
            if let error = response.error, let code = error.code, code != BackEndAPIErrorCode.success.rawValue  {
                print("Lambda Error: \(error)")
                guard let message = error.message else { return }
                AlertViewManager.show(type: .error, body: message)
                return
            }
            self.redirectSigned()
        case .failure(let apiError):
            switch apiError {
            case .serverError(let error):
                print("Server error: \(error)")
            case .connectionError(let error) :
                print("Connection error: \(error)")
            case .missingDataError:
                print("Missing Data Error")
            }
        }
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
//                        CloudFunctionsManager.shared.createUserProfileModel()
                        
                    }
                    
                    // TODO: new feature check
                    guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
                    changeRequest.displayName = user.userName
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                            print("Firebase changeRequest error: \(error)")
                        }
                    }
                }
                
            }
            
            LoaderController.shared.removeLoader()
        }
    }
    
    func handleError(error: Error) {
        print("error: \(String(describing: error))");
        if let errorCode = error as NSError? {
            if errorCode.code == 1 { // no Error
                return
            }
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
//            let className = ""
//            let eventName = className + "_" + callerFunctionName
//            Analytics.logEvent(eventName, parameters: [
//                "email": User.shared.email,
//                "password": User.shared.password])
        }
        
    }
    
    func getIdToken(completion : @escaping TokenCompletion) {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        currentUser.getIDTokenResult { (result, error) in
            if let error = error {
                self.handleError(error: error)
                LoaderController.shared.removeLoader()
                return
                
            } else {
                
                guard let result = result else { return }
                completion(result, true)
            }
        }
    }
    
    func checkUserLoggedIn() -> Bool {
        if let currentUser = Auth.auth().currentUser {
            User.shared.userID = currentUser.uid
            print("User.shared.userID : \(User.shared.userID)")
            return true
        } else {
            return false
        }
    }
}

extension FirebaseManager {
    
    func parseFacebookGraph(data: NSDictionary) {
        User.shared.userName = "" // no longer return username
        
        if let email = data[FacebookPermissions.email]  as? String {
            User.shared.email = email
        }
        if let name = data[FacebookPermissions.name]  as? String {
            User.shared.name = name
        }
        if let providerID = data[FacebookPermissions.id]  as? String {
            User.shared.providerID = providerID
        }
    }
}


struct FacebookPermissions {
    static let email               = "email"
    static let name                = "name"
    static let id                  = "id"
    static let public_profile      = "public_profile"
    static let user_friends        = "user_friends"
    static let parameter_key       = "fields"
    static let parameter_value     = "id, name, short_name, email"
    static let method              = "GET"
}
