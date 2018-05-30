//
//  LocalNotifications.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/11/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
        
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let root = appDelegate.root
        else {
            return
        }

        root.showGoogleHomeVC()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

class LocalNotificationManager {

    static let shared = LocalNotificationManager()
    let delegate = LocalNotificationDelegate()

    private lazy var center: UNUserNotificationCenter =  {
        let center = UNUserNotificationCenter.current()
        center.delegate = self.delegate
        return center
    }()
    
    private init() {}

    func requestPermissions(completion: @escaping (Bool, Error?) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: completion)
    }

    func showGoogleHomeNotification(_ delay: TimeInterval = 1.0) {
        let content = UNMutableNotificationContent()
        content.title = "Grocr is now on Google Home!"
        content.body = "You can add to your shopping list, discover new sales, and search for products at your store!"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)

        center.add(request) { error in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}
