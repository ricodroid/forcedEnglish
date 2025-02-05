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
            } else {
                print(granted ? "✅ 通知の許可が得られました" : "❌ 通知が拒否されました")
            }
            
            // 📌 現在の通知設定を取得してデバッグログを追加
            center.getNotificationSettings { settings in
                print("🔍 現在の通知設定: \(settings.authorizationStatus.rawValue)")
            }
        }
    }


    /// 10秒ごとに通知をスケジュール（テスト用）
    func scheduleRecurringNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()  // ⛔️ 以前の通知を削除

        let interval: TimeInterval = 10  // ⏳ **テスト用: 10秒ごとに通知**
        let notificationCount = 6  // 🔁 **1分間で6回通知を送る**

        for i in 1...notificationCount {
            let timeDelay = interval * Double(i)
            scheduleRandomVocabularyNotification(after: timeDelay)
        }
        print("✅ 10秒ごとの通知をスケジュールしました (合計 \(notificationCount) 回)")
    }

    /// 指定時間後に英単語の通知を送る
    func scheduleRandomVocabularyNotification(after timeInterval: TimeInterval) {
        guard let wordData = VocabularyManager.shared.getLowAccuracyWords() else {
            print("❌ スケジュールできる単語がありません")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Word of the Day"
        content.body = wordData.word
        content.userInfo = ["word": wordData.word, "meaning": wordData.meaning]
        content.sound = .default
        content.categoryIdentifier = "VOCAB_CATEGORY"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 通知のスケジュールに失敗: \(error.localizedDescription)")
            } else {
                print("✅ \(Int(timeInterval)) 秒後に通知をスケジュールしました: \(wordData.word)")
            }
        }

        // 📌 既存の通知リストをログ出力
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📌 現在のスケジュール済み通知数: \(requests.count)")
            for request in requests {
                print("🔔 通知予定: \(request.content.title) - \(request.trigger.debugDescription)")
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
