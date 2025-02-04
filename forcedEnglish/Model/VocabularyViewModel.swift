//
//  VocabularyViewModel.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import SwiftUI

class VocabularyViewModel: ObservableObject {
    @Published var vocabularyList: [Vocabulary] = []
    
    var lowAccuracyWords: [Vocabulary] {
        vocabularyList.filter { $0.accuracy < 50 }.sorted { $0.accuracy < $1.accuracy }
    }

    var highAccuracyWords: [Vocabulary] {
        vocabularyList.filter { $0.accuracy >= 50 }.sorted { $0.accuracy > $1.accuracy }
    }

    func loadVocabulary() {
        // ここで VocabularyManager などからデータを取得
        vocabularyList = VocabularyManager.shared.getVocabulary()
    }
}
