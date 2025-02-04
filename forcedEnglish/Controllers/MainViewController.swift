//
//  MainViewController.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        UNUserNotificationCenter.current().delegate = self
        NotificationManager.shared.requestAuthorization()
        
        let notifyButton = UIButton(type: .system)
        notifyButton.setTitle("Send Random Word Notification", for: .normal)
        notifyButton.addTarget(self, action: #selector(sendNotification), for: .touchUpInside)
        
        notifyButton.frame = CGRect(x: 50, y: 200, width: 300, height: 50)
        view.addSubview(notifyButton)
    }
    
    @objc func sendNotification() {
        NotificationManager.shared.scheduleRandomVocabularyNotification()
    }
    
    // 通知をタップした際の処理
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationManager.shared.handleNotificationResponse(response)
        completionHandler()
    }
}
