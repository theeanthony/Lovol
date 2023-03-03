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

enum AuthState{
    case loading, logged, unlogged, pendingInformation
}

class AuthViewModel: NSObject, ObservableObject {
    private let db = Firestore.firestore()
    private let userId: String? = Auth.auth().currentUser?.uid
    private let profileViewModel : ProfilesViewModel = ProfilesViewModel()
    
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
    func checkInvites(number:String,onCompletion:@escaping(Result<[InviteModel],DomainError>)->()){
        
//        let email : String = Auth.auth().currentUser?.email ?? ""
        var invites : [InviteModel] = []
//        if email == "" {
//            onCompletion(.success([]))
//        }
        
        let inviteRef = db.collection("pending_invites").whereField("receivingEmailAddress", isEqualTo: number)
        
        inviteRef.getDocuments { query, error in
            guard let documents = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            var count = 0
            let maxCount = documents.count
            
            for document in documents.documents {
                
                let teamName = document.get("teamName") as! String
                let groupId = document.get("groupId") as! String
                let receivingEmail = document.get("receivingEmailAddress") as! String
                let sendingEmail = document.get("sendingEmailAddress") as! String
                let inviteName  = document.get("inviteName") as! String
                let id = document.get("id") as! String
                
                let invite : InviteModel = InviteModel(groupId: groupId, teamName: teamName, inviteName: inviteName, receivingEmailAddress: receivingEmail, sendingEmailAddress: sendingEmail, id:id)
                
                invites.append(invite)
                
                count += 1
                
                if count == maxCount {
                    onCompletion(.success(invites))
                    return
                }


            }
            
            
        }
        
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
//        self.updateAuthState()
        
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
    
//    @MainActor func makeNewProfile() -> FormViewModel<FirestoreUser> {
//        return FormViewModel(
//            initialValue: FirestoreUser(name: "", birthDate: Date(), bio: "", isMale: false, orientation: Orientation.both, liked: [], passed: []),
//            action: { [weak self] user in
//                try await self?.db.collection("users_v1").document(self!.userId!).setData(user.dictionary)
//            }
//        )
//    }
    
    

    
    func signIn(){
        print("Loggin in")
        self.hasCheckedPendingInfo = true
        self.authState = .logged
    }
    
    func signOut(){
        
        if userId != nil {
            
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
