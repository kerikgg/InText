import Foundation

struct TextModel: Identifiable, Codable {
    var id: String
    let bookId: String

    var title: String
    var content: String
    var createdAt: Date
    var summary: String?
    var keywords: [String]?
}

