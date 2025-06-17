import Foundation

enum AnalysisMode: String, CaseIterable, Identifiable {
    case gpt = "GPT"
    case local = "Локальный"

    var id: String { rawValue }
}
