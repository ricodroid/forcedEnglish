//
//  Vocabulary.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import Foundation

struct Vocabulary: Identifiable, Codable {
    let id: UUID  // `UUID()` ではなく、外部からデコード可能にする
    let word: String
    let meaning: String
    var accuracy: Int  // 正答率

    // JSONデコード時にIDを自動生成するカスタムイニシャライザ
    init(id: UUID = UUID(), word: String, meaning: String, accuracy: Int) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.accuracy = accuracy
    }
}


struct VocabularyList: Codable {
    var vocabulary: [Vocabulary]
}
