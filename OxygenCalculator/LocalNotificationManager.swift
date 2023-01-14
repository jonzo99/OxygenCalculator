//
//  LocalNotificationManager.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import Foundation
import UserNotifications

class LocalNotificationManager: ObservableObject {
   var notifications = [Notification]()
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.criticalAlert,.sound,.badge]) { granted, error in
            if granted == true && error == nil {
                print("notifications permitted")
            } else {
                print("Notifications not permitted")
            }
            
        }
    }
    func sendLocalNotification(timeInterval: Double, title: String, body: String, sound: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .criticalSoundNamed(UNNotificationSoundName.init(rawValue: sound), withAudioVolume: 1.0)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // create a unique indentifier to be able to get multiople notifications
        let identifier = UUID.init().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        print(trigger.timeInterval, "jfkdsfjs")
        print(identifier)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //userNotificationCenter.add(request) { (error) in
        //    if let error = error {
        //        print("Notification Error: ", error)
       //     }
       // }
    }
    
}
