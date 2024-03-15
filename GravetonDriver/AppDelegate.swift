//
//  AppDelegate.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    private var pushNotification = PushNotification()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
              
        UNUserNotificationCenter.current().delegate = self
        UILabel.appearance().textColor = .label
        UIButton.appearance().setTitleColor(.label, for: .normal)
        UICollectionView.appearance().backgroundColor = .tertiarySystemGroupedBackground
        UIBarButtonItem.appearance().tintColor = .label

        configureNotification(application: application)
        
        FirebaseApp.configure()

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    
    func configureNotification(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        
        AppDataManager.shared.deviceToken = token
    }
}

extension AppDelegate {
    
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let data = response.notification.request.content.userInfo["data"] as? [String:Any] {

            if let dictData = NotificationData(dictionary: data){
                        
                pushNotification.createNotification(dictData)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let data = notification.request.content.userInfo["data"] as? [String:Any] {

            if let dictData = NotificationData(dictionary: data){
                            
                pushNotification.createNotification(dictData)
            }
        }
        
        completionHandler([.sound,.banner,.badge])
    }
}

