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
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var firestoreViewModel = FirestoreViewModel()
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var profileViewModel = ProfilesViewModel()
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var requestViewModel = RequestViewModel()
    
    
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

        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Set the root view controller

      return true
    }
    
    func handleIncomingDynamicLink(_ dynamicLink:DynamicLink){
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

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void ) -> Bool {
        print("opening url ")
        if let incomingURL = userActivity.webpageURL{
            print("Incoming url is \(incomingURL)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){
                (dynamicLink, error) in
                guard error == nil else {
                    print("found an error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled{
                return true
            }else{
                return false
            }
        }
        return false
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received a url from custom scheme \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
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
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
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


