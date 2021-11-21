//
//  ViewController.swift
//  Project21
//
//  Created by Keith Crooc on 2021-11-20.
//


// CHALLENGE
// 1. Update didReceive so it shows different UIAlertControllers depending on which action identifier was passed in.
// 2. Add a second notification action to the alarm cateogry. Give it title "remind me later" and call scheduleLocal() so that the same alert is shown in 24 hours
// 3. Update project 2 so that it reminds players to come back and play everday.


import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(schedulelocal))
        
    }

    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("yay")
            } else {
                print("doh")
            }
        }
    }
    
    @objc func schedulelocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
//        creating an instance of our notification center
        
//        we want to cancel all pending notifications (in this example, would be notifications that are waiting to be delivered and are waiting for the trigger to send out.
        center.removeAllPendingNotificationRequests()
        

        
        
//        configuring what kind of notification and how it's like
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the word, but the second mouse gets the cheese."
        
        content.categoryIdentifier = "alarm"
//        this is the type of notification we show
        content.userInfo = ["customData": "fizzbuzz"]
        
        content.sound = .default
//        with this you can of course customize it to be your own sound.
        
        
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //        interval trigger > calendar trigger. (wait 5 seconds, THEN show this thing) in some cases
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell Me More", options: .foreground)
//        .foreground means when this button is tapped, launch app immediately
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("custom data received: \(customData)")
            
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default Identifier")
            case "show":
                print("show more info")
            default:
                break
            }
            
            
        }
        
        completionHandler()
    }

}

