//
//  ContentView.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VocabularyViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("📉 苦手な英単語 (Low Accuracy)").font(.headline)) {
                        ForEach(viewModel.lowAccuracyWords) { word in
                            VocabularyRow(vocabulary: word)
                        }
                    }

                    Section(header: Text("📈 得意な英単語 (High Accuracy)").font(.headline)) {
                        ForEach(viewModel.highAccuracyWords) { word in
                            VocabularyRow(vocabulary: word)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("📖 単語学習")
            .onAppear {
                viewModel.loadVocabulary()
            }
        }
    }
}

#Preview {
    ContentView()
}
