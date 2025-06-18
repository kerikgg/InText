import SwiftUI
import Charts

struct KeywordChartView: View {
    let frequencies: [KeywordFrequency]

    var body: some View {
        // Показываем только топ-8 слов
        let topKeywords = frequencies.prefix(8)

        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Частота ключевых слов")
                .font(.headline)

            Chart(topKeywords) { item in
                BarMark(
                    x: .value("Частота", item.count),
                    y: .value("Слово", item.keyword)
                )
                .foregroundStyle(Color.purple)
                .annotation(position: .trailing) {
                    Text("\(item.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: CGFloat(topKeywords.count) * 32 + 30)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

