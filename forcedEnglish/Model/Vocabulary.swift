import Foundation

struct Vocabulary: Identifiable, Codable {
    let id: Int
    let word: String
    let meaning: String
    var accuracy: Int

    init(id: Int, word: String, meaning: String, accuracy: Int = 0) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.accuracy = accuracy
    }
}

// ✅ JSON の構造と一致させる
struct VocabularyList: Codable {
    var vocabulary: [Vocabulary]
}
