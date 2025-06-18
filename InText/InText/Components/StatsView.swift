import SwiftUI

struct StatsView: View {
    @ObservedObject private var stats: ProfileStatsViewModel

    init(stats: ProfileStatsViewModel) {
        self.stats = stats
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text("Статистика")
                    .font(.headline)
                    .padding(.bottom, 4)
                Spacer()
            }
            StatItemView(emoji: "📚", label: "Прочитано книг:", value: "\(stats.totalBooks)")
            StatItemView(emoji: "📃", label: "Прочитано статей:", value: "\(stats.totalArticles)")
            StatItemView(emoji: "✍️", label: "Добавлено отрывков:", value: "\(stats.totalTexts)")
            StatItemView(emoji: "🧠", label: "Проанализировано текстов:", value: "\(stats.analyzedTexts)")
            StatItemView(emoji: "🔑", label: "Уникальных ключевых слов:", value: "\(stats.uniqueKeywords)")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
