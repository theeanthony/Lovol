//
//  Lovol.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//


import SwiftUI
import Firebase
import UserNotifications
import UIKit

import FirebaseMessaging
import FirebaseCore
import FirebaseDynamicLinks

//import GoogleSignIn

@main
struct lovol: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()

    @StateObject var authViewModel = AuthViewModel()
    @StateObject var firestoreViewModel = FirestoreViewModel()
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var profileViewModel = ProfilesViewModel()
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var requestViewModel = RequestViewModel()
    @Environment(\.openURL) var openURL
    @State private var shouldShowInviteAlert = false
    @State private var teamName : String = ""
    @State private var teamId : String = ""
    
//    @StateObject private var store = LocalStore()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(firestoreViewModel)
                .environmentObject(locationViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(eventViewModel)
                .environmentObject(requestViewModel)
                .environmentObject(appState)

                .onOpenURL { url in
                    print("URL \(url.absoluteString)")
                    
                    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                       let queryItems = components.queryItems {
                        
                        for item in queryItems {
                            print("name: \(item.name), value: \(item.value ?? "")")
                        }
                        
                        if let link = components.queryItems?.first(where: { $0.name == "link" })?.value,
                           let linkComponents = URLComponents(string: link),
                           let groupID = linkComponents.queryItems?.first(where: { $0.name == "groupID" })?.value {
                            print("groupid: \(groupID)")
                            if groupID != ""{
                                if authViewModel.authState == .logged {
                                    // check if already in team
                                    profileViewModel.fetchMember { result in
                                        switch result{
                                        case .success(let member):
                                            if member.groupId == "" {
                                                profileViewModel.fetchTeam(id: groupID) { result in
                                                    switch result{
                                                        
                                                    case .success(let team):
                                                        
                                                        if team.teamMemberIDS.count == 6 {
                                                            return
                                                        }
                                                        self.teamName = team.teamName
                                                        self.teamId = groupID
                                                        self.shouldShowInviteAlert = true
                                                        
                                                        //show invite label alert
                                                       
                                                        
                                                    case .failure(let error):
                                                        print("error feching team \(error)")
                                                        return
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print("error fetching member to check foro team \(error)")
                                            return
                                        }
                                    }
                                    
                                    //check if team is full before joining
                                }
                            }
       
                            
                        } else {
                            print("group id not found")
                        }
                    }
                }
      
                .sheet(isPresented: $shouldShowInviteAlert, content: {
                    InviteAlertView(teamName:$teamName, groupId:$teamId, isPresented: $shouldShowInviteAlert)
                        .environmentObject(profileViewModel)
                        .environmentObject(appState)

                        .presentationDetents([.medium])


                })
            





        }
    }  
}
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, open urls: URL) {
        print("this is handling urls ")
            print("Unhandled: \(urls)")    // << here !!
        }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("Failed to request authorization for notifications: \(error.localizedDescription)")
                }
            }
        )

        application.registerForRemoteNotifications()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let launchOptions = launchOptions,
           let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
            self.application(application, open: url, options: [:])
        }
        
        // Set the root view controller

      return true
    }
    
    func handleIncomingDynamicLink(_ dynamicLink:DynamicLink){
        print("Handle incoming dynamic link")
        guard let url = dynamicLink.url else {
            print("no object in url")
            return
        }
        print("incoming link parameter \(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return
        }
        for queryItem in queryItems {
            print("parameter \(queryItem.name) has value of \(queryItem.value ?? "")")
        }
//        dynamicLink.matchType
    }

     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void ) -> Bool {
        print("opening url ")
        if let incomingURL = userActivity.webpageURL{
            print("Incoming url is \(incomingURL)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    print("found an error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled{
                print("link handled")
                return true
            } else {
                print("link not handled")
                return false
            }
        }
        return false
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received a url from custom scheme \(url.absoluteString)")

        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            print("in here")
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            if url.scheme == "messages" {
                // Handle custom URL scheme
                print("url scheme is messages")
                
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                            
                if let pathComponents = urlComponents?.path.split(separator: "/"), pathComponents.count == 3 {
                    let senderId = pathComponents[1]
                    let recipientId = pathComponents[2]
                    
                    print("senderId: \(senderId), recipientId: \(recipientId)")
                    let newWindow = UIWindow(frame: UIScreen.main.bounds)
                    let frontChatView = FrontChatView()
                    let hostingController = UIHostingController(rootView: frontChatView)
                    newWindow.rootViewController = hostingController

                     
                     // Set the new window as the main window
                     self.window = newWindow
                     self.window?.makeKeyAndVisible()
                    return true
                }
            }
            else if url.scheme == "post" {
                print("url scheme is post")
                
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                            
                if let pathComponents = urlComponents?.path.split(separator: "/"), pathComponents.count == 3 {
                    let recipientId = pathComponents[1]
                    let postId = pathComponents[2]
                    
                    print("recipientId: \(recipientId), postId: \(recipientId)")
    //                    let newWindow = UIWindow(frame: UIScreen.main.bounds)
    //                    let frontChatView = FrontChatView()
    //                    let hostingController = UIHostingController(rootView: frontChatView)
    //                    newWindow.rootViewController = hostingController
    //
    //
    //                     // Set the new window as the main window
    //                     self.window = newWindow
    //                     self.window?.makeKeyAndVisible()
                    return true
                }
            }
            return false
        }
    }


    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }
    func application(_ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
       -> UIBackgroundFetchResult {
       // If you are receiving a notification message while your app is in the background,
       // this callback will not be fired till the user taps on the notification launching the application.
       // TODO: Handle data of notification
       // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
       // Print message ID.
       if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

           print(" 1")
       // Print full message.
       print(userInfo)

       return UIBackgroundFetchResult.newData
     }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
       Messaging.messaging().apnsToken = deviceToken
    }
    
    
    

  
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      return GIDSignIn.sharedInstance.handle(url)
//    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let deepLink = userInfo["gcm.notification.deepLink"] as? String {
            // Handle the URL scheme here
            print("Received notification with URL: \(deepLink)")
        }
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        print(" 2")

        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.banner, .sound]]
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
      let userInfo = response.notification.request.content.userInfo

      // [START_EXCLUDE]
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
      // [END_EXCLUDE]
      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print full message.
            print(" 3")
        if let deepLink = userInfo["gcm.notification.deepLink"] as? String {
            print("Received notification with URL: \(deepLink)")
            if let url = URL(string: deepLink) {
                
                print("URL SCHEME \(String(describing: url.scheme))")
                
                if url.scheme == "messages" {
                    // Handle custom URL scheme for messages
                    print("url scheme is messages")
                    
                    if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
                    print("URL COMPONENTS \(String(describing: urlComponents))")
//                    if let pathComponents = urlComponents?.path.split(separator: "/"), pathComponents.count == 3 {
                        let pathComponents = urlComponents.path.split(separator: "/")
                       
                       print("path components size \(pathComponents.count) and \(pathComponents)")
//                        let senderId = String(pathComponents[1])
                        let recipientId = String(pathComponents[0])
                        let name = String(pathComponents[1])
                        let senderGroupId = String(pathComponents[2])
                        
                        
                        //                        print("senderId: \(senderId), recipientId: \(recipientId)")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let currentViewController = windowScene.windows.first?.rootViewController {
                            currentViewController.dismiss(animated: false, completion: nil)
                            let newWindow = UIWindow(frame: UIScreen.main.bounds)
                            let profilesViewModel = ProfilesViewModel()
                            //                        GroupChatView(match: $chosenMessage,groupId:teamInfo.id)
                            
                            @State var chatModel : ChatModel = ChatModel(id: recipientId, groupId: recipientId, name: name, picture: UIImage(), lastMessage: "")
                            
                            print("recipeint id \(recipientId) and name \(name) and senderGroupId \(senderGroupId)")
                      
                            let frontChatView = GroupChatView(match:$chatModel,groupId:senderGroupId, fromNotification: true)
                                        .environmentObject(profilesViewModel) // inject profilesViewModel as an environment object
                                       
                                    
                                    let hostingController = UIHostingController(rootView: frontChatView)
                                    hostingController.modalPresentationStyle = .fullScreen // set the presentation style to full screen

                                    newWindow.rootViewController = hostingController
                                    currentViewController.present(hostingController, animated: true, completion: nil)
                                    
                                    print("new window")
                                    
                                    // Set the new window as the main window
                                    self.window = newWindow
                                    self.window?.makeKeyAndVisible()
                   
                            
                            //                        return true
                            //                    }
                        }
                    }
                }
                else if url.scheme == "post" {
                    // Handle custom URL scheme for posts
                    print("url scheme is post")
                    
                    if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
                    print("urlComponents: \(String(describing: urlComponents))")

                     let pathComponents = urlComponents.path.split(separator: "/")
                        
                        print("path components size \(pathComponents.count) and \(pathComponents)")
//                        let recipientId = String(pathComponents[1])
                        let documentId = String(pathComponents[0])
                        
                        print("recipientId: \(documentId), postId: \(documentId)")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let currentViewController = windowScene.windows.first?.rootViewController {
                            currentViewController.dismiss(animated: false, completion: nil)
                            let newWindow = UIWindow(frame: UIScreen.main.bounds)
                            let eventViewModel = EventViewModel()
                            
                            let profileViewModel = ProfilesViewModel()

                            
                            eventViewModel.fetchSingleCompletedEvent(id: documentId) { result in
                                switch result{
                                case .success(let event):
                                    let fetchedEvent = event
                                    
                                    let imagePostView = ImagePost(completedEvent: fetchedEvent,isOverlayShowing: true,fromProfile:false)
                                        .environmentObject(eventViewModel)
                                        .environmentObject(profileViewModel) // inject profilesViewModel as an environment object

//
                                    let hostingController = UIHostingController(rootView: imagePostView)
                                    hostingController.modalPresentationStyle = .fullScreen // set the presentation style to full screen
                                    newWindow.rootViewController = hostingController
                                    currentViewController.present(hostingController, animated: true, completion: nil)
                                    
                                case .failure(let error):
                                    print("error fetching event \(error)")
                                }
                            }
                        }
                    }
                    else {
                        print("URL path does not contain three components")
                    }
                }
                else if url.scheme == "comment" {
                    if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
                    print("urlComponents: \(String(describing: urlComponents))")

                     let pathComponents = urlComponents.path.split(separator: "/")
                        
                        print("path components size \(pathComponents.count) and \(pathComponents)")
//                        let recipientId = String(pathComponents[1])
                        let documentId = String(pathComponents[0])
                        
                        print("recipientId: \(documentId), postId: \(documentId)")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let currentViewController = windowScene.windows.first?.rootViewController {
                            currentViewController.dismiss(animated: false, completion: nil)
                            let newWindow = UIWindow(frame: UIScreen.main.bounds)
                            let eventViewModel = EventViewModel()
                            
                          
                            let commentView = CommentsView(eventId:documentId)
                                        .environmentObject(eventViewModel)
                                      
//
                                    let hostingController = UIHostingController(rootView: commentView)
                                    hostingController.modalPresentationStyle = .fullScreen // set the presentation style to full screen
                                    newWindow.rootViewController = hostingController
                                    currentViewController.present(hostingController, animated: true, completion: nil)
                                    
                           
                        }
                    }
                    else {
                        print("URL path does not contain three components")
                    }
                }
                else if url.scheme == "request" {
                    if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
                    print("urlComponents: \(String(describing: urlComponents))")

                     let pathComponents = urlComponents.path.split(separator: "/")
                        
                        print("path components size \(pathComponents.count) and \(pathComponents)")
//                        let recipientId = String(pathComponents[1])
                        let recipientId = String(pathComponents[0])
                        
                        print("recipientId: \(recipientId), postId: \(recipientId)")
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let currentViewController = windowScene.windows.first?.rootViewController {
                            currentViewController.dismiss(animated: false, completion: nil)
                            let newWindow = UIWindow(frame: UIScreen.main.bounds)
                            let profileViewModel = ProfilesViewModel()
                            let firestoreViewModel = FirestoreViewModel()
                            let requestViewModel = RequestViewModel()

                            profileViewModel.fetchTeam(id: recipientId) { result in
                                switch result{
                                case .success(let team):
                                    let commentView = Member_Alliances_Requests(groupId:recipientId, teamInfo: team , isFromNotification:true)
                                                .environmentObject(profileViewModel)
                                                .environmentObject(firestoreViewModel)
                                                .environmentObject(requestViewModel)
                                                .padding(.top,30)
                                                .background(AppColor.lovolDark)
                                    


        //
                                            let hostingController = UIHostingController(rootView: commentView)
                                            hostingController.modalPresentationStyle = .fullScreen // set the presentation style to full screen
                                            newWindow.rootViewController = hostingController
                                            currentViewController.present(hostingController, animated: true, completion: nil)
                                case .failure(let error):
                                    print("error fetching team for notification \(error)")
                                    return
                                }
                            }
                            
                          
                           
                                    
                           
                        }
                    }
                    else {
                        print("URL path does not contain three components")
                    }
                }

                
            }
            else{
                print("Invalid URL: \(deepLink)")
            }
        }

      print(userInfo)
    }
    
//    private func process(_ notification: UNNotification) {
//      // 1
//      let userInfo = notification.request.content.userInfo
//      // 2
//      UIApplication.shared.applicationIconBadgeNumber = 0
//      if let newsTitle = userInfo["newsTitle"] as? String,
//        let newsBody = userInfo["newsBody"] as? String {
//        let newsItem = NewsItem(title: newsTitle, body: newsBody, date: Date())
//        NewsModel.shared.add([newsItem])
//      }
//    }
    
    
}

extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
      guard let userId = Auth.auth().currentUser?.uid else {
          return
      }
      Firestore.firestore().collection("users_v2").document(userId).updateData(["FCMToken" : fcmToken ?? ""])
      Firestore.firestore().collection("fcmTokens").document(userId).setData(["token" : fcmToken ?? "",
                                                                                                       "timestamp" : FieldValue.serverTimestamp()
                                                                                                       
      
      ])
  }
    

  // [END refresh_token]
    
}


extension URL {
    func valueOf(_ param: String) -> String? {
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        return urlComponents.queryItems?.first(where: { $0.name == param })?.value
    }
}
