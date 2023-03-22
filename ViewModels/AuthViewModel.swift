//
//  AuthViewModel.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreSwift
//import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit
import CommonCrypto

enum AuthState{
    case loading, logged, unlogged, pendingInformation
}

class AuthViewModel: NSObject, ObservableObject{
    private let db = Firestore.firestore()
    private let userId: String? = Auth.auth().currentUser?.uid
    private let profileViewModel : ProfilesViewModel = ProfilesViewModel()
    private var currentNonce: String?

    @Published var authState: AuthState = .loading
    @Published var error: Error?
    @Published var isWorking = false
    
    private var newLocalUser = LocalUser.Data()
    
    @StateObject var localStore : LocalStore = LocalStore()
    @AppStorage("hasCheckedPendingInfo") private var hasCheckedPendingInfo: Bool = false

 
    
    func updateAuthState(){
        print("Entering AuthState")
        if(Auth.auth().currentUser != nil && hasCheckedPendingInfo){
            print("Logged in sign in")
            
//            let id = profileViewModel.fetchUserId()
//          
//            profileViewModel.fetchUser(id: id) { result in
//                switch result {
//                    
//                case .success(let user):
//                    let newUser = LocalUser(id: id, groupId: user.groupId ?? "", userInfo: user)
//                    
//                    self.localStore.localUser.append(newUser)
//                    
//                case .failure(let error):
//                    print("error fetching users in authiewmodel \(error)")
//  
//                }
//            }
                self.authState = .logged
                print("user called to update local")
            
        } else if(Auth.auth().currentUser != nil && !hasCheckedPendingInfo){
            print("Account exists signing")
            let userId: String = Auth.auth().currentUser!.uid
            db.collection("users_v2").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    print("After document in signin")
                    self.signIn()
                } else {
                    self.authState = .pendingInformation
                }
            }
        } else {
            print("We are here")
            self.authState = .unlogged
        }
        print("The end")
    }
    func signInWithApple() {
//        if authState == .logged{
//            print("apple already logged")
//            return
//        }
        let request = createAppleIDRequest()
        performSignIn(using: [request])
    }
    
    func signUpWithApple() {
        let request = createAppleIDRequest()
        request.requestedScopes = [.fullName, .email]
        performSignIn(using: [request])
    }
    private func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let nonce = randomNonceString()
            request.nonce = sha256(nonce)
            currentNonce = nonce
            return request
        }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }


    func signInWithGoogle(controller: UIViewController){
//        if authState == .logged {
//            return
//        }
//
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: controller) { user, error in
//
//          if let error = error {
//              print(error.localizedDescription)
//            return
//          }
//
//          guard let authentication = user?.authentication, let idToken = authentication.idToken else {
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//
//
//        Auth.auth().signIn(with: credential){ result, error in
//            if let error = error {
//                print(error.localizedDescription)
//              return
//            }
//            self.updateAuthState()
//        }
//        }
    }

    func signInWithEmail(controller: UIViewController, email: String, password:String, onCompletion:@escaping(Result<Void,DomainError>)->()){
        if authState == .logged{
            print("ALready logged")
            return
        }
        
        print("Signing In with Email")
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            if let error = error {
                print(error.localizedDescription)
                onCompletion(.failure(.downloadError))
            }
            else if user != nil {
                self.updateAuthState()
                onCompletion(.success(()))
            }
        }
        
    }
    func createAccountWithEmail(controller: UIViewController, name: String, email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.updateAuthState()
        }
    }
    
    func signIn(){
        print("Loggin in")
        self.hasCheckedPendingInfo = true
        self.authState = .logged
    }
    
    func signOut(){
        
        if userId != nil {
            
            print("tokens removed")
            db.collection("fcmTokens").document(userId!).delete()

        }

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.hasCheckedPendingInfo = false
            self.authState = .unlogged
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
    
    
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
//            guard let fullName = appleIDCredential.fullName else {
//                print("Unable to fetch full name from apple id credential")
//                return
//            }
//            guard let email = appleIDCredential.email else {
//                print("Unable to fetch email from apple id credential")
//                return
//            }
            
            // Initialize a Firebase credential with the Apple ID token and nonce
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Sign in with Firebase using the credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // Check if user is signing up or signing in
                if let newUser = authResult?.additionalUserInfo?.isNewUser, newUser {
//                    let db = Firestore.firestore()
                    self.updateAuthState()

                } else {
                    
                         
                         print("Signing In with Apple")
                      
                                 self.updateAuthState()
                         }

                 }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error.localizedDescription)")
    }
}

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                fatalError("No active UIWindow found")
            }
            return window
        }
}
