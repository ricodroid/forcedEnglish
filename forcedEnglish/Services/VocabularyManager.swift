//
//  VocabularyManager.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//
import Foundation

class VocabularyManager {
    static let shared = VocabularyManager()
    private var vocabularyList: [Vocabulary] = []

    private init() {
        loadVocabularyFromJSON()
    }

    /// JSONファイルから単語リストを読み込む
    func loadVocabularyFromJSON() {
        if let url = Bundle.main.url(forResource: "vocabulary", withExtension: "json") {
            print("✅ JSONファイルのURL: \(url)")
        } else {
            print("❌ JSONファイルが見つかりません")
            return
        }

        guard let url = Bundle.main.url(forResource: "vocabulary", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ JSONファイルを読み込めません")
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(VocabularyList.self, from: data)
            vocabularyList = decodedData.vocabulary
            print("✅ Vocabulary JSONをロードしました（単語数: \(vocabularyList.count)）")
        } catch {
            print("❌ JSONデコードエラー: \(error.localizedDescription)")
            print("📌 読み込んだデータ: \(String(data: data, encoding: .utf8) ?? "データが空です")")
        }
    }


    /// 全単語リストを取得
    func getVocabulary() -> [Vocabulary] {
        return vocabularyList
    }

    /// 正答率の低い単語を取得（優先度: 正答率が低い順）
    func getLowAccuracyWords() -> Vocabulary? {
        return vocabularyList.filter { $0.accuracy < 50 }.sorted { $0.accuracy < $1.accuracy }.first
    }

    /// 正答率を更新
    func updateAccuracy(for word: String, isCorrect: Bool) {
        if let index = vocabularyList.firstIndex(where: { $0.word == word }) {
            vocabularyList[index].accuracy += isCorrect ? 10 : -10
            vocabularyList[index].accuracy = max(0, min(100, vocabularyList[index].accuracy))
            print("🔄 更新: \(word) の正答率 -> \(vocabularyList[index].accuracy)%")
        }
    }
}
