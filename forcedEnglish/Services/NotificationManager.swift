//
//  NotificationManager.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    /// 通知の許可をリクエスト
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        let correctAction = UNNotificationAction(identifier: "CORRECT_ACTION", title: "✅ 正解", options: [])
        let incorrectAction = UNNotificationAction(identifier: "INCORRECT_ACTION", title: "❌ わからなかった", options: [])

        let category = UNNotificationCategory(identifier: "VOCAB_CATEGORY", actions: [correctAction, incorrectAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification Authorization Error: \(error.localizedDescription)")
            } else if granted {
                print("✅ 通知の許可が得られました")
                self.scheduleRecurringNotifications()  // ✅ 許可されたら通知をスケジュール
            }
        }
    }

    /// 1時間ごとに通知をスケジュール
    func scheduleRecurringNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()  // ⛔️ 古い通知を削除

        let interval: TimeInterval = 3600  // ⏳ 1時間ごと

        for i in 1...24 {  // 🔁 24時間分の通知をスケジュール
            let timeDelay = interval * Double(i)
            scheduleRandomVocabularyNotification(after: timeDelay)
        }
        print("✅ 1時間ごとの通知をスケジュールしました")
    }

    /// 指定時間後に英単語の通知を送る
    func scheduleRandomVocabularyNotification(after timeInterval: TimeInterval = 10) {
        guard let wordData = VocabularyManager.shared.getLowAccuracyWords() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Word of the Day"
        content.body = wordData.word
        content.userInfo = ["word": wordData.word, "meaning": wordData.meaning]
        content.sound = .default
        content.categoryIdentifier = "VOCAB_CATEGORY"  // ✅ アクションを追加

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ 通知を \(timeInterval) 秒後にスケジュールしました: \(wordData.word)")
            }
        }
    }

    /// 通知がタップされたときの処理
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        guard let word = userInfo["word"] as? String else { return }

        switch response.actionIdentifier {
        case "CORRECT_ACTION":
            VocabularyManager.shared.updateAccuracy(for: word, isCorrect: true)
            print("✅ 正解: \(word)")

        case "INCORRECT_ACTION":
            VocabularyManager.shared.updateAccuracy(for: word, isCorrect: false)
            print("❌ わからなかった: \(word)")

        default:
            print("🔔 通知タップ: \(word)")
        }
    }
}
