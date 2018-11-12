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
            let transition = LoaderTransition(direction: .toBottom, style: .easeInOut)
            LoaderController.setRootViewController(controller: LoginViewController(), transition: transition)
        }
    }
    
    // MARK: push mainVC
    func redirectSigned() {
        if (Auth.auth().currentUser != nil) {
            let name = Constants.Storyboard.Name.Main
            let identifier = Constants.Storyboard.ID.MainTabBarViewController
            let transition = LoaderTransition(direction: .toTop, style: .easeInOut)
            LoaderController.setRootViewControllerForStoryboard(name: name, identifier: identifier, transition: transition)
        }
    }
    
    func loginFirebase(user: User) {
        LoaderController.shared.showLoader(style: .gray)
        guard let email = user.email else { return }
        guard let password = user.password else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (userData, error) in
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
                User.shared.userid = userData.user.uid
                let providerData = userData.user.providerData[0]
                User.shared.providerID = userData.user.uid
                User.shared.provider = providerData.providerID
                self.signidUserSync(authData: userData)
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
                
                let req = FBSDKGraphRequest(graphPath: FacebookPermissions.me, parameters: [parameterKey: parameterValue], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: method)
                
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
                User.shared.username = session.userName
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
            User.shared.userid = user.uid
            if let displayName = user.displayName {
                User.shared.name = displayName
            }
            let providerData = user.providerData[0]
            User.shared.providerID = providerData.uid
            User.shared.provider = getProviderType(providerData.providerID)
            
            if let email = providerData.email {
                User.shared.email = email
            }
            if let photoUrl = providerData.photoURL {
                // in twitter image url return
                // https://pbs.twimg.com/profile_images/1029101800446672896/rhgFoAYM_normal.jpg
                // https://graph.facebook.com/10155522219482546/picture?type=large
                
                var orginalUrl = photoUrl.absoluteString
                
                if (User.shared.provider == ProviderType.facebook.rawValue ) {
                    orginalUrl = orginalUrl + "?type=large"
                } else if (User.shared.provider == ProviderType.facebook.rawValue) {
                    orginalUrl = orginalUrl.replacingOccurrences(of: "_normal", with: "")
                }
                
                User.shared.profilePictureUrl = orginalUrl
                print("profile image url: \(orginalUrl)")
                print("provider: \(User.shared.provider ?? "")")
                print("providerId: \(User.shared.providerID ?? "")")
            }
            REAWSManager.shared.loginSync(user: User.shared) { [weak self] result in
                self?.handleResult(result)
                LoaderController.shared.removeLoader()
            }
        }
    }
    
    private func getProviderType(_ provider: String) -> String {
        var providerType = ProviderType.firebase.rawValue
        
        if provider.contains(ProviderType.facebook.rawValue) {
            providerType = ProviderType.facebook.rawValue
        } else if provider.contains(ProviderType.twitter.rawValue) {
            providerType = ProviderType.twitter.rawValue
        }
        return providerType
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
        
        LoaderController.shared.showLoader()
        
        guard let email = user.email else { return }
        guard let password = user.password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            
            if let error = error {
                
                if let errorCode = error as NSError? {
                    self.handleFirebaseError(error: errorCode)
                }
            }
            
            if let authData = authData {
                
                if let userID = authData.user.uid as String? {
                    
                    print("userID : \(userID)")
                    User.shared.userid = userID
                    //                        CloudFunctionsManager.shared.createUserProfileModel()
                    
                }
                
                // TODO: new feature check
                guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
                changeRequest.displayName = user.username
                changeRequest.commitChanges { (error) in
                    if let error = error {
                        print("Firebase changeRequest error: \(error)")
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
            self.handleFirebaseError(error: errorCode)
        }
    }
    
    func handleFirebaseError(error: NSError) {
        guard let firebaseErrorCode = Firebase.AuthErrorCode(rawValue: error.code) else { return }
        
        var errorTitle = LocalizedConstants.Error
        var errorMessage = error.localizedDescription
        
        switch firebaseErrorCode {
        case .accountExistsWithDifferentCredential:
            errorMessage = LocalizedConstants.FirebaseError.AccountExistsWithDifferentCredential
        case .credentialAlreadyInUse:
            errorMessage = LocalizedConstants.FirebaseError.CredentialAlreadyInUse
        case .emailAlreadyInUse:
            errorMessage = LocalizedConstants.FirebaseError.EmailAlreadyInUse
        case .invalidCredential:
            errorMessage = LocalizedConstants.FirebaseError.InvalidCredential
        case .invalidEmail, .missingEmail:
            errorMessage = LocalizedConstants.FirebaseError.InvalidEmail
        case .userNotFound:
            errorMessage = LocalizedConstants.FirebaseError.UserNotFound
        case .invalidPhoneNumber, .missingPhoneNumber:
            errorMessage = LocalizedConstants.FirebaseError.InvalidPhoneNumber
        case .invalidVerificationID, .missingVerificationID:
            errorMessage = LocalizedConstants.FirebaseError.InvalidVerificationID
        case .invalidVerificationCode, .missingVerificationCode:
            errorMessage = LocalizedConstants.FirebaseError.InvalidVerificationCode
        case .sessionExpired:
            errorMessage = LocalizedConstants.FirebaseError.SessionExpiredForVerificationCode
        default:
            errorTitle = LocalizedConstants.Error
            errorMessage = error.localizedDescription
        }
        AlertViewManager.shared.createAlert(title: errorTitle, message: errorMessage, preferredStyle: .alert, actionTitle: LocalizedConstants.Ok, actionStyle: .default, completionHandler: nil)
    }
    
    typealias TokenCompletion = (_ tokenResult: AuthTokenResult, _ finished: Bool) -> Void
    
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
            User.shared.userid = currentUser.uid
            return true
        } else {
            return false
        }
    }
}

extension FirebaseManager {
    
    struct FacebookPermissions {
        static let me                  = "me"
        static let email               = "email"
        static let name                = "name"
        static let id                  = "id"
        static let public_profile      = "public_profile"
        static let user_friends        = "user_friends"
        static let parameter_key       = "fields"
        static let parameter_value     = "id, name, short_name, email"
        static let method              = "GET"
        static let pathMe_Friends = "me/friends"
        static let parameterValueForFriends = "id, name, short_name, picture"
    }
    
    func parseFacebookGraph(data: NSDictionary) {
//        User.shared.username = "" // no longer return username
        
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

extension FirebaseManager {
    
    typealias PhoneCompletion = (_ verificationId: String) -> Void
    typealias ConfirmationCompletion = (_ success: Bool) -> Void
    
    func phoneSendSMSVerification(phoneNum: String, completion : @escaping PhoneCompletion) {
        
        // for test
        if let settings = Auth.auth().settings {
            print("Test Phone Setting var")
            settings.isAppVerificationDisabledForTesting = true
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                self.handleError(error: error)
                return
            }
            
            if let verificationId = verificationID {
                print("Successfully verificationId: \(verificationId)")
                completion(verificationId)
            }
        }
    }
    
    func phoneSMSConfirmation(verificationId: String, verificationCode: String, completion : @escaping ConfirmationCompletion) {
        
        // This test verification code is specified for the given test phone number in the developer console.
//        let testVerificationCode = "123456"
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
        
        print("credential.provider: \(credential.provider)")
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authData, error) in
            if let error = error {
                self.handleError(error: error)
                completion(false)
                return
            if let authData = authData {
                print("Userid: \(authData.user.uid)")
                print("phoneNumber: \(authData.user.phoneNumber)")
                completion(true)
            }
            completion(false)
        }
    }
    
    static let pathMe_Friends = "me/friends"
    static let parameterValueForFriends = "id, name, short_name, picture"
}

