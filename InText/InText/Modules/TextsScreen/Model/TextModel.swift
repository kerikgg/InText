import Foundation

struct TextModel: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var createdAt: Date
}

