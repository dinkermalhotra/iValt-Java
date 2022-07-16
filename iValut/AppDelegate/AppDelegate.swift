//
//  AppDelegate.swift
//  iValut
//
//  Created by Amit Sharma MAC 2 on 10/04/19.
//  Copyright © 2019 MAC Book Air. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isFirstLaunch = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setNavigationBar()
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//            }
//        }
        
        return true
    }
    
    func setNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = iVaultColors.LIGHT_BLUE_COLOR
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func registerForNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
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
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - NOTIFICATIONS DELEGATE
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        Helper.setPREF(fcmToken ?? "", key: UserDefaults.PREF_MY_DEVICE_TOKEN)
        if !(Helper.getPREF(UserDefaults.PREF_MOBILE_NUMBER)?.isEmpty ?? true) {
            self.updateToken(fcmToken ?? "", Helper.getPREF(UserDefaults.PREF_MOBILE_NUMBER) ?? "")
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let channel = userInfo["channel"] as? String ?? ""
        let channelKey = userInfo["key"] as? String ?? ""
        
        homeViewControllerDelegate?.fetchData(channel, channelKey)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let channel = userInfo["channel"] as? String ?? ""
        let channelKey = userInfo["key"] as? String ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            homeViewControllerDelegate?.fetchData(channel, channelKey)
        })
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let channel = userInfo["channel"] as? String ?? ""
        let channelKey = userInfo["key"] as? String ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            homeViewControllerDelegate?.fetchData(channel, channelKey)
        })
        completionHandler(.newData)
    }
}

// MARK: - API CALL
extension AppDelegate {
    func updateToken(_ token: String, _ mobile: String) {
        let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_MOBILENO: mobile as AnyObject,
                                           WSRequestParams.WS_REQS_PARAM_TOKEN: token as AnyObject]
        WSManager.wsCallUpdateToken(params)
    }
}
