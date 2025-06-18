import Foundation

enum SourceType: String, CaseIterable, Identifiable, Codable {
    case book = "Книга"
    case article = "Статья"

    var id: String { self.rawValue }

    var localizedName: String {
        switch self {
        case .book: return "Книга"
        case .article: return "Статья"
        }
    }
}
