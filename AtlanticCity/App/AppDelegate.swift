//
//  AppDelegate.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 26/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import UserNotifications
import FirebaseMessaging

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        GMSPlacesClient.provideAPIKey(Helpers.shared_maps_key)
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        
        return true
    }
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       let appId: String = Settings.appID!
       if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
       }
       return GIDSignIn.sharedInstance().handle(url)
       return false
    }
  

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AtlanticCity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink {
            let message = generateDynamicLinkMessage(dynamicLink)
            if #available(iOS 8.0, *) {
                //showDeepLinkAlertView(withMessage: message)
            }
            return true
        }
        if #available(iOS 8.0, *) {
            //showDeepLinkAlertView(withMessage: "openURL:\n\(url)")
        } else {
        }
        return false
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
                let urlparams = dynamiclink?.url?.valueOf("invitedby")
                UserDefaults.standard.set(urlparams!, forKey: "referral_user_id")
                UserDefaults.standard.synchronize()
                //let message = self.generateDynamicLinkMessage(dynamiclink!)
                //self.showDeepLinkAlertView(withMessage: urlparams!)
            
            }
            return handled
    }
    func generateDynamicLinkMessage(_ dynamicLink: DynamicLink) -> String {
        let matchConfidence: String
        if dynamicLink.matchType == .weak {
            matchConfidence = "Weak"
        } else {
            matchConfidence = "Strong"
        }
        let message = "App URL: \(dynamicLink.url)\nMatch Confidence: \(matchConfidence)\n"
        return message
    }

    @available(iOS 8.0, *)
    func showDeepLinkAlertView(withMessage message: String) {
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) -> Void in
            print("OK")
        }

        let alertController = UIAlertController.init(title: "Deep-link Data", message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}



@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    
    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message Firebase ID: \(messageID)")
    }
    //moveToNextViewController()
//    print(userInfo["user_id"])
//    print(userInfo["item_id"])
//    print(userInfo["click_action"])
//    print(userInfo["body"])
    // Print full message.
    print(userInfo)
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let otherVC = sb.instantiateViewController(withIdentifier: "notify") as! UINavigationController
    let notificationVC = otherVC.viewControllers.first as! NotificationController
    if(userInfo["user_id"] != nil){
        notificationVC.userid = userInfo["user_id"] as! String
    }
    notificationVC.itemid = userInfo["item_id"] as! String
    notificationVC.click_action = userInfo["click_action"] as! String
    notificationVC.body = userInfo["body"] as! String
    notificationVC.notifytitle = userInfo["title"] as! String
    window?.rootViewController = otherVC;

    completionHandler()
  }
}

// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    Helpers.writePreference(key: "fcmtoken", data: fcmToken)
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
}

