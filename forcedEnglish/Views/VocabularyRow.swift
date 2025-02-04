//
//  VocabularyRow.swift
//  forcedEnglish
//
//  Created by riko on 2025/02/03.
//

import SwiftUI
import Foundation

struct VocabularyRow: View {
    let vocabulary: Vocabulary

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(vocabulary.word)
                    .font(.title3)
                    .bold()
                Spacer()
                Text("\(vocabulary.accuracy)%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            ProgressView(value: Double(vocabulary.accuracy) / 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: vocabulary.accuracyColor))
        }
        .padding(.vertical, 5)
    }
}

extension Vocabulary {
    var accuracyColor: Color {
        switch accuracy {
        case 0..<40: return .red
        case 40..<70: return .orange
        default: return .green
        }
    }
}
